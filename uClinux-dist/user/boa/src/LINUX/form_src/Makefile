#
# Makefile for the web server form/asp functions
#  for the Linux OS
#
#
#

all:	compile

WEB_LIB	= ../libwebs.a

# User Management switch
UMSW	= -DUSER_MANAGEMENT_SUPPORT

# Digest Access switch
#DASW	= -DDIGEST_ACCESS_SUPPORT

# SSL switches (enable all to activate)
# SSLINC = /RSASSL/library/include
# SSLLIB = /RSASSL/library/lib/libsslc.a
# SSLSW	= -DWEBS_SSL_SUPPORT -I$(SSLINC)
# SSLPATCHFILE = ../websSSL.o

# If-Modified-Support switches (requires math library, libm.a)
# IFMODSW = -DWEBS_IF_MODIFIED_SUPPORT
# IFMODLIB = /usr/lib/libm.a

# Dependencies
DEPEND_FILES = fmget.o fmtcpip.o fmfwall.o fmfwall_v6.o fmmgmt.o \
		  fmwan.o fmbridge.o fmroute.o fmdns.o \
		  fmcapture.o \
		  fmping.o fmreboot.o \
		  fmoamlb.o fmdhcpv6.o fmigmproxy.o \
		  fmothers.o fmstatus.o fmupnp.o fmdiagtest.o\
		  fmeth2pvc.o fmeth2pvc_vlan.o fmqos.o fmacc.o fmacl.o fmdomainblk.o fmurl.o fmddns.o \
		  fmmenucreate.o fmmenucreate_user.o boamain.o fmlink.o fmalgonoff.o fmaddressmap.o

obj_y =

obj_$(CONFIG_USER_PPTP_CLIENT_PPTP)		+= fmvpn.o
obj_$(CONFIG_USER_L2TPD_L2TPD)			+= fmvpn.o
obj_$(CONFIG_NET_IPIP)				+= fmvpn.o
obj_$(CONFIG_XFRM)				+= fmvpn.o
obj_$(CONFIG_USER_MINIDLNA)			+= fmdms.o
obj_$(CONFIG_USER_CUPS)				+= fmPrtServer.o
obj_$(CONFIG_USER_SAMBA)			+= fmsamba.o
obj_$(CONFIG_USER_PPPOMODEM)			+= fm3g.o
obj_$(CONFIG_GPON_FEATURE)			+= fmstatus_pon.o
obj_$(CONFIG_EPON_FEATURE)			+= fmstatus_pon.o

obj_$(CONFIG_GPON_FEATURE)			+= fmgpon.o
obj_$(CONFIG_EPON_FEATURE)			+= fmepon.o
obj_$(CONFIG_USER_CWMP_TR069)			+= fmtr069.o
obj_$(CONFIG_USER_RADVD)			+= fmradvd.o
obj_$(CONFIG_USER_WIRELESS_TOOLS)		+= fmwlstatus.o fmwlan.o
obj_$(CONFIG_IPV6)				+= fmstatus_ipv6.o fmmldproxy.o fmipv6.o
obj_$(CONFIG_USER_IP_QOS_3)			+= fmqos_3.o
obj_$(CONFIG_INIT_SCRIPTS) += fmInitScripts.o
obj_$(CONFIG_USER_DOT1AG_UTILS) += fmdot1ag.o
obj_$(CONFIG_USER_DHCP_SERVER) += fmdhcpd.o fmdhcrelay.o fmdhcpmode.o fmmacbase.o fmiprange.o
obj_$(CONFIG_USER_BOA_WITH_MULTILANG)		+= multilang.o multilang_keys.o
obj_$(CONFIG_USER_BOA_WITH_MULTILANG_ZH_TW)	+= multilang_zh_TW.o
obj_$(CONFIG_APACHE_FELIX_FRAMEWORK)		+= fmosgi.o

DEPEND_FILES += $(obj_y)

RTFLAGS += -DNO_ACTION
WEBFLAG	= -DWEBS -DUEMF -DOS="LINUX" -DLINUX $(WLANSUPP) $(UMSW) $(DASW) \
	$(SSLSW) $(IFMODSW) $(RTFLAGS)
OTHERS	= -DB_STATS -DB_FILL -DDEBUG
#DEBUG	= -g -Wall
#DEBUG	=
DEBUG	= -D_DEBUG_MESSAGE
IFLAGS 	= -I.. -I../..
#LDFLAGS	= $(SSLLIB) $(IFMODLIB)

compile: $(WEB_LIB)

#
#	Build archive of objects
#
$(WEB_LIB): $(DEPEND_FILES)
	$(AR) $(ARFLAGS) $(WEB_LIB) $?

#
#	Primary link
#

romfs:

clean:
	rm -f $(WEB_LIB)

cleanall:
	rm -f *.o

#
#	Dependencies
#

$(DEPEND_FILES): ../options.h

ifdef CONFIG_LUNA
ifdef CONFIG_RTK_RG_INIT
#FIXME: -DDO_NOT_USE_LOG10 use to avoid link -lm when other apps use libmib.so
boamain.o : CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
											-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
											-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
											-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver
fmtcpip.o : CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
											-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
											-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
											-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver
endif
endif

ifdef CONFIG_GPON_FEATURE
CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver
else
ifdef  CONFIG_EPON_FEATURE
CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver
endif
endif

fmget.o: fmget.c

fmtcpip.o: fmtcpip.c

fmfwall.o: fmfwall.c

fmfwall_v6.o: fmfwall_v6.c

fmmgmt.o:fmmgmt.c

fmwan.o:fmwan.c

fmbridge.o:fmbridge.c

fmroute.o:fmroute.c

fmacl.o:fmacl.c

fmurl.o:fmurl.c

fmdhcrelay.o:fmdhcrelay.c
#added by xl_yue
fmmenucreate.o:fmmenucreate.c
#added by xl_yue
fmmenucreate_user.o:fmmenucreate_user.c

fmdhcpmode.o:fmdhcpmode.c

fmdhcpd.o:fmdhcpd.c

fmdhcpv6.o:fmdhcpv6.c

fmiprange.o:fmiprange.c

fmdns.o:fmdns.c

fmcapture.o:fmcapture.c

fmping.o:fmping.c

fmoamlb.o:fmoamlb.c

fmreboot.o:fmreboot.c

fmigmproxy.o:fmigmproxy.c

fmothers.o:fmothers.c

fmstatus.o:fmstatus.c

fmdiagtest.o: fmdiagtest.c

ifdef CONFIG_USER_WIRELESS_TOOLS
fmwlan.o:fmwlan.c
endif

ifdef CONFIG_USER_CUPS
fmPrtServer.o:fmPrtServer.c
endif

ifdef CONFIG_USER_PPPOMODEM
fm3g.o:fm3g.c
endif

ifdef CONFIG_USER_CWMP_TR069
fmtr069.o:fmtr069.c
endif

ifdef CONFIG_INIT_SCRIPTS
fmInitScripts.o:fmInitScripts.c
endif

#
#	Transition rules (add -o to put object in right directory)
#
.c.o: $(ROOTDIR)/include/linux/autoconf.h
	$(CC) -c -o $@ $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) $<
