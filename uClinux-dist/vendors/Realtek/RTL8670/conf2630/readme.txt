Configurations
==============

1Pi - 1 Port using Internal MAC
4Pe - 4 Port (8306) using External MAC
OTG - OTG Host
EHCI - EHCI Host
8192su
8187su
8192ce
8192ceG : RX_BUFFER_GATHER is enabled and reduce MAX_SKB_NUM from 256 to 96
MS : Massive Storage support
PA : Preallocate SKB
Vo : VoIP support
BF : Bridge Fastpath
IPV6: Support IPV6
3G : Support USB 3G dongle
4M/16M : flash size/memory size is 4M/16M
PS : Print Server

====================================================================================================================
IC	Code		Ethernet  USB Controller	WIFI	IMEM	VoIP		Other	
====================================================================================================================
RTL8676	e8b		4Pe				Y	Y			DSL
	e8lite		4Pe				N				DSL
	e8b_8676 	HW-NAT                          Y       32K+32K 		EthWan
	e8c_8676 	HW-NAT				Y	32K+32K			IAD, EthWan
	e8lite_8676 	HW-NAT								EthWan
	e8lite_06 	HW-NAT								DSL
	e8_06		HW-NAT				Y	64K			DSL
	01      	4Pe       EHCI+OTG              8192ce  64K     		BF,MS,3G,PS
	02		4Pe	  EHCI+OTG		8192ceG 64K			PA,BF,MS,3G,4M/16M,PS
	03		4Pe	  EHCI+OTG		8192ce	64K			--IAD Silab--
	04		4Pe	  EHCI+OTG		8192ce	64K			--IAD Zarlink--
	05      	HW-NAT    N                     N       64K     
	06		HW-NAT    EHCI			8192ce	64K			IAD Silab,8367B
	07		HW-NAT	  EHCI			8192ce	64K			4p-wifi
	08      	HW-NAT    EHCI                  8192ce  64K     Zar 2s1o,HWSPI	IAD 8676PN 176pin
	09		HW-NAT    EHCI                  8192ce  64K     Zar 1s,HWSPI	IAD 8676P  164pin
	mp_8676 	HW-NAT    EHCI			8192ce	64K	N		4p-wifi, 16M SDRAM	(for mp only)
	mts		HW-NAT    EHCI			8192ce	64K	N		Dual-Image, Russia MTS.
	10		HW-NAT	  EHCI			8192ce	64K	N		Dual-Image, DSL
	10_voip		HW-NAT    EHCI			8192ce	64K	Zar 1s,HWSPI	singel image, copy from 10
======================================================================================================================
RTL8676s
	8676s_88e	HW-NAT	  EHCI			8188e	48K	N		DSL
	8676s_92e	HW-NAT	  EHCI			8192e	48K	N		DSL
	8676s_ethwan	HW-NAT	  EHCI			8192e	48K	N		EthWan
======================================================================================================================
RTL8685 
	8685_00		HW_NAT	  N			N	16K	N		Initial version on FPGA platform
	8685_01		HW_NAT	  EHCI			8192e	16K	N		Release to ZTE, xDSL
	8685_01_voip	HW_NAT	  EHCI			8192e	16K	Y		Based on 8685_01, add VoIP function
	8685_e8b	HW_NAT	  EHCT			8192e	16K	N		E8B
	8685_vtuo	Switch-only							VTUO Configuration
======================================================================================================================
RTL8685P 
	8685P_01	HW_NAT	  EHCI			8812+	16K	N		RTL8685 292Pin,Dual WiFi, Serdes
							8192e
	8685P_01_voip	HW_NAT	  EHCI			8812+	16K	Y		Based on 8685P_01, add VoIP function
							8192e
======================================================================================================================
RTL8685S
	8685S_01	HW_NAT	  EHCI					N		RTL8685S
	8685S_01_voip	HW_NAT	  EHCI					N		Based on 8685S_01_voip, add VoIP function
