/*

*  fmmenucreate_user.c is used to create menu

*  added by xl_yue

*/





#include <string.h>

#include <stdlib.h>

#include <unistd.h>

#include <sys/types.h>

#include <sys/wait.h>



#include "../webs.h"

#include "mib.h"

#include "webform.h"

#include "utility.h"



const char menuTitle_user[] = "Site contents:";


#ifdef CONFIG_DEFAULT_WEB	// default pages

/*

 *	Second Layer Menu

 */

#ifdef CONFIG_RTL_92D_SUPPORT
struct RootMenu childmenu_wlan0_user[] = {

	{"Basic Settings", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlbasic.asp&wlan_idx=0",	"Setup wireless basic configuration", 0, 0, MENU_DISPLAY},

	{"Advanced Settings", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wladvanced.asp&wlan_idx=0",   "Setup wireless advanced configuration", 0, 0, MENU_DISPLAY},

	{"Security", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlwpa.asp&wlan_idx=0", "Setup wireless security", 0, 0, MENU_DISPLAY},

#ifdef WLAN_ACL

	{"Access Control", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlactrl.asp&wlan_idx=0",	"Setup access control list for wireless clients", 0, 0, MENU_DISPLAY},

#endif

#ifdef WLAN_WDS

	{"WDS", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlwds.asp&wlan_idx=0", "WDS Settings", 0, 0, MENU_DISPLAY},

#endif

#ifdef WLAN_CLIENT

	{"Site Survey", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlsurvey.asp&wlan_idx=0", "Wireless Site Survey", 0, 0, MENU_DISPLAY},

#endif

#ifdef CONFIG_WIFI_SIMPLE_CONFIG	// WPS

	{"WPS", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlwps.asp&wlan_idx=0", "Wireless Protected Setup", 0, 0, MENU_DISPLAY},

#endif

	{"Status", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlstatus.asp&wlan_idx=0", "Wireless Current Status", 0, 0, MENU_DISPLAY},

	{0, 0, 0, 0, 0, 0, 0}

};

struct RootMenu childmenu_wlan1_user[] = {

	{"Basic Settings", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlbasic.asp&wlan_idx=1",	"Setup wireless basic configuration", 0, 0, MENU_DISPLAY},

	{"Advanced Settings", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wladvanced.asp&wlan_idx=1",   "Setup wireless advanced configuration", 0, 0, MENU_DISPLAY},

	{"Security", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlwpa.asp&wlan_idx=1", "Setup wireless security", 0, 0, MENU_DISPLAY},

#ifdef WLAN_ACL

	{"Access Control", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlactrl.asp&wlan_idx=1",	"Setup access control list for wireless clients", 0, 0, MENU_DISPLAY},

#endif

#ifdef WLAN_WDS

	{"WDS", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlwds.asp&wlan_idx=1", "WDS Settings", 0, 0, MENU_DISPLAY},

#endif

#ifdef WLAN_CLIENT

	{"Site Survey", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlsurvey.asp&wlan_idx=1", "Wireless Site Survey", 0, 0, MENU_DISPLAY},

#endif

#ifdef CONFIG_WIFI_SIMPLE_CONFIG	// WPS

	{"WPS", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlwps.asp&wlan_idx=1", "Wireless Protected Setup", 0, 0, MENU_DISPLAY},

#endif

	{"Status", MENU_URL, "../boaform/admin/formWlanRedirect?redirect-url=/admin/wlstatus.asp&wlan_idx=1", "Wireless Current Status", 0, 0, MENU_DISPLAY},

	{0, 0, 0, 0, 0, 0, 0}

};
#endif //CONFIG_RTL_92D_SUPPORT

/*

 *	First Layer Menu

 */

struct RootMenu childmenu_status_user[] = {
	{"Device", MENU_URL, "status.asp", "Device status", 0, 0, MENU_DISPLAY},
#ifdef CONFIG_IPV6
	{"IPv6", MENU_URL, "status_ipv6.asp", "IPv6 status", 0, 0, MENU_DISPLAY},
#endif
  {0, 0, 0, 0, 0, 0, 0}
};

struct RootMenu childmenu_wlan_user[] = {

#ifdef CONFIG_RTL_92D_SUPPORT

	  {"Band Mode", MENU_URL, "wlbandmode.asp",   "Setup wireless band mode", 0, 0, MENU_DISPLAY},

	  {"wlan0 (5GHz)", MENU_FOLDER, &childmenu_wlan0_user, "", sizeof (childmenu_wlan0_user) / sizeof (struct RootMenu) - 1, 0, MENU_DISPLAY},

#ifdef CONFIG_RTL_92D_DMDP

	  {"wlan1 (2.4GHz)", MENU_FOLDER, &childmenu_wlan1_user, "", sizeof (childmenu_wlan1_user) / sizeof (struct RootMenu) - 1, 0, MENU_DISPLAY},

#endif //CONFIG_RTL_92D_DMDP

#else //CONFIG_RTL_92D_SUPPORT

	{"Basic Settings", MENU_URL, "wlbasic.asp", "Setup wireless basic configuration", 0, 0, MENU_DISPLAY},

	{"Advanced Settings", MENU_URL, "wladvanced.asp", "Setup wireless advanced configuration", 0, 0, MENU_DISPLAY},

	{"Security", MENU_URL, "wlwpa.asp", "Setup wireless security", 0, 0, MENU_DISPLAY},

#ifdef WLAN_ACL

	{"Access Control", MENU_URL, "wlactrl.asp", "Setup access control list for wireless clients", 0, 0, MENU_DISPLAY},

#endif

#ifdef WLAN_WDS

	{"WDS", MENU_URL, "wlwds.asp", "WDS Settings", 0, 0, MENU_DISPLAY},

#endif

#ifdef WLAN_CLIENT

	{"Site Survey", MENU_URL, "wlsurvey.asp", "Wireless Site Survey", 0, 0, MENU_DISPLAY},

#endif

#ifdef CONFIG_WIFI_SIMPLE_CONFIG	// WPS

	{"WPS", MENU_URL, "wlwps.asp", "Wireless Protected Setup", 0, 0, MENU_DISPLAY},

#endif

	{"Status", MENU_URL, "wlstatus.asp", "Wireless Current Status", 0, 0, MENU_DISPLAY},

#endif //CONFIG_RTL_92D_SUPPORT

	{0, 0, 0, 0, 0, 0, 0}

};



struct RootMenu childmenu_wan_user[] = {

#ifdef CONFIG_ETHWAN
	{"EthWan Config", MENU_URL, "waneth.asp", "Setup Eth WAN", 0, 0, MENU_DISPLAY},
#endif
#ifdef CONFIG_PTMWAN
	{"PTM Wan Config", MENU_URL, "multi_wanptm.asp", "Setup PTM WAN", 0, 0, MENU_DISPLAY},
#endif /*CONFIG_PTMWAN*/
#ifdef CONFIG_RTL8672_SAR
	{
	#ifdef CONFIG_VDSL
	"ATM WAN Config",
	#else
	"Channel Config",
	#endif /*CONFIG_VDSL*/
	MENU_URL, "wanadsl.asp", "Setup Channel Mode", 0, 0, MENU_DISPLAY},
#endif

#ifdef CONFIG_USER_PPPOMODEM
	{"3G Settings", MENU_URL, "wan3gconf.asp", "Setup 3G WAN", 0, 0, MENU_DISPLAY},
#endif //CONFIG_USER_PPPOMODEM

	{0, 0, 0, 0, 0, 0, 0}

};



struct RootMenu childmenu_fw_user[] = {

#ifdef MAC_FILTER
#ifdef CONFIG_RTK_RG_INIT
	{"MAC Filtering", MENU_URL, "fw-macfilter_rg.asp", "Setup MAC filering", 0, 0, MENU_DISPLAY},
#else
	{"MAC Filtering", MENU_URL, "fw-macfilter.asp", "Setup MAC filering", 0, 0, MENU_DISPLAY},
#endif
#endif

	{0, 0, 0, 0, 0, 0, 0}

};



struct RootMenu childmenu_admin_user[] = {

	{"Commit/Reboot", MENU_URL, "reboot.asp", "Commit/reboot the system", 0, 0, MENU_DISPLAY},

#ifdef ACCOUNT_LOGIN_CONTROL

	{"Logout", MENU_URL, "/admin/adminlogout.asp", "Logout", 0, 0, MENU_DISPLAY},

#endif

	{"Password", MENU_URL, "/admin/user-password.asp", "Setup access password", 0, 0, MENU_DISPLAY},

#ifdef IP_ACL

	{"ACL Config", MENU_URL, "acl.asp", "ACL Setting", 0, 0, MENU_DISPLAY},

#endif

//added by xl_yue

#ifdef USE_LOGINWEB_OF_SERVER

	{"Logout", MENU_URL, "/admin/logout.asp", "Logout", 0, 0, MENU_DISPLAY},

#endif

	{0, 0, 0, 0, 0, 0, 0}

};



/*

 *	Root Menu

 */

struct RootMenu rootmenu_user[] = {

	{"Status", MENU_FOLDER, &childmenu_status_user, "", sizeof(childmenu_status_user) / sizeof(struct RootMenu) - 1, 0, MENU_DISPLAY},

#ifdef WLAN_SUPPORT

	{"Wireless", MENU_FOLDER, &childmenu_wlan_user, "", sizeof(childmenu_wlan_user) / sizeof(struct RootMenu) - 1, 0, MENU_DISPLAY},

#endif

	{"WAN", MENU_FOLDER, &childmenu_wan_user, "", sizeof(childmenu_wan_user) / sizeof(struct RootMenu) - 1, 0, MENU_DISPLAY},

	{"Firewall", MENU_FOLDER, &childmenu_fw_user, "", sizeof(childmenu_fw_user) / sizeof(struct RootMenu) - 1, 0, MENU_DISPLAY},

	{"Admin", MENU_FOLDER, &childmenu_admin_user, "", sizeof(childmenu_admin_user) / sizeof(struct RootMenu) - 1, 0, MENU_DISPLAY},

	{0, 0, 0, 0, 0, 0, 0}

};

#endif				// of CONFIG_DEFAULT_WEB


int createMenu_user(int eid, request * wp, int argc, char ** argv)
{
	int i = 0, totalIdNums = 0, maxchildrensize = 0;

	int IdIndex = 0;

	unsigned char isRootMenuEnd = 0;

#ifdef CONFIG_RTL_92D_SUPPORT

	wlanMenuUpdate(rootmenu);

	wlanMenuUpdate(rootmenu_user);

#endif //CONFIG_RTL_92D_SUPPORT


	//calc the id nums and the max children size

	totalIdNums = calcFolderNum(rootmenu_user, &maxchildrensize);

	//product the js code

	addMenuJavaScript(wp, totalIdNums, maxchildrensize);

	//create the header
/* add by yq_zhou 09.2.02 add sagem logo for 11n*/
#ifdef CONFIG_11N_SAGEM_WEB
  boaWrite (wp, "<body  onload=\"initIt()\" bgcolor=\"#FFFFFF\" >\n");
#else
  boaWrite (wp, "<body  onload=\"initIt()\" bgcolor=\"#000000\" >\n");
#endif
	boaWrite(wp, "<table width=100%% border=0 cellpadding=0 cellspacing=0>\n<tr><td  width=100%% align=left>\n");

	boaWrite(wp, "<table  border=0 cellpadding=0 cellspacing=0>\n" "<tr><td width=18 height=18><img src=menu-images/menu_root.gif width=18 height=18></td>\n" "<td  height=18 colspan=4 class=link><font size=3>%s</font></td></tr>\n </table>\n", menuTitle_user);



	if (rootmenu_user[1].u.addr)

		addMenu(wp, &rootmenu_user[0], 0, &IdIndex, 0);

	else

		addMenu(wp, &rootmenu_user[0], 0, &IdIndex, 1);



	boaWrite(wp, "</td></tr>\n</table>\n");


	return 0;
}
