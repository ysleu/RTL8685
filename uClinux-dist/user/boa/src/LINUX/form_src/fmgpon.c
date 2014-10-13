#ifdef CONFIG_GPON_FEATURE
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <signal.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <time.h>
#include <net/route.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <net/if.h>
#if defined(CONFIG_RTK_L34_ENABLE)
#include <rtk_rg_liteRomeDriver.h>
#else
#include "rtk/gpon.h"
#endif


/*-- Local inlcude files --*/
#include "../webs.h"
#include "webform.h"
#include "mib.h"

int ShowGPONSIDInfo(int eid, request * wp, int argc, char **argv)
{
	unsigned int pon_mode;
	int nBytesSent=0;
	FILE *fp = NULL;
	char *FILE_PATH = "/proc/omci/veip";
	char buff[200];
	char *token1,*token2,*token3,*token4;
	char *saveptr1 = NULL;

	if (mib_get(MIB_PON_MODE, (void *)&pon_mode) != 0) 
	{
		if ( pon_mode != GPON_MODE) 
			return 0;
	}

	if (!(fp=fopen(FILE_PATH, "r"))) {
		printf("Error: cannot open %s - continuing...\n",FILE_PATH);
		boaWrite(wp, "Error: cannot open %s !!\n",FILE_PATH);
		return -1;
	}

	nBytesSent += boaWrite(wp, "<table><tr> <td width=100%% colspan=\"2\" bgcolor=\"#008000\"><font color=\"#FFFFFF\" size=2><b>GPON Stream ID/VLAN ID mapping</b></font></td> </tr> ");

	memset(buff,0,sizeof(buff));
	//First row : header
	if(fgets(buff, sizeof(buff), fp))
	{
		token1 =  strtok_r(buff,"|", &saveptr1);
		token2 =  strtok_r(NULL,"|", &saveptr1);
		token3 =  strtok_r(NULL,"|", &saveptr1);
		token4 =  strtok_r(NULL,"|", &saveptr1);
		nBytesSent += boaWrite(wp, "<tr><font size=1>"
				"<td align=center width=\"25%%\" bgcolor=\"#808080\">%s</td>\n"
				"<td align=center width=\"25%%\" bgcolor=\"#808080\">%s</td>\n"
				"<td align=center width=\"25%%\" bgcolor=\"#808080\">%s</td>\n"
				"<td align=center width=\"25%%\" bgcolor=\"#808080\">%s</td></font></tr>\n",
				token1, token2, token3, token4);
	}

	memset(buff,0,sizeof(buff));
	while(fgets(buff, sizeof(buff), fp))
	{
		token1 =  strtok_r(buff,"|", &saveptr1);
		token2 =  strtok_r(NULL,"|", &saveptr1);
		token3 =  strtok_r(NULL,"|", &saveptr1);
		token4 =  strtok_r(NULL,"|", &saveptr1);
		nBytesSent += boaWrite(wp, "<tr><font size=1>"
				"<td align=center width=\"25%%\" bgcolor=\"#C0C0C0\">%s</td>\n"
				"<td align=center width=\"25%%\" bgcolor=\"#C0C0C0\">%s</td>\n"
				"<td align=center width=\"25%%\" bgcolor=\"#C0C0C0\">%s</td>\n"
				"<td align=center width=\"25%%\" bgcolor=\"#C0C0C0\">%s</td></font></tr>\n",
				token1, token2, token3, token4);
	}
	nBytesSent += boaWrite(wp, "</table>");
	fclose(fp);
	return 0;
}

int fmGPONSIDSet(int eid, request * wp, int argc, char **argv)
{
	int nBytesSent=0;
	int pon_mode=0;

	if (mib_get(MIB_PON_MODE, (void *)&pon_mode) == 0) 
	{
		printf("Error! MIB access PON_MODE error!\n");
		return 0;
	}

	if (pon_mode == GPON_MODE) 
	{
		nBytesSent += boaWrite(wp, "<tr>"
				"<td> <font size=\"2\"><b>GPON SID : </b></font>\n"
				"<input type=\"text\" name=\"sid\" size=\"4\" maxlength=\"4\" ></td></tr>\n");
	}
	else
	{
		nBytesSent += boaWrite(wp, "<tr><td>\n"
				"<input type=\"hidden\" name=\"sid\" size=\"4\" maxlength=\"4\" ></td></tr>\n");
	}

	return 0;
}

int fmgpon_checkWrite(int eid, request * wp, int argc, char **argv)
{
	char *name;
	char tmpBuf[100];
	char loid[100]={0};
	
	if (boaArgs(argc, argv, "%s", &name) < 1) 
	{
   		boaError(wp, 400, "Insufficient args\n");
   		return -1;
   	}

	if(!strcmp(name, "fmgpon_loid")) 	
	{			
		if(!mib_get(MIB_GPON_LOID,  (void *)loid))		
		{	  		
			strcpy(tmpBuf, "get GPON LOID Error");			
			goto setErr;		
		}		
		boaWrite(wp, "%s", loid);		
		return 0;	
	}
	
	if(!strcmp(name, "fmgpon_loid_password")) 
	{
		if(!mib_get(MIB_GPON_LOID_PASSWD,  (void *)tmpBuf))
		{
			strcpy(tmpBuf, "get GPON LOID Password Error");
			goto setErr;
		}

		boaWrite(wp, "%s", tmpBuf);
		return 0;
	}

	if(!strcmp(name, "fmgpon_password")) 
	{
		if(!mib_get(MIB_GPON_PASSWD,  (void *)tmpBuf))
		{
			strcpy(tmpBuf, "get GPON LOID Error");
			goto setErr;
		}

		boaWrite(wp, "%s", tmpBuf);
		return 0;
	}

	if(!strcmp(name, "fmgpon_sn")) 
	{
		if(!mib_get(MIB_GPON_SN,  (void *)tmpBuf))
		{
			strcpy(tmpBuf, "get GPON LOID Error");
			goto setErr;
		}
		boaWrite(wp, "%s",tmpBuf);
		return 0;
	}

setErr:
	ERR_MSG(tmpBuf);
	return -1;
}

///////////////////////////////////////////////////////////////////
void formgponConf(request * wp, char *path, char *query)
{
	char	*strData,*strLoid,*strLoidPasswd;
	char tmpBuf[100];
	char omcicli[128];


	strLoid = boaGetVar(wp, "fmgpon_loid", "");	
	if ( strLoid[0] )	
	{		
		//printf("===>[%s:%d] fmgpon_loid=%s\n",__func__,__LINE__,strLoid);		
		if(!mib_set(MIB_GPON_LOID, strLoid))		
		{			
			strcpy(tmpBuf, "Save GPON LOID Error");			
			goto setErr;		
		}	
	}

	strLoidPasswd = boaGetVar(wp, "fmgpon_loid_password", "");	
	if ( strLoid[0] )	
	{		
		//printf("===>[%s:%d] fmgpon_loid_password=%s\n",__func__,__LINE__,strLoidPasswd);		
		if(!mib_set(MIB_GPON_LOID_PASSWD, strLoidPasswd))		
		{			
			strcpy(tmpBuf, "Save GPON LOID Password Error");			
			goto setErr;		
		}	
	}
	
	if(strLoid[0] && strLoidPasswd[0])
	{
		sprintf(omcicli, "/bin/omcicli set loid %s %s", strLoid,strLoidPasswd);
		//printf("OMCICLI : %s \n" , omcicli);
		system(omcicli);
	}


	strData = boaGetVar(wp, "fmgpon_password", "");
	if ( strData[0] )
	{
		//Password: 10 characters.
		rtk_gpon_password_t gpon_password;

		//Since OMCI has already active this, so need to deactive
		printf("GPON deActivate.\n");
#if defined(CONFIG_RTK_L34_ENABLE)
		rtk_rg_gpon_deActivate();
#else
		rtk_gpon_deActivate();
#endif
		memset(&gpon_password,0, sizeof(gpon_password));
		memcpy(gpon_password.password, strData, 10);
#if defined(CONFIG_RTK_L34_ENABLE)		
		rtk_rg_gpon_password_set(&gpon_password);
#else
		rtk_gpon_password_set(&gpon_password);
#endif
		if(!mib_set(MIB_GPON_PASSWD, strData))
		{
			strcpy(tmpBuf, "Save GPON Password Error");
			goto setErr;
		}

		strData = boaGetVar(wp, "fmgpon_sn", "");
		if ( strData[0] )
		{
			char specific_str[9] = {0};
			unsigned int  specific =0;

			//SN:format AAAABBBBBBBB
			//   AAAA: 4 characters string
			//   BBBBBBBB: 8 hex straing
			rtk_gpon_serialNumber_t SN;			
			memset(&SN, 0 ,sizeof(SN));
			memcpy(SN.vendor,strData,4);
			memcpy(specific_str,&strData[4],8);
	
			specific = (unsigned int) strtoll(specific_str,NULL,16); 
			SN.specific[0] = ( specific >>24 ) &0xFF; 
			SN.specific[1] = ( specific >>16 ) &0xFF; 
			SN.specific[2] = ( specific >>8 ) &0xFF; 
			SN.specific[3] = ( specific ) &0xFF; 
#if defined(CONFIG_RTK_L34_ENABLE)
			rtk_rg_gpon_serialNumber_set(&SN);
#else
			rtk_gpon_serialNumber_set(&SN);
#endif
			if(!mib_set(MIB_GPON_SN, strData))
			{
				strcpy(tmpBuf, "Save GPON Serial Number Error");
				goto setErr;
			}
			
#ifdef COMMIT_IMMEDIATELY
			Commit();
#endif
			//Active GPON again
			printf("GPON Activate again.\n");
#if defined(CONFIG_RTK_L34_ENABLE)
			rtk_rg_gpon_activate(RTK_GPONMAC_INIT_STATE_O1);
#else
			rtk_gpon_activate(RTK_GPONMAC_INIT_STATE_O1);
#endif

	
		}
		else
		{
			strcpy(tmpBuf, "Get GPON Serial Number Error");
			goto setErr;
		}
	}
	else
	{
		strcpy(tmpBuf, "Get GPON Password Error");
		goto setErr;
	}
	strData = boaGetVar(wp, "submit-url", "");

	OK_MSG(strData);
	return;

setErr:
	ERR_MSG(tmpBuf);
}
#endif
