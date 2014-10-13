#if defined(CONFIG_GPON_FEATURE) || defined(CONFIG_EPON_FEATURE)
/*
 *      Web server handler routines for System Pon status
 *
 */

#include "../webs.h"
#include "webform.h"
#include "mib.h"
#include "utility.h"
#include "debug.h"
#include "multilang.h"
#if defined(CONFIG_RTK_L34_ENABLE)
#include <rtk_rg_liteRomeDriver.h>
#else
#include "rtk/ponmac.h"
#include "rtk/gpon.h"
#include "rtk/epon.h"
#endif
int showgpon_status(int eid, request * wp, int argc, char **argv)
{
	unsigned int pon_mode;
	int nBytesSent=0;
	rtk_gpon_fsm_status_t onu;

	if (mib_get(MIB_PON_MODE, (void *)&pon_mode) != 0) 
	{
		if (pon_mode != GPON_MODE) 
			return 0;
	}
	else
		return 0;

#if defined(CONFIG_RTK_L34_ENABLE)
	rtk_rg_gpon_ponStatus_get(&onu);
#else
	rtk_gpon_ponStatus_get(&onu);
#endif
	 nBytesSent += boaWrite(wp, "<tr> <td width=100%% colspan=\"2\" bgcolor=\"#008000\"><font color=\"#FFFFFF\" size=2><b>GPON Status</b></font></td> </tr>"
	"<tr bgcolor=\"#DDDDDD\">"
    "<td width=\"30%%\"><font size=2><b>ONU State</b></td>"
	"<td width=\"70%%\"><font size=2>O%d</td> </tr>\n",onu);
	return 0;
}

int showepon_LLID_status(int eid, request * wp, int argc, char **argv)
{
	int nBytesSent=0;
    int entryNum=4;
	char tmpBuf[100];
	int i;
	unsigned int pon_mode;

	if (mib_get(MIB_PON_MODE, (void *)&pon_mode) != 0) 
	{
		if (pon_mode != EPON_MODE) 
			return 0;
	}
	else
			return 0;
#if defined(CONFIG_RTK_L34_ENABLE)
	rtk_rg_epon_llidEntryNum_get(&entryNum);
#else
	rtk_epon_llidEntryNum_get(&entryNum);
#endif

	if(entryNum<=0)
	{
 		strcpy(tmpBuf, "get llidEntryNum Error!");
		ERR_MSG(tmpBuf);
		return -1;
	}

    nBytesSent += boaWrite(wp, "<td width=100%% colspan=\"2\" bgcolor=\"#008000\"><font color=\"#FFFFFF\" size=2><b> EPON LLID Status </b></font></td>");

	nBytesSent += boaWrite(wp, "<tr><font size=1>"
	"<td align=center width=\"33%%\" bgcolor=\"#808080\">%s</td>\n"
	"<td align=center width=\"33%%\" bgcolor=\"#808080\">%s</td>\n"
	"</font></tr>\n", multilang("index"), multilang("status"));

	for (i=0; i<entryNum; i++) {
		rtk_epon_llid_entry_t llid_entry;

		memset(&llid_entry, 0, sizeof(llid_entry));
		llid_entry.llidIdx = i;
#if defined(CONFIG_RTK_L34_ENABLE)
		rtk_rg_epon_llid_entry_get(&llid_entry);
#else
		rtk_epon_llid_entry_get(&llid_entry);
#endif
		nBytesSent += boaWrite(wp, "<tr>"
				"<td align=center width=\"33%%\" bgcolor=\"#C0C0C0\"><font size=\"2\"><b>%d</b></font></td>\n"
				"<td align=center width=\"33%%\" bgcolor=\"#C0C0C0\"><font size=\"2\"><b>%d</b></font></td><br>\n",
				llid_entry.llidIdx, llid_entry.valid);
	}
	return 0;

}

void formStatus_pon(request * wp, char *path, char *query)
{
	char *submitUrl;

	submitUrl = boaGetVar(wp, "submit-url", "");
	if (submitUrl[0])
		boaRedirect(wp, submitUrl);
	else
		boaDone(wp, 200);
  	return;
}

int ponGetStatus(int eid, request * wp, int argc, char **argv)
{
	char *name;
	rtk_transceiver_data_t transceiver;
	
	if (boaArgs(argc, argv, "%s", &name) < 1) {
		boaError(wp, 400, "Insufficient args\n");
		return -1;
	}

	if(!strcmp(name, "vendor-name")) 
	{
#if defined(CONFIG_RTK_L34_ENABLE)
		rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_VENDOR_NAME,&transceiver); 
#else
		rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_VENDOR_NAME,&transceiver); 
#endif
		boaWrite(wp, "%s", transceiver.buf);
		return 0;
	}
	else if(!strcmp(name, "part-number"))
	{
#if defined(CONFIG_RTK_L34_ENABLE)	
		rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_VENDOR_PART_NUM,&transceiver); 
#else
		rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_VENDOR_PART_NUM,&transceiver); 
#endif
		boaWrite(wp, "%s", transceiver.buf);
		return 0;
	}
	else if(!strcmp(name, "temperature"))
	{
#if defined(CONFIG_RTK_L34_ENABLE)	
		rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_TEMPERATURE,&transceiver); 
#else
		rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_TEMPERATURE,&transceiver); 
#endif
		boaWrite(wp, "%s", transceiver.buf);
		return 0;
	}
	else if(!strcmp(name, "voltage"))
	{
#if defined(CONFIG_RTK_L34_ENABLE)	
		rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_VOLTAGE,&transceiver); 
#else
		rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_VOLTAGE,&transceiver); 
#endif
		boaWrite(wp, "%s", transceiver.buf);
		return 0;
	}
	else if(!strcmp(name, "tx-power"))
	{
#if defined(CONFIG_RTK_L34_ENABLE)	
		rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_TX_POWER,&transceiver);	
#else
		rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_TX_POWER,&transceiver);	
#endif
		boaWrite(wp, "%s", transceiver.buf);
		return 0;
	}
	else if(!strcmp(name, "rx-power"))
	{
#if defined(CONFIG_RTK_L34_ENABLE)	
		rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_RX_POWER,&transceiver);	
#else
		rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_RX_POWER,&transceiver);	
#endif
		boaWrite(wp, "%s", transceiver.buf);
		return 0;
	}
	else if(!strcmp(name, "bias-current"))
	{
#if defined(CONFIG_RTK_L34_ENABLE)
                rtk_rg_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_BIAS_CURRENT,&transceiver);
#else
                rtk_ponmac_transceiver_get(RTK_TRANSCEIVER_PARA_TYPE_BIAS_CURRENT,&transceiver);
#endif
                boaWrite(wp, "%s", transceiver.buf);
                return 0;
	}
	
	return -1;
}
#endif 
