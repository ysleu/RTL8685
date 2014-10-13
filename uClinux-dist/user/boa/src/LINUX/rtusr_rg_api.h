#include "options.h"
#include "mib.h"

#define UntagCPort 1
#define TagCPort 0

#define BridgeWan 0
#define RoutingWan 1

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef SUCCESS
#define SUCCESS 0
#endif

#ifndef FAIL
#define FAIL -1
#endif

//ccwei: for debug
#define NIP_QUAD(addr) \
	((unsigned char *)&addr)[0], \
	((unsigned char *)&addr)[1], \
	((unsigned char *)&addr)[2], \
	((unsigned char *)&addr)[3]
int RG_add_wan(MIB_CE_ATM_VC_Tp entry,int *wanIntfIdx,int rtk_rg_wan_type);
int RG_add_Dhcp_wan(MIB_CE_ATM_VC_Tp entry,int *wanIntfIdx);
int RG_add_PPPoE_wan(MIB_CE_ATM_VC_Tp entry);
int RG_add_ipoe(MIB_CE_ATM_VC_Tp entry);
int RG_add_bridge(MIB_CE_ATM_VC_Tp entry);
int Init_RG_API(int isUnTagCPort);

int SetRGDHCP(unsigned int ipaddr, unsigned int submsk, MIB_CE_ATM_VC_Tp entry,int wanIntfIdx);

int RG_Del_All_LAN_Interfaces();
int RG_WAN_Interface_Del(unsigned int);
int RG_WAN_Interface_Index_Add(unsigned int, int);

#ifdef MAC_FILTER
int AddRTK_RG_MAC_Filter(MIB_CE_MAC_FILTER_T *);
int RTK_RG_MAC_Filter_Default_Policy(int out_policy, int in_policy);
int FlushRTK_RG_MAC_Filters();
#endif
int AddRTK_RG_ACL_IPPort_Filter(MIB_CE_IP_PORT_FILTER_T *);
int RTK_RG_ACL_IPPort_Filter_Default_Policy(int out_policy, int in_policy);
int RTK_RG_ACL_IPPort_Filter_Allow_LAN_to_GW();
int FlushRTK_RG_ACL_Filters();
#ifdef CONFIG_IPV6
int AddRTK_RG_ACL_IPv6Port_Filter(MIB_CE_V6_IP_PORT_FILTER_T *, char * prefixIP);
int RTK_RG_ACL_IPv6Port_Filter_Default_Policy(int out_policy, int in_policy);
int FlushRTK_RG_ACL_IPv6Port_Filters();
#endif
int RTK_RG_DMZ_Set(int enabled, in_addr_t ip_addr);
#ifdef PORT_FORWARD_GENERAL
int RTK_RG_Vertual_Server_Set(MIB_CE_PORT_FW_T *pf);
#endif
#ifdef CONFIG_USER_IP_QOS_3
int RTK_RG_QoS_Queue_Set();
int RTK_RG_QoS_Rule_Set(MIB_CE_IP_QOS_Tp);
#endif
#ifdef CONFIG_USER_MINIUPNPD
int AddRTK_RG_UPnP_Connection(unsigned short, const char *, unsigned short, int);
int DelRTK_RG_UPnP_Connection(unsigned short, int);
#endif
#ifdef URL_BLOCKING_SUPPORT
int RTK_RG_URL_Filter_Set();
int Flush_RTK_RG_URL_Filter();
#endif
#if 0
int callbackRegistCheck(void);
#endif
int Init_rg_api(void);


