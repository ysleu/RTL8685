#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <memory.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <arpa/inet.h>
#include <rtk_rg_struct.h>
#include "rtusr_rg_api.h"
#include "mib.h"
#include "utility.h"

const char DHCPC_ROUTERFILE_B[] = "/var/udhcpc/router";
const char RG_LAN_INF_IDX[] = "/var/rg_lan_inf_idx";
const char RG_MAC_RULES_FILE[] = "/var/rg_mac_rules_idx";
const char RG_ACL_RULES_FILE[] = "/var/rg_acl_rules_idx";
const char RG_ACL_IPv6_RULES_FILE[] = "/var/rg_acl_ipv6_rules_idx";
const char RG_QOS_RULES_FILE[] = "/var/rg_acl_qos_idx";
const char RG_UPNP_CONNECTION_FILE[] = "/var/rg_upnp_idx";
const char RG_UPNP_TMP_FILE[] = "/var/rg_upnp_tmp";
const char RG_VERTUAL_SERVER_FILE[] = "/var/rg_vertual_servers_idx";
const char RG_URL_FILTER_FILE[] = "/var/rg_url_filter_idx";
const char MER_GWINFO_B[] = "/tmp/MERgw";
const char PPPoE_WANINTFINDX[] = "/tmp/rg_pppoe_wanIntfIdx";
const char RG_WAN_INF_IDX[] = "/var/rg_wan_inf_idx";
const char WAN_INTERFACE_TMP[] = "/var/wan_interface_tmp";

#define UntagCPort 1
#define TagCPort 0

#define MAX_VALUE(val1, val2) (val1>val2?val1:val2)
#define MIN_VALUE(val1, val2) (val1<val2?val1:val2)

#ifdef CONFIG_IPV6
	unsigned char empty_ipv6[IPV6_ADDR_LEN] = {0};
#endif

int Init_rg_api()
{
	int ret;
	unsigned char mbtd;
	rtk_rg_initParams_t init_param;

	bzero(&init_param, sizeof(rtk_rg_initParams_t));
	printf("init mac based tag des\n");

	mib_get(MIB_MAC_BASED_TAG_DECISION, (void *)&mbtd);
	init_param.macBasedTagDecision = mbtd;

#if defined(CONFIG_GPON_FEATURE)
	unsigned int pon_mode;

	if (mib_get(MIB_PON_MODE, (void *)&pon_mode) != 0)
	{
		if ( pon_mode == GPON_MODE )
		{
			init_param.wanPortGponMode = 1;
			printf("Init RG with GPON mode.\n");
		}
	}
#endif

#if defined(CONFIG_RTL_IGMP_SNOOPING)
	char igmp_mode;
	mib_get(MIB_MPMODE, (void *)&igmp_mode);
	if(igmp_mode & MP_IGMP_MASK)
		init_param.igmpSnoopingEnable = 1;
	else
		init_param.igmpSnoopingEnable = 0;

	if((ret = rtk_rg_initParam_set(&init_param)) != SUCCESS)
	{
		DBPRINT(1, "rtk_rg_initParam_set failed! ret=%d\n", ret);
		return -1;
	}
#else
	if((ret = rtk_rg_initParam_set(&init_param)) != SUCCESS)
	{
		DBPRINT(1, "rtk_rg_initParam_set failed! ret=%d\n", ret);
		return -1;
	}
#endif
	printf("=============Init_rg_api SUCESS!!==================\n");
	unlink(RG_LAN_INF_IDX);
	unlink(RG_WAN_INF_IDX);
	return SUCCESS;
}

#ifdef CONFIG_IPV6
int set_LAN_IPv6_IP()
{
	unsigned char value[6], ip_version=IPVER_V4V6, vchar, ipv6_addr[IPV6_ADDR_LEN], ipv6_prefix_len;
	struct ipv6_ifaddr ip6_addr[6];
	char ipv6addr_str[64], cur_ip6addr_str[64];

	mib_get(MIB_LAN_IP_VERSION1, (void *)&ip_version);
	if(ip_version == IPVER_V4V6 || ip_version == IPVER_V6ONLY)
	{
		mib_get(MIB_LAN_IPV6_MODE1, (void *)&vchar);
		if(vchar != 0) // IPv6 address mode is manual
		{
			mib_get(MIB_LAN_IPV6_ADDR1, (void *)ipv6_addr);
			mib_get(MIB_LAN_IPV6_PREFIX_LEN1, (void *)&ipv6_prefix_len);

			inet_ntop(PF_INET6, ipv6_addr, ipv6addr_str, sizeof(ipv6addr_str));
			sprintf(ipv6addr_str, "%s/%d", ipv6addr_str, ipv6_prefix_len);

			getifip6(LANIF, IPV6_ADDR_UNICAST, ip6_addr, 6);
			inet_ntop(PF_INET6, &ip6_addr[0].addr, cur_ip6addr_str, sizeof(cur_ip6addr_str));
			sprintf(cur_ip6addr_str, "%s/%d", cur_ip6addr_str, ip6_addr[0].prefix_len);

			va_cmd(IFCONFIG, 3, 1, LANIF, "del", cur_ip6addr_str);
			va_cmd(IFCONFIG, 3, 1, LANIF, "add", ipv6addr_str);
		}
	}
}
#endif

int Init_RG_ELan(int isUnTagCPort, int isRoutingWan)
{
	rtk_rg_lanIntfConf_t lan_info;
	int lanIntfIdx = -1;
#ifdef SECONDARY_IP
	int lanIntfIdx2 = -1;
#endif
	unsigned char value[6], ip_version=IPVER_V4V6, vchar, ipv6_addr[IPV6_ADDR_LEN], ipv6_prefix_len;
	int i;
	int wanPhyPort=0, vlan_id;
	unsigned int portMask = 0;
	struct ipv6_ifaddr ip6_addr[6];
	char ipv6addr_str[64], cur_ip6addr_str[64];
	FILE *fp;

#if 0
	Init_rg_api();
	DBPRINT(2, "Init_rg_api() on!\n");
#else
	DBPRINT(0, "Init_rg_api() off!!\n");
	RG_Del_All_LAN_Interfaces();
#endif
	memset(&lan_info,0,sizeof(lan_info));

	mib_get(MIB_LAN_IP_VERSION1, (void *)&ip_version);
	lan_info.ip_version=ip_version;

#ifdef CONFIG_IPV6
	if(ip_version == IPVER_V4V6 || ip_version == IPVER_V6ONLY)
	{
		mib_get(MIB_LAN_IPV6_MODE1, (void *)&vchar);
		if(vchar == 0) // IPv6 address mode is auto
		{
			getifip6(LANIF, IPV6_ADDR_UNICAST, ip6_addr, 6);
			memcpy(lan_info.ipv6_addr.ipv6_addr, &ip6_addr[0].addr, IPV6_ADDR_LEN);
			lan_info.ipv6_network_mask_length = ip6_addr[0].prefix_len;
		}
		else
		{
			mib_get(MIB_LAN_IPV6_ADDR1, (void *)ipv6_addr);
			mib_get(MIB_LAN_IPV6_PREFIX_LEN1, (void *)&ipv6_prefix_len);
			memcpy(lan_info.ipv6_addr.ipv6_addr, ipv6_addr, IPV6_ADDR_LEN);
			lan_info.ipv6_network_mask_length = ipv6_prefix_len;

			inet_ntop(PF_INET6, ipv6_addr, ipv6addr_str, sizeof(ipv6addr_str));
			sprintf(ipv6addr_str, "%s/%d", ipv6addr_str, ipv6_prefix_len);

			getifip6(LANIF, IPV6_ADDR_UNICAST, ip6_addr, 6);
			inet_ntop(PF_INET6, &ip6_addr[0].addr, cur_ip6addr_str, sizeof(cur_ip6addr_str));
			sprintf(cur_ip6addr_str, "%s/%d", cur_ip6addr_str, ip6_addr[0].prefix_len);

			va_cmd(IFCONFIG, 3, 1, LANIF, "del", cur_ip6addr_str);
			va_cmd(IFCONFIG, 3, 1, LANIF, "add", ipv6addr_str);
		}
	}
#endif

	if(ip_version == IPVER_V4V6 || ip_version == IPVER_V4ONLY)
	{
		if (mib_get(MIB_ADSL_LAN_IP, (void *)value) != 0)
		{
			lan_info.ip_addr=htonl((((struct in_addr *)value)->s_addr)); //192.168.1.1
		}
		if (mib_get(MIB_ADSL_LAN_SUBNET, (void *)value) != 0)
		{
			lan_info.ip_network_mask=htonl((((struct in_addr *)value)->s_addr));
		}
	}

	if (mib_get(MIB_ELAN_MAC_ADDR, (void *)value) != 0)
	{
		for(i =0;i<6;i++)
			lan_info.gmac.octet[i]=value[i];
	}

	if(mib_get(MIB_WAN_PHY_PORT , (void *)&wanPhyPort) == 0){
		printf("get MIB_WAN_PHY_PORT failed!!!\n");
		wanPhyPort=RTK_RG_MAC_PORT3 ; //for 0371 default
	}

	if(mib_get(MIB_LAN_VLAN_ID1, (void *)&vlan_id) != 0)
		lan_info.intf_vlan_id = vlan_id;

	lan_info.mtu=1500;

	mib_get(MIB_LAN_PORT_MASK1, (void *)&portMask);
	//portMask = ((1<<RTK_RG_MAC_PORT0)|(1<<RTK_RG_MAC_PORT1)|(1<<RTK_RG_MAC_PORT2)|(1<<RTK_RG_MAC_PORT3));
	if(isRoutingWan){
		portMask &= (~(1<<wanPhyPort));
	}
	#if 0
	lan_info.port_mask.portmask=((1<<RTK_RG_PORT0)|(1<<RTK_RG_PORT1)|(1<<RTK_RG_PORT2)|(1<<RTK_RG_PORT3));
	lan_info.untag_mask.portmask=((1<<RTK_RG_MAC_PORT0)|(1<<RTK_RG_MAC_PORT1)|(1<<RTK_RG_MAC_PORT2));
	#endif
	lan_info.port_mask.portmask=portMask|(1<<RTK_RG_EXT_PORT0)|(1<<RTK_RG_EXT_PORT1)|(1<<RTK_RG_EXT_PORT2)|(1<<RTK_RG_EXT_PORT3)|(1<<RTK_RG_EXT_PORT4);
	lan_info.untag_mask.portmask = portMask;

	if(isUnTagCPort)
		lan_info.untag_mask.portmask|=(1<<RTK_RG_MAC_PORT_CPU);

	if((rtk_rg_lanInterface_add(&lan_info,&lanIntfIdx))!=SUCCESS)
	{
		DBPRINT(1, "Add LAN interface 1 failed!\n");
		return -1;
	}

#ifdef SECONDARY_IP
	mib_get(MIB_ADSL_LAN_ENABLE_IP2, (void *)value);

	if (value[0] == 1)
	{
		ip_version = IPVER_V4V6;
		mib_get(MIB_LAN_IP_VERSION2, (void *)&ip_version);
		lan_info.ip_version = ip_version;

		if(ip_version == IPVER_V4V6 || ip_version == IPVER_V4ONLY)
		{
			if (mib_get(MIB_ADSL_LAN_IP2, (void *)value) != 0)
				lan_info.ip_addr=htonl((((struct in_addr *)value)->s_addr));

			if (mib_get(MIB_ADSL_LAN_SUBNET2, (void *)value) != 0)
				lan_info.ip_network_mask=htonl((((struct in_addr *)value)->s_addr));
		}

		if(mib_get(MIB_LAN_VLAN_ID2, (void *)&vlan_id) != 0)
			lan_info.intf_vlan_id = vlan_id;

		if(mib_get(MIB_LAN_PORT_MASK2, (void *)&portMask)!=0)
		{
			if(isRoutingWan)
				portMask &= (~(1<<wanPhyPort));

			lan_info.port_mask.portmask=portMask|(1<<RTK_RG_EXT_PORT0)|(1<<RTK_RG_EXT_PORT1)|(1<<RTK_RG_EXT_PORT2)|(1<<RTK_RG_EXT_PORT3)|(1<<RTK_RG_EXT_PORT4);
			lan_info.untag_mask.portmask = portMask;

			if(isUnTagCPort)
				lan_info.untag_mask.portmask|=(1<<RTK_RG_MAC_PORT_CPU);
		}

#ifdef CONFIG_IPV6
		if(ip_version == IPVER_V4V6 || ip_version == IPVER_V6ONLY)
		{
			mib_get(MIB_LAN_IPV6_MODE2, (void *)&vchar);
			if(vchar == 0) // IPv6 address mode is auto
			{
				getifip6(LAN_ALIAS, IPV6_ADDR_UNICAST, ip6_addr, 6);
				memcpy(lan_info.ipv6_addr.ipv6_addr, &ip6_addr[0].addr, IPV6_ADDR_LEN);
				lan_info.ipv6_network_mask_length = ip6_addr[0].prefix_len;
			}
			else
			{
				mib_get(MIB_LAN_IPV6_ADDR2, (void *)ipv6_addr);
				mib_get(MIB_LAN_IPV6_PREFIX_LEN2, (void *)&ipv6_prefix_len);
				memcpy(lan_info.ipv6_addr.ipv6_addr, ipv6_addr, IPV6_ADDR_LEN);
				lan_info.ipv6_network_mask_length = ipv6_prefix_len;

				inet_ntop(PF_INET6, ipv6_addr, ipv6addr_str, sizeof(ipv6addr_str));
				sprintf(ipv6addr_str, "%s/%d", ipv6addr_str, ipv6_prefix_len);

				getifip6(LAN_ALIAS, IPV6_ADDR_UNICAST, ip6_addr, 6);
				inet_ntop(PF_INET6, &ip6_addr[0].addr, cur_ip6addr_str, sizeof(cur_ip6addr_str));
				sprintf(cur_ip6addr_str, "%s/%d", cur_ip6addr_str, ip6_addr[0].prefix_len);

				va_cmd(IFCONFIG, 3, 1, LAN_ALIAS, "del", cur_ip6addr_str);
				va_cmd(IFCONFIG, 3, 1, LAN_ALIAS, "add", ipv6addr_str);
			}
		}
#endif

		if((rtk_rg_lanInterface_add(&lan_info,&lanIntfIdx2))!=SUCCESS)
		{
			DBPRINT(1, "Add LAN interface 2 failed!\n");
			return -1;
		}
	}
#endif

	if(fp = fopen(RG_LAN_INF_IDX, "w"))
	{
		fprintf(fp, "%d\n", lanIntfIdx);
		DBPRINT(0, "LAN interface index=%d\n", lanIntfIdx);
#ifdef SECONDARY_IP
		if(lanIntfIdx2 != -1)
		{
			fprintf(fp, "%d\n", lanIntfIdx2);
			DBPRINT(0, "LAN interface2 index=%d\n", lanIntfIdx2);
		}
#endif
		fclose(fp);
	}
	else
		fprintf(stderr, "Open %s failed! %s\n", RG_LAN_INF_IDX, strerror(errno));

	return SUCCESS;
}
int RG_add_bridge(MIB_CE_ATM_VC_Tp entry)
{
	int wanIntfIdx;
	if(RG_add_wan(entry,&wanIntfIdx,RTK_RG_BRIDGE)!=SUCCESS)
		return -1;
	return SUCCESS;
}
int RG_add_Dhcp_wan(MIB_CE_ATM_VC_Tp entry,int *wanIntfIdx)
{
	return RG_add_wan(entry,wanIntfIdx,RTK_RG_DHCP);
}
int RG_add_PPPoE_wan(MIB_CE_ATM_VC_Tp entry)
{
	int wanIntfIdx;
	FILE *fp;

	if(RG_add_wan(entry,&wanIntfIdx,RTK_RG_PPPoE)!=SUCCESS)
		return -1;

	fp = fopen(PPPoE_WANINTFINDX, "w");
	fprintf(fp, "%d\n", wanIntfIdx);
	fclose(fp);
	return SUCCESS;
}

int RG_add_wan(MIB_CE_ATM_VC_Tp entry,int *wanIntfIdx,int rtk_rg_wan_type)
{
	//int wanIntfIdx;
	int vcTotal, i, vlan_id;
	char intf_name[10];
	rtk_rg_wanIntfConf_t wan_info;
	unsigned char value[6];
	int ret=-1;
	int wanPhyPort=0;
	struct in_addr gw_addr;
	//Init_RG_ELan(UntagCPort, RoutingWan);

	memset(&wan_info,0,sizeof(wan_info));
	#if 0
	if (mib_get(MIB_ELAN_MAC_ADDR, (void *)value) != 0)
	{
		for(i =0;i<MAC_ADDR_LEN;i++)
		{
			if(i==MAC_ADDR_LEN-1)
			{
				wan_info.gmac.octet[i]=value[i]+ETH_INDEX(entry->ifIndex)+1;
			}else{
				wan_info.gmac.octet[i]=value[i];
			}
		}
	}
	#else
	memcpy(wan_info.gmac.octet, entry->MacAddr, MAC_ADDR_LEN);
	#endif

	if(mib_get(MIB_WAN_PHY_PORT , (void *)&wanPhyPort) == 0){
		printf("get MIB_WAN_PHY_PORT failed!!!\n");
		wanPhyPort=RTK_RG_MAC_PORT3 ; //for 0371 default
	}

	//wan_info.egress_vlan_id=8;
	//wan_info.vlan_based_pri=0;
	//wan_info.egress_vlan_tag_on=0;
	if (entry->vlan) {
		wan_info.egress_vlan_tag_on=1;
		wan_info.egress_vlan_id=entry->vid;
	}
	else{
		wan_info.egress_vlan_tag_on=0;
		wan_info.egress_vlan_id=8;

		if(rtk_rg_wan_type == RTK_RG_BRIDGE)
		{
			mib_get(MIB_LAN_VLAN_ID1, (void *)&vlan_id);
			wan_info.egress_vlan_id = vlan_id;
		}
	}

	if(entry->vprio)
	{
		wan_info.vlan_based_pri_enable=RTK_RG_ENABLED;
		wan_info.vlan_based_pri=(entry->vprio)-1;
	}
	else
	{
		wan_info.vlan_based_pri_enable=RTK_RG_DISABLED;
		wan_info.vlan_based_pri=-1;
	}

	wan_info.port_binding_mask.portmask = (entry->itfGroup & (1 << PMAP_ETH0_SW0)? 1 << RTK_RG_PORT0: 0) |
		(entry->itfGroup & (1 << PMAP_ETH0_SW1)? 1 << RTK_RG_PORT1: 0) |
		(entry->itfGroup & (1 << PMAP_ETH0_SW2)? 1 << RTK_RG_PORT2: 0) |
		(entry->itfGroup & (1 << PMAP_ETH0_SW3)? 1 << RTK_RG_PORT3: 0) |
		(entry->itfGroup & (1 << PMAP_WLAN0)? 1 << RTK_RG_EXT_PORT0: 0) |
		(entry->itfGroup & (1 << PMAP_WLAN0+1)? 1 << RTK_RG_EXT_PORT1: 0);

	wan_info.wan_port_idx=wanPhyPort;
	wan_info.wan_type=rtk_rg_wan_type;

#if 0//defined(CONFIG_GPON_FEATURE)
	unsigned int pon_mode;

	if (mib_get(MIB_PON_MODE, (void *)&pon_mode) != 0)
	{
		if ( pon_mode == GPON_MODE )
		{
			wan_info.gponStreamID = entry->sid;
			printf("GPON StreamID : %d.\n",wan_info.gponStreamID);
		}
	}
#endif

	if((rtk_rg_wanInterface_add(&wan_info, wanIntfIdx))!=SUCCESS)
		return -1;

	entry->rg_wan_idx = *wanIntfIdx;

	RG_WAN_Interface_Index_Add(entry->ifIndex, *wanIntfIdx);

	return SUCCESS;
}

int RG_add_ipoe(MIB_CE_ATM_VC_Tp entry)
{
	rtk_rg_ipStaticInfo_t staticInfo;
	int wanPhyPort;
	int wanIntfIdx;

	if(RG_add_wan(entry,&wanIntfIdx,RTK_RG_STATIC)!=SUCCESS)
		return -1;

	memset(&staticInfo, 0, sizeof(staticInfo));
	staticInfo.ipv4_default_gateway_on=entry->dgw;
	staticInfo.gw_mac_auto_learn_for_ipv4=1;
	staticInfo.gateway_ipv4_addr=(((struct in_addr *)entry->remoteIpAddr)->s_addr);
	staticInfo.ip_addr=(((struct in_addr *)entry->ipAddr)->s_addr);
	staticInfo.ip_network_mask=(((struct in_addr *)entry->netMask)->s_addr);
	staticInfo.mtu=1500;
	if(entry->napt==1){
		staticInfo.napt_enable=1;
	}
	else{
		staticInfo.napt_enable=0;
	}

#ifdef CONFIG_IPV6
	if((entry->IpProtocol & IPv6) && (entry->AddrMode & 2))
	{
		if(memcmp(entry->Ipv6Addr, empty_ipv6, IPV6_ADDR_LEN) != 0)
		{
			staticInfo.ip_version = entry->IpProtocol & IPv4? IPVER_V4V6: IPVER_V6ONLY;
			memcpy(staticInfo.ipv6_addr.ipv6_addr, entry->Ipv6Addr, IPV6_ADDR_LEN);
			staticInfo.ipv6_mask_length = entry->Ipv6AddrPrefixLen;
			staticInfo.ipv6_default_gateway_on = 1;
			memcpy(staticInfo.gateway_ipv6_addr.ipv6_addr, entry->RemoteIpv6Addr, IPV6_ADDR_LEN);
			staticInfo.gw_mac_auto_learn_for_ipv6 = 1;
		}
	}
#endif

	if((rtk_rg_staticInfo_set(wanIntfIdx, &staticInfo))!=SUCCESS)
		return -1;

	return SUCCESS;

}


#ifdef DBG_DHCP
#define DBG_DHCP_PRF(format, args...) printf(format, ##args)
#else
#define DBG_DHCP_PRF(format, args...)
#endif

int SetRGDHCP(unsigned int ipaddr, unsigned int submsk, MIB_CE_ATM_VC_Tp entry,int wanIntfIdx)
{
	rtk_rg_ipDhcpClientInfo_t dhcpClient_info;
	FILE *fp;
	struct in_addr gw_addr;
	char intf_name[10];

	memset(&dhcpClient_info,0,sizeof(dhcpClient_info));

	ifGetName(entry->ifIndex, intf_name, sizeof(intf_name));
	DBG_DHCP_PRF("%s-%d : entry.ifIndex:%d intf_name:%s\n", __func__,__LINE__,entry->ifIndex, intf_name);
	DBG_DHCP_PRF("%s-%d : entry.ipDhcp:%d \n", __func__,__LINE__,entry->ipDhcp);
	DBG_DHCP_PRF("%s-%d : entry.ipAddr:%x.%x.%x.%x \n", __func__,__LINE__,entry->ipAddr[0],entry->ipAddr[1]
	,entry->ipAddr[2], entry->ipAddr[3]);
	DBG_DHCP_PRF("%s-%d : entry.netMask:%x.%x.%x.%x \n", __func__,__LINE__,entry->netMask[0],entry->netMask[1]
	,entry->netMask[2], entry->netMask[3]);
	if(entry->ipDhcp == 1)
	{
		char gwip[20];
		char buffer[50];
		sprintf(buffer, "%s.%s", MER_GWINFO_B, intf_name);
		if(!(fp = fopen(buffer, "r")))
			return -1;
			fscanf(fp, "%s", gwip);
			DBG_DHCP_PRF("%s-%d : gwip:%s \n", __func__,__LINE__,gwip);
			if(!inet_aton(gwip,&gw_addr)){
				printf("get gw_addr fail!\n");
			}
			DBG_DHCP_PRF("%s-%d: gw_addr:(%u.%u.%u.%u)\n",__func__,__LINE__,NIP_QUAD(gw_addr.s_addr));
			fclose(fp);
		}
	dhcpClient_info.hw_info.ipv4_default_gateway_on=entry->dgw;
	dhcpClient_info.hw_info.gw_mac_auto_learn_for_ipv4=1;
	dhcpClient_info.hw_info.ip_addr=ipaddr;
DBG_DHCP_PRF("%s-%d: ip_addr:(%u.%u.%u.%u)\n",__func__,__LINE__,NIP_QUAD(dhcpClient_info.hw_info.ip_addr));
	dhcpClient_info.hw_info.ip_network_mask=submsk;
	dhcpClient_info.hw_info.mtu=1500;
	if(entry->napt==1){
		dhcpClient_info.hw_info.napt_enable=1;
	}else{
		dhcpClient_info.hw_info.napt_enable=0;
	}
	dhcpClient_info.hw_info.gateway_ipv4_addr = gw_addr.s_addr;
DBG_DHCP_PRF("%s-%d: gateway_ip_addr:(%u.%u.%u.%u)\n",__func__,__LINE__,NIP_QUAD(dhcpClient_info.hw_info.gateway_ipv4_addr));
DBG_DHCP_PRF("%s-%d: ip_network_mask:(%u.%u.%u.%u)\n",__func__,__LINE__,NIP_QUAD(dhcpClient_info.hw_info.ip_network_mask));
	dhcpClient_info.stauts=0;

#ifdef CONFIG_IPV6
	if((entry->IpProtocol & IPv6) && (entry->AddrMode & 2))
	{
		if(memcmp(entry->Ipv6Addr, empty_ipv6, IPV6_ADDR_LEN) != 0)
		{
			dhcpClient_info.hw_info.ip_version = entry->IpProtocol & IPv4? IPVER_V4V6: IPVER_V6ONLY;
			memcpy(dhcpClient_info.hw_info.ipv6_addr.ipv6_addr, entry->Ipv6Addr, IPV6_ADDR_LEN);
			dhcpClient_info.hw_info.ipv6_mask_length = entry->Ipv6AddrPrefixLen;
			dhcpClient_info.hw_info.ipv6_default_gateway_on = 1;
			memcpy(dhcpClient_info.hw_info.gateway_ipv6_addr.ipv6_addr, entry->RemoteIpv6Addr, IPV6_ADDR_LEN);
			dhcpClient_info.hw_info.gw_mac_auto_learn_for_ipv6 = 1;
		}
	}
#endif

	if(rtk_rg_dhcpClientInfo_set(wanIntfIdx,&dhcpClient_info)!=SUCCESS)
	{
		printf("rtk_rg_dhcpClientInfo_set error!!!\n");
		return -1;
	}
	DBG_DHCP_PRF("%s-%d:\n",__func__,__LINE__);

	return SUCCESS;
}

int RG_set_session_id(unsigned short session_id, MIB_CE_ATM_VC_T *entry){
	rtk_rg_wanIntfConf_t wan_info;
	rtk_rg_pppoeClientInfoBeforeDial_t pppoeClientInfoB;
	rtk_rg_pppoeClientInfoAfterDial_t pppoeClientInfoA;
	int wanIntfIdx;
	unsigned char value[6];
	int i;
	int wanPhyPort=0;
	FILE *fp;
	if(!(fp = fopen(PPPoE_WANINTFINDX, "r")))
		return -1;
	fscanf(fp, "%d\n", &wanIntfIdx);
	fclose(fp);

	memset(&pppoeClientInfoB, 0, sizeof(pppoeClientInfoB));
	memset(&pppoeClientInfoA, 0, sizeof(pppoeClientInfoA));
	if((rtk_rg_pppoeClientInfoBeforeDial_set(wanIntfIdx, &pppoeClientInfoB)) != SUCCESS){
		return -1;
	}
	pppoeClientInfoA.hw_info.napt_enable = 1;
	pppoeClientInfoA.hw_info.ip_addr = 0xaacc;
	pppoeClientInfoA.hw_info.ip_network_mask = 0xffffffff;
	pppoeClientInfoA.hw_info.mtu = 1492;
	pppoeClientInfoA.sessionId = session_id;

	if((rtk_rg_pppoeClientInfoAfterDial_set(wanIntfIdx, &pppoeClientInfoA)) != SUCCESS){
		return -1;
	}
}

int RG_add_pppoe(unsigned short session_id, unsigned long gw_ip, unsigned long my_ip, unsigned char* gw_mac, MIB_CE_ATM_VC_T *vcEntry){
	rtk_rg_wanIntfConf_t wan_info;
	rtk_rg_pppoeClientInfoBeforeDial_t pppoeClientInfoB;
	rtk_rg_pppoeClientInfoAfterDial_t pppoeClientInfoA;
	int wanIntfIdx;
	unsigned char value[6];
	int i;
	int wanPhyPort=0;
	FILE *fp;
	if(!(fp = fopen(PPPoE_WANINTFINDX, "r")))
		return -1;
	fscanf(fp, "%d\n", &wanIntfIdx);
	fclose(fp);

	memset(&pppoeClientInfoB, 0, sizeof(pppoeClientInfoB));
	memset(&pppoeClientInfoA, 0, sizeof(pppoeClientInfoA));
	if((rtk_rg_pppoeClientInfoBeforeDial_set(wanIntfIdx, &pppoeClientInfoB)) != SUCCESS){
		return -1;
	}

	pppoeClientInfoA.hw_info.napt_enable = 1;
	pppoeClientInfoA.hw_info.ip_addr = my_ip;
	pppoeClientInfoA.hw_info.ip_network_mask = 0xffffffff;
	pppoeClientInfoA.hw_info.ipv4_default_gateway_on = vcEntry->dgw;
	pppoeClientInfoA.hw_info.gateway_ipv4_addr = gw_ip;
	pppoeClientInfoA.hw_info.mtu = 1492;
	pppoeClientInfoA.sessionId = session_id;
	pppoeClientInfoA.hw_info.gw_mac_auto_learn_for_ipv4 = 0;
	memcpy(&(pppoeClientInfoA.hw_info.gateway_mac_addr_for_ipv4), gw_mac, 6);

#ifdef CONFIG_IPV6
	if((vcEntry->IpProtocol & IPv6) && (vcEntry->AddrMode & 2))
	{
		if(memcmp(vcEntry->Ipv6Addr, empty_ipv6, IPV6_ADDR_LEN) != 0)
		{
			pppoeClientInfoA.hw_info.ip_version = vcEntry->IpProtocol & IPv4? IPVER_V4V6: IPVER_V6ONLY;
			memcpy(pppoeClientInfoA.hw_info.ipv6_addr.ipv6_addr, vcEntry->Ipv6Addr, IPV6_ADDR_LEN);
			pppoeClientInfoA.hw_info.ipv6_mask_length = vcEntry->Ipv6AddrPrefixLen;
			pppoeClientInfoA.hw_info.ipv6_default_gateway_on = 1;
			memcpy(pppoeClientInfoA.hw_info.gateway_ipv6_addr.ipv6_addr, vcEntry->RemoteIpv6Addr, IPV6_ADDR_LEN);
			pppoeClientInfoA.hw_info.gw_mac_auto_learn_for_ipv6 = 1;
		}
	}
#endif

	if((rtk_rg_pppoeClientInfoAfterDial_set(wanIntfIdx, &pppoeClientInfoA)) != SUCCESS){
		return -1;
	}
}

int RG_Del_All_LAN_Interfaces()
{
	FILE *fp;
	int lanIdx;

	if(!(fp = fopen(RG_LAN_INF_IDX, "r")))
		return -2;

	while(fscanf(fp, "%d\n", &lanIdx) != EOF)
	{
		if(rtk_rg_interface_del(lanIdx))
			DBPRINT(1, "RG_Del_All_LAN_Interfaces failed! (idx = %d)\n", lanIdx);
	}

	fclose(fp);
	unlink(RG_LAN_INF_IDX);
	return 0;
}

int RG_WAN_Interface_Del(unsigned int ifindex)
{
	FILE *fp, *fp_tmp;
	unsigned int store_ifidx;
	char line[81];
	int store_idx;

	if(!(fp = fopen(RG_WAN_INF_IDX, "r")))
		return -2;

	if(!(fp_tmp = fopen(WAN_INTERFACE_TMP, "w")))
		return -2;

	while(fgets(line, 80, fp) != NULL)
	{
		sscanf(line, "%x %d\n", &store_ifidx, &store_idx);

		if(store_ifidx == ifindex)
		{
			if(rtk_rg_interface_del(store_idx))
				DBPRINT(1, "%s failed! (idx = %d)\n", __func__, store_idx);
		}
		else
			fprintf(fp_tmp, "%x %d\n", store_ifidx, store_idx);
	}

	fclose(fp);
	fclose(fp_tmp);
	unlink(RG_WAN_INF_IDX);
	rename(WAN_INTERFACE_TMP, RG_WAN_INF_IDX);
}

int RG_WAN_Interface_Index_Add(unsigned int ifindex, int idx)
{
	FILE *fp;

	if(!(fp = fopen(RG_WAN_INF_IDX, "a")))
		return -2;

	fprintf(fp, "%x %d\n", ifindex, idx);
	fclose(fp);
	return 0;
}

#ifdef MAC_FILTER
int AddRTK_RG_MAC_Filter(MIB_CE_MAC_FILTER_T *MacEntry)
{
	int macfilterIdx;
	rtk_rg_macFilterEntry_t macFilterEntry;
	FILE *fp;

	memset(&macFilterEntry, 0, sizeof(rtk_rg_macFilterEntry_t));
	memcpy(&macFilterEntry.mac, MacEntry->srcMac, MAC_ADDR_LEN);
	macFilterEntry.direct = MacEntry->dir;

	if(!(fp = fopen(RG_MAC_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -1;
	}

	if(rtk_rg_macFilter_add(&macFilterEntry, &macfilterIdx) == 0)
		fprintf(fp, "%d\n", macfilterIdx);
	else
		printf("Set rtk_rg_macFilter_add failed! dir = %d\n", MacEntry->dir? MacEntry->dir == 1? "Source": "Destination": "Both");

	fclose(fp);
	return 0;
#if 0
	rtk_rg_aclFilterAndQos_t aclRule;
	rtk_rg_intfInfo_t infinfo;
	int aclIdx, i;
	FILE *fp;

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));

	if (MacEntry->action == 0)
		aclRule.action_type = ACL_ACTION_TYPE_DROP;
	else if (MacEntry->action == 1)
		aclRule.action_type = ACL_ACTION_TYPE_PERMIT;
	else
	{
		fprintf(stderr, "Wrong mac filter action!\n");
		return -1;
	}

	if (memcmp(MacEntry->srcMac, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LEN))  // src mac is not empty.
	{
		aclRule.filter_fields |= INGRESS_SMAC_BIT;
		memcpy(&aclRule.ingress_smac, MacEntry->srcMac, MAC_ADDR_LEN);
	}

	if(memcmp(MacEntry->dstMac, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LEN))  // dst mac is not empty.
	{
		aclRule.filter_fields |= INGRESS_DMAC_BIT;
		memcpy(&aclRule.ingress_dmac, MacEntry->dstMac, MAC_ADDR_LEN);
	}

	if(!(fp = fopen(ACL_MAC_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -1;
	}

	for( i = 0; i < MAX_NETIF_SW_TABLE_SIZE; i++ )
	{
		if(rtk_rg_intfInfo_find(&infinfo, &i))
			break;

		if(infinfo.is_wan && infinfo.wan_intf.wan_intf_conf.wan_type == RTK_RG_BRIDGE)
		{
			if(MacEntry->dir == DIR_OUT)
			{
				aclRule.filter_fields |= EGRESS_INTF_BIT;
				aclRule.egress_intf_idx = i;  // Set egress interface to WAN.
			}
			else if(MacEntry->dir == DIR_IN)
			{
				aclRule.filter_fields |= INGRESS_INTF_BIT;
				aclRule.ingress_intf_idx = i;  // Set ingress interface to WAN.
			}
			else
			{
				DBPRINT(1, "Invalid MAC filtering direction!\n");
				return -1;
			}

			if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
				fprintf(fp, "%d\n", aclIdx);
			else
				printf("Set rtk_rg_aclFilterAndQos_add failed! dir = %s\n", MacEntry->dir? "Incoming": "Outgoing");
		}
	}

	fclose(fp);
#endif
}

int RTK_RG_MAC_Filter_Default_Policy(int out_policy, int in_policy)
{
	rtk_rg_aclFilterAndQos_t aclRule;
	rtk_rg_intfInfo_t infinfo;
	int aclIdx, i;
	FILE *fp;

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));

	if(!(fp = fopen(RG_MAC_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -1;
	}

	if( out_policy == 0 || in_policy == 0 )
	{
		aclRule.action_type = ACL_ACTION_TYPE_DROP;

		for( i = 0; i < MAX_NETIF_SW_TABLE_SIZE; i++ )
		{
			int j = i;
			memset(&infinfo, 0, sizeof(rtk_rg_intfInfo_t));
			if(rtk_rg_intfInfo_find(&infinfo, &i))
				break;

			DBPRINT(0, "i=%d; j=%d; is_wan=%d; intf_name=%s\n", i, j, infinfo.is_wan, infinfo.intf_name);
			if(infinfo.is_wan && infinfo.wan_intf.wan_intf_conf.wan_type == RTK_RG_BRIDGE)
			{
				int ret;

				if(out_policy == 0)
				{
					aclRule.filter_fields = EGRESS_INTF_BIT;
					aclRule.egress_intf_idx = i;  // Set egress interface to WAN.
				}
				else if(in_policy == 0)
				{
					aclRule.filter_fields = INGRESS_INTF_BIT;
					aclRule.ingress_intf_idx = i;  // Set ingress interface to WAN.
				}

				ret = rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx);

				if(ret == 0)
					fprintf(fp, "%d\n", aclIdx);
				else
				{
					printf("<%s>: Set rtk_rg_aclFilterAndQos_add failed! fault code = %d (out policy=%d, in policy=%d)\n", __func__, ret, out_policy, in_policy);
					continue;
				}
			}
		}
	}

	fclose(fp);
}

int FlushRTK_RG_MAC_Filters()
{
	FILE *fp;
	int mac_idx;

	if(!(fp = fopen(RG_MAC_RULES_FILE, "r")))
		return -2;

	while(fscanf(fp, "%d\n", &mac_idx) != EOF)
	{
		if(rtk_rg_macFilter_del(mac_idx))
			DBPRINT(1, "rtk_rg_macFilter_del failed! idx = %d\n", mac_idx);
	}

	fclose(fp);
	unlink(RG_MAC_RULES_FILE);
	return 0;
}
#endif // MAC_FILTER

int AddRTK_RG_ACL_IPPort_Filter(MIB_CE_IP_PORT_FILTER_T *ipEntry)
{
	rtk_rg_aclFilterAndQos_t aclRule;
	rtk_rg_intfInfo_t infinfo;
	int aclIdx, i;
	ipaddr_t mask;
	FILE *fp;

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));
	aclRule.filter_fields |= INGRESS_PORT_BIT;
	aclRule.ingress_port_mask.portmask = 0x7f; // All physical ports.

	if (ipEntry->action == 0)
		aclRule.action_type = ACL_ACTION_TYPE_DROP;
	else if (ipEntry->action == 1)
		aclRule.action_type = ACL_ACTION_TYPE_PERMIT;
	else
	{
		fprintf(stderr, "Wrong IP/Port filter action!\n");
		return -1;
	}

	// Source port
	if (ipEntry->srcPortFrom != 0)
	{
		aclRule.filter_fields |= INGRESS_L4_SPORT_RANGE_BIT;
		if (ipEntry->srcPortFrom == ipEntry->srcPortTo)
		{
			aclRule.ingress_src_l4_port_start = aclRule.ingress_src_l4_port_end = ipEntry->srcPortFrom;
		}
		else
		{
			aclRule.ingress_src_l4_port_start = ipEntry->srcPortFrom;
			aclRule.ingress_src_l4_port_end = ipEntry->srcPortTo;
		}
	}

	// Destination port
	if(ipEntry->dstPortFrom != 0)
	{
		aclRule.filter_fields |= INGRESS_L4_DPORT_RANGE_BIT;
		if(ipEntry->dstPortFrom == ipEntry->dstPortTo)
		{
			aclRule.ingress_dest_l4_port_start = aclRule.ingress_dest_l4_port_end = ipEntry->dstPortFrom;
		}
		else
		{
			aclRule.ingress_dest_l4_port_start = ipEntry->dstPortFrom;
			aclRule.ingress_dest_l4_port_end = ipEntry->dstPortTo;
		}
	}

	// Source ip, mask
	if(memcmp(ipEntry->srcIp, "\x00\x00\x00\x00", IP_ADDR_LEN) != 0)
	{
		aclRule.filter_fields |= INGRESS_IPV4_SIP_RANGE_BIT;

		if(ipEntry->smaskbit == 0)
			aclRule.ingress_src_ipv4_addr_start = aclRule.ingress_src_ipv4_addr_end = *((ipaddr_t *)ipEntry->srcIp);
		else
		{
			mask = ~0 << (sizeof(ipaddr_t)*8 - ipEntry->smaskbit);
			mask = htonl(mask);
			aclRule.ingress_src_ipv4_addr_start = *((in_addr_t *)ipEntry->srcIp) & mask;
			aclRule.ingress_src_ipv4_addr_end = *((in_addr_t *)ipEntry->srcIp) | ~mask;
		}
	}

	// Destination ip, mask
	if(memcmp(ipEntry->dstIp, "\x00\x00\x00\x00", IP_ADDR_LEN) != 0)
	{
		aclRule.filter_fields |= INGRESS_IPV4_DIP_RANGE_BIT;

		if(ipEntry->dmaskbit == 0)
			aclRule.ingress_dest_ipv4_addr_start = aclRule.ingress_dest_ipv4_addr_end = *((ipaddr_t *)ipEntry->dstIp);
		else
		{
			mask = ~0 << (sizeof(ipaddr_t)*8 - ipEntry->dmaskbit);
			mask = htonl(mask);
			aclRule.ingress_dest_ipv4_addr_start = *((in_addr_t *)ipEntry->dstIp) & mask;
			aclRule.ingress_dest_ipv4_addr_end = *((in_addr_t *)ipEntry->dstIp) | ~mask;
		}
	}

	// Protocol
	if( ipEntry->protoType != PROTO_NONE )
	{
		if( ipEntry->protoType == PROTO_TCP )
			aclRule.filter_fields |= INGRESS_L4_TCP_BIT;
		else if( ipEntry->protoType == PROTO_UDP )
			aclRule.filter_fields |= INGRESS_L4_UDP_BIT;
		else if( ipEntry->protoType == PROTO_ICMP)
			aclRule.filter_fields |= INGRESS_L4_ICMP_BIT;
		else
			return -1;
	}

	if(!(fp = fopen(RG_ACL_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -2;
	}

	if(ipEntry->dir == DIR_OUT)
	{
		aclRule.filter_fields |= INGRESS_DMAC_BIT;

		mib_get(MIB_ELAN_MAC_ADDR, (void *)&aclRule.ingress_dmac);

		if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
			fprintf(fp, "%d\n", aclIdx);
		else
			printf("rtk_rg_aclFilterAndQos_add ingress dmac failed!\n");
	}
	else if(ipEntry->dir == DIR_IN)
	{
		int wanPhyPort;
		aclRule.filter_fields |= INGRESS_PORT_BIT;

		if(mib_get(MIB_WAN_PHY_PORT , (void *)&wanPhyPort) == 0)
		{
			printf("Get MIB_WAN_PHY_PORT failed!!!\n");
			wanPhyPort = RTK_RG_MAC_PORT3; //for 0371 default
		}

		aclRule.ingress_port_mask.portmask = 1 << wanPhyPort;

		if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
			fprintf(fp, "%d\n", aclIdx);
		else
			printf("rtk_rg_aclFilterAndQos_add physic port failed!\n");
	}
	else
	{
		DBPRINT(1, "Invalid filtering direction!\n");
		fclose(fp);
		return -1;
	}

	fclose(fp);
	return 0;
}

int RTK_RG_ACL_IPPort_Filter_Default_Policy(int out_policy, int in_policy)
{
	rtk_rg_aclFilterAndQos_t aclRule;
	int aclIdx, ret;
	FILE *fp;

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));

	if(!(fp = fopen(RG_ACL_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -2;
	}

	if( out_policy == 0 )
	{
		aclRule.action_type = ACL_ACTION_TYPE_DROP;
		aclRule.filter_fields = INGRESS_DMAC_BIT|INGRESS_PORT_BIT;
		aclRule.ingress_port_mask.portmask = 0x7f; // All physical ports.

		mib_get(MIB_ELAN_MAC_ADDR, (void *)&aclRule.ingress_dmac);

		if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
			fprintf(fp, "%d\n", aclIdx);
		else
			printf("rtk_rg_aclFilterAndQos_add physic port failed!\n");
	}

	fclose(fp);
	return 0;
}

int RTK_RG_ACL_IPPort_Filter_Allow_LAN_to_GW()
{
	rtk_rg_aclFilterAndQos_t aclRule;
	int aclIdx, ret;
	FILE *fp;
	struct in_addr lan_ip;
	char ip2_enabled = 0;

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));

	if(!(fp = fopen(RG_ACL_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -1;
	}

	aclRule.action_type = ACL_ACTION_TYPE_PERMIT;
	aclRule.filter_fields = INGRESS_DMAC_BIT | INGRESS_IPV4_DIP_RANGE_BIT | INGRESS_PORT_BIT;
	aclRule.ingress_port_mask.portmask = 0x7f; // All physical ports.

	mib_get(MIB_ELAN_MAC_ADDR, (void *)&aclRule.ingress_dmac);
	mib_get(MIB_ADSL_LAN_IP, (void *)&lan_ip);
	aclRule.ingress_dest_ipv4_addr_start = aclRule.ingress_dest_ipv4_addr_end = *((ipaddr_t *)&lan_ip.s_addr);

	if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
		fprintf(fp, "%d\n", aclIdx);
	else
		printf("rtk_rg_aclFilterAndQos_add allow gw ip failed!\n");

	mib_get(MIB_ADSL_LAN_ENABLE_IP2, (void *)&ip2_enabled);

	if(ip2_enabled)
	{
		mib_get(MIB_ADSL_LAN_IP2, (void *)&lan_ip);
		aclRule.ingress_dest_ipv4_addr_start = aclRule.ingress_dest_ipv4_addr_end = *((ipaddr_t *)&lan_ip.s_addr);

		if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
			fprintf(fp, "%d\n", aclIdx);
		else
			printf("rtk_rg_aclFilterAndQos_add allow gw ip2 failed!\n");
	}

	fclose(fp);
	return 0;
}

int FlushRTK_RG_ACL_Filters()
{
	FILE *fp;
	int aclIdx;

	if(!(fp = fopen(RG_ACL_RULES_FILE, "r")))
		return -2;

	while(fscanf(fp, "%d\n", &aclIdx) != EOF)
	{
		if(rtk_rg_aclFilterAndQos_del(aclIdx))
			DBPRINT(1, "rtk_rg_aclFilterAndQos_del failed! idx = %d\n", aclIdx);
	}

	fclose(fp);
	unlink(RG_ACL_RULES_FILE);
	return 0;
}

#ifdef CONFIG_IPV6
int IPv6PrefixToStartEnd(char ipv6_addr[IPV6_ADDR_LEN], int prefix, char ipv6_start[IPV6_ADDR_LEN], char ipv6_end[IPV6_ADDR_LEN])
{
	int num_byte = prefix / 8;
	int rem_bits = prefix % 8;

	memcpy(ipv6_start, ipv6_addr, IPV6_ADDR_LEN);
	memcpy(ipv6_end, ipv6_addr, IPV6_ADDR_LEN);

	if(num_byte < IPV6_ADDR_LEN)
	{
		ipv6_start[num_byte] &= ((char)0xFF) << (8-rem_bits);
		ipv6_end[num_byte] |= ~(((char)0xFF) << (8-rem_bits));

		if(num_byte+1 < IPV6_ADDR_LEN)
		{
			memset(ipv6_start+num_byte+1, 0, IPV6_ADDR_LEN-num_byte-1);
			memset(ipv6_end+num_byte+1, 0xff, IPV6_ADDR_LEN-num_byte-1);
		}
	}
}

int AddRTK_RG_ACL_IPv6Port_Filter(MIB_CE_V6_IP_PORT_FILTER_T *ipv6_filter_entry, char *prefixIP)
{
	rtk_rg_aclFilterAndQos_t aclRule;
	rtk_rg_intfInfo_t infinfo;
	int aclIdx, i;
	FILE *fp;
	unsigned char empty_ipv6[IPV6_ADDR_LEN] = {0};

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));

	if (ipv6_filter_entry->action == 0)
		aclRule.action_type = ACL_ACTION_TYPE_DROP;
	else if (ipv6_filter_entry->action == 1)
		aclRule.action_type = ACL_ACTION_TYPE_PERMIT;
	else
	{
		fprintf(stderr, "Wrong IP/Port filter action!\n");
		return -1;
	}

	// Source port
	if (ipv6_filter_entry->srcPortFrom != 0)
	{
		aclRule.filter_fields |= INGRESS_L4_SPORT_RANGE_BIT;
		if (ipv6_filter_entry->srcPortFrom == ipv6_filter_entry->srcPortTo)
		{
			aclRule.ingress_src_l4_port_start = aclRule.ingress_src_l4_port_end = ipv6_filter_entry->srcPortFrom;
		}
		else
		{
			aclRule.ingress_src_l4_port_start = ipv6_filter_entry->srcPortFrom;
			aclRule.ingress_src_l4_port_end = ipv6_filter_entry->srcPortTo;
		}
	}

	// Destination port
	if(ipv6_filter_entry->dstPortFrom != 0)
	{
		aclRule.filter_fields |= INGRESS_L4_DPORT_RANGE_BIT;
		if(ipv6_filter_entry->dstPortFrom == ipv6_filter_entry->dstPortTo)
		{
			aclRule.ingress_dest_l4_port_start = aclRule.ingress_dest_l4_port_end = ipv6_filter_entry->dstPortFrom;
		}
		else
		{
			aclRule.ingress_dest_l4_port_start = ipv6_filter_entry->dstPortFrom;
			aclRule.ingress_dest_l4_port_end = ipv6_filter_entry->dstPortTo;
		}
	}

#ifdef CONFIG_IPV6_OLD_FILTER
	// Source ip, mask
	if(memcmp(ipv6_filter_entry->sip6Start, empty_ipv6, IPV6_ADDR_LEN) != 0)
	{
		aclRule.filter_fields |= INGRESS_IPV6_SIP_RANGE_BIT;

		if(ipv6_filter_entry->sip6End[0] == 0)
		{
			if(ipv6_filter_entry->sip6PrefixLen == 0)
			{
				memcpy(aclRule.ingress_src_ipv6_addr_start, ipv6_filter_entry->sip6Start, IPV6_ADDR_LEN);
				memcpy(aclRule.ingress_src_ipv6_addr_end, ipv6_filter_entry->sip6Start, IPV6_ADDR_LEN);
			}
			else
				IPv6PrefixToStartEnd(ipv6_filter_entry->sip6Start, ipv6_filter_entry->sip6PrefixLen, aclRule.ingress_src_ipv6_addr_start, aclRule.ingress_src_ipv6_addr_end);
		}
		else
		{
			memcpy(aclRule.ingress_src_ipv6_addr_start, ipv6_filter_entry->sip6Start, IPV6_ADDR_LEN);
			memcpy(aclRule.ingress_src_ipv6_addr_end, ipv6_filter_entry->sip6End, IPV6_ADDR_LEN);
		}
	}

	// Destination ip, mask
	if(memcmp(ipv6_filter_entry->dip6Start, empty_ipv6, IPV6_ADDR_LEN) != 0)
	{
		aclRule.filter_fields |= INGRESS_IPV6_DIP_RANGE_BIT;

		if(ipv6_filter_entry->dip6End[0] == 0)
		{
			if(ipv6_filter_entry->dip6PrefixLen == 0)
			{
				memcpy(aclRule.ingress_dest_ipv6_addr_start, ipv6_filter_entry->dip6Start, IPV6_ADDR_LEN);
				memcpy(aclRule.ingress_dest_ipv6_addr_end, ipv6_filter_entry->dip6Start, IPV6_ADDR_LEN);
			}
			else
				IPv6PrefixToStartEnd(ipv6_filter_entry->dip6Start, ipv6_filter_entry->dip6PrefixLen, aclRule.ingress_dest_ipv6_addr_start, aclRule.ingress_dest_ipv6_addr_end);
		}
		else
		{
			memcpy(aclRule.ingress_dest_ipv6_addr_start, ipv6_filter_entry->dip6Start, IPV6_ADDR_LEN);
			memcpy(aclRule.ingress_dest_ipv6_addr_end, ipv6_filter_entry->dip6End, IPV6_ADDR_LEN);
		}
	}

#else
	if(!prefixIP){
		printf("Error! PrefixIP should not be NULL!\n");
		return -1;
	}

	// Make Source ip from prefix+sIfId6Start
	if(memcmp(ipv6_filter_entry->sIfId6Start, empty_ipv6, IPV6_ADDR_LEN) != 0)
	{
		int index;

		aclRule.filter_fields |= INGRESS_IPV6_SIP_RANGE_BIT;

		memcpy(aclRule.ingress_src_ipv6_addr_start, (void *) prefixIP, IP6_ADDR_LEN);
		for (index=0; index<8; index++){
			aclRule.ingress_src_ipv6_addr_start[index+8] = ipv6_filter_entry->sIfId6Start[index+8];
		}			
			
		memcpy(aclRule.ingress_src_ipv6_addr_end, aclRule.ingress_src_ipv6_addr_start, IPV6_ADDR_LEN);
	}

	// Make Destination  ip from prefix+dIfId6Start
	if(memcmp(ipv6_filter_entry->dIfId6Start, empty_ipv6, IPV6_ADDR_LEN) != 0)
	{
		int index;
		aclRule.filter_fields |= INGRESS_IPV6_DIP_RANGE_BIT;

		memcpy(aclRule.ingress_dest_ipv6_addr_start, (void *) prefixIP, IP6_ADDR_LEN);
		for (index=0; index<8; index++){
			aclRule.ingress_dest_ipv6_addr_start[index+8] = ipv6_filter_entry->dIfId6Start[index+8];
		}			
		memcpy(aclRule.ingress_dest_ipv6_addr_end, aclRule.ingress_dest_ipv6_addr_start, IPV6_ADDR_LEN);
	}
#endif

	// Protocol
	if( ipv6_filter_entry->protoType != PROTO_NONE )
	{
		if( ipv6_filter_entry->protoType == PROTO_TCP )
			aclRule.filter_fields |= INGRESS_L4_TCP_BIT;
		else if( ipv6_filter_entry->protoType == PROTO_UDP )
			aclRule.filter_fields |= INGRESS_L4_UDP_BIT;
		else if( ipv6_filter_entry->protoType == PROTO_ICMP)
			aclRule.filter_fields |= INGRESS_L4_ICMP_BIT;
		else
			return -1;
	}

	if(!(fp = fopen(RG_ACL_IPv6_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -2;
	}

	if(ipv6_filter_entry->dir == DIR_OUT)
	{
		for( i = 0; i < MAX_NETIF_SW_TABLE_SIZE; i++ )
		{
			memset(&infinfo, 0, sizeof(rtk_rg_intfInfo_t));
			if(rtk_rg_intfInfo_find(&infinfo, &i))
				break;

			if(infinfo.is_wan)
			{
				aclRule.filter_fields |= EGRESS_INTF_BIT;
				aclRule.egress_intf_idx = i;

				if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
					fprintf(fp, "%d\n", aclIdx);
				else
					DBPRINT(1, "rtk_rg_aclFilterAndQos_add failed!\n");
			}
		}
	}
	else if(ipv6_filter_entry->dir == DIR_IN)
	{
		int wanPhyPort;
		aclRule.filter_fields |= INGRESS_PORT_BIT;

		if(mib_get(MIB_WAN_PHY_PORT , (void *)&wanPhyPort) == 0)
		{
			printf("Get MIB_WAN_PHY_PORT failed!!!\n");
			wanPhyPort = RTK_RG_MAC_PORT3; //for 0371 default
		}

		aclRule.ingress_port_mask.portmask = 1 << wanPhyPort;

		if(rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx) == 0)
			fprintf(fp, "%d\n", aclIdx);
		else
			DBPRINT(1, "rtk_rg_aclFilterAndQos_add failed!\n");
	}
	else
	{
		DBPRINT(1, "Invalid filtering direction!\n");
		fclose(fp);
		return -1;
	}

	fclose(fp);
	return 0;
}

// Magician: No support default policy yet.
int RTK_RG_ACL_IPv6Port_Filter_Default_Policy(int out_policy, int in_policy)
{
}

int FlushRTK_RG_ACL_IPv6Port_Filters()
{
	FILE *fp;
	int aclIdx;

	if(!(fp = fopen(RG_ACL_IPv6_RULES_FILE, "r")))
		return -2;

	while(fscanf(fp, "%d\n", &aclIdx) != EOF)
	{
		if(rtk_rg_aclFilterAndQos_del(aclIdx))
			DBPRINT(1, "rtk_rg_aclFilterAndQos_del failed! idx = %d\n", aclIdx);
	}

	fclose(fp);
	unlink(RG_ACL_IPv6_RULES_FILE);
	return 0;
}
#endif

int RTK_RG_DMZ_Set(int enabled, in_addr_t ip_addr)
{
	int i;
	rtk_rg_intfInfo_t infinfo;
	rtk_rg_dmzInfo_t dmz_info;

	for( i = 0; i < MAX_NETIF_SW_TABLE_SIZE; i++ )
	{
		memset(&infinfo, 0, sizeof(rtk_rg_intfInfo_t));
		if(rtk_rg_intfInfo_find(&infinfo, &i))
			break;

		if(infinfo.is_wan)
		{
			/* dmz setting */
			memset(&dmz_info, 0, sizeof(rtk_rg_dmzInfo_t));
			dmz_info.enabled = enabled;
			dmz_info.mac_mapping_enabled = 0; //use ip
			dmz_info.private_ip = ip_addr;
			rtk_rg_dmzHost_set(i, &dmz_info);
		}
	}
}

#ifdef PORT_FORWARD_GENERAL
int RTK_RG_Vertual_Server_Set(MIB_CE_PORT_FW_T *pf)
{
	rtk_rg_virtualServer_t vs;
	rtk_rg_intfInfo_t inf_info;
	int vs_idx, i, ret;
	FILE *fp;

	memset(&vs, 0, sizeof(rtk_rg_virtualServer_t));

	vs.local_ip = *((ipaddr_t *)pf->ipAddr);
	vs.valid = pf->enable;

	if(pf->fromPort)
	{
		vs.local_port_start = pf->fromPort;
		vs.gateway_port_start = pf->fromPort;
		vs.mappingPortRangeCnt = pf->toPort - pf->fromPort + 1;
	}

	if(pf->externalfromport)
	{
		if(!pf->fromPort)
			vs.local_port_start = pf->externalfromport;

		vs.gateway_port_start = pf->externalfromport;

		if(pf->externaltoport)
			vs.mappingPortRangeCnt = pf->externaltoport - pf->externalfromport + 1;
		else if(pf->fromPort && pf->toPort)
			vs.mappingPortRangeCnt = pf->toPort - pf->fromPort + 1;
		else
			vs.mappingPortRangeCnt = 1;
	}

	// Mapping all, if all fileds of ports are empty.
	if(!pf->fromPort && !pf->externalfromport)
	{
		vs.local_port_start = vs.gateway_port_start = 1;
		vs.mappingPortRangeCnt = 0xffff;
	}

	if(pf->remotehost[0])
	{
	}

	if(!(fp = fopen(RG_VERTUAL_SERVER_FILE, "a")))
		return -2;

	if(pf->ifIndex == DUMMY_IFINDEX) // Work on any interface.
	{
		for( i = 0; i < MAX_NETIF_SW_TABLE_SIZE; i++ )
		{
			memset(&inf_info, 0, sizeof(rtk_rg_intfInfo_t));
			if(rtk_rg_intfInfo_find(&inf_info, &i))
				break;

			if(inf_info.is_wan)
			{
				vs.wan_intf_idx = i;

				if(pf->protoType == PROTO_TCP || pf->protoType == PROTO_UDPTCP)
				{
					vs.is_tcp = 1;
					ret = rtk_rg_virtualServer_add(&vs, &vs_idx);

					DBPRINT(0, "Add vertual server. RG WAN Index=%d, protocol=%s\n", vs.wan_intf_idx, vs.is_tcp? "TCP": "UDP");
					if(ret == 0)
						fprintf(fp, "%d\n", vs_idx);
					else
					{
						DBPRINT(1, "Error %d: rtk_rg_virtualServer_add failed! protoType=TCP\n", ret);
						continue;
					}
				}

				if(pf->protoType == PROTO_UDP || pf->protoType == PROTO_UDPTCP)
				{
					vs.is_tcp = 0;
					ret = rtk_rg_virtualServer_add(&vs, &vs_idx);

					DBPRINT(0, "Add vertual server. RG WAN Index=%d, protocol=%s\n", vs.wan_intf_idx, vs.is_tcp? "TCP": "UDP");

					if(ret == 0)
						fprintf(fp, "%d\n", vs_idx);
					else
					{
						DBPRINT(1, "Error %d: rtk_rg_virtualServer_add failed! protoType=UDP\n", ret);
						continue;
					}
				}
			}
		}
	}
	else
	{
		int totalEntry = mib_chain_total(MIB_ATM_VC_TBL);
		MIB_CE_ATM_VC_T entry;

		for (i = 0; i < totalEntry; i++)
		{
			if (mib_chain_get(MIB_ATM_VC_TBL, i, (void *)&entry) == 0)
				continue;

			if( pf->ifIndex == entry.ifIndex )
			{
				vs.wan_intf_idx = entry.rg_wan_idx;

				if(pf->protoType == PROTO_TCP || pf->protoType == PROTO_UDPTCP)
				{
					vs.is_tcp = 1;
					ret = rtk_rg_virtualServer_add(&vs, &vs_idx);

					DBPRINT(2, "Add vertual server. Interface index=%X, RG WAN Index=%d, protocol=%s\n", entry.ifIndex, entry.rg_wan_idx, vs.is_tcp? "TCP": "UDP");
					if(ret == 0)
						fprintf(fp, "%d\n", vs_idx);
					else
					{
						DBPRINT(1, "Error %d: rtk_rg_virtualServer_add failed! protoType=TCP\n", ret);
						continue;
					}
				}

				if(pf->protoType == PROTO_UDP || pf->protoType == PROTO_UDPTCP)
				{
					vs.is_tcp = 0;
					ret = rtk_rg_virtualServer_add(&vs, &vs_idx);

					DBPRINT(2, "Add vertual server. Interface index=%X, RG WAN Index=%d, protocol=%s\n", entry.ifIndex, entry.rg_wan_idx, vs.is_tcp? "TCP": "UDP");
					if(ret == 0)
						fprintf(fp, "%d\n", vs_idx);
					else
					{
						DBPRINT(1, "Error %d: rtk_rg_virtualServer_add failed! protoType=UDP\n", ret);
						continue;
					}
				}
				break;
			}
		}
	}

	fclose(fp);
	return 0;
}

int FlushRTK_RG_Vertual_Server()
{
	FILE *fp;
	int vsIdx;

	if(!(fp = fopen(RG_VERTUAL_SERVER_FILE, "r")))
		return -1;

	while(fscanf(fp, "%d\n", &vsIdx) != EOF)
	{
		if(rtk_rg_virtualServer_del(vsIdx))
			printf("rtk_rg_virtualServer_del failed! idx = %d\n", vsIdx);
		else
			printf("Deleted Vertual Server %d.\n", vsIdx);
	}

	unlink(RG_VERTUAL_SERVER_FILE);

	return 0;
}
#endif

#ifdef CONFIG_USER_IP_QOS_3
int RTK_RG_QoS_Queue_Set()
{
	unsigned char policy;
	int aclIdx, i, ret;
	rtk_rg_qos_queue_weights_t q_weight;

	memset(&q_weight, 0, sizeof(q_weight));

	if(!mib_get(MIB_QOS_POLICY, (void *)&policy))
	{
		DBPRINT(1, "MIB get MIB_QOS_POLICY failed!\n");
		return -2;
	}

	if(policy == 0) // PRIO
	{
		q_weight.weights[7] = 0; // Queue4~7: Strict Priority
		q_weight.weights[6] = 0;
		q_weight.weights[5] = 0;
		q_weight.weights[4] = 0;
	}
	else if(policy ==1) // WRR
	{
		MIB_CE_IP_QOS_QUEUE_T qEntry;
		int qEntryNum, i;

		if((qEntryNum = mib_chain_total(MIB_IP_QOS_QUEUE_TBL)) <=0)
			return -1;

		for(i = 0; i < qEntryNum; i++)
		{
			if(!mib_chain_get(MIB_IP_QOS_QUEUE_TBL, i, (void*)&qEntry))
				continue;

			if( i <= 7 )
				q_weight.weights[7-i] = qEntry.weight;
		}
	}
	else
	{
		DBPRINT(1, "policy=%d: Unexpected policy value! (0=PRIO, 1=WRR)\n", policy);
		return -1;
	}

	for( i = 0; i < 7; i++ )
	{
		if((ret = rtk_rg_qosStrictPriorityOrWeightFairQueue_set(i, q_weight)) != 0)
			DBPRINT(1, "rtk_qos_schedulingQueue_set failed! (ret=%d, i=%d)\n", ret, i);
	}

	return 0;
}

int RTK_RG_QoS_Rule_Set(MIB_CE_IP_QOS_Tp qos_entry)
{
	rtk_rg_aclFilterAndQos_t aclRule;
	MIB_CE_ATM_VC_T vc_entry;
	int aclIdx, ret, i, total_vc;
	FILE *fp;
	ipaddr_t mask;
	unsigned char empty_ipv6[IPV6_ADDR_LEN] = {0};

	memset(&aclRule, 0, sizeof(rtk_rg_aclFilterAndQos_t));

	aclRule.action_type = ACL_ACTION_TYPE_QOS;

	// Source MAC
	if(memcmp(qos_entry->smac, EMPTY_MAC, MAC_ADDR_LEN))
	{
		aclRule.filter_fields |= INGRESS_SMAC_BIT;
		memcpy(&aclRule.ingress_smac, qos_entry->smac, MAC_ADDR_LEN);
	}

	// Destination MAC
	if(memcmp(qos_entry->dmac, EMPTY_MAC, MAC_ADDR_LEN))
	{
		aclRule.filter_fields |= INGRESS_DMAC_BIT;
		memcpy(&aclRule.ingress_dmac, qos_entry->dmac, MAC_ADDR_LEN);
	}

	// Filter rule of physic ports.
	if(qos_entry->phyPort >= 1 && qos_entry->phyPort <= SW_LAN_PORT_NUM)
	{
		aclRule.filter_fields |= INGRESS_PORT_BIT;
		aclRule.ingress_port_mask.portmask = (1 << RTK_RG_PORT0)  | (1 << RTK_RG_PORT1) | (1 << RTK_RG_PORT2) | (1 << RTK_RG_PORT3);
	}

	// Filter rule of DSCP
	if(qos_entry->qosDscp != 0)
	{
		aclRule.filter_fields |= INGRESS_DSCP_BIT;
		aclRule.ingress_dscp = qos_entry->qosDscp >> 2;
	}

	// Filter rule of 802.1p mark
	if(qos_entry->vlan1p != 0)
	{
		aclRule.filter_fields |= INGRESS_CTAG_VID_BIT;
		aclRule.ingress_ctag_vid = qos_entry->vlan1p - 1;
	}

	// Filter rule of Protocol: UDP, TCP, ICMP, UDP and TCP
	if(qos_entry->protoType != PROTO_NONE)
	{
		if(qos_entry->protoType == PROTO_TCP)
			aclRule.filter_fields |= INGRESS_L4_TCP_BIT;
		else if(qos_entry->protoType == PROTO_UDP)
			aclRule.filter_fields |= INGRESS_L4_UDP_BIT;
		else if(qos_entry->protoType == PROTO_ICMP)
			aclRule.filter_fields |= INGRESS_L4_ICMP_BIT;
		else if(qos_entry->protoType == PROTO_UDPTCP)
			aclRule.filter_fields |= INGRESS_L4_TCP_BIT | INGRESS_L4_UDP_BIT;
		else
		{
			DBPRINT(1, "Add acl rule failed! No support of this protocol type!\n");
			return -1;
		}
	}

	if(qos_entry->sPort != 0)
	{
		aclRule.filter_fields |= INGRESS_L4_SPORT_RANGE_BIT;
		if (qos_entry->sPort == qos_entry->sPortRangeMax)
		{
			aclRule.ingress_src_l4_port_start = aclRule.ingress_src_l4_port_end = qos_entry->sPort;
		}
		else
		{
			aclRule.ingress_src_l4_port_start = MIN_VALUE(qos_entry->sPort, qos_entry->sPortRangeMax);
			aclRule.ingress_src_l4_port_end = MAX_VALUE(qos_entry->sPort, qos_entry->sPortRangeMax);
		}
	}

	if(qos_entry->dPort != 0)
	{
		aclRule.filter_fields |= INGRESS_L4_DPORT_RANGE_BIT;
		if (qos_entry->dPort == qos_entry->dPortRangeMax)
		{
			aclRule.ingress_dest_l4_port_start = aclRule.ingress_dest_l4_port_end = qos_entry->dPort;
		}
		else
		{
			aclRule.ingress_dest_l4_port_start = MIN_VALUE(qos_entry->dPort, qos_entry->dPortRangeMax);
			aclRule.ingress_dest_l4_port_end = MAX_VALUE(qos_entry->dPort, qos_entry->dPortRangeMax);
		}
	}

#ifdef CONFIG_IPV6
	if(qos_entry->IpProtocol == 2)  // IPv6
	{
		// Source ip, prefix
		if(memcmp(qos_entry->sip6, empty_ipv6, IPV6_ADDR_LEN) != 0)
		{
			aclRule.filter_fields |= INGRESS_IPV6_SIP_RANGE_BIT;

			IPv6PrefixToStartEnd(qos_entry->sip6, qos_entry->sip6PrefixLen, aclRule.ingress_src_ipv6_addr_start, aclRule.ingress_src_ipv6_addr_end);
		}

		// Destination ip, prefix
		if(memcmp(qos_entry->dip6, empty_ipv6, IPV6_ADDR_LEN) != 0)
		{
			aclRule.filter_fields |= INGRESS_IPV6_DIP_RANGE_BIT;

			IPv6PrefixToStartEnd(qos_entry->dip6, qos_entry->dip6PrefixLen, aclRule.ingress_dest_ipv6_addr_start, aclRule.ingress_dest_ipv6_addr_end);
		}
	}
	else if(qos_entry->IpProtocol == 1) // IPv4
	{
#endif
		// Source ip, mask
		if(memcmp(qos_entry->sip, "\x00\x00\x00\x00", IP_ADDR_LEN) != 0)
		{
			aclRule.filter_fields |= INGRESS_IPV4_SIP_RANGE_BIT;

			if(qos_entry->smaskbit == 0)
				aclRule.ingress_src_ipv4_addr_start = aclRule.ingress_src_ipv4_addr_end = *((ipaddr_t *)qos_entry->sip);
			else
			{
				mask = ~0 << (sizeof(ipaddr_t)*8 - qos_entry->smaskbit);
				mask = htonl(mask);
				aclRule.ingress_src_ipv4_addr_start = *((in_addr_t *)qos_entry->sip) & mask;
				aclRule.ingress_src_ipv4_addr_end = *((in_addr_t *)qos_entry->sip) | ~mask;
			}
		}

		// Destination ip, mask
		if(memcmp(qos_entry->dip, "\x00\x00\x00\x00", IP_ADDR_LEN) != 0)
		{
			aclRule.filter_fields |= INGRESS_IPV4_DIP_RANGE_BIT;

			if(qos_entry->dmaskbit == 0)
				aclRule.ingress_dest_ipv4_addr_start = aclRule.ingress_dest_ipv4_addr_end = *((ipaddr_t *)qos_entry->dip);
			else
			{
				mask = ~0 << (sizeof(ipaddr_t)*8 - qos_entry->dmaskbit);
				mask = htonl(mask);
				aclRule.ingress_dest_ipv4_addr_start = *((in_addr_t *)qos_entry->dip) & mask;
				aclRule.ingress_dest_ipv4_addr_end = *((in_addr_t *)qos_entry->dip) | ~mask;
			}
		}
#ifdef CONFIG_IPV6
	}
#endif

	// Filter rule of WAN interface
	if(qos_entry->outif != DUMMY_IFINDEX)
	{
		total_vc = mib_chain_total(MIB_ATM_VC_TBL);

		for( i = 0; i < total_vc; i++ )
		{
			if(!mib_chain_get(MIB_ATM_VC_TBL, i, (void *)&vc_entry))
				continue;

			if(vc_entry.ifIndex == qos_entry->outif)
			{
				aclRule.filter_fields |= EGRESS_INTF_BIT;
				aclRule.egress_intf_idx = vc_entry.rg_wan_idx;  // Set egress interface.
			}
		}
	}

	// Action rule of DSCP
	if(qos_entry->m_dscp != 0)
	{
		aclRule.qos_actions |= ACL_ACTION_DSCP_REMARKING_BIT;
		aclRule.action_dscp_remarking_pri = qos_entry->m_dscp >> 2;
	}

	// Action rule of IP precedence.
	if(qos_entry->prior != 0)
	{
		MIB_CE_IP_QOS_QUEUE_T qEntry;
		int qEntryNum, i;

		if(!mib_chain_get(MIB_IP_QOS_QUEUE_TBL, qos_entry->prior-1, (void*)&qEntry))
			return -1;

		if(qEntry.enable)
		{
			aclRule.qos_actions |= ACL_ACTION_ACL_PRIORITY_BIT;
			aclRule.action_acl_priority = 8 - qos_entry->prior;  // Only use queue 7, 6, 5, 4
		}
	}

	// Action rule of CVLAN priority change.
	if(qos_entry->m_1p != 0)
	{
		aclRule.qos_actions |= ACL_ACTION_1P_REMARKING_BIT;
		aclRule.action_dot1p_remarking_pri = qos_entry->m_1p - 1;
	}

	if(!(fp = fopen(RG_QOS_RULES_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -2;
	}

	if((ret = rtk_rg_aclFilterAndQos_add(&aclRule, &aclIdx)) == 0)
		fprintf(fp, "%d\n", aclIdx);
	else
		printf("rtk_rg_aclFilterAndQos_add QoS rule failed! (ret = %d)\n", ret);

	fclose(fp);
	return 0;
}

int FlushRTK_RG_QoS_Rules()
{
	FILE *fp;
	int qos_idx;

	if(!(fp = fopen(RG_QOS_RULES_FILE, "r")))
		return -2;

	while(fscanf(fp, "%d\n", &qos_idx) != EOF)
	{
		if(rtk_rg_aclFilterAndQos_del(qos_idx))
			DBPRINT(1, "rtk_rg_aclFilterAndQos_del failed! idx = %d\n", qos_idx);
	}

	fclose(fp);
	unlink(RG_QOS_RULES_FILE);
	return 0;
}
#endif

#ifdef CONFIG_USER_MINIUPNPD
int AddRTK_RG_UPnP_Connection(unsigned short eport, const char *iaddr, unsigned short iport, int protocol)
{
	int upnpIdx, ret, total_vc, i;
	rtk_rg_upnpConnection_t upnp;
	MIB_CE_ATM_VC_T vc_entry;
	FILE *fp;
	unsigned int ext_if;
	char lan_ip[IP_ADDR_LEN];

	mib_get(MIB_UPNP_EXT_ITF, (void *)&ext_if);
	inet_pton(AF_INET, iaddr, (void *)lan_ip);
	memset(&upnp, 0, sizeof(rtk_rg_upnpConnection_t));

	upnp.valid = ENABLED;
	upnp.is_tcp = (protocol == IPPROTO_TCP? 1: 0);
	upnp.gateway_port = eport;
	upnp.local_ip = *((ipaddr_t *)lan_ip);
	upnp.local_port = iport;
	upnp.limit_remote_ip = DISABLED;
	upnp.limit_remote_port = DISABLED;
	upnp.type = UPNP_TYPE_PERSIST;
	upnp.timeout = 0; // 0: disable auto-delete

	total_vc = mib_chain_total(MIB_ATM_VC_TBL);

	for( i = 0; i < total_vc; i++ )
	{
		if(!mib_chain_get(MIB_ATM_VC_TBL, i, (void *)&vc_entry))
			continue;

		if(vc_entry.ifIndex == ext_if)
		{
			upnp.wan_intf_idx = vc_entry.rg_wan_idx;
			break;
		}
	}

	if(!(fp = fopen(RG_UPNP_CONNECTION_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -2;
	}

	if((ret = rtk_rg_upnpConnection_add(&upnp, &upnpIdx)) == 0)
		fprintf(fp, "%d %u %d\n", upnpIdx, eport, protocol);
	else
		printf("rtk_rg_aclFilterAndQos_add QoS rule failed!\n");

	fclose(fp);
	return 0;
}

int DelRTK_RG_UPnP_Connection(unsigned short eport, int protocol)
{
	FILE *fp, *fp_tmp;
	int upnp_idx, upnp_eport, upnp_proto;
	char line[24];

	if(!(fp = fopen(RG_UPNP_CONNECTION_FILE, "r")))
		return -2;

	if(!(fp_tmp = fopen(RG_UPNP_TMP_FILE, "w")))
		return -2;

	while(fgets(line, 23, fp) != NULL)
	{
		sscanf(line, "%d %d %d\n", &upnp_idx, &upnp_eport, &upnp_proto);

		if( upnp_eport == eport && upnp_proto == protocol )
		{
			if(rtk_rg_aclFilterAndQos_del(upnp_idx))
				DBPRINT(1, "rtk_rg_aclFilterAndQos_del failed! idx = %d\n", upnp_idx);
		}
		else
			fprintf(fp_tmp, "%d %d %d\n", upnp_idx, upnp_eport, upnp_proto);
	}

	fclose(fp);
	fclose(fp_tmp);
	unlink(RG_UPNP_CONNECTION_FILE);
	rename(RG_UPNP_TMP_FILE, RG_UPNP_CONNECTION_FILE);
	return 0;
}
#endif

#ifdef CONFIG_IP_NF_ALG_ONOFF
int RTK_RG_ALG_Set()
{
	rtk_rg_alg_type_t alg_app;

	unsigned char value = 0;
#ifdef CONFIG_NF_CONNTRACK_FTP
	if(mib_get(MIB_IP_ALG_FTP, &value) && value == 1)
	{
		alg_app = RTK_RG_ALG_FTP_TCP_BIT | RTK_RG_ALG_FTP_UDP_BIT;
		if(rtk_rg_algApps_set(alg_app))
			return -1;
	}
	else
	{
		alg_app = 0;
		if(rtk_rg_algApps_set(alg_app))
			return -1;
	}
#endif
}
#endif

#ifdef URL_BLOCKING_SUPPORT
int RTK_RG_URL_Filter_Set()
{
	int url_idx, ret, total_url, total_keyd, i;
	rtk_rg_urlFilterString_t url_f_s;
	MIB_CE_URL_FQDN_T fqdn;
	MIB_CE_KEYWD_FILTER_T keyword;
	FILE *fp;

	total_url = mib_chain_total(MIB_URL_FQDN_TBL);

	if(!(fp = fopen(RG_URL_FILTER_FILE, "a")))
	{
		fprintf(stderr, "ERROR! %s\n", strerror(errno));
		return -2;
	}

	url_f_s.path_exactly_match = 0;

	for (i = 0; i < total_url; i++)
	{
		if (!mib_chain_get(MIB_URL_FQDN_TBL, i, (void *)&fqdn))
			continue;

		strncpy(url_f_s.url_filter_string, fqdn.fqdn, MAX_URL_LENGTH);

		if((ret = rtk_rg_urlFilterString_add(&url_f_s, &url_idx)) == 0)
			fprintf(fp, "%d\n", url_idx);
		else
			DBPRINT(1, "rtk_rg_urlFilterString_add QoS rule failed!\n");
	}

	total_keyd = mib_chain_total(MIB_KEYWD_FILTER_TBL);

	for(i = 0; i < total_keyd; i++)
	{
		if(!mib_chain_get(MIB_KEYWD_FILTER_TBL, i, (void *)&keyword))
		 continue;

		strncpy(url_f_s.url_filter_string, keyword.keyword, MAX_KEYWD_LENGTH);

		if((ret = rtk_rg_urlFilterString_add(&url_f_s, &url_idx)) == 0)
			fprintf(fp, "%d\n", url_idx);
		else
			DBPRINT(1, "rtk_rg_urlFilterString_add QoS rule failed!\n");
	}

	fclose(fp);
	return 0;
}

int Flush_RTK_RG_URL_Filter()
{
	FILE *fp;
	int url_filter_idx;

	if(!(fp = fopen(RG_URL_FILTER_FILE, "r")))
		return -2;

	while(fscanf(fp, "%d\n", &url_filter_idx) != EOF)
	{
		if(rtk_rg_urlFilterString_del(url_filter_idx))
			DBPRINT(1, "rtk_rg_urlFilterString_del failed! idx = %d\n", url_filter_idx);
	}

	fclose(fp);
	unlink(RG_URL_FILTER_FILE);
	return 0;
}
#endif

#if 0
#define CALLBACKREGIST  "/proc/rg/callbackRegist"
int callbackRegistCheck(void)
{
	FILE *fp;
	int proc_read;
	int enabled=0;
	char buffer[8];
	fp=fopen(CALLBACKREGIST, "r");
	if(fp==NULL)
	{
		printf("file %s open failed @%s line:%d\n", CALLBACKREGIST,__func__,__LINE__);
		return FALSE;
	}
	memset(buffer, 0, sizeof(buffer));
	proc_read=fread(buffer, 1, 8, fp);
	if(proc_read!=0){
		printf("read size=%d, buffer=%s\n", proc_read, buffer);
	}
	if(proc_read < 0){
		printf("proc_read failed @%s line:%d\n",__func__,__LINE__);
		goto err;
	}

	if(strncmp(buffer, "1",1) == 0){
		enabled = TRUE;
	}else if(strncmp(buffer, "0",1) == 0){
		enabled = FALSE;
	}
err:
	fclose(fp);

	return enabled;
}
#endif

int rg_eth2wire_block(int enable)
{

	rtk_portmask_t portmask,extportmask;
	if(enable == 1)
		portmask.bits[0] = 0x70;
	else
		portmask.bits[0] = 0x7f; // disalbe

	extportmask.bits[0] = 0x1f;

	//for master
	rtk_rg_port_isolationEntryExt_set(RTK_PORT_ISO_CFG_0,1,&portmask,&extportmask);
	rtk_rg_port_isolationEntryExt_set(RTK_PORT_ISO_CFG_1,1,&portmask,&extportmask);

	//for slave
	rtk_rg_port_isolationEntryExt_set(RTK_PORT_ISO_CFG_0,2,&portmask,&extportmask);
	rtk_rg_port_isolationEntryExt_set(RTK_PORT_ISO_CFG_1,2,&portmask,&extportmask);

	return 0;
}



