#include <stdlib.h>

/* multilang_*.c must be sync'ed to have the same content with different languages */

const char *const values[] = {
/* code.asp */
"Site contents",

"Status",
"Device",
"IPv6",

"LAN",

"WLAN",
"Band Mode",
"wlan0 (5GHz)",
"wlan1 (2.4GHz)",
"Basic Settings",
"Advanced Settings",
"Security",
"Access Control",
"WDS",
"Site Survey",
"WPS",
"MBSSID",
"WAPI",
"Certification Installation",

"WAN",
"Ethernet WAN",
"DSL WAN",
"ATM Settings",
"ADSL Settings",
"3G Settings",
"VPN",
"PPTP",
"L2TP",
"IPIP",

"Services",
"DHCP",
"DHCPv6",
"DNS",
"DNS Server",
"Dynamic DNS",
"Firewall",
"ALG",
"IP/Port Filtering",
"MAC Filtering",
"Port Forwarding",
"URL Blocking",
"Domain Blocking",
"Parental Control",
"Connection Limit",
"NAT IP Forwarding",
"Port Triggering",
"DMZ",
"NAT Rule Configuration",
"MLD",
"MLD Proxy",
"MLD Snooping",
"IGMP Proxy",
"UPnP",
"RIP",
"Landing Page",
"DMS",

"VoIP",
"Port1",
"Port2",
"FXO",
"Tone",
"Ring",
"Other",
"Config",

"Advance",
"ARP Table",
"Bridging",
"Routing",
"SNMP",
"Port Mapping",
"DiffServ",
"IP QoS",
"Classification",
"QoS Queue",
"QoS Policy",
"QoS Classification",
"Traffic Shaping",
"Link Mode",
"Remote Access",
"RADVD",
"Print Server",
"Others",

"Diagnostics",
"Ping",
"Packet Dump",
"ATM Loopback",
"ADSL Tone",
"ADSL Connection",

"Admin",
"Finish Maintenance",
"Commit/Reboot",
"Backup/Restore",
"Logout",
"System Log",
"DOS",
"User Account",
"Password",
"Firmware Upgrade",
"ACL",
"Time Zone",
"Auto-Provisionning",
"TR-069",

"Statistics",
"Interface",
"ADSL",

/* status.asp */
"Router Status",
"This page shows the current status and some basic settings of the device.",
"System",
"Alias",
"Uptime",
"Date",
"Time",
"Firmware Version",
"DSP Version",
"DSP Slave Version",
"Name Servers",
"Default Gateway",
"Operational Status",
"Upstream Speed",
"Downstream Speed",
" Configuration",
"IP Address",
"Subnet Mask",
"Server",
"MAC Address",
"VPI/VCI",
"Encapsulation",
"Protocol",
"Gateway",
"Disconnect",
"Connect",

/* status_ipv6.asp */
"This page shows the current system status of IPv6.",
"IPv6 Address",
"IPv6 Link-Local Address",
"Prefix Delegation",
"Prefix",

/* tcpiplan.asp */
"LAN Interface Settings",
"This page is used to configure the LAN interface of your Router. Here you may change the setting for IP addresses, subnet mask, etc..",
"Secondary IP",
"DHCP Pool",
"IGMP Snooping",
"Ethernet to Wireless Blocking",

/* wlbasic.asp */
"WLAN Basic Settings",
"This page is used to configure the parameters for WLAN clients which may connect to your Access Point. Here you may change wireless encryption settings as well as wireless network parameters.",
"Disable WLAN Interface",
"Band",
"Mode",
"SSID",
"Channel Width",
"Control Sideband",
"Channel Number",
"Radio Power (mW)",
"Associated Clients",
"Show Active WLAN Clients",
"Apply Changes",

/* wlstatbl.asp */
"Active WLAN Clients",
"This table shows the MAC address, transmission, reception packet counters and encrypted status for each associated WLAN clients.",
"Tx Packets",
"Rx Packets",
"Tx Rate (Mbps)",
"Power Saving",
"Expired Time (sec)",

/* wladvanced.asp */
"WLAN Advanced Settings",
"These settings are only for more technically advanced users who have a sufficient knowledge about WLAN. These settings should not be changed unless you know what effect the changes will have on your Access Point.",
"Fragment Threshold",
"RTS Threshold",
"Beacon Interval",
"Data Rate",
"Auto",
"Tx Operation Rate",
"Tx Basic Rate",
"DTIM Period",
"IAPP",
"Preamble Type",
"Long Preamble",
"Short Preamble",
"Broadcast",
"Enabled",
"Disabled",
"Relay Blocking",
"Protection",
"Aggregation",
"Short GI",
"WMM Support",

/* wlwpa.asp */
"WLAN Security Settings",
"This page allows you setup the WLAN security. Turn on WEP or WPA by using Encryption Keys could prevent any unauthorized access to your wireless network.",
"Encryption",
"Authentication",
"Open System",
"Shared Key",
"Key Length",
"Key Format",
"Encryption Key",
"Authentication Mode",
"Cipher Suite",
"Pre-Shared Key Format",
"Pre-Shared Key",
"Port",
"Use Local AS Server",

/* wlactrl.asp */
"WLAN Access Control",
"If you choose 'Allowed Listed', only those WLAN clients whose MAC addresses are in the access control list will be able to connect to your Access Point. When 'Deny Listed' is selected, these WLAN clients on the list will not be able to connect the Access Point.",
"Allow Listed",
"Deny Listed",
"Add",
"Reset",
"Current Access Control List",
"Delete Selected",
"Delete All",
"Select",

/* wlwps.asp */
"Wi-Fi Protected Setup",
"This page allows you to change the setting for WPS (Wi-Fi Protected Setup). Using this feature could let your WLAN client automically syncronize its setting and connect to the Access Point in a minute without any hassle.",
"Disable WPS",
"Configured",
"UnConfigured",
"Auto-lock-down state",
"Locked",
"Unlocked",
"Unlock",
"Self-PIN Number",
"Regenerate PIN",
"Configuration",
"Start PIN",
"Push Button",
"Start PBC",
"Current Key Info",
"Key",
"Client PIN Number",

/* wlmbssid.asp */
"WLAN Multiple BSSID Settings",
"Blocking between VAP",
"Disable",
"Enable",

/* wlstatus.asp */
"WLAN Status",
"This page shows the WLAN current status.",
"State",
"Virtual AP",
"Repeater Interface",

/* multi_waneth.asp */
"This page is used to configure the parameters for Ethernet WAN of your Router.",
"WAN Mode",
"Connection Type",
"Enable VLAN",
"VLAN",
"Channel Mode",
"Enable NAPT",
"Enable IGMP",
"Default Route",
"Admin Status",
"PPP Settings",
"Type",
"Idle Time (sec)",
"Authentication Method",
"AC-Name",
"Service-Name",
"Obtain default gateway automatically",
"Use the following default gateway",
"Use Remote WAN IP Address",
"Use WAN Interface",
"WAN Setting",
"Address Mode",
"Enable DHCPv6 Client",
"Request Options",
"Request Address",
"Request Prefix",
"Delete",
"WAN IP Settings",
"Local",
"Unnumbered",

/* multi_wanptm.asp */
"PTM WAN",
"This page is used to configure the parameters for PTM WAN of your Router.",

/* wanadsl.asp */
"This page is used to configure the parameters for DSL WAN of your Router.",
"Current ATM VC Table",
"Current Auto-PVC Table",
"Table",
"Modify",
"Remote",
"Enable Auto-PVC Search",
"Apply",
"",

/* wanatm.asp */
"This page is used to configure the parameters for the ATM of your Router. Here you may change the setting for VPI, VCI, QoS etc ...",
"Undo",

/* wan3gconf.asp */
"This page is used to configure the parameters for your 3G network access.",
"PIN Code",
"APN",
"Dial Number",
"Connection Type",
"Backup for ADSL",
"Backup Timer (sec)",

/* dhcpd.asp */
"DHCP Settings",
"This page is used to configure DHCP Server and DHCP Relay.",
"None",
"Relay",
"This page is used to configure the DHCP Server IP Address for DHCP Relay.",
"Enable the DHCP Server if you are using this device as a DHCP server. This page lists the IP address pools available to hosts on your LAN. The device distributes numbers in the pool to hosts on your network as they request Internet access.",
"IP Pool Range",
"Show Client",
"Max Lease Time",
"seconds",
"-1 indicates an infinite lease",
"Gateway Address",
"MAC-Based Assignment",
"Port-Based Filter",
"This page is used to configure the Port-Based Filtering.",
"Filter DHCP Discover packet",


/* dns.asp */
"This page is used to configure the DNS Server IP addresses.",
"Attain DNS Automatically",
"Set DNS Manually",
"WAN Interface Binding",

/* ddns.asp */
"Dynamic",
"This page is used to configure the Dynamic DNS address from DynDNS.org or TZO. Here you can Add/Remove to configure Dynamic DNS.",
"Provider",
"Hostname",
"Settings",
"Email",
"Remove",
"Service",

/* fw-ipportfilter.asp */
"Filtering",
"Entries in this table are used to restrict certain types of data packets through the Gateway. Use of such filters can be helpful in securing or restricting your local network.",
"Outgoing Default Action",
"Deny",
"Allow",
"Incoming Default Action",
"Direction",
"Outgoing",
"Incoming",
"Rule Action",
"Source",
"Destination",
"Current Filter Table",
"Source Port",
"Destination Port",

/* fw-macfilter.asp */
"Entries in this table are used to restrict certain types of data packets from your local network to Internet through the Gateway.  Use of such filters can be helpful in securing or restricting your local network.",

/* fw-portfw.asp */
"Entries in this table allow you to automatically redirect common network services to a specific machine behind the NAT firewall. These settings are only necessary if you wish to host some sort of server like a web server or mail server on the private local network behind your Gateway's NAT firewall.",
"Both",
"Comment",
"Local Port",
"Public Port",
"Any",
"Current Port Forwarding Table",
"Remote Host",

/* url_blocking.asp */
"Blocking",
"This page is used to configure the Blocked FQDN(Such as tw.yahoo.com) and filtered keyword. Here you can add/delete FQDN and filtered keyword.",
"FQDN",
" Table",
"Keyword",
"Keyword Filtering Table",
"Filtered Keyword",

/* domainblk.asp */
"This page is used to configure the Blocked domain. Here you can add/delete the blocked domain.",
"Domain",

/* fw-dmz.asp */
"A Demilitarized Zone is used to provide Internet services without sacrificing unauthorized access to its local private network. Typically, the DMZ host contains devices accessible to Internet traffic, such as Web (HTTP) servers, FTP servers, SMTP (e-mail) servers and DNS servers.",
"DMZ Host",

/* app_mldProxy.asp */
"This page be used to configure MLD Proxy.",
"WAN Interface",

/* app_mld_snooping.asp */
"This page be used to configure MLD Snooping.",

/* upnp.asp */
"This page is used to configure UPnP. The system acts as a daemon when you enable it and select WAN interface (upstream) that will use UPnP.",

/* rip.asp */
"Enable the RIP if you are using this device as a RIP-enabled Router to communicate with others using the Routing Information Protocol. This page is used to select the interfaces on your device is that use RIP, and the version of the protocol used.",
"Receive Mode",
"Send Mode",
"RIP Config Table",

/* arptable.asp */
"This table shows a list of learned MAC addresses.",
"Refresh",

/* bridging.asp */
"This page is used to configure the bridge parameters. Here you can change the settings or view some information on the bridge and its attached ports.",
"Ageing Time",
"Spanning Tree",
"Show MACs",

/* routing.asp */
"This page is used to configure the routing information. Here you can add/delete IP routes.",
"Next Hop",
"Metric",
"Add Route",
"Update",
"Show Routes",
"Static Route Table",

/* rmtacc.asp */
"This page is used to enable/disable management services for the LAN and WAN.",
"WAN Port",

/* radvdconf.asp */
"This page is used to setup the RADVD's configuration of your Router.",
"MaxRtrAdvInterval",
"MinRtrAdvInterval",
"AdvCurHopLimit",
"AdvDefaultLifetime",
"AdvReachableTime",
"AdvRetransTimer",
"AdvLinkMTU",
"AdvSendAdvert",
"AdvManagedFlag",
"AdvOtherConfigFlag",
"Prefix Mode",
"Manual",
"Prefix Length",
"AdvValidLifetime",
"AdvPreferredLifetime",
"AdvOnLink",
"AdvAutonomous",

/* others.asp */
"Other Advanced",
"Here you can set some other advanced settings.",
"IP PassThrough",
"Lease Time",
"Allow LAN access",

/* ping.asp */
"This page is used to send ICMP ECHO_REQUEST packets to network host. The diagnostic result will then be displayed.",
"Host Address",
"Go",

/* oamloopback.asp */
"ATM Loopback Diagnostics",
"Connectivity Verification",
"Connectivity verification is supported by the use of the ATM OAM loopback capability for both VP and VC connections. This page is used to perform the VCC loopback function to check the connectivity of the VCC.",
"Flow Type",
"F5 Segment",
"F5 End-to-End",
"Loopback Location ID",

/* adsl-diag.asp */
"ADSL Tone Diagnostics",
"ADSL Tone Diagnostics. Only ADSL2/2+ support this function.",
"DSL Tone Diagnostics",
"DSL Tone Diagnostics. Only ADSL2/ADSL2+/VDSL2 support this function.",
"ADSL Slave Tone Diagnostics",
"ADSL Slave Tone Diagnostics. Only ADSL2/2+ support this function.",
"DSL Slave Tone Diagnostics",
"DSL Slave Tone Diagnostics. Only ADSL2/ADSL2+/VDSL2 support this function.",
"Start",
"Downstream",
"Upstream",
"Loop Attenuation",
"Signal Attenuation",
"Hlin Scale",
"SNR Margin",
"Attainable Rate",
"Output Power",
"Tone Number",
"H.Real",
"H.Image",
"SNR",
"QLN",
"Hlog",

/* diag-test.asp */
"ADSL Connection Diagnostics",
"The Router is capable of testing your connection. The individual tests are listed below. If a test displays a fail status, click 'Go' button again to make sure the fail status is consistent.",
"Select the ADSL Connection",

/* finishmaintenance.asp */
"This page is used to inform ITMS that maintenance is finished, and then ITMS may change this gateway's password.",

/* reboot.asp */
"Commit and Reboot",
"This page is used to commit changes to system memory and reboot your system.",

/* saveconf.asp */
"Backup and Restore Settings",
"Choose File",
"This page allows you to backup current settings to a file or restore the settings from the file which was saved previously. Besides, you could reset the current settings to factory default.",
"Backup Settings to File",
"Backup Default Settings to File",
"Backup Hardware Settings to File",
"Backup",
"Restore Settings from File",
"Restore",
"Reset Settings to Default",

/* password.asp */
"This page is used to set the account to access the web server of your Router. Empty user name and password will disable the protection.",
"Old Password",
"New Password",
"Confirmed Password",

/* upgrade.asp */
"This page allows you upgrade the firmware to the newer version. Please note that do not power off the device during the upload because this make the system unbootable.",
"Upgrade",

/* acl.asp */
"This page is used to configure the IP Address for Access Control List. If ACL is enabled, only the IP address in the ACL Table can access CPE. Here you can add/delete the IP Address.",
"Capability",

/* tz.asp */
"You can maintain the system time by synchronizing with a public time server over the Internet.",
"Current Time",
"Time Zone Select",
"Enable Daylight Saving Time",
"Enable SNTP Client Update",
"Manual Setting",
"Yes",
"No",

/* tr069config.asp */
"This page is used to configure the TR-069 CPE. Here you may change the setting for the ACS's parameters.",
"WAN Interface",
"Periodic Inform",
"Periodic Inform Interval",
"Connection Request",
"Path",
"Certificate Management",
"Certificate Password",
"Certificate",
"Upload",

/* stats.asp */
"Interface Statisitcs",
"This page shows the packet statistics for transmission and reception regarding to network interface.",
"Reset Statistics",

/* adsl-stats.asp */
"ADSL Statistics",
"DSL Statistics",
"ADSL Slave Statistics",
"DSL Slave Statistics",

/* algonoff.asp */
"On-Off",
"This page is used to enable/disable ALG services.",

/* parental-ctrl.asp */
"Entries in this table are used to restrict access to Internet from your local PCs/devices by mac address and time interval. Use of such filters can be helpful for parents to control children's usage of Internet.",
"Sun",
"Mon",
"Tue",
"Wed",
"Thu",
"Fri",
"Sat",
"End",
"Controlled Days",
"Start Blocking time",
"End Blocking time",
"Current Parent Control Table",

/* connlimit.asp */
"Max Ports",
"Entries in this table allow you to limit the number of TCP/UDP ports used by internal users.",
"Global",
"0 for no limit",
"Max Limitation Ports",
"Current Connection Limit Table",

/* fw-ipfw.asp */
"Entries in this table allow you to automatically redirect traffic to a specific machine behind the NAT firewall. These settings are only necessary if you wish to host some sort of server like a web server or mail server on the private local network behind your Gateway's NAT firewall.",
"External",
"Current NAT IP Forwarding Table",

/* gaming.asp */
"Port Triggering",
"Select Game",
"Game Rules List",
"Checked",
"Port to Open",

/* multi_addr_mapping.asp */
"Address Mapping Rule",
"This page is used to set and configure the Address Mapping Rule for your device.",
"The maximum number of entries are 16.",
"One-to-One",
"Many-to-One",
"Many-to-Many Overload",
"One-to-Many",
"Local Start IP",
"Local End IP",
"Global Start IP",
"Global End IP",
"Current Address Mapping Table",

/* ipqos_sc.asp */
"Outbound Iterface",
"Type of Servie (TOS)",
"Precedence",
"Entries in this table are used to assign the precedence for each incoming packet. If disable IP QoS, traffic shaping will be effective, otherwise traffic shaping is invalid.",
"Policy",
"Specify Traffic Classification Rules",
"Source Mask",
"Destination Mask",
"Physical Port",
"Assign Priority and/or IP Precedence and/or Type of Service and/or DSCP",
"Outbound Priority",
"Rules",

/* ipqos_shape.asp */
"Entries in this table are used for traffic control.",
"Total Bandwidth Limit",
"Rate",
"Apply Total Bandwidth Limit",

/* ipqos.asp */
"Configuration of classification table for IPQoS.",
"Netmask",
"Classification Results",
"ClassQueue",
"Rules",

/* ipqos_queue.asp */
"Description",
"Queue Key",
"RemoveQueue",
"SaveAndReboot",
"Queue Config List",
"Queue Description",
"Queue Status",
"Click to Select",
"Queue Interface",
"Queue Priority",
"Cancel",

/* net_qos_imq_policy.asp */
"Queue Config",
"This page is used to configure the QoS policy and Queue. If select PRIO of policy, the lower numbers imply greater precedence. If select WRR of policy, please input the weight of this queue. Default is 40:30:20:10. After configration, please click 'Apply Changes'",
"PRIO",
"WRR",
"Queue",
"Priority",

/* net_qos_cls.asp */
"This page is used to add or delete classicification rule.",
"After add a new rule, please click 'Apply Changes' to take effect.",
"Classification Rules",
"Mark",
"ID",
"Name",
"Mask",
"Edit",
"Version",

/* net_qos_traffictl.asp */
"Cancel Total Bandwidth Limit",

/* pptp.asp */
"This page is used to configure the parameters for PPTP mode VPN.",
"Action",

/* l2tp.asp */
"This page is used to configure the parameters for L2TP mode VPN.",
"Tunnel Authentication",
"Tunnel Authentication Secret",
"Persistent",
"Dial-on-Demand",
"Challenge",
"On",
"Off",

/* ipip.asp */
"This page is used to configure the parameters for IPIP mode VPN.",

/* wlwapiinstallcert.asp */
"This page allows you to install ASU and user certification for your Router. Please note, certification type X.509 is supported at present.",
"Certification",

/* wlwds.asp */
"Wireless Distribution System uses wireless media to communicate with other APs, like the Ethernet does. To do this, you must set these APs in the same channel and set MAC address of other APs which you want to communicate with in the table and then enable the WDS.",
"Set Security",
"Show Statistics",
"Current WDS AP List",

/* wlsurvey.asp */
"WLAN Site Survey",
"This page provides tool to scan the wireless network. If any Access Point or IBSS is found, you could choose to connect it manually when client mode is enabled.",
"Signal",
"Channel",

/* adsl-set.asp */
"This page is used to configure the parameters for the bands of your Router.",
"Modulation",
"Option",
"Note: Only ADSL 2 supports AnnexL",
"Note: Only ADSL 2/2+ support AnnexM",
"Tone Mask",
"PSD Mask",
"PSD Measurement Mode",
"DSL Settings",

/* adsltone.asp */
"This page let user to mark the designate tones to be masked.",
"Mask All",
"Unmask All",
"Close",

/* adslpsd.asp */
"This page let user to set PSD Mask.",
"Tone",

/* wlbandmode.asp */
"Wireless Band Mode",
"This page is used to switch 802.11n single-band or dual-band radio frequency.",
"Signle Band",
"This mode can support single mode by 2x2.",
"Dual Band",
"This mode can simultaneously support 802.11 a/b/g/n wireless network connection.",

/* dhcpmode.asp */
"This page is used to set and configure the Dynamic Host Configuration Protocol mode for your router. With DHCP, IP addresses for your LAN are administered and distributed as needed by this device or an ISP device.",

/* dhcpd_sc.asp */
"IP Range",

/* dhcpdv6.asp */
"This page is used to configure the upper interface (server link) for DHCPv6 Relay.",
"Upper Interface",
"Enable the DHCPv6 Server if you are using this device as a DHCPv6 server. This page lists the IP address pools available to hosts on your LAN. The device distributes numbers in the pool to hosts on your network as they request Internet access.",
"Valid Lifetime",
"Preferred Lifetime",
"Renew Time",
"Rebind Time",
"Client",
"Domain Search Table",
"Name Server",
"Name Server Table",
"Auto Config by Prefix Delegation for DHCPv6 Server.",
"This page is used to configure DHCPv6 Server and DHCPv6 Relay.",

/* igmproxy.asp */
"IGMP proxy enables the system to issue IGMP host messages on behalf of hosts that the system discovered through standard IGMP interfaces. The system acts as a proxy for its hosts when you enable it by doing the follows",
"Enable IGMP proxy on WAN interface (upstream), which connects to a router running IGMP.",
"Enable IGMP on LAN interface (downstream), which connects to its hosts.",
"Proxy Interface",

/* landing.asp */
"This page is used to configure the time interval of Landing Page.",
"Time Interval",

/* dms.asp */
"Digital Media Server Settings",
"This page is used to configure the parameters for your Digital Media Server.",
"Digital Media Server",

/* snmp.asp */
"This page is used to configure the SNMP. Here you may change the settings for system description, trap ip address, community name, etc..",
"System Description",
"System Contact",
"System Location",
"System Object ID",
"Trap IP Address",
"Community name (read-only)",
"Community name (write-only)",

/* eth2pvc.asp */
"To manipulate a mapping group",
"Select a group from the table.",
"Select interfaces from the available/grouped interface list and add it to the grouped/available interface list using the arrow buttons to manipulate the required mapping of the ports.",
"Click 'Apply Changes' button to save the changes.",
"Note that the selected interfaces will be removed from their existing groups and added to the new group.",
"Grouped Interfaces",
"Available Interfaces",

/* diffserv.asp */
"Differentiated Services",
"Entries in this table are used to assign the precedence for each incoming packet based on TCP/UDP port number, source/destination IP address/subnet masks.",
"PHB Groups",
"Rate Limit",
"Min",
"Max",
"Max Desired Latency",

/* linkmode.asp */
"Ethernet Link Speed/Duplex Mode",
"Half Mode",
"Full Mode",
"Auto Mode",
"Set the Ethernet link speed/duplex mode.",

/* printServer.asp */
"This page is used to show printer URL(s).",
"Printer",

/* net_qos_traffictl_edit.asp */
"Add IP QoS Traffic Shaping Rule",
"Source Prefix Length",
"Destination Prefix Length",
"Uplink Rate",

/* pdump.asp */
"This page is used to start or stop a Wireshark packet capture.",
"You need to return to this page to Stop it.",
"Click here for the documentation of the additional arguments.",
"Additional Arguments",
"Stop",

/* logout.asp */
"This page is used to logout from the Router.",

/* user-password.asp */
"Login User",

/* login.asp */
"Input username and password",
"Login",

/* title.asp */
"Router WebServer",

/* net_qos_cls_edit.asp */
"Add IP QoS Classification Rules",
"Please select IP version",
"This page is used to add a IP QoS classification rule.",
"Rule",
"Assign",
"Please specify",
"Or",

/* wlwdsenp.asp */
"WDS Security Settings",
"This page allows you setup the WLAN security for WDS. When enabled, you must make sure each WDS device has adopted the same encryption algorithm and Key.",

/* wlwdstbl.asp */
"This table shows the MAC address, transmission, reception packet counters and state information for each configured WDS AP.",
"Tx Errors",

/* macIptbl.asp */
"This page is used to configure the static IP base on MAC Address. You can assign/delete the static IP. The Host MAC Address, please input a string with hex number. Such as ",
"Assigned IP Address",
"Delete Assigned IP",

/* date.asp */
"System Date & Time Modification",
"Set the system date and time.",
"Submit",

/* userconfig.asp */
"This page is used to add user account to access the web server of the Router. Empty user name or password is not allowed.",
"Privilege",
"User",
"Support",

/* dhcptbl.asp */
"Active DHCP Clients",
"This table shows the assigned IP address, MAC address and time expired for each DHCP leased client.",

/* devicetbl.asp */
" Name",
"This page is used to configure the IP address range based on device type.",
"Start Address",
"End Address",
"Gateway address",
"Option60",
"Device Type",
"PC",
"Camera",
"HGW",
"STB",
"Phone",
"Unknown",
"Reserved Option",
"Option String",
"DNS1",
"DNS2",

/* syslog.asp */
"Log Level",
"Display Level",
"Save Log to File",
"Save",
"Clear Log",
"Facility",
"Level",
"Message",

/* qos_pred.asp */
"IP Precedence Priority Settings",
"This page is used to config IP precedence priority.",
"IP Precedence Rule",

/* fdbtbl.asp */
"Bridge Forwarding Database",
"This table shows a list of learned MAC addresses for this bridge.",
"Port No",
"Is Local",
"Ageing Timer",

/* dos.asp */
"DoS (Denial-of-Service) attack which is launched by hacker aims to prevent legal user from taking normal services. In this page you can configure to prevent some kinds of DOS attack.",
"Enable DoS Block",
"Select All",
"Clear",
"Enable Source IP Blocking",
"Block Interval",

/* portfw-advance.asp */
"Category",
"Available Rules",
"Applied Rules",
"Port Forwarding Advance Table",

/* routetbl.asp */
"IP Route Table",
"This table shows a list of destination routes commonly accessed by your network.",

/* toupgrade.asp */
"The System is Rebooting into Upgrade Mode.....",
"Close the DSL Router Configuration Window and wait for 2 minutes before reopening your web browser.",

/* from Javascript code */
};

const size_t nr_values = sizeof(values) / sizeof(values[0]);

