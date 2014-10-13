/*
 *      Web server handler routines for Ethernet-to-PVC mapping stuffs
 *
 */


/*-- System inlcude files --*/
#include <net/if.h>
#include <signal.h>
#ifdef EMBED
#include <linux/config.h>
#else
#include "../../../../include/linux/autoconf.h"
#endif

/*-- Local inlcude files --*/
#include "../webs.h"
#include "webform.h"
#include "mib.h"
#include "utility.h"
#include "options.h"

#ifdef __i386__
#define _LITTLE_ENDIAN_
#endif

// Mason Yu. combine_1p_4p_PortMapping
#if (defined( ITF_GROUP_1P) && defined(ITF_GROUP)) || (defined( ITF_GROUP_4P) && defined(ITF_GROUP))
void formItfGroup(request * wp, char *path, char *query)
{
	char	*str, *submitUrl;
	char tmpBuf[100];
	char vc_str[]="vc0";
	int group_num;
	unsigned char mode;
	// bitmap for virtual lan port function
	// Port Mapping: bit-0
	// QoS : bit-1
	// IGMP snooping: bit-2
	mib_get(MIB_MPMODE, (void *)&mode);
	str = boaGetVar(wp, "pmap", "");
	if ( str[0] == '1' )
		mode |= MP_PMAP_MASK;
	else
		mode &= ~MP_PMAP_MASK;
	mib_set(MIB_MPMODE, (void *)&mode);
	str = boaGetVar(wp, "select", "");
	if (str[0]) {
		group_num = str[1]-'0';
		str = boaGetVar(wp, "itfsGroup", "");
		if (str[0])
		{
			setgroup(str, group_num);
		}

		str = boaGetVar(wp, "itfsAvail", "");
		if (str[0])
		{
			setgroup(str, 0);
		}
	}
#if defined(APPLY_CHANGE)
	if(mode&MP_PMAP_MASK)
		setupEth2pvc();
	else {
		setupEth2pvc_disable();
	}
#endif

// Magician: Commit immediately
#ifdef COMMIT_IMMEDIATELY
	Commit();
#endif

	submitUrl = boaGetVar(wp, "submit-url", "");
	OK_MSG(submitUrl);
	return;
}

int ifGroupList(int eid, request * wp, int argc, char **argv)
{
	int nBytesSent=0;
	int i, ifnum, num;
	struct itfInfo itfs[MAX_NUM_OF_ITFS];
	char grpitf[512], grpval[128], availitf[512], availval[128];
	char *ptr;
	nBytesSent += boaWrite(wp, "<tr><font size=2>"
	"<td align=center bgcolor=\"#808080\">Select</td>\n"
	"<td align=center bgcolor=\"#808080\"><font size=2>Interfaces</td></font></tr>\n");
	// Show default group
	ifnum = get_group_ifinfo(itfs, MAX_NUM_OF_ITFS, 0);
	availitf[0]=availval[0]=0;
	if (ifnum>=1) {
		strncat( availitf, itfs[0].name, 64);
		snprintf( availval, 64, "%d", IF_ID(itfs[0].ifdomain, itfs[0].ifid));
		ptr = availval+strlen(availval);
		ifnum--;
		for (i=0; i<ifnum; i++) {
			strncat(availitf, ",", 64);
			strncat(availitf, itfs[i+1].name, 64);
			snprintf(ptr, 64, ",%d", IF_ID(itfs[i+1].ifdomain, itfs[i+1].ifid));
			ptr+=strlen(ptr);
		}
	}
	nBytesSent += boaWrite(wp, "<tr><font size=2>"
	"<td align=center bgcolor=\"#C0C0C0\">Default</td>\n"
	"<td align=center bgcolor=\"#C0C0C0\"><font size=2>%s</td></tr>\n", availitf);

	// Show the specified groups
	for (num=1; num<=4; num++)
	{
		ifnum = get_group_ifinfo(itfs, MAX_NUM_OF_ITFS, num);
		grpitf[0]=grpval[0]=0;
		if (ifnum>=1) {
			snprintf( grpitf, 256, "%s", itfs[0].name);
			snprintf( grpval, 64, "%d", IF_ID(itfs[0].ifdomain, itfs[0].ifid));
			ifnum--;
			for (i=0; i<ifnum; i++) {
				//jim: avoid overflow....
				snprintf( grpitf, 510, "%s,%s", grpitf, itfs[i+1].name);
				snprintf( grpval, 64, "%s,%d", grpval, IF_ID(itfs[i+1].ifdomain, itfs[i+1].ifid));
			}
		}
		nBytesSent += boaWrite(wp, "<tr>"
		"<td align=center bgcolor=\"#C0C0C0\"><font size=\"2\"><input type=\"radio\" name=\"select\""
		" value=\"s%d\" onClick=\"postit('%s','%s','%s','%s')\"</td>\n", num, grpitf, grpval, availitf, availval);
		nBytesSent += boaWrite(wp,
		"<td align=center bgcolor=\"#C0C0C0\"><font size=2>%s</td></tr>\n", grpitf);
	}

	return nBytesSent;
}
#endif

//xl_yue: translocate to fmmenucreate.c
int vportMenu(int eid, request * wp, int argc, char **argv)
{
	char *parm;

	if (boaArgs(argc, argv, "%s", &parm) < 1) {
		boaError(wp, 400, "Insufficient args\n");
		return -1;
	}

	if ( parm[0] == '1' ) {
		boaWrite(wp, ""
// Mason Yu. combine_1p_4p_PortMapping
#if (defined( ITF_GROUP_4P) && defined(ITF_GROUP)) || (defined( ITF_GROUP_1P) && defined(ITF_GROUP))
		"advance.addItem(\"Port Mapping\", \"eth2pvc.asp\", \"\", \"Assign Ethernet to PVC\");\n"
#endif
#ifdef IP_QOS
		"advance.addItem(\"IP QoS\", \"ipqos.asp\", \"\", \"IP QoS Configuration\");\n"
#elif defined(NEW_IP_QOS_SUPPORT)
		"advance.addItem(\"IP QoS\", \"ipqos_sc.asp\", \"\", \"IP QoS Configuration\");\n"
#endif
		);
	}
	else {
		boaWrite(wp, ""
// Mason Yu. combine_1p_4p_PortMapping
#if (defined( ITF_GROUP_4P) && defined(ITF_GROUP)) || (defined( ITF_GROUP_1P) && defined(ITF_GROUP))
		"<tr><td>&nbsp;&nbsp;<a href=\"eth2pvc.asp\" target=\"view\">Port Mapping</a></td></tr>\n"
#endif
#ifdef IP_QOS
		"<tr><td>&nbsp;&nbsp;<a href=\"ipqos.asp\" target=\"view\">IP QoS</a></td></tr>\n"
#elif defined(NEW_IP_QOS_SUPPORT)
		"<tr><td>&nbsp;&nbsp;<a href=\"ipqos_sc.asp\" target=\"view\">IP QoS</a></td></tr>\n"
#endif
		);
	}

	return 0;
}

