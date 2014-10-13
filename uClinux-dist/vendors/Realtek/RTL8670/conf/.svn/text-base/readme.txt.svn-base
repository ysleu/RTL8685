Configurations
==============

1Pi - 1 Port using Internal MAC
4Pe - 4 Port (8306) using External MAC
OTG - OTG Host
EHCI - EHCI Host
8192su
8187su
8192ce
8192ceG : RX_BUFFER_GATHER is enabled
PP - Packet Processor
MS : Massive Storage support
PA : Preallocate SKB
Vo : VoIP support
BF : Bridge Fastpath
IPV6: Support IPV6
3G : Support USB 3G dongle
4M/16M : flash size/memory size is 4M/16M

Code	Ethernet  USB Controller	PP	WIFI	IMEM	Other
00	1Pi	  OTG+EHCI		N	8192su	32K	MS
01	4Pe	  EHCI			Y	8192su	32K	MS,PA
02	4Pe	  OTG			N	8192su	 4K	BF
03	4Pe	  OTG			N	8187su	 4K	
04	1Pi       OTG+EHCI              N       n/a     32K
05	4Pe	  EHCI			N	8192su	32K	MS,BF
06	4Pi	  EHCI			Y	8192su	32K	MS,PA,Vo
07      4Pe       OTG                   N       8192su  32K     BF
08	combo	  OTG	                N	N	4K			
09      4Pe       N/A                   N       8192ce  64K     PA,BF
10	4Pe	  OTG			N	8187su	 4K     IPV6
11  preconfig_09 + VoIP-1.4 = for rl6166 iad with Zarlink LE89116+LE89316(2S1O)
12  preconfig_09 + VoIP-1.4 = for rl6166 iad with Silab Si32176+Si32178(2S1O)
13	4Pe       OTG+EHCI              N       8192ce  64K     PA,BF,MS
14	preconfig_13 + ethwan + 3g = rl6166 iad(multi wan) with Zarlink(1S)
15	4Pe	  OTG+EHCI		N	8192ceG 64K	PA,BF,MS,3G,4M/16M

