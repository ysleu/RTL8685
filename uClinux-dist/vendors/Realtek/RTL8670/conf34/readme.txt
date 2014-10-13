Linux 3.4.x Configurations
==================================================================================================================
NIC -- 	1Pi 	: 1 Port using Internal MAC
	4Pe 	: 4 Port (8306) using External MAC
	HW_NAT
	Serdes
USB -- 	OTG 	: OTG Host
	EHCI 	: EHCI Host
WiFi - 	8192ce
	8192ceG 
	8192e
	8812
VoIP -
xDSL -	ADSL
	VDSL
	Both(ADSL + VDSL)

==================================================================================================================
IC	Preconfig	Ethernet	USB 	WIFI		xDSL	VoIP	Other	
==================================================================================================================
RTL8685 
	01		HW_NAT 		EHCI	8192e		Both	N	RTL8685 176Pin, single WiFi
	01_voip		HW_NAT 		EHCI	8192e		Both	Y	Based on 01, add VoIP function
	02_voip		HW_NAT 		EHCT	8192e		Both	Y	Based on 01, add by DarrenShiue
==================================================================================================================
RTL8685P 
	8685P_01	HW_NAT+Serdes	EHCI	8812+8192e	Both	N	RTL8685 292Pin,Dual WiFi, Serdes
	8685P_01_voip	HW_NAT+Serdes	EHCI	8812+8192e	Both	Y	Based on 8685P_01, add VoIP function
