/*
 *	msgparser.c -- Parser for an well-formed message
 */

#include "../msgq.h"
#include "mibtbl.h"
#include "utility.h"
#include <stdio.h>
#include <sys/reboot.h>
#include <sys/stat.h>
#include <signal.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <pthread.h>
#ifdef EMBED
#include <config/autoconf.h>
#else
#include "../../../../config/autoconf.h"
#endif
#ifdef _USE_RSDK_WRAPPER_
#include "../../../spppd/pppoe.h"
#endif //_USE_RSDK_WRAPPER_
#include <linux/version.h>
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411)
#include "subr_dhcpv6.h"
#endif

#ifdef CONFIG_MTD_NAND
#include "rtl_flashdrv_api.h"
#endif
#define MAX_ARGS	3
#define MAX_ARG_LEN	32

#ifdef CONFIG_IPV6
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411)
static DLG_INFO_T dlg_info;
#endif
static DLG_INFO_T old_dlg_info={0};	
#endif

extern int shm_id;
extern char *shm_start;
extern char g_upload_post_file_name[MAX_SEND_SIZE];
extern int g_upload_startPos;
extern int g_upload_fileSize;

static int parse_token(char *buf, char argv[MAX_ARGS][MAX_ARG_LEN+1]);
//static void cfg_get(int argc, char argv[MAX_ARGS][MAX_ARG_LEN+1], struct mymsgbuf *qbuf);
static void cfg_mib_get(struct mymsgbuf *qbuf);
//static void cfg_set(int argc, char argv[MAX_ARGS][MAX_ARG_LEN+1], struct mymsgbuf *qbuf);
static void cfg_mib_set(struct mymsgbuf *qbuf);
static void cfg_mib_set_flash(struct mymsgbuf *qbuf);
static void cfg_mib_info_id(struct mymsgbuf *qbuf);
static void cfg_mib_info_index(struct mymsgbuf *qbuf);
static void cfg_mib_info_total(struct mymsgbuf *qbuf);  // For Star Zhang's fast load
static void cfg_mib_backup(struct mymsgbuf *qbuf);
static void cfg_mib_restore(struct mymsgbuf *qbuf);
static void cfg_mib_get_default(struct mymsgbuf *qbuf);
static void cfg_mib_swap(struct mymsgbuf *qbuf);
static void cfg_mib_flash_to_default(struct mymsgbuf *qbuf);
#if (defined VOIP_SUPPORT) && (defined CONFIG_USER_XMLCONFIG)
static void cfg_mib_voip_to_default(struct mymsgbuf *qbuf);
#endif
/*
static void cfg_mib_size(struct mymsgbuf *qbuf);
static void cfg_mib_type(struct mymsgbuf *qbuf);
*/
static void cfg_chain_total(struct mymsgbuf *qbuf);
static void cfg_chain_get(struct mymsgbuf *qbuf);
static void cfg_chain_add(struct mymsgbuf *qbuf);
static void cfg_chain_delete(struct mymsgbuf *qbuf);
static void cfg_chain_clear(struct mymsgbuf *qbuf);
static void cfg_chain_update(struct mymsgbuf *qbuf);
static void cfg_chain_swap(struct mymsgbuf *qbuf);
static void cfg_chain_info_id(struct mymsgbuf *qbuf);
static void cfg_chain_info_index(struct mymsgbuf *qbuf);
static void cfg_chain_info_name(struct mymsgbuf *qbuf);
static void cfg_chain_desc_id(struct mymsgbuf *qbuf);
static void cfg_check_desc(struct mymsgbuf *qbuf);

static void cfg_mib_lock(struct mymsgbuf *qbuf);
static void cfg_mib_unlock(struct mymsgbuf *qbuf);
static void cfg_mib_update_from_raw(struct mymsgbuf *qbuf);
static void cfg_mib_read_to_raw(struct mymsgbuf *qbuf);
static void cfg_mib_update(struct mymsgbuf *qbuf);
static void cfg_mib_read_header(struct mymsgbuf *qbuf);
static void cfg_mib_reload(struct mymsgbuf *qbuf);
#ifdef EMBED
static void cfg_reboot(struct mymsgbuf *qbuf);
#ifdef CONFIG_IPV6
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411) && defined(CONFIG_USER_RADVD)
static void cfg_delegation(struct mymsgbuf *qbuf);
#endif
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411)
static void cfg_stop_delegation(struct mymsgbuf *qbuf);
static void cfg_get_PD_prefix_ip(struct mymsgbuf *qbuf);
static void cfg_get_PD_prefix_len(struct mymsgbuf *qbuf);
#endif
#endif
static void cfg_upload(struct mymsgbuf *qbuf);
static void cfg_killprocess(struct mymsgbuf *qbuf);
static void cfg_check_image(struct mymsgbuf *qbuf);
#ifdef CONFIG_RTL8672_SAR
#ifdef AUTO_PVC_SEARCH_AUTOHUNT
static void cfg_start_autohunt(struct mymsgbuf *qbuf);
#endif
#endif
#ifdef CONFIG_USER_DDNS
static void cfg_ddns_ctrl(struct mymsgbuf *qbuf);
#endif
#endif
static void cfg_file2xml(struct mymsgbuf *qbuf);
static void cfg_xml2file(struct mymsgbuf *qbuf);
///added by ql
static void cfg_retrieve_table(struct mymsgbuf *qbuf);
static void cfg_retrieve_chain(struct mymsgbuf *qbuf);
static void cfg_clear_mib(struct mymsgbuf *qbuf);
//#ifdef  CONFIG_USER_PPPOE_PROXY
#if 0
static void cfg_add_policy_rule(struct mymsgbuf * qbuf);
static void cfg_del_policy_rule(struct mymsgbuf * qbuf);
static void cfg_add_policy_table(struct mymsgbuf * qbuf);
static void cfg_del_policy_table(struct mymsgbuf * qbuf);
static void cfg_noadsllink_ppp(struct mymsgbuf *qbuf);
#endif
static void cfg_update_PPPoE_session(struct mymsgbuf *qbuf);
static void cfg_mib_set_PPPoE(struct mymsgbuf *qbuf);

static void cfg_ip_config_changed(struct mymsgbuf *qbuf);

#if defined(CONFIG_USER_CWMP_TR069)
static void cfg_set_acs_url_route(struct mymsgbuf *qbuf);
#endif

struct command
{
	int	needs_arg;
	int	cmd;
	void	(*func)(struct mymsgbuf *qbuf);
};

volatile int __mib_lock = 0;
MIB_T table_backup;
unsigned char *chain_backup = NULL;
unsigned int backupChainSize = 0;

static struct command commands[] = {
	{1, CMD_MIB_GET, cfg_mib_get},
	{1, CMD_MIB_SET, cfg_mib_set},
	{1, CMD_MIB_SET_FLASH, cfg_mib_set_flash},
	{1, CMD_MIB_INFO_ID, cfg_mib_info_id},
	{1, CMD_MIB_INFO_INDEX, cfg_mib_info_index},
	{1, CMD_MIB_INFO_TOTAL, cfg_mib_info_total},  // For Star Zhang's fast load
	{1, CMD_MIB_BACKUP, cfg_mib_backup},
	{1, CMD_MIB_RESTORE, cfg_mib_restore},
	{1, CMD_MIB_GET_DEFAULT, cfg_mib_get_default},
	{1, CMD_MIB_SWAP, cfg_mib_swap},
	{1, CMD_MIB_FLASH_TO_DEFAULT, cfg_mib_flash_to_default},
#if (defined VOIP_SUPPORT) && (defined CONFIG_USER_XMLCONFIG)
	{1, CMD_MIB_VOIP_TO_DEFAULT, cfg_mib_voip_to_default},
#endif
	/*
	{1, CMD_MIB_SIZE, cfg_mib_size},
	{1, CMD_MIB_TYPE, cfg_mib_type},
	*/
	{1, CMD_CHAIN_TOTAL, cfg_chain_total},
	{1, CMD_CHAIN_GET, cfg_chain_get},
	{1, CMD_CHAIN_ADD, cfg_chain_add},
	{1, CMD_CHAIN_DELETE, cfg_chain_delete},
	{1, CMD_CHAIN_CLEAR, cfg_chain_clear},
	{1, CMD_CHAIN_UPDATE, cfg_chain_update},
	{1, CMD_CHAIN_INFO_ID, cfg_chain_info_id},
	{1, CMD_CHAIN_INFO_INDEX, cfg_chain_info_index},
	{1, CMD_CHAIN_INFO_NAME, cfg_chain_info_name},
	{1, CMD_CHAIN_DESC_ID, cfg_chain_desc_id},
	{1, CMD_CHECK_DESC, cfg_check_desc},
	{1, CMD_CHAIN_SWAP, cfg_chain_swap},
	/*
	{1, CMD_CHAIN_SIZE, cfg_chain_size},
	*/
	{1, CMD_MIB_LOCK, cfg_mib_lock},
	{1, CMD_MIB_UNLOCK, cfg_mib_unlock},
	{1, CMD_MIB_UPDATE_FROM_RAW, cfg_mib_update_from_raw},
	{1, CMD_MIB_READ_TO_RAW, cfg_mib_read_to_raw},
	{1, CMD_MIB_UPDATE, cfg_mib_update},
	{1, CMD_MIB_READ_HEADER, cfg_mib_read_header},
	{1, CMD_MIB_RELOAD, cfg_mib_reload},
#ifdef EMBED
	{1, CMD_REBOOT, cfg_reboot},
	{1, CMD_UPLOAD, cfg_upload},
	{1, CMD_KILLPROC, cfg_killprocess},
	{1, CMD_CHECK_IMAGE, cfg_check_image },
#ifdef CONFIG_RTL8672_SAR
#ifdef AUTO_PVC_SEARCH_AUTOHUNT
	{1, CMD_START_AUTOHUNT, cfg_start_autohunt},
#endif
#endif
#ifdef CONFIG_USER_DDNS
	{1, CMD_DDNS_CTRL, cfg_ddns_ctrl },
#endif
	{1, CMD_FILE2XML, cfg_file2xml},
	{1, CMD_XML2FILE, cfg_xml2file},
#endif
//#ifdef CONFIG_USER_PPPOE_PROXY
#if 0
	{1, CMD_ADD_POLICY_RULE,	cfg_add_policy_rule},
	{1, CMD_DEL_POLICY_RULE,	cfg_del_policy_rule},
	{1, CMD_ADD_POLICY_TABLE,	cfg_add_policy_table},
	{1, CMD_DEL_POLICY_TABLE,	cfg_del_policy_table},
	{1, CMD_NO_ADSLLINK_PPP,	cfg_noadsllink_ppp},
#endif
#ifdef	RESERVE_KEY_SETTING
	{1, CMD_MIB_RETRIVE_TABLE, cfg_retrieve_table},
	{1, CMD_MIB_RETRIVE_CHAIN, cfg_retrieve_chain},
	{1, CMD_MIB_CLEAR,	cfg_clear_mib},
#endif
	{1, CMD_UPDATE_PPPOE_SESSION, cfg_update_PPPoE_session},
	{1, CMD_MIB_SAVE_PPPOE, cfg_mib_set_PPPoE},
#ifdef CONFIG_IPV6
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411) && defined(CONFIG_USER_RADVD)
	{1, CMD_DELEGATION, cfg_delegation},
#endif
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411)
	{1, CMD_STOP_DELEGATION, cfg_stop_delegation},
	{1, CMD_GET_PD_PREFIX_IP, cfg_get_PD_prefix_ip},
	{1, CMD_GET_PD_PREFIX_LEN, cfg_get_PD_prefix_len},
#endif
#endif
	{1, CMD_IP_CONFIG_CHANGED, cfg_ip_config_changed},
	{0, 0, NULL}
};

int msgProcess(struct mymsgbuf *qbuf)
{
  	int argc, c;
	char argv[MAX_ARGS][MAX_ARG_LEN+1];

	// response message type should be the client request magic number
	qbuf->mtype = qbuf->request;
	/*
	if ((argc=parse_token(qbuf->mtext, argv)) == 0)
		return 0;

	for(c=0; commands[c].name!=NULL; c++) {
		if(!strcmp(argv[0], commands[c].name)) {
			argc--;
			if(argc >= commands[c].num_string_arg)
				commands[c].func(argc, (char **)(&argv[1]), qbuf);
			break;
		}
	}
	*/
	for (c=0; commands[c].cmd!=0; c++) {
		if (qbuf->msg.cmd == commands[c].cmd) {
			commands[c].func(qbuf);
			break;
		}
	}
	return 0;
}

/******************************************************************************/
/*
 *	Token Parser -- parse tokens seperated by spaces on buf
 *	Return: number of tokens been parsed
 */

#if 0
static int parse_token(char *buf, char argv[MAX_ARGS][MAX_ARG_LEN+1])
{
  	int num, arg_idx, i;
  	char *arg_ptr;

	num = 0;
	arg_idx = 0;

	for(i=0; buf[i]!='\0'; i++) {
		if(buf[i]==' '){
			if (arg_idx != 0) {	// skip multiple spaces
				argv[num][arg_idx]='\0';
				num++;
				arg_idx=0;
				if (num == MAX_ARGS)
					break;
			}
		}
		else {
			if(arg_idx<MAX_ARG_LEN) {
				argv[num][arg_idx]=buf[i];
				arg_idx++;
			}
		}
	}

	if (arg_idx != 0) {
		argv[num][arg_idx]='\0';
		num++;
	}

	return num;
}
#endif

#ifdef CONFIG_USER_XMLCONFIG
static int xml_mib_update(CONFIG_DATA_T type, CONFIG_MIB_T flag)
{
	int ret=1;
	
	printf("%s():...\n", __FUNCTION__);
	if (va_cmd("/bin/sh",2,0, "/etc/scripts/config_xmlconfig.sh", "-u") != MSG_SUCC) {
		printf("[xmlconfig] mib update failed\n");
		ret = 0;
	}

	return ret;
}

#endif /*CONFIG_USER_XMLCONFIG */

static void cfg_mib_lock(struct mymsgbuf *qbuf)
{
	__mib_lock = 1;
	qbuf->request = MSG_SUCC;
}

static void cfg_mib_unlock(struct mymsgbuf *qbuf)
{
	__mib_lock = 0;
	qbuf->request = MSG_SUCC;
}

static void cfg_mib_update_from_raw(struct mymsgbuf *qbuf)
{
	int len;

	qbuf->request = MSG_FAIL;
	len = qbuf->msg.arg1;

	//printf("update_from_raw: shm_id=%d; shm_start=0x%x\n", shm_id, shm_start);
	if(shm_start && _mib_update_from_raw(shm_start, len) == 1)
		qbuf->request = MSG_SUCC;
}

static void cfg_mib_read_to_raw(struct mymsgbuf *qbuf)
{
	CONFIG_DATA_T data_type;
	int len;

	qbuf->request = MSG_FAIL;
	data_type = (CONFIG_DATA_T)qbuf->msg.arg1;
	len = qbuf->msg.arg2;
	if (len > SHM_SIZE || shm_start == NULL)
		return;
	if (_mib_read_to_raw(data_type, shm_start, len)==1)
		qbuf->request = MSG_SUCC;
}

static void cfg_mib_update(struct mymsgbuf *qbuf)
{
#ifdef CONFIG_USER_CWMP_TR069
	int cwmp_msgid;
	struct cwmp_message cwmpmsg;
#endif
	CONFIG_DATA_T data_type;
	CONFIG_MIB_T flag;

	qbuf->request = MSG_FAIL;

	data_type = (CONFIG_DATA_T)qbuf->msg.arg1;
	flag = (CONFIG_MIB_T)qbuf->msg.arg2;

#ifdef CONFIG_USER_XMLCONFIG
	if (xml_mib_update(data_type, flag))
		qbuf->request = MSG_SUCC;
#else
	if (data_type == CURRENT_SETTING) {
		if (flag == CONFIG_MIB_ALL) {
			if(_mib_update(data_type)!=0)
				qbuf->request = MSG_SUCC;
		}
		else if (flag == CONFIG_MIB_TABLE) {
			PARAM_HEADER_T header;
			unsigned int total_size, table_size;
			unsigned char *buf, *ptr;
			unsigned char *pMibTbl;

			if(__mib_header_read(data_type, &header) != 1)
				return;
			total_size = sizeof(PARAM_HEADER_T) + header.len;
			buf = (unsigned char *)malloc(total_size);
			if (buf == NULL)
				return;
			if(_mib_read_to_raw(data_type, buf, total_size) != 1) {
				free(buf);
				return;
			}
			ptr = buf + sizeof(PARAM_HEADER_T);
			// update the mib table only
			pMibTbl = __mib_get_mib_tbl(data_type);
			memcpy(ptr, pMibTbl, sizeof(MIB_T));
			__mib_content_encod_check(data_type, &header, ptr);
			// update header
			memcpy(buf, (unsigned char*)&header, sizeof(PARAM_HEADER_T));

			if(_mib_update_from_raw(buf, total_size) != 1) {
				free(buf);
				return;
			}
			free(buf);
			qbuf->request = MSG_SUCC;
		}
		else { // not support currently, Jenny added
				//jim we should check the size to make sure of no-exceeded flash range....
				//jim this will called by pppoe.c /pppoe_session_info();
			PARAM_HEADER_T header;
			unsigned int chainRecordSize, mibTblSize, totalSize;
			unsigned char *buf, *ptr;
			unsigned char* pVarLenTable = NULL;
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
			if(__mib_header_read(data_type, &header) != 1)
				return;
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
			mibTblSize = __mib_content_min_size(data_type);
			chainRecordSize = __mib_chain_all_table_size(data_type);
			header.len = chainRecordSize + mibTblSize;
			totalSize = sizeof(PARAM_HEADER_T) + header.len;
			buf = (unsigned char *)malloc(totalSize);
		    	//printf("%s line %d Totalsize=%d\n", __FUNCTION__, __LINE__, totalSize);
			if (buf == NULL)
				return;
			//jim
			if(totalSize > __mib_content_max_size(data_type))
			{
				printf("too large config paras to store! abadon!\n");
				free(buf);
				return;
			}
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
			if(_mib_read_to_raw(data_type, buf, totalSize) != 1) {
				free(buf);
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
				return;
			}
			ptr = &buf[sizeof(PARAM_HEADER_T)];	// point to start of MIB data
		    	//printf("%s line %d chainRecordSize=%d\n", __FUNCTION__, __LINE__, chainRecordSize);
			// update the chain record only
			if (chainRecordSize > 0) {
				pVarLenTable = &ptr[mibTblSize];	// point to start of variable length MIB data
				if(__mib_chain_record_content_encod(data_type, pVarLenTable, chainRecordSize) != 1) {
					free(buf);
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
					return;
				}
			}
			__mib_content_encod_check(data_type, &header, ptr);
			// update header
			memcpy(buf, (unsigned char*)&header, sizeof(PARAM_HEADER_T));

		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
			if(_mib_update_from_raw(buf, totalSize) != 1) {
				free(buf);
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
				return;
			}
			qbuf->request = MSG_SUCC;
		    	//printf("%s line %d\n", __FUNCTION__, __LINE__);
			free(buf);
		}
	}
	else {
		if(_mib_update(data_type)!=0)
			qbuf->request = MSG_SUCC;
	}
#endif

	if (qbuf->request == MSG_SUCC) {
#ifdef CONFIG_USER_CWMP_TR069
		if ((cwmp_msgid = msgget((key_t) 1234, 0)) > 0) {
			cwmpmsg.msg_type = MSG_USERDATA_CHANGE;
			cwmpmsg.msg_datatype = qbuf->msg.arg1;
			msgsnd(cwmp_msgid, &cwmpmsg, MSG_SIZE, 0);
		}
#endif

#ifdef CONFIG_USER_XMLCONFIG
#ifdef CONFIG_USER_FLATFSD_XXX
		va_cmd("/bin/flatfsd", 1, 1, "-s");
#endif
#else
		//create config file -- config.xml
		va_cmd("/bin/saveconfig", 1, 0, "-s");
#endif /*CONFIG_USER_XMLCONFIG */
	}
}

/* 2010-10-26 krammer :  */
static void cfg_mib_swap(struct mymsgbuf *qbuf)
{
	int id;

	qbuf->request = MSG_FAIL;

    if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	if(_mib_swap(qbuf->msg.arg1, qbuf->msg.arg2)!=0)
		qbuf->request = MSG_SUCC;
}
/* 2010-10-26 krammer :  */

static void cfg_mib_flash_to_default(struct mymsgbuf *qbuf)
{
	CONFIG_DATA_T data_type;
	qbuf->request = MSG_FAIL;
	data_type = (CONFIG_DATA_T)qbuf->msg.arg1;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}
/* 2013/11 Jiachiam
   Only reset default to ram memory, not write back to flash.
   The latter task is performed by xmlconfig (write back to new xml file).
*/
#ifdef CONFIG_USER_XMLCONFIG
	mib_init_mib_with_program_default(data_type, FLASH_DEFAULT_TO_MEMORY);
#else
	switch (data_type) {
		case CURRENT_SETTING:
			va_cmd("/bin/flash", 2, 1, "default", "cs");
			break;
		case HW_SETTING:
			va_cmd("/bin/flash", 2, 1, "default", "hs");
			break;
		case DEFAULT_SETTING:
		default:
			printf("Not supported type to reset to default.\n");
			return;
	}
#endif /* CONFIG_USER_XMLCONFIG */
	qbuf->request = MSG_SUCC;
}

/** 2013/11 Jiachiam */
#if (defined VOIP_SUPPORT) && (defined CONFIG_USER_XMLCONFIG)
static void cfg_mib_voip_to_default(struct mymsgbuf *qbuf){

       voipCfgParam_t voipEntry;

       qbuf->request = MSG_FAIL;

       if (__mib_lock) {
               qbuf->request = MSG_MIB_LOCKED;
               return;
       }

       _mib_chain_clear(MIB_VOIP_CFG_TBL);
       flash_voip_default(&voipEntry);
       if (_mib_chain_add(MIB_VOIP_CFG_TBL, &voipEntry))
               qbuf->request = MSG_SUCC;

}
#endif /* VOIP_SUPPORT & CONFIG_USER_XMLCONFIG */

static void cfg_mib_get(struct mymsgbuf *qbuf)
{
	int id;

	qbuf->request = MSG_FAIL;

	if(_mib_get(qbuf->msg.arg1, (void *)qbuf->msg.mtext)!=0)
		qbuf->request = MSG_SUCC;
}



static void cfg_mib_get_default(struct mymsgbuf *qbuf)
{
	int id;

	qbuf->request = MSG_FAIL;

	if(_mib_getDef(qbuf->msg.arg1, (void *)qbuf->msg.mtext)!=0)
		qbuf->request = MSG_SUCC;
}

static void cfg_mib_set(struct mymsgbuf *qbuf)
{
#ifdef CONFIG_USER_CWMP_TR069
	int cwmp_msgid;
	struct cwmp_message cwmpmsg;
#endif

	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	if (_mib_set(qbuf->msg.arg1, (void *)qbuf->msg.mtext) != 0) {
		qbuf->request = MSG_SUCC;
#ifdef CONFIG_USER_CWMP_TR069
		if (qbuf->msg.arg2) {
			if ((cwmp_msgid = msgget((key_t) 1234, 0)) > 0) {
				cwmpmsg.msg_type = MSG_USERDATA_CHANGE;
				cwmpmsg.msg_datatype = qbuf->msg.arg1;
				msgsnd(cwmp_msgid, &cwmpmsg, MSG_SIZE, 0);
			}
		}
#endif
	}
}

static void cfg_mib_set_flash(struct mymsgbuf *qbuf)
{
	struct mymsgbuf myqbuf;

	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	_mib_set(qbuf->msg.arg1, (void *)qbuf->msg.mtext); // set to the current table
	myqbuf.msg.arg1 = CONFIG_MIB_TABLE;
	cfg_mib_backup(&myqbuf);	// backup current MIB table into system
	myqbuf.msg.arg1 = CURRENT_SETTING;
	myqbuf.msg.arg2 = CONFIG_MIB_TABLE;
	cfg_mib_reload(&myqbuf);	//get table setting from flash
	_mib_set(qbuf->msg.arg1, (void *)qbuf->msg.mtext); // set to the flash table

	myqbuf.msg.arg1 = CURRENT_SETTING;
	myqbuf.msg.arg2 = CONFIG_MIB_TABLE;
	cfg_mib_update(&myqbuf);

	myqbuf.msg.arg1 = CONFIG_MIB_TABLE;
	cfg_mib_restore(&myqbuf);	// restore backup MIB table
	qbuf->request = MSG_SUCC;
}

static void cfg_mib_info_id(struct mymsgbuf *qbuf)
{
	int k;

	qbuf->request = MSG_FAIL;

	for (k=0; mib_table[k].id; k++) {
		if (mib_table[k].id == qbuf->msg.arg1)
			break;
	}

	if (mib_table[k].id == 0)
		return;

	memcpy((void *)qbuf->msg.mtext, (void *)&mib_table[k], sizeof(mib_table_entry_T));
	qbuf->request = MSG_SUCC;
}

static void cfg_mib_info_index(struct mymsgbuf *qbuf)
{
	int total;

	qbuf->request = MSG_FAIL;

	total = mib_table_size / sizeof(mib_table[0]);
	if (qbuf->msg.arg1 >= total)
		return;

	memcpy((void *)qbuf->msg.mtext, (void *)&mib_table[qbuf->msg.arg1],
	       sizeof(mib_table_entry_T));
	qbuf->request = MSG_SUCC;
}

// Apply Star Zhang's fast load
static void cfg_mib_info_total(struct mymsgbuf *qbuf)
{
	qbuf->request = MSG_FAIL;

	qbuf->msg.arg1 = mib_table_size / sizeof(mib_table[0]);

	qbuf->request = MSG_SUCC;
}
// The end of fast load

static void cfg_mib_backup(struct mymsgbuf *qbuf)
{
	CONFIG_MIB_T type;
	unsigned char *pMibTbl;

	qbuf->request = MSG_FAIL;
	type = (CONFIG_MIB_T)qbuf->msg.arg1;

//	if (type == CONFIG_MIB_ALL || type == CONFIG_MIB_TABLE) {
	if (type == CONFIG_MIB_TABLE) {
		pMibTbl = __mib_get_mib_tbl(CURRENT_SETTING);
		memcpy(&table_backup, pMibTbl, sizeof(MIB_T));  //save setting
	}
	else if (type == CONFIG_MIB_CHAIN){
		unsigned char* pVarLenTable = NULL;
		PARAM_HEADER_T header;
		unsigned int chainRecordSize, mibTblSize, totalSize;
		unsigned char *buf, *ptr;

		if(__mib_header_read(CURRENT_SETTING, &header) != 1)
			return;
		mibTblSize = __mib_content_min_size(CURRENT_SETTING);
		backupChainSize = __mib_chain_all_table_size(CURRENT_SETTING);
		header.len = backupChainSize + mibTblSize;
		totalSize = sizeof(PARAM_HEADER_T) + header.len;
		buf = (unsigned char *)malloc(totalSize);
		if (buf == NULL)
			return;
		if(_mib_read_to_raw(CURRENT_SETTING, buf, totalSize) != 1) {
			free(buf);
			return;
		}
		ptr = &buf[sizeof(PARAM_HEADER_T)];
		if (backupChainSize > 0) {
			pVarLenTable = &ptr[mibTblSize];
			if(__mib_chain_record_content_encod(CURRENT_SETTING, pVarLenTable, backupChainSize) != 1) {
				free(buf);
				return;
			}
		}
		chain_backup = realloc(chain_backup, backupChainSize);
		memcpy(chain_backup, pVarLenTable, backupChainSize);  //save MIB chain setting
		free(buf);
	}
	else if (type == CONFIG_MIB_ALL){
		unsigned char* pVarLenTable = NULL;
		PARAM_HEADER_T header;
		unsigned int chainRecordSize, mibTblSize, totalSize;
		unsigned char *buf, *ptr;

		if(__mib_header_read(CURRENT_SETTING, &header) != 1)
			return;
		mibTblSize = __mib_content_min_size(CURRENT_SETTING);
		backupChainSize = __mib_chain_all_table_size(CURRENT_SETTING);
		header.len = backupChainSize + mibTblSize;
		totalSize = sizeof(PARAM_HEADER_T) + header.len;
		buf = (unsigned char *)malloc(totalSize);
		if (buf == NULL)
			return;
		if(_mib_read_to_raw(CURRENT_SETTING, buf, totalSize) != 1) {
			free(buf);
			return;
		}
		ptr = &buf[sizeof(PARAM_HEADER_T)];
		pMibTbl = __mib_get_mib_tbl(CURRENT_SETTING);
		memcpy(&table_backup, pMibTbl, sizeof(MIB_T));  //save MIB table setting
		if (backupChainSize > 0) {
			pVarLenTable = &ptr[mibTblSize];
			if(__mib_chain_record_content_encod(CURRENT_SETTING, pVarLenTable, backupChainSize) != 1) {
				free(buf);
		return;
			}
		}
		chain_backup = realloc(chain_backup, backupChainSize);
		memcpy(chain_backup, pVarLenTable, backupChainSize);  //save MIB chain setting
		free(buf);
	}
	else
		return;

	qbuf->request = MSG_SUCC;
}

//added by ql
#ifdef	RESERVE_KEY_SETTING
static void cfg_retrieve_table(struct mymsgbuf *qbuf)
{
	int id;

	qbuf->request = MSG_FAIL;
	id = qbuf->msg.arg1;

	mib_table_record_retrive(id);

	qbuf->request = MSG_SUCC;
}
static void cfg_retrieve_chain(struct mymsgbuf *qbuf)
{
	int id;

	qbuf->request = MSG_FAIL;
	id = qbuf->msg.arg1;

	mib_chain_record_retrive(id);

	qbuf->request = MSG_SUCC;
}
static void cfg_clear_mib(struct mymsgbuf *qbuf)
{
	CONFIG_MIB_T type;

	qbuf->request = MSG_FAIL;
	type = (CONFIG_MIB_T)qbuf->msg.arg1;

	mib__record_clear(type);

	qbuf->request = MSG_SUCC;
}
#endif

static void cfg_mib_restore(struct mymsgbuf *qbuf)
{
	CONFIG_MIB_T type;
	unsigned char *pMibTbl;

	qbuf->request = MSG_FAIL;
	type = (CONFIG_MIB_T)qbuf->msg.arg1;

//	if (type == CONFIG_MIB_ALL || type == CONFIG_MIB_TABLE) {
	if (type == CONFIG_MIB_TABLE) {
		pMibTbl = __mib_get_mib_tbl(CURRENT_SETTING);
		memcpy(pMibTbl, &table_backup, sizeof(MIB_T));  //restore setting
	}
	else if (type == CONFIG_MIB_CHAIN){
		unsigned char* pVarLenTable = NULL;
		PARAM_HEADER_T header;
		unsigned int mibTblSize, totalSize;
		unsigned char *buf, *ptr;

		if(__mib_header_read(CURRENT_SETTING, &header) != 1)
			return;
		mibTblSize = __mib_content_min_size(CURRENT_SETTING);
		header.len = backupChainSize + mibTblSize;
		totalSize = sizeof(PARAM_HEADER_T) + header.len;
		buf = (unsigned char *)malloc(totalSize);
		if (buf == NULL)
			return;
		if(__mib_file_read(CURRENT_SETTING, buf, totalSize) != 1) {
			free(buf);
			return;
		}
		ptr = &buf[sizeof(PARAM_HEADER_T)];
		pMibTbl = __mib_get_mib_tbl(CURRENT_SETTING);
		memcpy(ptr, pMibTbl, sizeof(MIB_T));
		__mib_chain_all_table_clear(CURRENT_SETTING);
		if(backupChainSize > 0)
		{
			pVarLenTable = &ptr[mibTblSize];	// point to start of variable length MIB data
			memcpy(pVarLenTable, chain_backup, backupChainSize);  //restore MIB chain setting
			// parse variable length MIB data
			if( __mib_chain_record_content_decod(pVarLenTable, backupChainSize) != 1)
			{
				free(buf);
				return;
			}
		}
		memcpy(buf, (unsigned char*)&header, sizeof(PARAM_HEADER_T));
		free(buf);
//		return;
	}
	else if (type == CONFIG_MIB_ALL){
		unsigned char* pVarLenTable = NULL;
		PARAM_HEADER_T header;
		unsigned int mibTblSize, totalSize;
		unsigned char *buf, *ptr;

		if(__mib_header_read(CURRENT_SETTING, &header) != 1)
			return;
		mibTblSize = __mib_content_min_size(CURRENT_SETTING);
		header.len = backupChainSize + mibTblSize;
		totalSize = sizeof(PARAM_HEADER_T) + header.len;
		buf = (unsigned char *)malloc(totalSize);
		if (buf == NULL)
			return;
		if(__mib_file_read(CURRENT_SETTING, buf, totalSize) != 1) {
			free(buf);
			return;
		}
		ptr = &buf[sizeof(PARAM_HEADER_T)];
		pMibTbl = __mib_get_mib_tbl(CURRENT_SETTING);
		memcpy(pMibTbl, &table_backup, sizeof(MIB_T));  //restore setting
		//memcpy(ptr, &table_backup, sizeof(MIB_T));  //restore MIB table setting
		__mib_chain_all_table_clear(CURRENT_SETTING);
		if(backupChainSize > 0)
		{
			pVarLenTable = &ptr[mibTblSize];	// point to start of variable length MIB data
			memcpy(pVarLenTable, chain_backup, backupChainSize);  //restore MIB chain setting
			// parse variable length MIB data
			if( __mib_chain_record_content_decod(pVarLenTable, backupChainSize) != 1)
			{
				free(buf);
				return;
			}
		}
		memcpy(buf, (unsigned char*)&header, sizeof(PARAM_HEADER_T));
		free(buf);
//		return;
	}
	else
		return;

	qbuf->request = MSG_SUCC;
}

static void cfg_chain_total(struct mymsgbuf *qbuf)
{
	qbuf->request = MSG_FAIL;

	qbuf->msg.arg1 = _mib_chain_total(qbuf->msg.arg1);
	qbuf->request = MSG_SUCC;
}

static void cfg_chain_get(struct mymsgbuf *qbuf)
{
	int index, entryNo;
	void *pEntry;

	qbuf->request = MSG_FAIL;
	index = __mib_chain_mib2tbl_id(qbuf->msg.arg1);
	if (index == -1)
		return;

	entryNo = atoi(qbuf->msg.mtext);
	pEntry = _mib_chain_get(qbuf->msg.arg1, entryNo);
	if (pEntry) {
		#ifdef USE_SHM
		memcpy(shm_start, pEntry, mib_chain_record_table[index].per_record_size);
		#else
		memcpy(qbuf->msg.mtext, pEntry, mib_chain_record_table[index].per_record_size);
		#endif
		qbuf->request = MSG_SUCC;
	}
	else
		qbuf->request = MSG_FAIL;
}

static void cfg_chain_add(struct mymsgbuf *qbuf)
{
	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	#ifdef USE_SHM
	if (_mib_chain_add(qbuf->msg.arg1, shm_start)) {
	#else
	if (_mib_chain_add(qbuf->msg.arg1, qbuf->msg.mtext)) {
	#endif
		qbuf->request = MSG_SUCC;
	}
	else
		qbuf->request = MSG_FAIL;
}

static void cfg_chain_delete(struct mymsgbuf *qbuf)
{
	int entryNo;

	qbuf->request = MSG_FAIL;
	entryNo = atoi(qbuf->msg.mtext);

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	if (_mib_chain_delete(qbuf->msg.arg1, entryNo)) {
		qbuf->request = MSG_SUCC;
	}
	else
		qbuf->request = MSG_FAIL;
}

static void cfg_chain_clear(struct mymsgbuf *qbuf)
{
	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	_mib_chain_clear(qbuf->msg.arg1);
	qbuf->request = MSG_SUCC;
}

static void cfg_chain_update(struct mymsgbuf *qbuf)
{
	int index;
	void *pEntry;

	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	index = __mib_chain_mib2tbl_id(qbuf->msg.arg1);
	if (index == -1)
		return;
	pEntry = _mib_chain_get(qbuf->msg.arg1, qbuf->msg.arg2);
	if (pEntry)
		#ifdef USE_SHM
		memcpy(pEntry, shm_start, mib_chain_record_table[index].per_record_size);
		#else
		memcpy(pEntry, qbuf->msg.mtext, mib_chain_record_table[index].per_record_size);
		#endif
	else
		return;
	#ifdef USE_SHM
	if (_mib_chain_update(qbuf->msg.arg1, shm_start, qbuf->msg.arg2)) {
	#else
	if (_mib_chain_update(qbuf->msg.arg1, qbuf->msg.mtext, qbuf->msg.arg2)) {
	#endif
		qbuf->request = MSG_SUCC;
	}
	else
		qbuf->request = MSG_FAIL;
}

/* cathy, to swap entry A and B of a chain */
static void cfg_chain_swap(struct mymsgbuf *qbuf)
{
	int index, id;
	void *pEntryA, *pEntryB, *tmpEntry;

	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	id = atoi(qbuf->msg.mtext);
	index = __mib_chain_mib2tbl_id(id);
	if (index == -1)
		return;

	pEntryA = _mib_chain_get(id, qbuf->msg.arg1);
	pEntryB = _mib_chain_get(id, qbuf->msg.arg2);

	if(!pEntryA || !pEntryB) {
		printf("%s: cannot find entry!\n", __func__);
		return;
	}

	tmpEntry = malloc(mib_chain_record_table[index].per_record_size);
	if(!tmpEntry) {
		printf("%s: cannot allocate memory!\n", __func__);
		return;
	}

	//swap pEntryA and pEntryB
	memcpy(tmpEntry, pEntryA, mib_chain_record_table[index].per_record_size);
	memcpy(pEntryA, pEntryB, mib_chain_record_table[index].per_record_size);
	memcpy(pEntryB, tmpEntry, mib_chain_record_table[index].per_record_size);

	free(tmpEntry);
	qbuf->request = MSG_SUCC;
}

static void cfg_chain_info_id(struct mymsgbuf *qbuf)
{
	int index;

	qbuf->request = MSG_FAIL;

	index = __mib_chain_mib2tbl_id(qbuf->msg.arg1);
	if (index == -1)
		return;

	memcpy((void *)qbuf->msg.mtext, (void *)&mib_chain_record_table[index], sizeof(mib_chain_record_table_entry_T));
	qbuf->request = MSG_SUCC;
}

static void cfg_chain_info_index(struct mymsgbuf *qbuf)
{
	int total;
	int i;

	qbuf->request = MSG_FAIL;

	for (i=0; mib_chain_record_table[i].id; i++);
	total = i+1;
	if (qbuf->msg.arg1>=total)
		return;

	memcpy((void *)qbuf->msg.mtext, (void *)&mib_chain_record_table[qbuf->msg.arg1], sizeof(mib_chain_record_table_entry_T));
	qbuf->request = MSG_SUCC;
}

static void cfg_chain_info_name(struct mymsgbuf *qbuf)
{
	int total;
	int i;

	qbuf->request = MSG_FAIL;

	for (i=0; mib_chain_record_table[i].id; i++) {
		if (!strcmp(mib_chain_record_table[i].name, qbuf->msg.mtext))
			break;
	}

	if (mib_chain_record_table[i].id == 0)
		return; // not found

	memcpy((void *)qbuf->msg.mtext, (void *)&mib_chain_record_table[i], sizeof(mib_chain_record_table_entry_T));
	qbuf->request = MSG_SUCC;
}

static void cfg_chain_desc_id(struct mymsgbuf *qbuf)
{
	int index;
	mib_chain_member_entry_T *rec_desc;
	int i, size, copylen;

	qbuf->request = MSG_FAIL;

	index = __mib_chain_mib2tbl_id(qbuf->msg.arg1);
	if (index == -1)
		return;

	rec_desc = mib_chain_record_table[index].record_desc;
	if (rec_desc == 0)
		return;
	// get total size of the record descriptor
	i = 0; size = 0;
	while (rec_desc[i++].name[0] != 0)
		size++;

	copylen = sizeof(mib_chain_member_entry_T)*size;
	if (copylen > MAX_SEND_SIZE)
		return;
	qbuf->msg.arg1 = size;
	memcpy((void *)qbuf->msg.mtext, (void *)rec_desc, copylen);
	qbuf->request = MSG_SUCC;
}

/*
 * Check the consistency between chain records and their record descriptors.
 * Return msg.arg1:
 *	1: checking ok
 *	-1: checking failed
 */
static void cfg_check_desc(struct mymsgbuf *qbuf)
{
	mib_chain_member_entry_T *rec_desc;
	int i, k, count_size, verdict;

	qbuf->request = MSG_FAIL;
	verdict = 1;

	for (i=0; mib_chain_record_table[i].id; i++) {
		rec_desc = mib_chain_record_table[i].record_desc;
		if (!rec_desc) {
			#ifdef VOIP_SUPPORT
			// VOIP chain descriptor not ready, bypass it.
			if(mib_chain_record_table[i].id != MIB_VOIP_CFG_TBL)
			{
			#endif
			printf("Error: Null MIB-chain(%s) record descriptor !\n", mib_chain_record_table[i].name);
			verdict = -1;
			#ifdef VOIP_SUPPORT
			}
			#endif
			continue;
		}
		k = 0; count_size = 0;
		while (rec_desc[k].name[0] != 0) {
			count_size += rec_desc[k].size;
			k++;
		}
		if (count_size != mib_chain_record_table[i].per_record_size) {
			printf("Error: MIB chain %s descriptor not consistent with chain record !\n", mib_chain_record_table[i].name);
			verdict = -1;
		}
	}

	printf("MIB chain descriptors checking (total %d) %s !\n", i, verdict==1?"ok":"failed");
	qbuf->msg.arg1 = verdict;
	qbuf->request = MSG_SUCC;
}

static void cfg_mib_read_header(struct mymsgbuf *qbuf)
{
	CONFIG_DATA_T data_type;

	data_type = (CONFIG_DATA_T)qbuf->msg.arg1;
	if(_mib_read_header(data_type, (PARAM_HEADER_Tp)qbuf->msg.mtext) != 1)
		qbuf->request = MSG_FAIL;
	else
		qbuf->request = MSG_SUCC;
}

/*
 *	reload hs	---	reload hardware setting
 *	reload cs	---	reload current setting
 *	reload ds	---	reload default setting
 */
static void cfg_mib_reload(struct mymsgbuf *qbuf)
{
	CONFIG_DATA_T data_type;
	CONFIG_MIB_T flag;
	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	data_type = (CONFIG_DATA_T)qbuf->msg.arg1;
	flag = (CONFIG_MIB_T)qbuf->msg.arg2;

	if (data_type == CURRENT_SETTING) {
		if (flag == CONFIG_MIB_ALL) {
			if(_mib_load(data_type)!=0)
				qbuf->request = MSG_SUCC;
		}
		else if (flag == CONFIG_MIB_TABLE) {
			if (mib_load_table(data_type)!=0)
				qbuf->request = MSG_SUCC;
		}
		else { // not support currently, Jenny added
			if (mib_load_chain(data_type)!=0)
				qbuf->request = MSG_SUCC;
		}
	}
	else {
		if(_mib_load(data_type)!=0)
			qbuf->request = MSG_SUCC;
	}
}



#ifdef EMBED

#if (defined(CONFIG_USB_ARCH_HAS_XHCI) && defined(CONFIG_USB_XHCI_HCD))
void unbind_xhci_driver()
{

	/* This function is for USB XHCI driver unload, because some USB 3.0 
	 * device need this step, then after  reboot could set configuration 
	 * successfully 
	 */
	if (0 == access("/sys/bus/usb/devices/1-2/driver/", F_OK)) {
		if(0 == access("/sys/bus/usb/devices/1-2/driver/1-2.1",F_OK))
		{
			printf("echo 1-2.1 >  /sys/bus/usb/devices/1-2/driver/unbind\n");
			system("echo 1-2.1 > /sys/bus/usb/devices/1-2/driver/unbind");
		}
		if(0 == access("/sys/bus/usb/devices/1-2/driver/1-2.2",F_OK))
		{
			printf("echo 1-2.2 >  /sys/bus/usb/devices/1-2/driver/unbind\n");
			system("echo 1-2.2 > /sys/bus/usb/devices/1-2/driver/unbind");
		}
		if(0 == access("/sys/bus/usb/devices/1-2/driver/1-2.3",F_OK))
		{
			printf("echo 1-2.3 >  /sys/bus/usb/devices/1-2/driver/unbind\n");
			system("echo 1-2.3 > /sys/bus/usb/devices/1-2/driver/unbind");
		}
		if(0 == access("/sys/bus/usb/devices/1-2/driver/1-2.4",F_OK))
		{
			printf("echo 1-2.4 >  /sys/bus/usb/devices/1-2/driver/unbind\n");
			system("echo 1-2.4 > /sys/bus/usb/devices/1-2/driver/unbind");
		}
		if(0==access("/sys/bus/usb/devices/1-2/driver/1-2", F_OK))
		{
			printf("echo 1-2 >  /sys/bus/usb/devices/1-2/driver/unbind\n");
			system("echo 1-2 > /sys/bus/usb/devices/1-2/driver/unbind");
		}
	}
}
#endif


static void *sysReboot(void *arg)
{
	sleep(1);

#if (defined(CONFIG_USB_ARCH_HAS_XHCI) && defined(CONFIG_USB_XHCI_HCD))
	unbind_xhci_driver();
#endif

#ifdef CONFIG_PPP
	// Jenny, disconnect PPP before rebooting
	stopPPP();
#endif
#if defined(CONFIG_RTL867X_NETLOG) && defined(CONFIG_USER_NETLOGGER_SUPPORT)
	va_cmd("/bin/netlogger", 1, 1, "disable");
#endif

#ifdef CONFIG_DEV_xDSL
	va_cmd("/bin/adslctrl", 1, 1, "disablemodemline");
#endif
#ifdef CONFIG_VIRTUAL_WLAN_DRIVER
	system("echo 1 > /proc/vwlan");
#endif

	sync();
#ifdef CONFIG_RTL8672_SAR
	itfcfg("sar", 0);
#endif
	itfcfg("eth0", 0);
	itfcfg("wlan0", 0);

	/* reboot the system */
	reboot(RB_AUTOBOOT);

	return NULL;
}

static void cfg_reboot(struct mymsgbuf *qbuf)
{
	pthread_t ptRebootId;

	pthread_create(&ptRebootId, NULL, sysReboot, NULL);
	pthread_detach(ptRebootId);

	qbuf->request = MSG_SUCC;
}

#ifdef CONFIG_IPV6
#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411)
int _option_name_server(FILE *fp)
{
	unsigned int entryNum, i;
	MIB_DHCPV6S_NAME_SERVER_Tp pEntry;
	unsigned char strAll[(MAX_V6_IP_LEN+2)*MAX_DHCPV6_CHAIN_ENTRY]="";

	entryNum = _mib_chain_total(MIB_DHCPV6S_NAME_SERVER_TBL);

	for (i=0; i<entryNum; i++) {
		unsigned char buf[MAX_V6_IP_LEN+2]="";

		pEntry = (MIB_DHCPV6S_NAME_SERVER_Tp) _mib_chain_get(MIB_DHCPV6S_NAME_SERVER_TBL, i);

		if ( i< (entryNum-1) )
		{
			sprintf(buf, "%s, ", pEntry->nameServer);
		} else
			sprintf(buf, "%s", pEntry->nameServer);
		strcat(strAll, buf);
	}

	if ( entryNum > 0 )
	{
		//printf("strAll=%s\n", strAll);
		fprintf(fp, "option dhcp6.name-servers %s;\n", strAll);
	}

	return 0;
}

int _option_domain_search(FILE *fp)
{
	unsigned int entryNum, i;
	MIB_DHCPV6S_DOMAIN_SEARCH_Tp pEntry;
	unsigned char strAll[(MAX_DOMAIN_LENGTH+4)*MAX_DHCPV6_CHAIN_ENTRY]="";

	entryNum = _mib_chain_total(MIB_DHCPV6S_DOMAIN_SEARCH_TBL);

	for (i=0; i<entryNum; i++) {
		unsigned char buf[MAX_DOMAIN_LENGTH+4]="";

		pEntry = (MIB_DHCPV6S_DOMAIN_SEARCH_Tp) _mib_chain_get(MIB_DHCPV6S_DOMAIN_SEARCH_TBL, i);

		if ( i< (entryNum-1) )
		{
			sprintf(buf, "\"%s\", ", pEntry->domain);
		} else
			sprintf(buf, "\"%s\"", pEntry->domain);
		strcat(strAll, buf);
	}

	if ( entryNum > 0 )
	{
		//printf("strAll(domain)=%s\n", strAll);
		fprintf(fp, "option dhcp6.domain-search %s;\n", strAll);
	}

	return 0;
}

int _setup_dhcpdv6_conf(DLG_INFO_Tp pDLGInfo)
{
	FILE *fp;
	unsigned int DLTime, PFTime, RNTime, RBTime;
	unsigned char vChar;
	struct in6_addr ip6Addr, ip6Prefix;
	int k;
	unsigned char value[MAX_V6_IP_LEN];
	unsigned char value2[MAX_V6_IP_LEN];
	unsigned char value3[MAX_DUID_LEN];
	unsigned char 	Ipv6AddrStr[48];

	if ((fp = fopen(DHCPDV6_CONF_AUTO, "w")) == NULL)
	{
		printf("Open file %s failed !\n", DHCPDV6_CONF_AUTO);
		return;
	}

	fprintf(fp, "preferred-lifetime %u;\n", pDLGInfo->PLTime);
	fprintf(fp, "default-lease-time %u;\n", pDLGInfo->MLTime);
	fprintf(fp, "option dhcp-renewal-time %u;\n", pDLGInfo->RNTime);
	fprintf(fp, "option dhcp-rebinding-time %u;\n", pDLGInfo->RBTime);
	fprintf(fp, "option dhcp6.name-servers %s;\n", pDLGInfo->nameServer);
#if 0
	// Option dhcp6.name-servers
	_option_name_server(fp);

	// Option dhcp6.domain-search
	_option_domain_search(fp);

	// option dhcp6.client-id 00:01:00:01:00:04:93:e0:00:00:00:00:a2:a2;
	if ( !_mib_get(MIB_DHCPV6S_CLIENT_DUID, (void *)value3)) {
		printf("Get MIB_DHCPV6S_CLIENT_DUID mib error!");
		return -1;
	}
	if (value3[0]) {
		fprintf(fp, "option dhcp6.client-id %s;\n", value3);
	}
#endif
	// subnet6 3ffe:501:ffff:100::/64 {
	inet_ntop(PF_INET6, (struct in6_addr *)pDLGInfo->prefixIP, Ipv6AddrStr, sizeof(Ipv6AddrStr));
	fprintf(fp, "subnet6 %s/%d {\n", Ipv6AddrStr, pDLGInfo->prefixLen);
	fprintf(fp, "\trange6 %s/%d;\n", Ipv6AddrStr, pDLGInfo->prefixLen);
	fprintf(fp, "}\n");
	fclose(fp);

	if ((fp = fopen(DHCPDV6_LEASES, "w")) == NULL)
	{
		printf("Open file %s failed !\n", DHCPDV6_LEASES);
		return;
	}
	fclose(fp);

	return 1;

}

int _start_dhcpv6(int enable, DLG_INFO_Tp pDLGInfo)
{
	unsigned char value[64];
	unsigned char vChar;
	int tmp_status, status=0;
	unsigned int uInt, i;
	DHCP_TYPE_T mode;
	int dhcpserverpid=0;
	struct in6_addr ip6Addr, targetIp;
	unsigned char devAddr[MAC_ADDR_LEN];
	unsigned char meui64[8];

	mode = DHCP_LAN_NONE;
	if (_mib_get(MIB_DHCPV6_MODE, (void *)value) != 0)
	{
		mode = (DHCP_TYPE_T)(*(unsigned char *)value);
	}
	if ( (mode != DHCP_LAN_SERVER_AUTO) )
	{
		//Even the MODE is not auto, setup the config file for future usage
		tmp_status = _setup_dhcpdv6_conf(pDLGInfo);
		return 1;
	}

	dhcpserverpid = read_pid((char*)DHCPSERVER6PID);

	if(dhcpserverpid > 0) {
		kill(dhcpserverpid, 15);
		//unlink((char*)DHCPSERVER6PID);
	}

	while(read_pid((char*)DHCPSERVER6PID)>0)
	{
		usleep(30000);
	}


	// Delete LAN IP which is set by manual
	_mib_get(MIB_DHCPV6S_PREFIX_LENGTH, (void *)&vChar);
	_mib_get(MIB_DHCPV6S_RANGE_START, (void *)ip6Addr.s6_addr);
	uInt = (int)vChar;
	if (uInt<=0 || uInt > 128) {
		printf("WARNNING! Prefix Length == %d\n", uInt);
		uInt = 64;
	}
	ip6toPrefix(&ip6Addr, uInt, &targetIp);
	_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
	mac_meui64(devAddr, meui64);
	for (i=0; i<8; i++)
		targetIp.s6_addr[i+8] = meui64[i];
	inet_ntop(PF_INET6, &targetIp, value, sizeof(value));
	sprintf(value, "%s/%d", value, uInt);
	va_cmd(IFCONFIG, 3, 1, LANIF, "del", value);

	// Set LAN IP which is set by auto
	uInt = pDLGInfo->prefixLen;
	if (uInt<=0 || uInt > 128) {
		printf("WARNNING! Prefix Length == %d\n", uInt);
		uInt = 64;
	}
	ip6toPrefix((struct in6_addr *)pDLGInfo->prefixIP, uInt, &targetIp);
	_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
	mac_meui64(devAddr, meui64);
	for (i=0; i<8; i++)
		targetIp.s6_addr[i+8] = meui64[i];
	inet_ntop(PF_INET6, &targetIp, value, sizeof(value));
	sprintf(value, "%s/%d", value, uInt);
	if (enable)
		va_cmd(IFCONFIG, 3, 1, LANIF, "add", value);


	if (!enable)
		return 1;

	tmp_status = _setup_dhcpdv6_conf(pDLGInfo);
	if (tmp_status == 1)
	{
		// dhcpd -6 -cf /var/dhcpdv6.conf -lf /var/dhcpd6.leases br0
		status = va_cmd(DHCPDV6, 6, 0, "-6", "-cf", DHCPDV6_CONF_AUTO, "-lf", DHCPDV6_LEASES, BRIF);

		//while(read_pid((char*)DHCPSERVER6PID) < 0)
		//	usleep(250000);
	}
	else if (tmp_status == -1)
	 	status = -1;

	return status;
}

int delLANIP(const char *fname)
{
	int ret=0;
	unsigned char value[64];
	unsigned int uInt, i;
	struct in6_addr targetIp;
	unsigned char devAddr[MAC_ADDR_LEN];
	unsigned char meui64[8];

	ret = getLeasesInfo(fname, &dlg_info);

	// found Prefix Delegation
	if ( ret == 1 ) {
		uInt = dlg_info.prefixLen;
		if (uInt<=0 || uInt > 128) {
			printf("WARNNING! Prefix Length == %d\n", uInt);
			uInt = 64;
		}
		ip6toPrefix((struct in6_addr *)dlg_info.prefixIP, uInt, &targetIp);
		_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
		mac_meui64(devAddr, meui64);
		for (i=0; i<8; i++)
			targetIp.s6_addr[i+8] = meui64[i];
		inet_ntop(PF_INET6, &targetIp, value, sizeof(value));
		sprintf(value, "%s/%d", value, uInt);
		printf("Delete the previous LAN IP for Prefix Delegation\n");
		va_cmd(IFCONFIG, 3, 1, LANIF, "del", value);
	}
	return 1;
}

static void cfg_stop_delegation(struct mymsgbuf *qbuf)
{
	delLANIP(qbuf->msg.mtext);
	qbuf->request = MSG_SUCC;
}

static void cfg_get_PD_prefix_ip(struct mymsgbuf *qbuf)
{
	memcpy(qbuf->msg.mtext, dlg_info.prefixIP, IP6_ADDR_LEN);
	qbuf->request = MSG_SUCC;
}

static void cfg_get_PD_prefix_len(struct mymsgbuf *qbuf)
{
	qbuf->msg.arg1 = dlg_info.prefixLen;
	qbuf->request = MSG_SUCC;
}
#endif



#if defined(CONFIG_USER_DHCPV6_ISC_DHCP411) && defined(CONFIG_USER_RADVD)
void _setup_radvd_conf(int resync, DLG_INFO_Tp pDLGInfo, int handlePDChange_rfc6204L13, DLG_INFO_Tp pOldDLGInfo)
{
	FILE *fp;
	unsigned char str[MAX_RADVD_CONF_PREFIX_LEN];
	unsigned char str2[MAX_RADVD_CONF_PREFIX_LEN];
	unsigned char vChar,vChar2;
	int radvdpid;
	unsigned char 	Ipv6AddrStr[48];
	unsigned char mode;
	unsigned char prefix_enable = 0;

	_mib_get(MIB_V6_PREFIX_MODE, (void *)&mode);
	if ( mode != 0 )   // It is Manual config.
		return;

	if ((fp = fopen(RADVD_CONF, "w")) == NULL)
	{
		printf("Open file %s failed !\n", RADVD_CONF);
		return;
	}

	fprintf(fp, "interface br0\n");
	fprintf(fp, "{\n");

	// AdvSendAdvert
	if ( !_mib_get( MIB_V6_SENDADVERT, (void *)&vChar) )
		printf("Get MIB_V6_SENDADVERT error!");
	if (0 == vChar)
		fprintf(fp, "\tAdvSendAdvert off;\n");
	else if (1 == vChar)
		fprintf(fp, "\tAdvSendAdvert on;\n");

	// MaxRtrAdvIntervalAct
	if ( !_mib_get(MIB_V6_MAXRTRADVINTERVAL, (void *)str)) {
		printf("Get MaxRtrAdvIntervalAct mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tMaxRtrAdvInterval %s;\n", str);
	}

	// MinRtrAdvIntervalAct
	if ( !_mib_get(MIB_V6_MINRTRADVINTERVAL, (void *)str)) {
		printf("Get MinRtrAdvIntervalAct mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tMinRtrAdvInterval %s;\n", str);
	}

	// AdvCurHopLimitAct
	if ( !_mib_get(MIB_V6_ADVCURHOPLIMIT, (void *)str)) {
		printf("Get AdvCurHopLimitAct mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tAdvCurHopLimit %s;\n", str);
	}

	// AdvDefaultLifetime
	if ( !_mib_get(MIB_V6_ADVDEFAULTLIFETIME, (void *)str)) {
		printf("Get AdvDefaultLifetime mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tAdvDefaultLifetime %s;\n", str);
	}

	// AdvReachableTime
	if ( !_mib_get(MIB_V6_ADVREACHABLETIME, (void *)str)) {
		printf("Get AdvReachableTime mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tAdvReachableTime %s;\n", str);
	}

	// AdvRetransTimer
	if ( !_mib_get(MIB_V6_ADVRETRANSTIMER, (void *)str)) {
		printf("Get AdvRetransTimer mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tAdvRetransTimer %s;\n", str);
	}

	// AdvLinkMTU
	if ( !_mib_get(MIB_V6_ADVLINKMTU, (void *)str)) {
		printf("Get AdvLinkMTU mib error!");
	}
	if (str[0]) {
		fprintf(fp, "\tAdvLinkMTU %s;\n", str);
	}

	// AdvManagedFlag
	if ( !_mib_get( MIB_V6_MANAGEDFLAG, (void *)&vChar) )
		printf("Get MIB_V6_MANAGEDFLAG error!");
	if (0 == vChar)
		fprintf(fp, "\tAdvManagedFlag off;\n");
	else if (1 == vChar)
		fprintf(fp, "\tAdvManagedFlag on;\n");

	// AdvOtherConfigFlag
	if ( !_mib_get( MIB_V6_OTHERCONFIGFLAG, (void *)&vChar) )
		printf("Get MIB_V6_OTHERCONFIGFLAG error!");
	if (0 == vChar)
		fprintf(fp, "\tAdvOtherConfigFlag off;\n");
	else if (1 == vChar)
		fprintf(fp, "\tAdvOtherConfigFlag on;\n");

	//NOTE: in radvd.conf
	//      Prefix/clients/route/RDNSS configurations must be given in exactly this order.

	// Prefix

	// ULA Prefix
	_mib_get (MIB_V6_ULAPREFIX_ENABLE, (void *)&vChar);
	if (vChar!=0) {
		unsigned char validtime[MAX_RADVD_CONF_PREFIX_LEN];
		unsigned char preferedtime[MAX_RADVD_CONF_PREFIX_LEN];

		if ( !_mib_get(MIB_V6_ULAPREFIX, (void *)str)       ||
	         !_mib_get(MIB_V6_ULAPREFIX_LEN, (void *)str2)  ||
	         !_mib_get(MIB_V6_ULAPREFIX_VALID_TIME, (void *)validtime)  ||
	         !_mib_get(MIB_V6_ULAPREFIX_PREFER_TIME, (void *)preferedtime)
			)
		{
			printf("Get ULAPREFIX mib error!");
		}
		else
		{
			unsigned char ip6Addr[IP6_ADDR_LEN];
			unsigned char devAddr[MAC_ADDR_LEN];
			unsigned char meui64[8];
			unsigned char value[64];
			int i;

			fprintf(fp, "\t\n");
			fprintf(fp, "\tprefix %s/%s\n", str, str2);
			fprintf(fp, "\t{\n");
			fprintf(fp, "\t\tAdvOnLink on;\n");
			fprintf(fp, "\t\tAdvAutonomous on;\n");
			fprintf(fp, "\t\tAdvValidLifetime %s;\n",validtime);
			fprintf(fp, "\t\tAdvPreferredLifetime %s;\n",preferedtime);
			fprintf(fp, "\t};\n");

			inet_pton(PF_INET6, str, (void *) ip6Addr);

			//setup LAN ULA v6 IP address according the ULA prefix + EUI64.
			_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
			mac_meui64(devAddr, meui64);
			for (i=0; i<8; i++)
				ip6Addr[i+8] = meui64[i];
			inet_ntop(PF_INET6, &ip6Addr, value, sizeof(value));
			sprintf(value, "%s/%s", value, str2);

			printf("Set LAN ULA %s\n",value);
			va_cmd(IFCONFIG, 3, 1, LANIF, "del", value);
			va_cmd(IFCONFIG, 3, 1, LANIF, "add", value);
		}
	}

	_mib_get( MIB_V6_PREFIX_ENABLE, (void *)&vChar2);
    if( vChar2 == 1)
	{
		_mib_get( MIB_V6_PREFIX_MODE, (void *)&vChar);
		if ( vChar == 1) {	// setup config without delegation
			struct  in6_addr ip6Addr;
			unsigned char devAddr[MAC_ADDR_LEN];
			unsigned char meui64[8];
			unsigned char value[64];
			int i;

			if ( !_mib_get(MIB_V6_PREFIX_IP, (void *)str)) {
				printf("Get Prefix_IP mib error!");
			}
			if ( !_mib_get(MIB_V6_PREFIX_LEN, (void *)str2)) {
				printf("Get Prefix_Length mib error!");
			}
			fprintf(fp, "\t\n");
			fprintf(fp, "\tprefix %s/%s\n", str, str2);
			fprintf(fp, "\t{\n");

			if(inet_pton(AF_INET6,str,&ip6Addr))
			{
				_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
				mac_meui64(devAddr, meui64);
				for (i=0; i<8; i++)
					ip6Addr.s6_addr[i+8] = meui64[i];
				inet_ntop(PF_INET6, &ip6Addr, value, sizeof(value));
				sprintf(value, "%s/%s", value, str2);
				va_cmd(IFCONFIG, 3, 1, LANIF, "del", value);
				va_cmd(IFCONFIG, 3, 1, LANIF, "add", value);
			}
			prefix_enable = 1;
		}
		else if( pDLGInfo )  //vChar =0 (auto) and have delegation info
		{ 		// setup config with delegation
			unsigned char ip6Addr[IP6_ADDR_LEN];
			unsigned char devAddr[MAC_ADDR_LEN];
			unsigned char meui64[8];
			unsigned char value[64];
			static unsigned char previous_ip[64];
			int i;

			if(handlePDChange_rfc6204L13 == 1)	
			{
				fprintf(fp, "\t\n");
				inet_ntop(PF_INET6, (struct in6_addr *)pOldDLGInfo->prefixIP, Ipv6AddrStr, sizeof(Ipv6AddrStr));	
				fprintf(fp, "\tprefix %s/%d\n", Ipv6AddrStr, pOldDLGInfo->prefixLen);
				fprintf(fp, "\t{\n");			
			}
			else{
			fprintf(fp, "\t\n");
			inet_ntop(PF_INET6, (struct in6_addr *)pDLGInfo->prefixIP, Ipv6AddrStr, sizeof(Ipv6AddrStr));
			fprintf(fp, "\tprefix %s/%d\n", Ipv6AddrStr, pDLGInfo->prefixLen);
			fprintf(fp, "\t{\n");

			//setup LAN v6 IP address according the prefix,then the IPv6 routing could be correct.
			memcpy(ip6Addr, (void *)pDLGInfo->prefixIP, IP6_ADDR_LEN);
			_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
			mac_meui64(devAddr, meui64);
			for (i=0; i<8; i++)
				ip6Addr[i+8] = meui64[i];
			inet_ntop(PF_INET6, &ip6Addr, value, sizeof(value));
			sprintf(value, "%s/%d", value, pDLGInfo->prefixLen);

			//Note: Perfix may change, so need to remeber previous prefix
			//      then could delete the correct IP.
			va_cmd(IFCONFIG, 3, 1, LANIF, "del", previous_ip);
			va_cmd(IFCONFIG, 3, 1, LANIF, "add", value);
			memcpy(previous_ip,value,sizeof(previous_ip));
			}
			prefix_enable =1;
		}

		if( prefix_enable)
		{
			// AdvOnLink
			if ( !_mib_get( MIB_V6_ONLINK, (void *)&vChar) )
				printf("Get MIB_V6_ONLINK error!");
			if (0 == vChar)
				fprintf(fp, "\t\tAdvOnLink off;\n");
			else if (1 == vChar)
				fprintf(fp, "\t\tAdvOnLink on;\n");

			// AdvAutonomous
			if ( !_mib_get( MIB_V6_AUTONOMOUS, (void *)&vChar) )
				printf("Get MIB_V6_AUTONOMOUS error!");
			if (0 == vChar)
				fprintf(fp, "\t\tAdvAutonomous off;\n");
			else if (1 == vChar)
				fprintf(fp, "\t\tAdvAutonomous on;\n");

			// AdvValidLifetime
			if ( pDLGInfo == 0 ) {
				if ( !_mib_get(MIB_V6_VALIDLIFETIME, (void *)str)) {
					printf("Get AdvValidLifetime mib error!");
				}
				if (str[0]) {
					fprintf(fp, "\t\tAdvValidLifetime %s;\n", str);
				}
			} else {
				if(handlePDChange_rfc6204L13 == 1)	
				{
					unsigned int twoHour=2*60*60;  //in seconds
					unsigned int validLifeTime = (pOldDLGInfo->MLTime<twoHour)?pOldDLGInfo->MLTime:twoHour;
					fprintf(fp, "\t\tAdvValidLifetime %u;\n", validLifeTime);			
				}	
				else
				fprintf(fp, "\t\tAdvValidLifetime %u;\n", pDLGInfo->MLTime);
			}

			// AdvPreferredLifetime
			if ( pDLGInfo == 0 ) {
				if ( !_mib_get(MIB_V6_PREFERREDLIFETIME, (void *)str)) {
					printf("Get AdvPreferredLifetime mib error!");
				}
				if (str[0]) {
					fprintf(fp, "\t\tAdvPreferredLifetime %s;\n", str);
				}
			} else {
				if(handlePDChange_rfc6204L13 == 1)	
				{
					fprintf(fp, "\t\tAdvPreferredLifetime %u;\n", 0);
				}
				else
				fprintf(fp, "\t\tAdvPreferredLifetime %u;\n", pDLGInfo->PLTime);
			}


			fprintf(fp, "\t};\n");

		}
	}

	//RDNSS
	if ( pDLGInfo == 0 ) {	// setup RDNSS without delegation: manual mode
		if ( !_mib_get(MIB_V6_RDNSS1, (void *)str)) {
			printf("Get RDNSS1 mib error!");
		}
		else if (str[0]) {
			fprintf(fp, "\n\tRDNSS %s\n", str);
			fprintf(fp, "\t{\n");
			fprintf(fp, "\t\tAdvRDNSSPreference 8;\n");
			fprintf(fp, "\t\tAdvRDNSSOpen off;\n");
			fprintf(fp, "\t};\n");
		}

		if ( !_mib_get(MIB_V6_RDNSS2, (void *)str)) {
			printf("Get RDNSS2 mib error!");
		}
		else if (str[0]) {
			fprintf(fp, "\n\tRDNSS %s\n", str);
			fprintf(fp, "\t{\n");
			fprintf(fp, "\t\tAdvRDNSSPreference 8;\n");
			fprintf(fp, "\t\tAdvRDNSSOpen off;\n");
			fprintf(fp, "\t};\n");
		}
	} else {				// setup RDNSS config with delegation : auto mode
		//pDLGInfo->nameServer 2001:b000:168::1,2001:b000:168::2;
		char *saveptr1=NULL,*token=NULL;
		char nameServer[200];

		strcpy(nameServer,pDLGInfo->nameServer);

		if(pDLGInfo->nameServer[0]){
			token = strtok_r(nameServer, ",;", &saveptr1);
			if(token){
				fprintf(fp, "\n\tRDNSS %s\n", token);
				fprintf(fp, "\t{\n");
				fprintf(fp, "\t\tAdvRDNSSPreference 8;\n");
				fprintf(fp, "\t\tAdvRDNSSOpen off;\n");
				fprintf(fp, "\t};\n");
			}
			token = strtok_r(NULL, ",;", &saveptr1);
			if(token){
				fprintf(fp, "\n\tRDNSS %s\n", token);
				fprintf(fp, "\t{\n");
				fprintf(fp, "\t\tAdvRDNSSPreference 8;\n");
				fprintf(fp, "\t\tAdvRDNSSOpen off;\n");
				fprintf(fp, "\t};\n");
			}
		}
	}

	fprintf(fp, "};\n");
	fclose(fp);

	// Resync radvd.conf
	if ( resync == 1 ) {
		struct  in6_addr ip6Addr;
		unsigned char devAddr[MAC_ADDR_LEN];
		unsigned char meui64[8];
		unsigned char value[64];
		int i;

		//Make sure link local address exists,then radvd could be started.
		if((handlePDChange_rfc6204L13 == 0) && (inet_pton(AF_INET6,"fe80::",&ip6Addr)))
	
		{
			_mib_get(MIB_ELAN_MAC_ADDR, (void *)devAddr);
			mac_meui64(devAddr, meui64);
			for (i=0; i<8; i++)
				ip6Addr.s6_addr[i+8] = meui64[i];
			inet_ntop(PF_INET6, &ip6Addr, value, sizeof(value));
			sprintf(value, "%s/%s", value, "64");
		    printf("value=%s\n",value);
			va_cmd(IFCONFIG, 3, 1, LANIF, "del", value);
			va_cmd(IFCONFIG, 3, 1, LANIF, "add", value);
			sleep(3);  //Sleep for ready to send out ra right after sending signal to radvd
		}

		radvdpid = read_pid((char *)RADVD_PID);
		if (radvdpid > 0) {
			printf("Resync RADVD, radvdpid=%d\n",radvdpid);
			kill(radvdpid, SIGHUP);
		}
		if (read_pid((char *)RADVD_PID) <= 0)
		{
			printf("New RADVD process!\n");
			va_cmd( "/bin/radvd", 3, 0, "-s", "-C", (char *)RADVD_CONF );
		}
	}

	return;

}
#ifndef CONFIG_IPV6_OLD_FILTER
/* 
 * Function updateIPV6FilterByPD
 *
 * Here will read MIB setting to setup IPv6 firewall rules.
 * 1. Flush all rules.
 * 2. Setup rules according to user setting with Delegated Prefix
 * 3. Setup default incoming/outgoing rules.
 *
 */
void updateIPV6FilterByPD(DLG_INFO_Tp pDLGInfo)
{
	char *argv[20];
	unsigned char value[32], byte;
	unsigned char ivalue;	
	int vInt, i, total;
	MIB_CE_V6_IP_PORT_FILTER_Tp pIpEntry;
	char *policy, *filterSIP, *filterDIP, srcPortRange[12], dstPortRange[12];
	char SIPRange[110]={0};	
	char DIPRange[110]={0};
	unsigned char prefixIp6Addr[IP6_ADDR_LEN];
	unsigned char newPrefixStr[MAX_V6_IP_LEN]={0};

	if(!pDLGInfo)
	{
		printf("Error! Invalid parameter pDLGInfo in %s\n",__func__);
	return;
	}

	printf("Update Firewall rule set by user.\n");
	// Delete ipfilter rule
	va_cmd(IP6TABLES, 2, 1, "-F", (char *)FW_IPV6FILTER);

	// packet filtering
	// ip filtering
	total = _mib_chain_total(MIB_V6_IP_PORT_FILTER_TBL);	

	// accept related
	// ip6tables -A ipv6filter -m state --state ESTABLISHED,RELATED -j RETURN
	va_cmd(IP6TABLES, 8, 1, (char *)FW_ADD, (char *)FW_IPV6FILTER, "-m", "state",
			"--state", "ESTABLISHED,RELATED", "-j", (char *)FW_RETURN);
	// ip6tables -A ipv6filter -d ff00::/8 -j RETURN
	//va_cmd(IP6TABLES, 6, 1, (char *)FW_ADD, (char *)FW_IPV6FILTER, "-d",
	//	"ff00::/8", "-j", (char *)FW_RETURN);

	for (i = 0; i < total; i++)
	{
		pIpEntry= (typeof(pIpEntry))_mib_chain_get(MIB_V6_IP_PORT_FILTER_TBL, i);
		if(!pIpEntry)
		{
			printf("mib chain MIB_V6_IP_PORT_FILTER_TB get fail!\n");
			continue;
		}

		setEachIPv6FilterRuleByPD(pIpEntry, pDLGInfo);
	}	

	// Kill all conntrack (to kill the established conntrack when change ip6tables rules)
	va_cmd("/bin/ethctl", 2, 0, "conntrack", "killall");

	//----------------------------------------------
	//   Now setup incoming/outgoing default rule
	//----------------------------------------------
	printf("Setup default Firewall rule.\n");
	if (_mib_get(MIB_V6_IPF_OUT_ACTION, (void *)&ivalue) != 0)
	{		
		if (ivalue == 0)	// DROP
		{
			// ip6tables -A ipv6filter -i $LAN_IF -j DROP			
			va_cmd(IP6TABLES, 6, 1, (char *)FW_ADD,
					(char *)FW_IPV6FILTER, (char *)ARG_I,
					(char *)LANIF, "-j", (char *)FW_DROP);
		}
	}

	if (_mib_get(MIB_V6_IPF_IN_ACTION, (void *)&ivalue) != 0)
	{		
		if (ivalue == 0)	// DROP
		{
			// ip6tables -A ipv6filter -i ! $LAN_IF -j DROP				
			va_cmd(IP6TABLES, 7, 1, (char *)FW_ADD,
					(char *)FW_IPV6FILTER, (char *)ARG_I, "!",
					(char *)LANIF, "-j", (char *)FW_DROP);

		}
	}
}
#endif

int doDelegation(const char *fname)
{
	int ret=0;
	char vChar=-1;

	_mib_get(MIB_V6_IPV6_ENABLE, (void *)&vChar);
	if (vChar == 0)
		return;

	ret = getLeasesInfo(fname, &dlg_info);

	if ( ret == 1 ) {
		unsigned char 	Ipv6AddrStr[48]={0},old_Ipv6AddrStr[48]={0};
		//     IPv6 network  may give prefix with length 56 by prefix delegation,
		//     but only prefix length = 64, SLAAC will work.
		//
		//Ref: rfc4862: Section 5.5.3.  Router Advertisement Processing
		//     If the sum of the prefix length and interface identifier length
		//     does not equal 128 bits, the Prefix Information option MUST be
		//     ignored.
		if( dlg_info.prefixLen!=64 )
			dlg_info.prefixLen=64;


		// Now deal with RFC6204, L-13:  
		//			 If the delegated prefix changes, i.e., the current prefix is
		//           replaced with a new prefix without any overlapping time
		//           period, then the IPv6 CE router MUST immediately advertise the
		//           old prefix with a Preferred Lifetime of zero and a Valid
		//           Lifetime of the lower of the current Valid Lifetime and 2
		//           hours (which must be decremented in real time) in a Router
		//           Advertisement message as described in Section 5.5.3, (e) of 
		//           [RFC4862].		
		//
		inet_ntop(PF_INET6, (struct in6_addr *)dlg_info.prefixIP, Ipv6AddrStr, sizeof(Ipv6AddrStr));	
		inet_ntop(PF_INET6, (struct in6_addr *)old_dlg_info.prefixIP, old_Ipv6AddrStr, sizeof(Ipv6AddrStr));	
		if( strcmp(old_Ipv6AddrStr,"::")!=0 && strcmp(Ipv6AddrStr,old_Ipv6AddrStr)!=0)
		{
			printf("Prefix delegation: Changed from %s to %s\n",old_Ipv6AddrStr,Ipv6AddrStr);
			_setup_radvd_conf(1, &dlg_info, 1, &old_dlg_info);
			// make sure that sending this packet is finished. So we sleep(3).
			sleep(3);
		}

		memcpy(&old_dlg_info,&dlg_info,sizeof(old_dlg_info));
		// Reset RADVD conf
		_setup_radvd_conf(1, &dlg_info, 0, NULL);
		// Reset DHCPDV6 conf
		_start_dhcpv6(1, &dlg_info);

#ifndef CONFIG_IPV6_OLD_FILTER
		updateIPV6FilterByPD(&dlg_info);
#endif
		va_cmd("/bin/cp", 2, 1, fname, "/var/prefix_info");
	}

	return 1;
}

static void cfg_delegation(struct mymsgbuf *qbuf)
{
	doDelegation(qbuf->msg.mtext);
	qbuf->request = MSG_SUCC;
}
#endif
#endif // #ifdef CONFIG_IPV6

/*
 *	upload <filename>	---	upload firmware
 */
// Brian --- for debug
//FILE *myfp;
//const char ftpFile[]="/var/msglog";
//const char killFile[]="/var/killlog";
struct pidStruc {
	PID_SHIFT_T shift;
	char *pidFile;
};

static struct pidStruc killProcessFile[]=
{
	{PID_DNSMASQ, "dnsmasq.pid"},
	{PID_SNMPD, "snmpd.pid"},
	{PID_WEB, "boa.pid"},
	{PID_CLI, "cli.pid"},
	{PID_DHCPD, "udhcpd.pid"},
	{PID_DHCPRELAY, "dhcrelay.pid"},
	{PID_TELNETD, "telnetd.pid"},
	{PID_FTPD, "ftpd.pid"},
	{PID_TFTPD, "tftpd.pid"},
	{PID_SSHD, "dropbear.pid"},
	{PID_SYSLOGD, "syslogd.pid"},
	{PID_KLOGD, "klogd.pid"},
	{PID_IGMPPROXY, "igmp_pid"},
	{PID_RIPD, "routed.pid"},
	{PID_WATCHDOGD, "wdg.pid"},
	{PID_SNTPD, "vsntp.pid"},
	{PID_MPOAD, "mpoad.pid"},
	{PID_SPPPD, "spppd.pid"},
	{PID_UPNPD, "linuxigd.pid"},
	{PID_UPDATEDD, "updatedd.pid"},
	{PID_CWMP, "cwmp.pid"}, /*tr069/cwmpClient pid,jiunming*/
	{PID_WSCD, "wscd-wlan0.pid"},
	{PID_MINIUPNPD, "mini_upnpd.pid"},
	{PID_SMBD, "smbd.pid"},
	{PID_NMBD, "nmbd.pid"},
#ifdef VOIP_SUPPORT
	{PID_VOIPGWDT, "voip_gwdt.pid"},
	{PID_SOLAR, "solar.pid"},
#endif
	{-1, 0}
};

#define CONF_PIDFILE_PATH  "/var/run"
#define SIGKILL		 9
#define SIGTERM		15
int g_killprocess=KILL_PROCESS_OFF;
static void cfg_killprocess(struct mymsgbuf *qbuf)
{
	int  spid, index;
	FILE *spidfile;
	unsigned int pidMask, thisPid;

	qbuf->request = MSG_FAIL;

	if (chdir (CONF_PIDFILE_PATH) < 0){
		return;
	}

#ifdef CONFIG_USER_WATCHDOG_WDG
	// Mason Yu
	va_cmd_no_echo("/bin/wdg", 1, 1, "off");
#endif

	pidMask = (unsigned int)qbuf->msg.arg1;

	for( index=0; killProcessFile[index].pidFile; index++ )
	{
		// check for process mask
		thisPid = 1 << killProcessFile[index].shift;
		if (!(thisPid & pidMask))
			continue;
		if ((spidfile = fopen( killProcessFile[index].pidFile, "r"))) {
			// Mason Yu
			if ( strcmp("updatedd.pid", killProcessFile[index].pidFile) == 0 ) {
				g_killprocess = KILL_PROCESS_ON;
			}

			fscanf(spidfile, "%d\n", &spid);
			fclose(spidfile);
			unlink(killProcessFile[index].pidFile);
			printf("kill=%s spid=%d\n", killProcessFile[index].pidFile, spid);
			//fprintf(myfp, "cfg_killprocess: kill=%s spid=%d\n", killProcessFile[index].pidFile, spid);
			//fflush(myfp);
			kill( spid, SIGTERM);
		}
	}

	qbuf->request = MSG_SUCC;
}

#include <net/if.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#define SIOCETHTEST_SAVED 0x89a1

struct arg{
	unsigned char cmd;
	unsigned int cmd2;
	unsigned int cmd3;
	unsigned int cmd4;
}pass_arg_saved;

void reboot_by_watchdog()
{
	struct ifreq	ifr;
  	int fd=0;

	fd = socket(AF_INET, SOCK_DGRAM, 0);
  	if(fd< 0){
		printf("Saved: Watchdog control fail!\n");
		goto fail;
  	}
	strncpy(ifr.ifr_name, "eth0", 16);
	ifr.ifr_data = (void *)&pass_arg_saved;

	pass_arg_saved.cmd=14;  //watchdog command
    	pass_arg_saved.cmd2=2;
    	pass_arg_saved.cmd3=0;

	ioctl(fd, SIOCETHTEST_SAVED, &ifr);

fail:
	return;
}

void stop_processes(void)
{

	//printf("upgrade: killing tasks...\n");

	kill(1, SIGTSTP);		/* Stop init from reforking tasks */
	kill(1, SIGSTOP);
	kill(2, SIGSTOP);
	kill(3, SIGSTOP);
	kill(4, SIGSTOP);
	kill(5, SIGSTOP);
	kill(6, SIGSTOP);
	//atexit(restartinit);		/* If exit prematurely, restart init */
	sync();

#if 0
	signal(SIGTERM,SIG_IGN);	/* Don't kill ourselves... */
	setpgrp(); 			/* Don't let our parent kill us */
	sleep(1);
	signal(SIGHUP, SIG_IGN);	/* Don't die if our parent dies due to
					 * a closed controlling terminal */
#endif

}

static void fw_upload(const char *fname, int offset, int imgFileSize)
{
	int ret = -1;
	FILE *fp = NULL;
	struct stat st;
	int fsize;
	int hasHdr;
	IMGHDR imgHdr;
	unsigned int image_offset;
#ifdef CONFIG_8M_SDRAM
	struct mymsgbuf myqbuf;
#endif
	/*ql:20080729 START: check image key validity. */
#ifdef MULTI_IC_SUPPORT
	unsigned int key;
#endif
	/*ql:20080729 END */
#ifdef CONFIG_DOUBLE_IMAGE
	int partCheck = 0;
#endif
#ifdef CONFIG_RTL8686
	char part_name[32];
	unsigned int image_len = 0;
#endif

// Kaohj -- TR068 Power LED
//star: for ZTE power LED request
	FILE *fp1;
	unsigned char power_flag;

	fp1 = fopen("/proc/power_flag", "w");
	if (fp1) {
		power_flag = '1';
		fwrite(&power_flag, 1, 1, fp1);
		fclose(fp1);
	}
#ifdef CONFIG_8M_SDRAM
	stop_processes();
#ifdef CONFIG_USER_WATCHDOG_WDG
	va_cmd_no_echo("/bin/wdg", 1, 1, "off");
	va_cmd_no_echo("/bin/wdg", 2, 1, "timeout", "1");
#endif
	myqbuf.msg.arg1 = NET_PID;
	cfg_killprocess(&myqbuf);
#endif // of CONFIG_8M_SDRAM

#ifdef ENABLE_SIGNATURE
	offset += sizeof(SIGHDR);
	fsize = imgFileSize - sizeof(SIGHDR);
#else
	fsize = imgFileSize;
#endif

	if ((fp = fopen(fname, "rb")) == NULL) {
		fprintf(stderr, "File %s open fail\n", fname);
		goto ret;
	}

	if (fstat(fileno(fp), &st) < 0)
		goto ret;

	if (fseek(fp, offset, SEEK_SET) == -1)
		goto ret;

	if (fsize <= 0)
		goto ret;

	/*ql:20080729 START: check the validity of image, just check key */
#ifndef MULTI_IC_SUPPORT
	// simple check for image header. Making it backward compatible for now.
	// Andrew
#ifdef CONFIG_RTL8686
check_next_header:
	if (fread(&imgHdr, sizeof(imgHdr), 1, fp)) {
		switch (imgHdr.key) {
		case APPLICATION_UBOOT:
			hasHdr = 1;
			strcpy(part_name, "boot");
			printf("%s-%d::find uboot img\n", __func__, __LINE__);
			break;
		case APPLICATION_UIMAGE:
			hasHdr = 1;
			strcpy(part_name, "linux");
			printf("%s-%d::find linux img\n", __func__, __LINE__);
			break;
		case APPLICATION_ROOTFS:
			hasHdr = 1;
			strcpy(part_name, "rootfs");
			printf("%s-%d::find rootfs img\n", __func__, __LINE__);
			break;
		default:
			hasHdr = 0;
			fseek(fp, offset, SEEK_SET);
			printf("img with unknown header! hasHdr=%d\n", hasHdr);
			break;
		}
		if (hasHdr) {
			image_len = imgHdr.length;
			printf("%s(%d)::image_len:%d\n", __func__,
			       __LINE__, image_len);
			#ifndef CONFIG_ENABLE_KERNEL_FW_UPDATE 
			fsize -= sizeof(IMGHDR);
			#endif 
		}
	} else {
		hasHdr = 0;
		fseek(fp, offset, SEEK_SET);
		printf("img without header! hasHdr=%d\n", hasHdr);
	}
#else //CONFIG_RTL8686
	if ((1 == fread(&imgHdr, sizeof(imgHdr), 1, fp)) &&
	    (APPLICATION_IMAGE == imgHdr.key)) {
		hasHdr = 1;
		fsize -= sizeof(IMGHDR);
	} else {
		hasHdr = 0;
		fseek(fp, offset, SEEK_SET);
	}
#endif /*CONFIG_RTL8686 */
#else // MULTI_IC_SUPPORT start
	// simple check for image header. Making it backward compatible for now.
	// Andrew
	key = getImgKey();
	if ((1 == fread(&imgHdr, sizeof(imgHdr), 1, fp)) &&
	    ((key == (imgHdr.key & key))
	     && (((imgHdr.key >> 28) & 0xf) == ((key >> 28) & 0xf)))) {
		hasHdr = 1;
		fsize -= sizeof(IMGHDR);
	} else {
		hasHdr = 0;
		fseek(fp, offset, SEEK_SET);
	}
#endif // of !MULTI_IC_SUPPORT
	/*ql:20080729 END */

	printf("filesize(Not include imgHdr(64 bytes))  = %d\n", fsize);
	printf("imgFileSize = %d\n", imgFileSize);

#ifdef CONFIG_ENABLE_KERNEL_FW_UPDATE
	do {
		char buf[128];
		int part=1;

#ifdef CONFIG_PPP
		// Jenny, disconnect PPP before rebooting
		stopPPP();
#endif
#ifdef CONFIG_DOUBLE_IMAGE
		//printf("check current rootfs... ");
		//ql: check the run-time image block
		__mib_flash_read(&partCheck, PART_CHECK_OFFSET, 4);
		if (!partCheck) {
			printf("latest is the first!\n");
			partCheck = 0xffffffff;
			__mib_flash_write(&partCheck, PART_CHECK_OFFSET, 4);
			part = 2;
			printf("write second rootfs finished!\n");
		}
		else {
			printf("latest is the second!\n");
			partCheck = 0;
			__mib_flash_write(&partCheck, PART_CHECK_OFFSET, 4);
			part = 1;
			printf("write first rootfs finished!\n");
		}
#endif
		system("echo -n \"1321\" > /proc/fwupdate");
		#ifdef CONFIG_RTL8686
		/* 8696 series take whole image as input */
		snprintf(buf, sizeof(buf), "echo -n \"%d;%s;%d;%d\" > /proc/fwupdate", offset, fname, part, fsize);
		#else
		if (hasHdr) {
			snprintf(buf, sizeof(buf), "echo -n \"%d;%s;%d;%d\" > /proc/fwupdate", offset+sizeof(imgHdr), fname, part, fsize);
		}
		else {
			snprintf(buf, sizeof(buf), "echo -n \"%d;%s;%d;%d\" > /proc/fwupdate", offset, fname, part, fsize);
		}
		#endif 
		printf("cmd: %s\n", buf);
		fclose(fp);
		system(buf);
		while (1)
			;
	} while (0);
#else

//ccwei
#ifdef CONFIG_MTD_NAND
	ret = system("echo 1 > /var/http_upgrade");
#endif
#ifdef CONFIG_DOUBLE_IMAGE
	//printf("check current rootfs... ");
	//ql: check the run-time image block
	__mib_flash_read(&partCheck, PART_CHECK_OFFSET, 4);
	if (!partCheck) {
		printf("latest is the first!\n");

		//write to bakup block
		// 20130315 W.H. Hung:
		// ret = flashdrv_filewrite(fp, fsize, (void *)ROOTFS_BAKUP_OFFSET);
		ret = flashdrv_filewrite(fp, fsize, (void *)g_fs_bak_offset);
		partCheck = 0xffffffff;
		__mib_flash_write(&partCheck, PART_CHECK_OFFSET, 4);
		printf("write second rootfs finished!\n");
	} else {
		printf("latest is the second!\n");

		//write to main block
		//20130315 W.H. Hung:
		//ret = flashdrv_filewrite(fp, fsize, (void *)CODE_IMAGE_OFFSET);
		ret = flashdrv_filewrite(fp, fsize, (void *)g_rootfs_offset);
		partCheck = 0;
		__mib_flash_write(&partCheck, PART_CHECK_OFFSET, 4);
		printf("write first rootfs finished!\n");
	}
#else	//!CONFIG_DOUBLE_IMAGE start
#ifdef CONFIG_RTL8686
	if (hasHdr) {
		ret = flash_filewrite(fp, image_len, part_name);
		fsize -= image_len;

		if (fsize > sizeof(imgHdr)) {
			goto check_next_header;
		}
	} else {
		printf("%s-%d:: can't find your image KEY! ret:%d\n", __func__,
		       __LINE__, ret);
	}
#else
	#ifdef CONFIG_MTD_NAND
	if (hasHdr) {
		ret = flashdrv_filewrite(fp, fsize, (void *)image_offset);
	}else{
		printf("%s-%d:: can't find your image KEY! ret:%d\n", __func__,
		       __LINE__, ret);
	}
	#else /*CONFIG_MTD_NAND*/
	if (hasHdr) {
		if ((unsigned int)imgHdr.flashp & 0x02000000)	// flash_base: 0xbfc00000
			image_offset = ((unsigned int)imgHdr.flashp) - 0xbfc00000;
		else		// flash_base: 0xbd000000
			image_offset = ((unsigned int)imgHdr.flashp) - 0xbd000000;

		// 20130315 W.H. Hung:
		//if (image_offset >= CODE_IMAGE_OFFSET)
		if (image_offset >= g_rootfs_offset && g_rootfs_offset > 0)
			ret = flashdrv_filewrite(fp, fsize, (void *)image_offset);
		else
			printf("Invalid image: not allowed to write at 0x%x\n",
			       image_offset);
	}
	else {
		// 20130315 W.H. Hung:
		//ret = flashdrv_filewrite(fp, fsize, (void *)CODE_IMAGE_OFFSET);
		ret = flashdrv_filewrite(fp, fsize, (void *)g_rootfs_offset);
	}
	#endif /*CONFIG_MTD_NAND*/
#endif /*CONFIG_RTL8686 */
#endif

#if (LINUX_VERSION_CODE < 0x00020600)	// linux 2.4?
	// Kaohj -- re-init fs
	if ((fp1 = fopen("/proc/fs/fs_init", "w")) == NULL) {
		printf(stderr, "open fs_init error\n");
	} else {
		printf(fp1, "1\n");
		fclose(fp1);
	}
#endif

	if (ret)
		printf("flash error!\n");
	else
		printf("flash write completed !!\n");

#endif //#ifdef CONFIG_ENABLE_KERNEL_FW_UPDATE
ret:
	fclose(fp);
//ccwei
#ifdef CONFIG_MTD_NAND
	system("rm /var/http_upgrade");
#endif
	unlink(fname);
	printf("The system is restarting ...\n");
	sysReboot(NULL);
}

static void *fwUpload(void *data)
{
#ifdef CONFIG_USER_RTK_RECOVER_SETTING	// Save Setting to flatfsd(flash).
	va_cmd("/bin/saveconfig", 1, 1, "-s");
#endif
	/*
	 * Default value is PTHREAD_CANCEL_DEFERRED that
	 * a cancellation request is deferred until the thread
	 * next calls a function that is a cancellation point.
	 * Setting cancel type to PTHREAD_CANCEL_ASYNCHRONOUS is for
	 * the thread being canceled at any time.
	 */
	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

	fw_upload(g_upload_post_file_name, g_upload_startPos, g_upload_fileSize);

	// We can use pthread_exit() or return to terminate this thread.
	pthread_exit(NULL);
}

static void cfg_upload(struct mymsgbuf *qbuf)
{
	static pthread_t ptUploadId;

	if (qbuf->msg.arg2 == 0) {
		printf("Cancel Upload therad\n");

		pthread_cancel(ptUploadId);
	} else {
		//tylo, telefonica LED flash while firmware upgrade
		if (access("/proc/fwupgrade_flag", F_OK) == 0)
			system("echo 1 > /proc/fwupgrade_flag");
		unlink("/var/log/messages");

		g_upload_startPos = qbuf->msg.arg1;
		g_upload_fileSize = qbuf->msg.arg2;
		strncpy(g_upload_post_file_name, qbuf->msg.mtext,
			MAX_SEND_SIZE);
		g_upload_post_file_name[MAX_SEND_SIZE - 1] = '\0';
		// To create Upload thread
		printf("Create Upload therad\n");

		pthread_create(&ptUploadId, NULL, fwUpload, NULL);
		pthread_detach(ptUploadId);
	}
	qbuf->request = MSG_SUCC;
}

static void cfg_check_image(struct mymsgbuf *qbuf)
{
	FILE	*fp=NULL;
	IMGHDR imgHdr;
	unsigned int csum;
	int nRead, total = 0;
	unsigned char buf[64];
	int offset, size, remain, block;
#ifdef CONFIG_RTL8686
	int err=-1;
#endif
#if defined(ENABLE_SIGNATURE)
	SIGHDR sigHdr;
	int i;
	unsigned int hdrChksum;
#endif
	/*ql:20080729 START: check image key validity.*/
#ifdef MULTI_IC_SUPPORT
	unsigned int key;
#endif
	/*ql:20080729 END*/

	qbuf->request = MSG_FAIL;
	offset = qbuf->msg.arg1;

	if ((fp = fopen (qbuf->msg.mtext, "rb")) == NULL) {
		printf("File %s open fail\n", qbuf->msg.mtext);
		return;
	}

	if (fseek(fp, offset, SEEK_SET)==-1) {
		//jim should delete below fclose, otherwise will be closed twice...
		//fclose(fp);
		goto ERROR;
	}
#if defined(ENABLE_SIGNATURE)
//ql add to check if the image is right.
	memset(&sigHdr, 0, sizeof(sigHdr));
	if (1 != fread(&sigHdr, sizeof(sigHdr), 1, fp)) {
		printf("failed to read signature\n");
		goto ERROR;
	}
#endif

	if (1!=fread(&imgHdr, sizeof(imgHdr), 1, fp)) {
		printf("Failed to read header\n");
		goto ERROR;
	}
#ifndef ENABLE_SIGNATURE_ADV
#ifdef ENABLE_SIGNATURE
	if (sigHdr.sigLen > SIG_LEN) {
		printf("signature length error\n");
		goto ERROR;
	}
	for (i=0; i<sigHdr.sigLen; i++)
		sigHdr.sigStr[i] = sigHdr.sigStr[i] - 10;
	if (strcmp(sigHdr.sigStr, SIGNATURE)) {
		printf("signature error\n");
		goto ERROR;
	}

	hdrChksum = sigHdr.chksum;
	hdrChksum = ipchksum(&imgHdr, sizeof(imgHdr), hdrChksum);
	if (hdrChksum) {
		printf("Checksum failed(msgparser cfg_check_image), size=%d, csum=%04xh\n", sigHdr.sigLen, hdrChksum);
		goto ERROR;
	}
#endif
#endif

	/*ql:20080729 START: check the validity of image, just check key*/
#ifndef MULTI_IC_SUPPORT
#ifdef CONFIG_RTL8686
		switch(imgHdr.key){
			case APPLICATION_UBOOT:
			case APPLICATION_UIMAGE:
			case APPLICATION_ROOTFS:
				printf("%s-%d, got header::%x\n",__func__,__LINE__,imgHdr.key);
				err = 0;
				break;
			default:
				printf("%s-%d, Unknown header::%x\n",__func__,__LINE__,imgHdr.key);
				err = 1;
				break;
		}
		if(err)
			goto ERROR;
#else
	if (imgHdr.key != APPLICATION_IMAGE) {
		printf("Unknown header\n");
		goto ERROR;
	}
#endif
#else
	key = getImgKey();

	if ((key != (imgHdr.key & key)) || (((imgHdr.key>>28)&0xf) != ((key>>28)&0xf))) {
		printf("img key error!\n");
		goto ERROR;
	}
#endif
	/*ql:20080729 END*/

	csum = imgHdr.chksum;
	size = imgHdr.length;
	remain = size;

	while (remain > 0) {
		block = (remain > sizeof(buf)) ? sizeof(buf) : remain;
		nRead = fread(buf, 1, block, fp);
		if (nRead <= 0) {
			printf("read too short (remain=%d, block=%d)\n", remain, block);
			goto ERROR;
		}
		remain -= nRead;
		csum = ipchksum(buf, nRead,csum);
	}
#if 0
	csum = imgHdr.chksum;
	while (nRead = fread(buf, 1, sizeof(buf), fp)) {
		total += nRead;
		csum = ipchksum(buf, nRead, csum);
	}
#endif

	if (csum) {
		printf("Checksum failed(msgparser cfg_check_image2), size=%d, csum=%04xh\n", total, csum);
		goto ERROR;
	}
	qbuf->request = MSG_SUCC;

ERROR:
	fclose(fp);
	return;
}

#ifdef CONFIG_RTL8672_SAR
#ifdef AUTO_PVC_SEARCH_AUTOHUNT
#define MAX_PVC_SEARCH_PAIRS 16
static void cfg_start_autohunt(struct mymsgbuf *qbuf)
{
	FILE *fp;

	MIB_AUTO_PVC_SEARCH_Tp entryP;
	//MIB_AUTO_PVC_SEARCH_T Entry;
	unsigned int entryNum,i;
	unsigned char tmp[12], tmpBuf[MAX_PVC_SEARCH_PAIRS*12];

	entryNum = _mib_chain_total(MIB_AUTO_PVC_SEARCH_TBL);
	memset(tmpBuf, 0, sizeof(tmpBuf));
	for(i=0;i<entryNum; i++) {
		memset(tmp, 0, 12);
		entryP = (typeof(entryP))_mib_chain_get(MIB_AUTO_PVC_SEARCH_TBL, i);
		if (!entryP)
			continue;
		//if (!_mib_chain_get(MIB_AUTO_PVC_SEARCH_TBL, i, (void *)&Entry))
		//	continue;
		sprintf(tmp,"(%d %d)", entryP->vpi, entryP->vci);
		strcat(tmpBuf, tmp);

	}
	//printf("StartSarAutoPvcSearch: inform SAR %s\n", tmpBuf);


	if (fp=fopen("/proc/AUTO_PVC_SEARCH", "w") )
	{
		fprintf(fp, "1%s\n", tmpBuf);	//write pvc list stored in flash to SAR driver
//		printf("StartSarAutoPvcSearch: Inform SAR driver to start auto-pvc-search\n");

		fclose(fp);
	} else {
		printf("Open /proc/AUTO_PVC_SEARCH failed! Can't start SAR driver doing auto-pvc-search\n");
	}

	qbuf->request = MSG_SUCC;
}
#endif
#endif

// Added by Mason Yu
#ifdef CONFIG_USER_DDNS
static void cfg_ddns_ctrl(struct mymsgbuf *qbuf)
{
	struct thread_info tinfo;

	strcpy(tinfo.ifname, qbuf->msg.mtext);
	tinfo.ipversion= qbuf->msg.arg1;

	// Mason Yu.  create DDNS thread dynamically
	startDdnsc(tinfo);
	qbuf->request = MSG_SUCC;
	return;
}
#endif

// Kaohj -- transform received file to xml file
const char tmpxml[] = "/tmp/tmpdecryxor.xml";
const char xml_name[] = "/tmp/config.xml";
static void cfg_file2xml(struct mymsgbuf *qbuf)
{
	FILE	*fpin=NULL;
	char LINE[256], str[64], str2[64];
	struct mymsgbuf myqbuf;
	MSGFile_T *pFile;

	qbuf->request = MSG_FAIL;

	pFile = (MSGFile_T *)&qbuf->msg.mtext[0];
	#ifdef XOR_ENCRYPT
	rename(pFile->fromName, tmpxml);
	xor_encrypt((char *)tmpxml, pFile->toName);
	unlink(tmpxml);
	#else
	if (strcmp(pFile->fromName, pFile->toName))
		rename(pFile->fromName, pFile->toName);
	#endif

	if ((fpin = fopen (xml_name, "rb")) == NULL)
		return;

	fseek(fpin, 0, SEEK_SET);
	fgets(LINE, sizeof(LINE), fpin);
	fclose(fpin);
	sprintf(str, "%s\n", CONFIG_HEADER);
	// Support Dos Format
	sprintf(str2, "%s\r\n", CONFIG_HEADER);
	if (strcmp(LINE, str) && strcmp(LINE, str2)) { // header error
		unlink(xml_name);
		return;
	}

	qbuf->request = MSG_SUCC;
}

// Kaohj -- transform xml file to backup file
static void cfg_xml2file(struct mymsgbuf *qbuf)
{
	struct mymsgbuf myqbuf;
	MSGFile_T *pFile;

	qbuf->request = MSG_FAIL;

	pFile = (MSGFile_T *)&qbuf->msg.mtext[0];
	#ifdef XOR_ENCRYPT
	rename(pFile->fromName, tmpxml);
	xor_encrypt((char *)tmpxml, pFile->toName);
	unlink(tmpxml);
	#else
	if (strcmp(pFile->fromName, pFile->toName))
		rename(pFile->fromName, pFile->toName);
	#endif

	qbuf->request = MSG_SUCC;
}

#ifndef _USE_RSDK_WRAPPER_
#include "../../../spppd/pppoe.h"
#endif  //_USE_RSDK_WRAPPER_
static void cfg_update_PPPoE_session(struct mymsgbuf *qbuf)
{
	PPPOE_SESSION_INFO *p = (PPPOE_SESSION_INFO *)qbuf->msg.mtext;
	unsigned int totalEntry;
	int i, found=0, selected=-1;
	MIB_CE_PPPOE_SESSION_Tp Entry;

	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	//update_PPPoE_session(p);
	totalEntry = _mib_chain_total(MIB_PPPOE_SESSION_TBL);
	for (i=0; i<totalEntry; i++) {
		selected = i;
		Entry = (typeof(Entry))_mib_chain_get(MIB_PPPOE_SESSION_TBL, i);
		if (!Entry) {
  			printf("Get chain record error!\n");
			return;
		}

		if (Entry->uifno == p->uifno)
		{
			found ++;
				break;
		}
	}

	if (found != 0) {
		Entry->sessionId = p->session;
		memcpy((unsigned char *)Entry->acMac, (unsigned char *)p->remote.sll_addr, 6);
			_mib_chain_update(MIB_PPPOE_SESSION_TBL, (void *)Entry, selected);
		}
	else {
		MIB_CE_PPPOE_SESSION_T entry;
		memset(&entry, 0, sizeof(entry));
		entry.uifno = p->uifno;
		memcpy((unsigned char *)entry.acMac, (unsigned char *)p->remote.sll_addr, 6);
		entry.sessionId = p->session;
		_mib_chain_add(MIB_PPPOE_SESSION_TBL, (void *)&entry);
	}

	qbuf->request = MSG_SUCC;
}

static void cfg_mib_set_PPPoE(struct mymsgbuf *qbuf)
{
	struct mymsgbuf myqbuf;
	PPPOE_SESSION_INFO *p = (PPPOE_SESSION_INFO *)qbuf->msg.mtext;

	qbuf->request = MSG_FAIL;

	if (__mib_lock) {
		qbuf->request = MSG_MIB_LOCKED;
		return;
	}

	myqbuf.msg.arg1 = CONFIG_MIB_CHAIN;
	cfg_mib_backup(&myqbuf);	// backup current MIB chain into system
	myqbuf.msg.arg1 = CURRENT_SETTING;
	myqbuf.msg.arg2 = CONFIG_MIB_CHAIN;
	cfg_mib_reload(&myqbuf);	//get MIB chain from flash
	myqbuf.msg.arg1 = (int)qbuf->msg.arg1;
	memcpy(myqbuf.msg.mtext, qbuf->msg.mtext, myqbuf.msg.arg1);
	cfg_update_PPPoE_session(&myqbuf);

	myqbuf.msg.arg1 = CURRENT_SETTING;
	myqbuf.msg.arg2 = CONFIG_MIB_CHAIN;
	cfg_mib_update(&myqbuf);

	myqbuf.msg.arg1 = CONFIG_MIB_CHAIN;
	cfg_mib_restore(&myqbuf);	// restore backup MIB chain
	myqbuf.msg.arg1 = (int)qbuf->msg.arg1;
	memcpy(myqbuf.msg.mtext, qbuf->msg.mtext, myqbuf.msg.arg1);
	cfg_update_PPPoE_session(&myqbuf);
	qbuf->request = MSG_SUCC;
}

#endif
#ifdef WLAN_WISP
static void _getWispIfName(int ifIndex, char *buffer, int len)
{
	int orig_idx;
	char wlan_mode, rptEnabled;

	orig_idx = wlan_idx;
	wlan_idx = ETH_INDEX(ifIndex);

	//wlan_idx = ETH_INDEX(pEntry->ifIndex);
	_mib_get(MIB_WLAN_MODE, (void *)&wlan_mode);
#ifdef WLAN_UNIVERSAL_REPEATER
	_mib_get(MIB_REPEATER_ENABLED1, (void *)&rptEnabled);
#else
	rptEnabled = 0;
#endif
	
	if( (wlan_mode == AP_MODE || wlan_mode == AP_WDS_MODE) && rptEnabled)
		snprintf(buffer, len, "wlan%d-vxd", ETH_INDEX(ifIndex));
	else if (wlan_mode == CLIENT_MODE)
		snprintf(buffer, len, "wlan%d", ETH_INDEX(ifIndex));

	wlan_idx = orig_idx;
}
#endif
static char *_ifGetName(int ifindex, char *buffer, unsigned int len)
{
	MEDIA_TYPE_T mType;

	if ( ifindex == DUMMY_IFINDEX )
		return 0;
	if (PPP_INDEX(ifindex) == DUMMY_PPP_INDEX)
	{
		mType = MEDIA_INDEX(ifindex);
		if (mType == MEDIA_ATM)
#ifdef CONFIG_RTL_MULTI_PVC_WAN
			snprintf( buffer, len,  "vc%u_%u", VC_MAJOR_INDEX(ifindex),  VC_MINOR_INDEX(ifindex));
#else
			snprintf( buffer, len,  "vc%u", VC_INDEX(ifindex) );
#endif
		else if (mType == MEDIA_ETH)
#ifdef CONFIG_RTL_MULTI_ETH_WAN
			snprintf( buffer, len, "%s%d", ALIASNAME_MWNAS, ETH_INDEX(ifindex));
#else
			snprintf( buffer, len,  "%s%u", ALIASNAME_NAS, ETH_INDEX(ifindex) );
#endif
#ifdef CONFIG_PTMWAN
		else if (mType == MEDIA_PTM)
			snprintf( buffer, len, "%s%d", ALIASNAME_MWPTM, PTM_INDEX(ifindex));
#endif /*CONFIG_PTMWAN*/
#ifdef WLAN_WISP
		else if (mType == MEDIA_WLAN)
			_getWispIfName(ifindex, buffer, len);
#endif
		else if (mType == MEDIA_IPIP)    // Mason Yu. Add VPN ifIndex
			snprintf( buffer, len, "ipip%u", IPIP_INDEX(ifindex));
		else
			return 0;

	}else{
		snprintf( buffer, len,  "ppp%u", PPP_INDEX(ifindex) );

	}
	return buffer;
}


// Mason Yu. for copy the ppp & dhcp nameserver to the /var/resolv.conf
//add by ramen
//now copy the ppp & dhcp nameserver to the /var/resolv.conf
static int fixUpDnsServer()
{	
	FILE *dnsfp=fopen(AUTO_RESOLV,"w");		/*save the DNS auto config into resolv.auto.conf*/
	unsigned int entryNum, i;
	MIB_CE_ATM_VC_T *Entry;
	char wanif[IFNAMSIZ];	
	char buf[1024]={0};	
#ifdef CONFIG_USER_PPPOMODEM
	unsigned char pppidx=0;
	MIB_WAN_3G_T *p;
#endif
	entryNum = _mib_chain_total(MIB_ATM_VC_TBL);
	if(dnsfp){	
		for (i = 0; i < entryNum; i++) {
			/* Retrieve entry */			
			if(!(Entry = _mib_chain_get(MIB_ATM_VC_TBL,i))) {
				printf("fixUpDnsServer_dhcpc: cannot get ATM_VC_TBL(ch=%d) entry\n", i);
				return -1;
			}				
			
			if (((DHCP_T)Entry->ipDhcp == DHCP_CLIENT) || (Entry->cmode == ACC_PPPOE || Entry->cmode == ACC_PPPOA) )
			{
				FILE* infdns;
				char value[64];

				_ifGetName(Entry->ifIndex,wanif,sizeof(wanif));

				if ((DHCP_T)Entry->ipDhcp == DHCP_CLIENT)
					snprintf(value, 64, "%s.%s", (char *)DNS_RESOLV, wanif);
				if (Entry->cmode == ACC_PPPOE || Entry->cmode == ACC_PPPOA)
					snprintf(value, 64, "%s.%s", (char *)PPP_RESOLV, wanif);				
				
				infdns=fopen(value,"r");
				
				if(infdns){
					while(!feof(infdns))
					{
						memset(buf,0,sizeof(buf));
						fgets(buf,sizeof(buf),infdns);
						fprintf(dnsfp,"%s",buf);
					}
					fclose(infdns);
				}
			}			
		}
		#ifdef CONFIG_USER_PPPOMODEM
		if (p = (MIB_WAN_3G_Tp)_mib_chain_get(MIB_WAN_3G_TBL, pppidx)) {
			if(p->enable){
				FILE* infdns_3g;
				char value_3g[64];
				snprintf(value_3g, 64, "%s.ppp%d", (char *)PPP_RESOLV, MODEM_PPPIDX_FROM + pppidx);							
				infdns_3g=fopen(value_3g,"r");
				if(infdns_3g){
					while(!feof(infdns_3g))
					{
						memset(buf,0,sizeof(buf));
						fgets(buf,sizeof(buf),infdns_3g);
						fprintf(dnsfp,"%s",buf);
					}
					fclose(infdns_3g);
				}
			}
		}
		#endif
		fclose(dnsfp);
	}
	return 1;	
}

static void cfg_ip_config_changed(struct mymsgbuf *qbuf)
{
	fixUpDnsServer();	// Mason Yu. for copy the ppp & dhcp nameserver to the /var/resolv.conf

	qbuf->request = MSG_SUCC;
}

