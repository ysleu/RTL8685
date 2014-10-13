
//static const char* const RtpTransmitter_cxx_Version =
//    "$Id: RtpTransmitter.c,v 1.1 2012/08/21 09:43:23 krammer Exp $";

//#include <time.h>
//#include <sys/types.h>
//#include <unistd.h>
//#include <string.h>

#include <linux/string.h>
#include <linux/delay.h>
#include <linux/netdevice.h>
#ifdef DEBUG_LOG
#include "cpLog.h"
#endif
/* Kao
#include "vsock.hxx"
*/

#include "assert.h"
#include "rtpTypes.h"
#include "rtpTools.h"
#include "Rtp.h"
#include "rtk_voip.h"
//#include <debug.h>

#include "codec_descriptor.h"

#include "v152_api.h"

///////////////////////////////////////////////////////////////////////

char rfc2833_period[MAX_VOIP_CH_NUM]={0};        // hc+ for voice packet interleave in rfc2833 period issue
unsigned int gRfc2833_volume[MAX_SESS_NUM] = {[0 ... MAX_SESS_NUM-1] = 0x0A};
static int transmit(RtpPacket*, BOOL);


static int cur_send_dtmf;
static int cur_send;
static BOOL bCreate;

extern int voip_ch_num;

#ifdef SUPPORT_MULTI_FRAME
extern unsigned char MFFrameNo[MAX_SESS_NUM];
#endif

unsigned char rfc2833_payload_type_remote[MAX_SESS_NUM];    /* 0: Don't send 2833 packets. 96 or 101 or ..: send 2833 packets */
unsigned int CurrentRfc2833Mode[MAX_VOIP_CH_NUM];	/* 0 : current is not in RFC2833 mode, 1: in RFC2833 mode*/
static int send_2833_start[MAX_SESS_NUM]={0};              /* 0: stop send 2833 packets   1: start  send 2833 packets */
static int send_marker_flag[MAX_SESS_NUM] = {0};           /* 0: not send. 1: send */
static int send_2833_flag[MAX_SESS_NUM] = {0};             /* 0: not send. 1: send */
static int send_edge_flag[MAX_SESS_NUM] = {0};             /* 0: not send. 1: send */
static int timestamp_2833[MAX_SESS_NUM] = {0};
static unsigned short edge_sequence_2833[MAX_SESS_NUM] = {0};
int send_2833_by_ap[MAX_VOIP_CH_NUM] = {0};		/* 0: by DSP 1: by AP */	
extern int g_dynamic_pt_remote[];
extern int g_dynamic_pt_remote_vbd[];


#if defined( SUPPORT_RFC_2833 ) && defined( SEND_RFC2833_ISR )
unsigned char send_2833_count_down[MAX_SESS_NUM];
static unsigned char send_2833_count_down_dsp[MAX_SESS_NUM] = {0};
#endif

#ifdef SUPPORT_RFC2833_PLAY_LIMIT
extern int bRfc2833_play_limit[MAX_SESS_NUM]; // flag to turn on/off play time limit
extern int rfc2833_play_limit_ms[MAX_SESS_NUM];
#endif

RtpTransmitter RtpTxInfo[MAX_SESS_NUM];

#ifdef SUPPORT_RTP_REDUNDANT
// ------ RTP Redundancy - Audio ---------
#define MAX_AUDIO_REDUNDANT_NUM		2	// redundant audio packet number 
#define MAX_AUDIO_ELEMENT_DATA		( PKTDATA_SIZES / MAX_AUDIO_REDUNDANT_NUM )

typedef struct {
	unsigned char data[ MAX_AUDIO_ELEMENT_DATA ];
	int len;
	RtpTime timestamp;
	RtpPayloadType PT;
} RtpRedundantTxAudioElement_t;

typedef struct {
	RtpRedundantTxAudioElement_t element[ MAX_AUDIO_REDUNDANT_NUM ];	// preceding is older 
	int set_count;
} RtpRedundantTxAudio_t;

// ------ RTP Redundancy - RFC 2833 ---------
#define MAX_RFC2833_ELEMENT_DATA	8	// when I check RFC2833, 8 bytes seems maximum 
#define MAX_RFC2833_REDUNDANT_R		5	// RFC2833 suggest 5 (but whitin 2.048 sec due to timestamp offset field)

typedef struct {
	RtpTime timestamp;
	RtpPayloadType PT;
	unsigned char data[ MAX_RFC2833_ELEMENT_DATA ];
	int len;
} RtpRedundantTxRFC2833Element_t;

typedef struct {
	RtpRedundantTxRFC2833Element_t element[ MAX_RFC2833_REDUNDANT_R ];	// preceding is older 
	int valid_element;
} RtpRedundantTxRFC2833_t;

typedef struct {
	RtpRedundantTxAudio_t audio;
	RtpRedundantTxRFC2833_t rfc2833;
} RtpRedundantTx_t;

static RtpRedundantTx_t RtpRedundantTx[ SESS_NUM ];
#endif // SUPPORT_RTP_REDUNDANT

/* ----------------------------------------------------------------- */
/* --- RtpTransmitter Constructor ---------------------------------- */
/* ----------------------------------------------------------------- */

void RtpTx_Init (void)
{
	int i;
	// set private variables
	cur_send = 0;
	cur_send_dtmf = 0;
	bCreate = FALSE;
	for(i=0; i<SESS_NUM; i++)
	{
		RtpTx_InitbyID(i);
		rfc2833_payload_type_remote[i] = 101; /* Init payload type to 101 */
	}
}

void RtpTx_InitbyID (uint32 sid)
{
	RtpTransmitter* pInfo = NULL;

	if(sid >= SESS_NUM)
		return;

	pInfo = &RtpTxInfo[sid];

	pInfo->ssrc = generateSRC();
/*	pInfo->seedNtpTime = Ntp_getTime(); */
#ifdef SUPPORT_RTCP
	Ntp_getTime(&pInfo->seedNtpTime);
        pInfo->prevNtpTime = pInfo->seedNtpTime;
#endif
	pInfo->seedRtpTime = generate32();
	pInfo->prevRtpTime = pInfo->seedRtpTime;
	pInfo->prevSequence = generate32();
	pInfo->markerOnce = TRUE;

	pInfo->tranOpmode = rtptran_droppacket;

	// set counters
	pInfo->packetSent = 0;
	pInfo->payloadSent = 0;

#ifdef SUPPORT_RTP_REDUNDANT	
	RtpRedundantTx[ sid ].audio.set_count = 0;
	RtpRedundantTx[ sid ].rfc2833.valid_element = 0;
#endif
}

void RtpTx_renewSession (uint32 sid, int randomly, RtpSrc SSRC, RtpSeqNumber seqno, RtpTime timestamp )
{
	RtpTransmitter* pInfo = NULL;

	if(sid >= SESS_NUM)
		return;

	pInfo = &RtpTxInfo[sid];

	pInfo->ssrc = ( randomly ? generateSRC() : SSRC );
	pInfo->seedRtpTime = ( randomly ? generate32() : timestamp );
	pInfo->prevRtpTime = pInfo->seedRtpTime - 80;	// '-80' is not good style, but RtpTx_setFormat() will update again 
	pInfo->prevSequence = ( randomly ? generate32() : seqno );
#ifdef CONFIG_RTK_VOIP_SRTP
	// Avoid losing ROC synchronization
	// Initial seguence number shall be less than 2^15
	pInfo->prevSequence &= 0x7FFF;
#endif	
	pInfo->markerOnce = TRUE;

	// set counters
	pInfo->packetSent = 0;
	pInfo->payloadSent = 0;
	
#ifdef SUPPORT_RTP_REDUNDANT
	RtpRedundantTx[ sid ].audio.set_count = 0;
	RtpRedundantTx[ sid ].rfc2833.valid_element = 0;
#endif
}

#if 0
void setRemoteAddr (const NetworkAddress& theAddr)
{
	remoteAddr = theAddr;
}
#endif

RtpTransmitter* RtpTx_getInfo (uint32 sid)
{
    RtpTransmitter* pInfo = NULL;

	if(sid >= SESS_NUM)
		return NULL;

	pInfo = &RtpTxInfo[sid];
	return pInfo;
}

/* --- send packet functions --------------------------------------- */

static RtpPacket* createPacket (uint32 chid, uint32 sid, int npadSize, int csrc_count)
{
	RtpTransmitter* pInfo = NULL;

	RtpPacket* packet;
	// create packet
	if(bCreate)
	{
		bCreate = FALSE;
		return NULL;
	}
	bCreate = TRUE;

	if(sid >= SESS_NUM)
	{
		bCreate = FALSE;
		return NULL;
	}

	pInfo = &RtpTxInfo[sid];

	packet = &RTP_TX_DTMF[cur_send_dtmf];
	if(packet->own == OWNBYDSP)
	{
		bCreate = FALSE;
    	return NULL;
	}
	cur_send_dtmf++;
	cur_send_dtmf &= (RTP_TX_DTMF_NUM-1);
	RtpPacket_Init(packet, RECV_BUF/*pInfo->payloadSize*/, npadSize, csrc_count);
	assert (packet);
	// load packet
	setSSRC (packet, pInfo->ssrc);
	setPayloadType (packet, pInfo->payloadFormat/*apiFormat*/);
	packet->chid = chid;
	packet->sid = sid;
	
	packet->own = OWNBYDSP;
	bCreate = FALSE;

    return packet;
}

#ifdef SUPPORT_RTP_REDUNDANT
static void RtpRedundantReclaimRFC2833( int sid, RtpTime now )
{
	RtpRedundantTxRFC2833_t * const pRtpRedTx2833 = &RtpRedundantTx[ sid ].rfc2833;
	RtpRedundantTxRFC2833Element_t * pRtpRedTx2833Element;
	int elements = pRtpRedTx2833 ->valid_element;
	int i, j;
	
	// quickly return 
	if( elements == 0 )
		return;
	
	// check elements number 
	if( elements > MAX_RFC2833_REDUNDANT_R ) {
		printk( "sid=%d elements > %d\n", sid, MAX_RFC2833_REDUNDANT_R );
		elements = MAX_RFC2833_REDUNDANT_R;
	}
	
	// loop to check element 
	for( i = 0; i < elements; i ++ ) {
		
		pRtpRedTx2833Element = &pRtpRedTx2833 ->element[ i ];
		
		// redundancy timestamp offset 14 bits --> 2^14 = 16384
		if( now - pRtpRedTx2833Element ->timestamp > 16384 ) {
			// remove this!! 
		} else
			break;	// scan done! 
	}
	
	// no corrupt element 
	if( i == 0 )
		return;
	
	// update valid element 
	pRtpRedTx2833 ->valid_element -= i;
	
	// remove corrupt elements 
	for( j = 0; j < MAX_RFC2833_REDUNDANT_R && i < elements; j ++, i ++ ) 
	{
		pRtpRedTx2833 ->element[ j ] = pRtpRedTx2833 ->element[ i ];
	}
}

static int RtpRedundantTransmitProcessRFC2833( RtpPacket* p )
{
	// Process: 
	//   move payload to redundancy primary payload 
	//   set (enlarge) payload total length 
	//   fill redundancy 'RFC2833' data 
	// Not process: 
	//   RTP payload type (by caller)
	
	//const int chid = p ->chid;
	const int sid = p ->sid;
	const int primLen = getPayloadUsage( p );
	const RtpPayloadType primPT = getPayloadType(p);
	const RtpTime primTimestamp = getRtpTime( p );
	
	RtpRedundantTxRFC2833_t * const pRtpRedTx2833 = &RtpRedundantTx[ sid ].rfc2833;
	RtpRedundantTxRFC2833Element_t * pRtpRedTx2833Element;
	int nTotalPayloadLen;	// redundant header + red/primary data
	unsigned char *pDst;
	int i, elements;
	
	if( !GetRtpRedundantStatus( sid ) )
		return 0;
	
	// arrange rundancy RFC2833 data (valid_elements will change!!)
	// call this before enter!
	//RtpRedundantReclaimRFC2833( sid, primTimestamp );
	
	// calculate nTotalPayloadLen (1) - primary 
	nTotalPayloadLen = sizeof( RtpRedPrimaryHeader ) + primLen;
	
	//printk( "T:%d=%d+%d ", nTotalPayloadLen, sizeof( RtpRedPrimaryHeader ), len );
	
	// calculate nTotalPayloadLen (2) - redundancy  
	elements = pRtpRedTx2833 ->valid_element;
	
	for( i = 0; i < elements; i ++ ) {
		
		pRtpRedTx2833Element = &pRtpRedTx2833 ->element[ i ];
		
		if( pRtpRedTx2833Element ->timestamp == primTimestamp )
			continue;	// to avoid three continual 'end' 
		
		nTotalPayloadLen += sizeof( RtpRedHeader ) + 
							pRtpRedTx2833Element ->len;
	}
	
	// calculate nTotalPayloadLen (3) - set to packet 
	setPayloadUsage (p, nTotalPayloadLen/*packetSize*/);
	
	// fill packet to transmit (1) - primary payload (memmove to tail)
	pDst = getPayloadLoc(p);
	
	memmove( pDst + nTotalPayloadLen - primLen, pDst, primLen );	// move primary data to tail 
	
	// fill packet to transmit (2) - redundancy header  
	for( i = 0; i < elements; i ++ ) {
		
		pRtpRedTx2833Element = &pRtpRedTx2833 ->element[ i ];

		if( pRtpRedTx2833Element ->timestamp == primTimestamp )
			continue;	// to avoid three continual 'end' 
		
		( ( RtpRedHeader * )pDst ) ->F = 1;
		( ( RtpRedHeader * )pDst ) ->blockPT = pRtpRedTx2833Element ->PT;
		( ( RtpRedHeader * )pDst ) ->timestamp_offset = primTimestamp - pRtpRedTx2833Element ->timestamp;
		( ( RtpRedHeader * )pDst ) ->block_length = pRtpRedTx2833Element ->len;
		pDst += sizeof( RtpRedHeader );
	}

	// fill packet to transmit (3) - primary header 
	( ( RtpRedPrimaryHeader * )pDst ) ->F = 0;	// fill primary redundant header 
	( ( RtpRedPrimaryHeader * )pDst ) ->blockPT = getPayloadType( p );
	pDst += sizeof( RtpRedPrimaryHeader );
	
	// fill packet to transmit (4) - redundancy data   
	for( i = 0; i < elements; i ++ ) {
		
		pRtpRedTx2833Element = &pRtpRedTx2833 ->element[ i ];
		
		if( pRtpRedTx2833Element ->timestamp == primTimestamp )
			continue;	// to avoid three continual 'end' 
		
		memcpy( pDst, pRtpRedTx2833Element ->data, pRtpRedTx2833Element ->len );
		pDst += pRtpRedTx2833Element ->len;
	}
	
	// pDst point to primary data 
	
	/////////////////////////////////////////////////////////////// 	
	// save primary for next redundant 
	// (now, we process event only, but not tone with freqency)
	
	if( primPT != rfc2833_payload_type_remote[sid] )	// event 
		goto lable_process_modulation;
	
//label_pocess_event:
	// Process DTMF digits only  
	if( ( ( RtpEventDTMFRFC2833 * )pDst ) ->edge != 1 )
		goto lable_process_modulation;
	
	// check the newest element 
	pRtpRedTx2833Element = &pRtpRedTx2833 ->element[ elements - 1 ];
	
	if( pRtpRedTx2833Element ->timestamp == primTimestamp )
		goto label_save_primary_done;	// has been saved!! 
	
	// check len 
	if( primLen > MAX_RFC2833_ELEMENT_DATA ) {
		printk( "primary len %d > %d\n", primLen, MAX_RFC2833_ELEMENT_DATA );
		goto label_save_primary_done;
	}
	
	// full!! remove one for current! 
	if( elements == MAX_RFC2833_REDUNDANT_R ) {	
		for( i = 0; i < MAX_RFC2833_REDUNDANT_R - 1; i ++ )
			pRtpRedTx2833 ->element[ i ] = pRtpRedTx2833 ->element[ i + 1 ];
		
		elements = MAX_RFC2833_REDUNDANT_R - 1;
	}
	
	// save it 
	pRtpRedTx2833Element = &pRtpRedTx2833 ->element[ elements ];
	
	pRtpRedTx2833Element ->timestamp = primTimestamp;
	pRtpRedTx2833Element ->PT = primPT;
	memcpy( pRtpRedTx2833Element ->data, pDst, primLen );
	pRtpRedTx2833Element ->len = primLen;
	
	pRtpRedTx2833 ->valid_element = elements + 1;

lable_process_modulation:
	;
		
label_save_primary_done:
	;
	
	return 1;
}
#endif

// takes api RTP packet and send to network
// assumes payload size is already set
static int transmit(RtpPacket* packet, BOOL eventFlag )
{
	static int _2833_pkt_cnt[MAX_SESS_NUM] ={0};
	static int _2833_terminate[MAX_SESS_NUM] = {0};
	
	RtpTransmitter* pInfo = NULL;
	if( !packet )
	{
#ifdef DEBUG_LOG
		cpLog(LOG_ERR,"Attempting to transmit a NULL rtp packet");
#endif
		return -1;
	}

	RtpPacket* p = packet;

	if(p->sid >= SESS_NUM)
		return -1;

	pInfo = &RtpTxInfo[p->sid];

	if( !p->timestampSet )
	{
		setRtpTime( p, pInfo->prevRtpTime + pInfo->pktSampleSize/*network_pktSampleSize*/ );
		
		if (true == p->EventPktMarker)
		{
			timestamp_2833[p->sid] = pInfo->prevRtpTime + 80;
			//timestamp_2833[p->sid] = pInfo->prevRtpTime + pInfo->pktSampleSize;
			//printk("tx: %u, sid=%d\n", timestamp_2833[p->sid], p->sid);
		}
	}
	
	if (eventFlag)
		setRtpTime( p, timestamp_2833[p->sid] );


	if( (!p->sequenceSet) )
	{
		if (eventFlag == 1)
		{
			_2833_pkt_cnt[p->sid]++;
			
			setSequence( p, pInfo->prevSequence++ );
			
			if (p->EventPktEdge == true)
			{
				edge_sequence_2833[p->sid] = pInfo->prevSequence - 1;
			}
		}
		else
			setSequence( p, pInfo->prevSequence++ );
	}
	else
	{
		if ( (eventFlag == 1) && (p->EventPktEdge == true) )
		{
			static int cnt[MAX_SESS_NUM] = {0};
			_2833_pkt_cnt[p->sid]++;
			
			cnt[p->sid]++;
			//printk("->%d\n", cnt[p->sid]);

			if (cnt[p->sid] == 2)
			{
				_2833_terminate[p->sid] = 1;
				cnt[p->sid] = 0;
				//printk("1:%d\n", _2833_pkt_cnt[p->sid]);
			}
				
			setSequence( p, edge_sequence_2833[p->sid]);
		}
	}
		
	if( getPayloadUsage(p) < 0  ||  getPayloadUsage(p) > 1012 )
	{
#ifdef DEBUG_LOG
		cpLog(LOG_DEBUG_STACK,"Invalid data packet size %d", getPayloadUsage());
#endif
		return -1;
	}

    //set marker once
	if( pInfo->markerOnce )
	{
#ifdef DEBUG_LOG
		cpLog( LOG_DEBUG_STACK,"Setting marker bit once");
#endif
		setMarkerFlag(p, 1);
		pInfo->markerOnce = FALSE;
	}

#ifdef SUPPORT_RTP_REDUNDANT
	// reclaim redudnacy data 
	RtpRedundantReclaimRFC2833( p ->sid, getRtpTime( p ) );
	
	// RFC2833 need redudancy 
	if( p ->RFC2833 && RtpRedundantTransmitProcessRFC2833( p ) ) {	
		/* overwrite payload type with redundant one */
		setPayloadType (p, GetRtpRedundantPayloadType( p ->sid, 0 /* remote */ ) );
	}
#endif

	// for packet reuse
	p->timestampSet = FALSE;
	p->sequenceSet = FALSE;
	// transmit packet
	DSP_rtpWrite(p);

	// update counters
	pInfo->packetSent++;
	//prevSequence = getSequence(p);
	if( !eventFlag )
	{
		pInfo->payloadSent += getPayloadUsage(p);
#ifdef SUPPORT_RTCP
		Ntp_getTime(&pInfo->prevNtpTime);
#endif
		pInfo->prevRtpTime = getRtpTime(p);
	}
	else
	{
		if (_2833_terminate[p->sid] == 1)
		{
			pInfo->prevRtpTime = 
				timestamp_2833[p->sid] + 80*(_2833_pkt_cnt[p->sid]-3);
				//timestamp_2833[p->sid] + pInfo->pktSampleSize*(_2833_pkt_cnt[p->sid]-3);

			_2833_pkt_cnt[p->sid] = 0;
			_2833_terminate[p->sid] = 0;

			//printk("2:0%x\n", pInfo->prevRtpTime);
		}

		/*
		 *	voice rtp timestamp: x
		 *	2833 pkt 1 timestamp: y = x + pkt-time
		 *	2833 pkt 2 timestamp: y 
		 *	..
		 *	2833 pkt N timestamp: y
		 *	voice rtp timestamp: x + (pkt-time)*(N-3)
		 */
	}
	

	// set up return value
	int result = getPayloadUsage(p);

	// exit with success
	return result;
}

#ifdef SUPPORT_RTP_REDUNDANT
static void RtpRedundantReclaimAudio( uint32 sid, RtpTime now )
{
	RtpRedundantTxAudio_t * const pRedAudio = &RtpRedundantTx[ sid ].audio;
	RtpRedundantTxAudioElement_t * pElement;
	int i, j;
	int count = pRedAudio ->set_count;
	
	// check which one need reclaim 
	for( i = 0; i < count; i ++ ) {
		
		pElement = &pRedAudio ->element[ i ];
		
		// check if timestamp too large (timestamp offset 14 bits -->16384 )
		if( now - pElement ->timestamp < 16384 )
			break;
	}
	
	if( i == 0 )
		return;	// no need reclaim 

	pRedAudio ->set_count = count - i;
	
	for( j = 0; j < MAX_AUDIO_REDUNDANT_NUM - 1 && 
				i < count; 
												j ++, i ++ )
	{
		pRedAudio ->element[ j ] = pRedAudio ->element[ i ];
	}
}

static int RtpRedundantTransmitProcess( uint32 sid, char* data, int len,
								 RtpTransmitter* pInfo,
								 RtpPacket* p )
{
	// goal of this function is to: 
	//	setPayloadUsage (p, len/*packetSize*/);
	//	memcpy (getPayloadLoc(p), data, len);
	
	RtpRedundantTxAudio_t * const pRtpRedTx = &RtpRedundantTx[ sid ].audio;
	RtpRedundantTxAudioElement_t * pElement;
	int nTotalPayloadLen = 0;	// redundant header + red/primary data
	unsigned char *pDst;
	const RtpTime curTimestamp = pInfo->prevRtpTime + pInfo->pktSampleSize;
	int i;

	if( !GetRtpRedundantStatus( sid ) )
		return 0;
	
	// reclaim audio redundancy 
	RtpRedundantReclaimAudio( sid, curTimestamp );
	
	// fill packet to transmit - calculate nTotalPayloadLen 
	for( i = 0; i < pRtpRedTx ->set_count; i ++ ) {
		
		pElement = &pRtpRedTx ->element[ i ];
		
		nTotalPayloadLen += sizeof( RtpRedHeader ) + pElement ->len;
	}
	
	nTotalPayloadLen += sizeof( RtpRedPrimaryHeader ) + len;
	
	// fill packet to transmit - set payload usage 
	setPayloadUsage (p, nTotalPayloadLen/*packetSize*/);
	
	pDst = getPayloadLoc(p);
	
	// fill packet to transmit - fill redundant header 
	for( i = 0; i < pRtpRedTx ->set_count; i ++ ) {
		
		pElement = &pRtpRedTx ->element[ i ];
		
		( ( RtpRedHeader * )pDst ) ->F = 1;
		( ( RtpRedHeader * )pDst ) ->blockPT = pElement ->PT;
		( ( RtpRedHeader * )pDst ) ->timestamp_offset = curTimestamp - pElement ->timestamp;
		( ( RtpRedHeader * )pDst ) ->block_length = pElement ->len;
		pDst += sizeof( RtpRedHeader );
	}
	
	// fill packet to transmit - fill primary redundant header 
	( ( RtpRedPrimaryHeader * )pDst ) ->F = 0;
	( ( RtpRedPrimaryHeader * )pDst ) ->blockPT = getPayloadType( p );
	pDst += sizeof( RtpRedPrimaryHeader );
	
	// fill packet to transmit - fill redundant data 
	for( i = 0; i < pRtpRedTx ->set_count; i ++ ) {
		
		pElement = &pRtpRedTx ->element[ i ];
		
		memcpy( pDst, pElement ->data, pElement ->len );
		pDst += pElement ->len;
	}
	
	// fill packet to transmit - fill primary data 
	memcpy( pDst, data, len );
	pDst += len;
	
	// save current for next redundant - check length 
	if( len > MAX_AUDIO_ELEMENT_DATA ) {
		printk( "audio len %d > %d\n", len, MAX_AUDIO_ELEMENT_DATA );
		return 1;
	} 
	
	// save current for next redundant - free a space for current 
	if( pRtpRedTx ->set_count >= MAX_AUDIO_REDUNDANT_NUM ) {
		
		for( i = 0; i < MAX_AUDIO_REDUNDANT_NUM - 1; i ++ )
			pRtpRedTx ->element[ i ] = pRtpRedTx ->element[ i + 1 ];
		
		pRtpRedTx ->set_count = MAX_AUDIO_REDUNDANT_NUM - 1;
	}
	
	// save current for next redundant - save it!! 
	pElement = &pRtpRedTx ->element[ pRtpRedTx ->set_count ];
	
	pRtpRedTx ->set_count ++;	// increase count 
	
	memcpy( pElement ->data, data, len );
	pElement ->len = len;
	pElement ->timestamp = curTimestamp;
	pElement ->PT = getPayloadType( p );

	return 1;
}
#endif

// takes rawdata, buffers it, and send network packets
int RtpTx_transmitRaw (uint32 chid, uint32 sid, char* data, int len)
{
	RtpTransmitter* pInfo = NULL;
	// send out packets from buffer
	int result = 0;

	extern uint32 rtpConfigOK[];
#ifdef SUPPORT_COMFORT_NOISE
        extern int m_nSIDFrameLen[MAX_SESS_NUM];                                            // the length of SID frame
#endif
	extern uint16 SID_payload_type_remote[ SESS_NUM ];
	extern uint32 SID_count_tx[ SESS_NUM ];
	// create packet
	RtpPacket* p = &RTP_TX_DEC[cur_send];

	if(chid >= voip_ch_num)
		return 0;
	
	if(sid >= SESS_NUM)
		return 0;

	if(rtpConfigOK[sid] == 0)
		return 0;

	if(p->own == OWNBYDSP)
		return 0;

	if(!isTranMode(sid))
		return 0;

	pInfo = &RtpTxInfo[sid];

	cur_send++;
	cur_send &= (RTP_TX_DEC_NUM-1);
	RtpPacket_Init(p, RECV_BUF/*pInfo->payloadSize*/, 0, 0);
	p->chid = chid;
	p->sid = sid;
	assert (p);
	setSSRC (p, pInfo->ssrc);
#ifdef SUPPORT_COMFORT_NOISE
	if ((len == m_nSIDFrameLen[sid]) && (g_dynamic_pt_remote[sid] != rtpPayload_AMR_NB) && (g_dynamic_pt_remote[sid] != rtpPayloadG729))
	{
		if( SID_payload_type_remote[ sid ] )
			setPayloadType( p, SID_payload_type_remote[ sid ] );
		else
			setPayloadType (p, 13);
		
		SID_count_tx[ sid ] ++;
	} else
#endif
	{
		RtpPayloadType type;

#ifdef SUPPORT_V152_VBD		
		if( V152_CheckIfSendVBD( sid ) )
			type = g_dynamic_pt_remote_vbd[sid];
		else
#endif
		{
			type = g_dynamic_pt_remote[sid];
		}
			
		setPayloadType (p, type); // support dynamic payload.
		//setPayloadType (p, pInfo->payloadFormat/*networkFormat*/);
	}

#ifdef SUPPORT_RTP_REDUNDANT
	if( RtpRedundantTransmitProcess( sid, data, len, pInfo, p ) ) {
		/* overwrite payload type with redundant one */
		setPayloadType (p, GetRtpRedundantPayloadType( sid, 0 /* remote */ ) );
	} else
#endif
	{
		setPayloadUsage (p, len/*packetSize*/);
	
		memcpy (getPayloadLoc(p), data, len);
	}
	p->own = OWNBYDSP;
	result += transmit(p, FALSE);
	p->own = OWNBYRTP;
	return result;
}

#ifdef SUPPORT_RFC_2833
int RtpTx_transmitEvent( uint32 chid, uint32 sid, int event, int delay_ms)
{
	extern char dtmf_mode[MAX_VOIP_CH_NUM]/*_inband*/ ;
	int num,i;
	unsigned short n = 160;
	RtpTransmitter* pInfo = NULL;

        if(chid >= voip_ch_num)
		return 0;

	if(sid >= SESS_NUM)
		return 0;
		
	pInfo = &RtpTxInfo[sid];

    // Howard. 2004.12.30 for prevent to send dtmf digit using Outband when user enables the Inband
    if( dtmf_mode[chid]/*_inband*/ != 0 )	// Howard. 2005.2.24 when dtmf_mode is not RFC2833 , then we can't generate RFC2833 packet, so we return here.
		return ( -1 ) ;

	rfc2833_period[chid] = 1;	// hc+ for avoid voice packet interleave issue

	//sessionError = session_success;
	RtpPacket* eventPacket = createPacket(chid, sid, 0, 0);
	// Howard. 2005.3.16
	setPayloadType( eventPacket, rfc2833_payload_type_remote[sid]);
	setPayloadUsage( eventPacket, sizeof( RtpEventDTMFRFC2833 ) );
	setMarkerFlag(eventPacket, 1);
	RtpEventDTMFRFC2833* eventPayload = (RtpEventDTMFRFC2833*)( getPayloadLoc(eventPacket) );

	// reset event payload
	eventPayload->event = event; 
	eventPayload->volume = gRfc2833_volume[sid];
	eventPayload->reserved = 0;
	eventPayload->edge = 0;
	eventPayload->duration = n;	//htons(n);

	// send onedge packet
	// jimmylin - let's send it for delay_ms
	num = (delay_ms/20) - 2;
	//Howard. 2005.3.16 to transmit 3 times first Digit ( Marker bit set to 1 )
	for( i = 0 ; i < 3 ; i++ )
	{
		eventPacket->timestampSet = true ;
		transmit( eventPacket, true ) ;
		eventPacket->sequenceSet = true ;
	}
	setMarkerFlag(eventPacket,0);
	udelay(20);

	for(i=0; i<num; i++)	
	{
		n += 160;
		eventPayload->duration = n;	//htons(n);
		eventPacket->timestampSet = true;
		transmit( eventPacket, true );
		udelay(20);
	}

	// send on packet
	eventPayload->edge = 1;
	// jimmylin - retransmit 3 times according to Rfc2833
	for(i=0; i<3; i++)
	{
		eventPacket->timestampSet = true;
		transmit( eventPacket, true );
		eventPacket->sequenceSet = true;
	}
	pInfo->prevRtpTime += 640;	// hc+ 1101 timestamp issue

	rfc2833_period[chid] = 0;	// hc+ for avoid voice packet interleave issue
	
	eventPacket->own = OWNBYRTP;
	return 0;
}


static unsigned short duration[SESS_NUM] = {0};

#define EVENT_PKT_FIFO_NUM 10
static RtpPacket eventPkt_fifo[MAX_SESS_NUM][EVENT_PKT_FIFO_NUM]={{{0}}};
static int eventPkt_fifo_r[MAX_SESS_NUM]={0}, eventPkt_fifo_w[MAX_SESS_NUM]={0};

static int eventPkt_fifoWrite(int sid, RtpPacket *eventPkt)
{
	RtpPacket* p;
	
	if(((eventPkt_fifo_w[sid]+1)%EVENT_PKT_FIFO_NUM) == eventPkt_fifo_r[sid])
	{
		printk("RTP Event PKT FIFO Full\n");
		return 0;
	}
		
	p = &eventPkt_fifo[sid][eventPkt_fifo_w[sid]];
	memcpy(p, eventPkt, sizeof(RtpPacket));
	p->packetData = p->packetbuf;
	p->header = (RtpHeader*) (char*)(p->packetData);
	eventPkt_fifo_w[sid] = (eventPkt_fifo_w[sid] + 1)%EVENT_PKT_FIFO_NUM;
	//printk("w[%d]=%d\n", sid, eventPkt_fifo_w[sid]);
		
	return 1;
}

static int eventPkt_fifoRead(int sid, RtpPacket** eventPacket)
{

	if (eventPkt_fifo_r[sid] == eventPkt_fifo_w[sid])
	{
		//printk("RTP Event PKT FIFO Empty\n");
		//printk(".");
		return 0;
	}

	*eventPacket = &eventPkt_fifo[sid][eventPkt_fifo_r[sid]];
	
	return 1; 
	
}

static void eventPkt_fifoReadDone(int sid)
{
	unsigned long flags;

	save_flags(flags); cli();
	eventPkt_fifo_r[sid] = (eventPkt_fifo_r[sid]+1)%EVENT_PKT_FIFO_NUM;
	restore_flags(flags);
	// printk("r[%d]=%d\n", sid, eventPkt_fifo_r[sid]);
}

static void eventPkt_fifoFlush(int sid)
{
	eventPkt_fifo_r[sid] = 0;
	eventPkt_fifo_w[sid] = 0;
}

// Support FaxModem RTP Removal Flag
static uint32 Support_FaxModem_RtpRemoval[MAX_VOIP_CH_NUM] = {0};

int SetFaxModem_RtpRemoval(uint32 chid, uint32 flag)
{
	Support_FaxModem_RtpRemoval[chid] = flag;
	return 0;
}

int GetFaxModem_RtpRemoval(uint32 chid)
{
	return Support_FaxModem_RtpRemoval[chid];
}

static int dtmf_three_end[MAX_SESS_NUM] = {[0 ... MAX_SESS_NUM-1] = 1};
static int fax_modem_three_end[MAX_SESS_NUM] = {[0 ... MAX_SESS_NUM-1] = 1};

int get_2833_three_end(uint32 sid)
{
	int chid, ret;
	extern uint32 chanInfo_GetChannelbySession(uint32 sid);
	
	chid = chanInfo_GetChannelbySession(sid);
	
	if (Support_FaxModem_RtpRemoval[chid] == 1)
	{
		ret = (dtmf_three_end[sid] & fax_modem_three_end[sid]);
		//printk("%d ", fax_modem_three_end[chid]);
	}
	else
	{
		ret = dtmf_three_end[sid];
		//printk("2:%d\n", ret);
	}
	
	return ret;
}

struct tasklet_struct	event_send_tasklet;

void event_send(unsigned long *dummy)
{
	static int end_cnt[MAX_SESS_NUM] = {0};
	unsigned char sid;
	RtpPacket* eventPacket = NULL;
	RtpEventDTMFRFC2833* eventPayload = NULL;
	int eventPacket_EventPktEdge;
	int eventPayload_event;

	for(sid=0; sid < MAX_SESS_NUM; sid++)
	{
		while(eventPkt_fifoRead(sid, &eventPacket))
		{
			eventPayload = getPayloadLoc(eventPacket);
			
			if (eventPacket->EventPktEdge == false)
			{
				end_cnt[sid] = 0;
				if ((eventPayload->event >= 0) && (eventPayload->event <= 16))
					dtmf_three_end[sid] = 0;
				else if ((eventPayload->event >= 32) && (eventPayload->event <= 49))
					fax_modem_three_end[sid] = 0;
			}

			// backup check variable for later use 
			eventPacket_EventPktEdge = eventPacket->EventPktEdge;
			eventPayload_event = eventPayload->event;

			transmit(eventPacket, true);
			eventPkt_fifoReadDone(sid);

			// transmit() may modify eventPacket and eventPayload, so 
			// don't use them 
			if (eventPacket_EventPktEdge == true)
			{
				end_cnt[sid]++;
				//printk("=> %d\n", end_cnt[chid]);
				if (end_cnt[sid] == 3)
				{
					if ((eventPayload_event >= 0) && (eventPayload_event <= 16))
						dtmf_three_end[sid] = 1;
					else if ((eventPayload_event >= 32) && (eventPayload_event <= 49))
						fax_modem_three_end[sid] = 1;
				}
			}
		}
	}
}

static unsigned int check_removal(uint32 sid, int event)
{
	//extern char dtmf_removal[MAX_VOIP_CH_NUM][2];
	extern uint32 chanInfo_GetChannelbySession(uint32 sid);
	extern unsigned int check_answer_id(unsigned int chid);
	int chid;
	
	chid = chanInfo_GetChannelbySession(sid);
	
	if ((event >= 0) && (event <= 16))		// DTMF Event
	{
#if 0
		return (unsigned int)dtmf_removal[chid][0];
#else
		if (send_2833_count_down_dsp[sid] > 0)
			return 1;
		else if (send_2833_count_down_dsp[sid] == 0)
			return 0;
#endif
	}
	else if ((event >= 32) && (event <= 49))	// Modem/Fax Event
	{
		//printk("%d ",check_answer_id(chid));
		if (check_answer_id(chid) != 0)
			return 1;
		else
			return 0;
	}
}

int get_2833_send_flag(uint32 sid)
{
	extern int send_dtmf_flag[];
	extern int send_modem_fax_flag[];
	extern uint32 chanInfo_GetChannelbySession(uint32 sid);
	int chid, ret;
	
	chid = chanInfo_GetChannelbySession(sid);
	
	if (Support_FaxModem_RtpRemoval[chid] == 1)
		ret = (send_dtmf_flag[sid] ||send_modem_fax_flag[sid]);
	else
		ret = send_dtmf_flag[sid] ;
	
	return ret;
}

static void set_2833_send_flag(uint32 sid, int event, int flag)
{
	extern int send_dtmf_flag[];
	extern int send_modem_fax_flag[];

	if ((event >= 0) && (event <= 16))		// DTMF Event
		send_dtmf_flag[sid] = flag;
	else if ((event >= 32) && (event <= 49))	// Modem/Fax Event
		send_modem_fax_flag[sid] = flag;
}

static int reset_2833_send_flag(uint32 sid)
{
	extern int send_dtmf_flag[];
	extern int send_modem_fax_flag[];
	
	send_dtmf_flag[sid] = 0;
	send_modem_fax_flag[sid] = 0;
	dtmf_three_end[sid] = 1;
	fax_modem_three_end[sid] = 1;
}

int Reset_RFC2833_Trasmit(uint32 sid)
{
	eventPkt_fifoFlush(sid);
	reset_2833_send_flag(sid);
}

uint32 rfc2833_count_add(uint32 sid, uint32 cnt)
{
	send_2833_count_down_dsp[sid] += cnt;
	
	//printk("%d-s%d\n", send_2833_count_down_dsp[sid], sid);

	return send_2833_count_down_dsp[sid];
}

uint32 rfc2833_count_sub(uint32 sid, uint32 cnt)
{
	if (send_2833_count_down_dsp[sid] >= cnt)
		send_2833_count_down_dsp[sid] -= cnt;
	else
		send_2833_count_down_dsp[sid] = 0;
	
	return send_2833_count_down_dsp[sid];
}

int RtpTx_transmitEvent_ISR( uint32 chid, uint32 sid, int event)
{
	
	int i;
	RtpTransmitter* pInfo = NULL;
		
	if(chid >= voip_ch_num)
	{
		set_2833_send_flag(sid, event, 0);
		return 0;
	}

	if(sid >= SESS_NUM)
	{
		set_2833_send_flag(sid, event, 0);
		return 0;
	}
	
	if(!isTranMode(sid))
		return 0;
		
	if (rfc2833_payload_type_remote[sid] == 0) /* 0: Don't send 2833 packets. */
	{
		set_2833_send_flag(sid, event, 0);
		return 0;
	}

	if (!send_2833_start[sid])
	{
  		if(((send_2833_count_down[ sid ] != 0) && (send_2833_by_ap[chid] == 1) ) ||
  			((check_removal(sid, event) == 1) && (send_2833_by_ap[chid] == 0))) 
		{
			send_2833_start[sid] = 1;
			send_marker_flag[sid] = 1;
			//printk("s\n");	
		}
		else
		{
			set_2833_send_flag(sid, event, 0);
			return 0;
		}
	}
	else
	{
  		if(((send_2833_count_down[ sid ] == 0) && (send_2833_by_ap[chid] == 1) ) ||
  			((check_removal(sid, event) == 0) && (send_2833_by_ap[chid] == 0))) 
		{
			send_edge_flag[sid] = 1;
			send_2833_flag[sid] = 0;
			//printk("e\n");	
		}
		else
			send_2833_flag[sid] = 1;
	}


	pInfo = &RtpTxInfo[sid];


	RtpPacket* eventPacket = createPacket(chid, sid, 0, 0);
	setPayloadType( eventPacket, rfc2833_payload_type_remote[sid]);
	setPayloadUsage( eventPacket, sizeof( RtpEventDTMFRFC2833 ) );
	RtpEventDTMFRFC2833* eventPayload = (RtpEventDTMFRFC2833*)( getPayloadLoc(eventPacket) );

	// reset event payload
	eventPayload->event = event; 
	eventPayload->volume = gRfc2833_volume[sid];
	eventPayload->reserved = 0;
	eventPayload->edge = 0;
	eventPayload->duration = duration[sid];
	setMarkerFlag(eventPacket,0);
	eventPacket->RFC2833 = FALSE;
	eventPacket->EventPktMarker = false;
	eventPacket->EventPktBody = false;
	eventPacket->EventPktEdge = false;
	

	/* Send Marker Packet */
	if (send_marker_flag[sid] == 1)
	{
		duration[sid] = 80;
		setMarkerFlag(eventPacket, 1);
		eventPayload->duration = duration[sid];
		eventPacket->timestampSet = false ;
		eventPacket->sequenceSet = false ;
		eventPacket->EventPktMarker = true;
		eventPacket->RFC2833 = TRUE;
		//transmit( eventPacket, true ) ;
		eventPkt_fifoWrite(sid, eventPacket);
		
		send_marker_flag[sid] = 0;
		//printk("ss\n");	
	}

#ifdef SUPPORT_RFC2833_PLAY_LIMIT
	if (bRfc2833_play_limit[sid] == 1)
	{
		if (duration[sid] >= (rfc2833_play_limit_ms[sid]*8 - 80*PCM_PERIOD))
		{
			send_edge_flag[sid] = 1;
			send_2833_flag[sid] = 0;
			//printk("==> stop 2833 event gen, sid=%d\n", sid);
		}	
	}		
#endif


	/* Send 2833 Event Packet */
	if (send_2833_flag[sid] == 1)
	{
		duration[sid] += 80*PCM_PERIOD;
		eventPayload->duration = duration[sid];
		eventPacket->timestampSet = true;
		eventPacket->sequenceSet = false ;
		eventPacket->EventPktBody = true;
		eventPacket->RFC2833 = TRUE;
		//transmit( eventPacket, true );
		eventPkt_fifoWrite(sid, eventPacket);
		//printk("st\n");	

	}
	

	/* Send Edge Packet */
	if (send_edge_flag[sid] == 1)
	{
		eventPayload->edge = 1;
		duration[sid] += 80*PCM_PERIOD;
		eventPayload->duration = duration[sid];
		
		/*** send three the same sequence number edge packets ***/
		
		eventPacket->timestampSet = true;
		eventPacket->sequenceSet = false;
		eventPacket->EventPktEdge = true;
		eventPacket->RFC2833 = TRUE;
		//transmit( eventPacket, true );
		eventPkt_fifoWrite(sid, eventPacket);
		
		send_edge_flag[sid] = 0;	/* Must be set to 0 after send first edge packets */
		
		for(i=0; i<2; i++)
		{
			eventPacket->timestampSet = true;
			eventPacket->sequenceSet = true;
			eventPacket->EventPktEdge = true;
			eventPacket->RFC2833 = TRUE;
			//transmit( eventPacket, true );
			eventPkt_fifoWrite(sid, eventPacket);
		}
		
		send_2833_start[sid] = 0;
		set_2833_send_flag(sid, event, 0);
		//printk("se\n");	
	}
	
	tasklet_hi_schedule(&event_send_tasklet);
	eventPacket->own = OWNBYRTP;

  	if (send_2833_by_ap[chid] == 1)
  	{
		if( send_2833_count_down[ sid ] ) 
			send_2833_count_down[ sid ] --;	/* dec. 2833 count */
	}
	else
	{
		if( send_2833_count_down_dsp[ sid ] ) 
			send_2833_count_down_dsp[ sid ] --;	/* dec. 2833 count */
	}
	
	return 1;
}
#endif


void RtpTx_setFormat (uint32 sid, RtpPayloadType newtype, int frameRate)
{
	const codec_payload_desc_t *pCodecPayloadDesc;
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;

	pInfo = &RtpTxInfo[sid];

	pInfo->payloadFormat = newtype;

	pCodecPayloadDesc = GetCodecPayloadDesc( newtype );
	
	if( pCodecPayloadDesc ) { 
		pInfo->bitRate = 8000;
		pInfo->payloadSize = 
			_imul32(pCodecPayloadDesc ->nFrameBytes, 
					_idiv32(frameRate, pCodecPayloadDesc ->nTranFrameRate));
	#ifdef SUPPORT_MULTI_FRAME
		pInfo->pktSampleSize = pCodecPayloadDesc ->nFrameTimestamp * MFFrameNo[sid];
	#else
		pInfo->pktSampleSize = pCodecPayloadDesc ->nFrameTimestamp;
	#endif		
	} else {
		pInfo->bitRate = 8000;
		pInfo->payloadSize = 160;
		pInfo->pktSampleSize = 160;
	}
	
	// setFormat can know timestamp period, so update again 
	pInfo->prevRtpTime = pInfo->seedRtpTime - pInfo->pktSampleSize;
}

void RtpTx_addTimestamp (uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;
	
	pInfo = &RtpTxInfo[sid];
    pInfo->prevRtpTime += pInfo->pktSampleSize;
}

void RtpTx_addTimestampOfOneFrame (uint32 sid)
{
	/*
	 * During silence period, 'Not Tx' is generated in period of one frame.
	 */
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;

	pInfo = &RtpTxInfo[sid];
#if 0
	// Satisfy with G711 and G729 only.
    	 pInfo->prevRtpTime += 80;		// 10ms
#else
 #ifdef SUPPORT_MULTI_FRAME
     pInfo->prevRtpTime += ( pInfo->pktSampleSize / MFFrameNo[sid] );
 #else
	 pInfo->prevRtpTime += pInfo->pktSampleSize;
 #endif
#endif
}

void RtpTx_subTimestamp(uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;
	
	pInfo = &RtpTxInfo[sid];
    pInfo->prevRtpTime -= pInfo->pktSampleSize;
}

 #ifdef CONFIG_RTK_VOIP_G729AB
uint32 G729GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadG729:	// G729 */
	return ( nSize + 9 ) / 10;	// G729 length: 10 bytes
}
 #endif /* CONFIG_RTK_VOIP_G729AB */

uint32 G711GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/*
	case rtpPayloadPCMU:	// G711
	case rtpPayloadPCMA:
	*/
	return ( nSize + 79 ) / 80;	// G711 length: 80 bytes
}

 #ifdef CONFIG_RTK_VOIP_G722
uint32 G722GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{		
	return ( nSize + 79 ) / 80;	// G722 length: 80 bytes;
}
 #endif /* CONFIG_RTK_VOIP_G722 */

 #ifdef CONFIG_RTK_VOIP_G7231
uint32 G723GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{		
	/* case rtpPayloadG723:	// G723 */
	if( pBuffer[ 0 ] & 0x02 ) 		// VAD FLAG --> SID 
		return 1;
	else if( pBuffer[ 0 ] & 0x01 )	// RATE FLAG 
		return ( nSize + 19 ) / 20;	// G723 5.3k
	else
		return ( nSize + 23 ) / 24;	// G723 6.3k
}
 #endif /* CONFIG_RTK_VOIP_G7231 */

 #ifdef CONFIG_RTK_VOIP_G726
uint32 G726_16GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadG726_16:	// G726 16k */
	return ( nSize + 19 ) / 20;	// G726-16k length: 20 bytes
}

uint32 G726_24GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadG726_24:	// G726 24k */
	return ( nSize + 29 ) / 30;	// G726-24k length: 30 bytes
}

uint32 G726_32GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadG726_32:	// G726 32k */
	return ( nSize + 39 ) / 40;	// G726-32k length: 40 bytes
}

uint32 G726_40GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadG726_40:	// G726 40k */
	return ( nSize + 49 ) / 50;	// G726-40k length: 50 bytes
}
 #endif /* CONFIG_RTK_VOIP_G726 */

 #ifdef CONFIG_RTK_VOIP_GSMFR
uint32 GSMfrGetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadGSM: */
	return ( nSize + 32 ) / 33;
}
 #endif /* CONFIG_RTK_VOIP_GSMFR */
		
 #ifdef CONFIG_RTK_VOIP_ILBC
uint32 iLBC30msGetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadiLBC30ms: */
	return ( nSize + 49 ) / 50;
}
uint32 iLBC20msGetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadiLBC20ms: */
	return ( nSize + 37 ) / 38;
}
 #endif /* CONFIG_RTK_VOIP_ILBC */
 
  #ifdef CONFIG_RTK_VOIP_AMR_NB
uint32 AMR_NB_GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{		
	// @@-amr
	//return ( nSize + 33 ) / 34;	// 12.2K
	return 1;
}
 #endif /* CONFIG_RTK_VOIP_AMR_NB */
	
 #ifdef CONFIG_RTK_VOIP_T38
uint32 T38GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	/* case rtpPayloadT38_Virtual: */
	/* This is a dummy function */
	return 1;
}
 #endif /* CONFIG_RTK_VOIP_T38 */
		
  #ifdef CONFIG_RTK_VOIP_SPEEX_NB
uint32 SPEEX_NB_GetTxNumberOfFrame( uint32 nSize, const char *pBuffer )
{
	// @@-speex nb

	return 1;
}
 #endif /* CONFIG_RTK_VOIP_SPEEX_NB */
		
void RtpTx_subTimestampIfNecessary( uint32 sid, char *pBuf, int32 size )
{
	/*
	 * In original design, we assume that every packet contains a
	 * fixed amount of frames, so (80 * framePerPkt) is always added 
	 * to time stamp.
	 * In newer design, subtract time stamp in two cases:
	 *  1) a packet may contain various frames, which 
	 *     could combine voice and SID frames.
	 *     PS. G729 only
	 *  2) While the last frame of a packet is SID, the packet may not  
	 *     satisfy number of frame per packet. 
	 */

	const codec_payload_desc_t *pCodecPayloadDesc;
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;

	pInfo = &RtpTxInfo[sid];


	int32 nNumOfFrame;
	uint32 nDeltaOfTimestamp;
	uint32 nFrameTimestamp;		// frame interval

	// consider SID is a part of packet
	pCodecPayloadDesc = GetCodecPayloadDesc( pInfo->payloadFormat );
	
	if( pCodecPayloadDesc ) {
		nNumOfFrame = ( *pCodecPayloadDesc ->fnGetTxNumberOfFrame )( size, pBuf );
		nFrameTimestamp = pCodecPayloadDesc ->nFrameTimestamp;
	} else {
		printk( "ST " );
		return;
	}

	// ok. a normal packet
	if( nNumOfFrame == MFFrameNo[sid] )
		return;
			
	nDeltaOfTimestamp = ( MFFrameNo[sid] - nNumOfFrame ) * nFrameTimestamp;
	
	pInfo->prevRtpTime -= nDeltaOfTimestamp;
}

void RtpTx_setMarkerOnce(uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;

	pInfo = &RtpTxInfo[sid];
	pInfo->markerOnce = TRUE;
}

RtpTime RtpTx_getPrevRtpTime (uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return 0;

	pInfo = &RtpTxInfo[sid];
	return pInfo->prevRtpTime;
}

RtpSrc RtpTx_getSSRC (uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return 0;

	pInfo = &RtpTxInfo[sid];
	return pInfo->ssrc;
}

///
int RtpTx_getPacketSent (uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return 0;

	pInfo = &RtpTxInfo[sid];
	return pInfo->packetSent;
}
///
int RtpTx_getPayloadSent (uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return 0;

	pInfo = &RtpTxInfo[sid];
	return pInfo->payloadSent;
}

void RtpTx_setMode(uint32 sid, RtpTransmitMode opmode)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return;

	pInfo = &RtpTxInfo[sid];
	pInfo->tranOpmode = opmode;
}

int32 isTranMode(uint32 sid)
{
	RtpTransmitter* pInfo = NULL;
	if(sid >= SESS_NUM)	// Sandro+
		return 0;

	pInfo = &RtpTxInfo[sid];
	if(pInfo->tranOpmode == rtptran_droppacket)
		return 0;
	return 1;
}

