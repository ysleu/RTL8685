#
# Makefile for the GoAhead web server reference source base
#  for the Linux OS
#
# Copyright (c) GoAhead Software, Inc. 1995-2000
#
# $Id: Makefile,v 1.106 2013/01/14 09:00:06 rubychou Exp $
#

ifndef UCLINUX_BUILD_USER
LIBCRYPT = -lcrypt
ifndef CONFIG_USE_RSDK_WRAPPER
LDFLAGS = -L. -L/lib
endif #CONFIG_USE_RSDK_WRAPPER
endif
all:	compile

WEB_SRC_DIR = form_src
WEB_LIB	= libwebs.a
MIB_LIB = libmib.a
MIB_LIB_SO = libmib.so
ifeq ($(CONFIG_USER_CLI),y)
CLI = cli
endif



ifndef CONFIG_USE_RSDK_WRAPPER
# Dick
ifdef NOT_IN_UCLINUX_DIST
CC = mips-uclibc-gcc
STRIP = mips-uclibc-strip
endif
endif #CONFIG_USE_RSDK_WRAPPER



# User Management switch
UMSW	= -DUSER_MANAGEMENT_SUPPORT

ifeq ($(ACTION),1)
RTFLAGS += -DAPPLY_CHANGE
endif

CONFIG_MMU = 1

ifdef CONFIG_MMU
RTFLAGS += -DCONFIG_MMU
FLASHDRV = rtl_flashdrv_mmu
else
FLASHDRV = rtl_flashdrv
endif

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
exec_y =

exec_$(CONFIG_USER_CLI)			+= cli
exec_$(CONFIG_USER_RTK_SYSLOG)		+= slogd
exec_$(CONFIG_USER_FON)			+= fonservice
ifneq ($(CONFIG_USER_XMLCONFIG),y)
exec_y					+= flash
endif
exec_y					+= startup qc ShowStatus configd saveconfig loadconfig mib

# MIB_DEPEND_FILES = mib.o mibtbl.o $(FLASHDRV).o utility.o adsl_drv.o debug.o arping.o ../msgutil.o sysconfig.o
MIB_DEPEND_FILES = $(FLASHDRV).o utility.o debug.o arping.o ../msgutil.o \
				   sysconfig.o lzss.o subr_dhcpv6.o subr_itfgroup.o subr_vlangroup.o subr_natlb.o

ifdef CONFIG_LUNA
ifdef CONFIG_RTK_RG_INIT
MIB_DEPEND_FILES += rtusr_gpon.o
MIB_DEPEND_FILES += rtusr_i2c.o
MIB_DEPEND_FILES += rtusr_intr.o
MIB_DEPEND_FILES += rtusr_ponmac.o
MIB_DEPEND_FILES += rtusr_port.o
MIB_DEPEND_FILES += rtusr_rate.o
MIB_DEPEND_FILES += rtusr_rg.o
MIB_DEPEND_FILES += rtusr_rldp.o
MIB_DEPEND_FILES += rtusr_stp.o
MIB_DEPEND_FILES += rtusr_stat.o
MIB_DEPEND_FILES += rtusr_switch.o
MIB_DEPEND_FILES += rtusr_trap.o
MIB_DEPEND_FILES += rtusr_rg_api.o
endif
endif

ifdef UCLINUX_BUILD_USER
ifndef CONFIG_LIB_LIBMD5_FORCE
MIB_DEPEND_FILES += ../md5.o
endif
else
MIB_DEPEND_FILES += ../md5.o
endif

obj2_y =

obj2_$(CONFIG_USER_XDSL_SLAVE)			+= subr_nfbi_api.o
obj2_$(CONFIG_DEV_xDSL)				+= adsl_drv.o
obj2_$(IP_QOS)					+= subr_qos.o
obj2_$(CONFIG_IPV6)				+= subr_ipv6.o
obj2_$(CONFIG_USER_IP_QOS_3)			+= subr_qos_3.o
obj2_$(CONFIG_USER_WIRELESS_TOOLS)		+= subr_wlan.o
obj2_$(CONFIG_NEW_PORTMAPPING)			+= subr_pmap.o

MIB_DEPEND_FILES += $(obj2_y)

startobj_y = startup.o
startobj_$(CONFIG_USER_FON)	+= start_fon.o
STARTUP_FILES = $(startobj_y)

ifdef CONFIG_USER_VSNTP
MIB_DEPEND_FILES += tz.o
endif

FLASH   = -DINCLUDE_DEFAULT_VALUE
RTFLAGS += -DNO_ACTION
WEBFLAG	= -DWEBS -DUEMF -DOS="LINUX" -DLINUX $(WLANSUPP) $(UMSW) $(DASW) \
	$(SSLSW) $(IFMODSW) $(RTFLAGS)
OTHERS	= -DB_STATS -DB_FILL -DDEBUG
#DEBUG	= -g -Wall
#DEBUG	=
DEBUG	= -D_DEBUG_MESSAGE
IFLAGS 	= -I..
#LDFLAGS	= $(SSLLIB) $(IFMODLIB)

ifeq ($(CONFIG_USER_RTK_VOIP),y)
#+++++add by Jack for VoIP project 20/03/07+++++
PWD := $(shell pwd)
TOPDIR := $(shell pwd)/../../../..
VOIP_APP = $(TOPDIR)/user/rtk_voip
-include ../../../../linux-2.4.x/.config
ifdef CONFIG_RTK_VOIP
# have VOIP support
FLASH_FILE = voip_flash.o voip_flash_mib.o voip_flash_tool.o voip_flash_server.o
MIB_DEPEND_FILES += $(FLASH_FILE)
CFLAGS += -DVOIP_SUPPORT -I$(VOIP_APP)/includes -I$(VOIP_APP)/web \
	-I$(PWD) -I$(PWD)/..
LDFLAGS += -L$(VOIP_APP)/voip_manager -lvoip_manager
endif

all:
ifdef CONFIG_RTK_VOIP
		make -C $(VOIP_APP)/web -f rtl867x.mak WEB_FLAGS='$(DEBUG) $(CFLAGS) $(IFLAGS)' WEB_DIR=$(TOPDIR)/romfs/home/httpd/web
endif
	@make compile
#-----end-----
endif

.PHONY: $(WEB_LIB)
#compile: cleanmib $(WEB_LIB) flash webpage startup
ifdef UCLINUX_BUILD_USER
compile: cleanmib $(WEB_LIB) $(MIB_LIB) $(exec_y)
else
compile: cleanmib $(WEB_LIB) $(MIB_LIB)
endif
#compile: cleanmib $(NAME) cleanmib flash
#compile: cleanmib $(NAME) webpage

#
#	Build archive of objects
#
$(WEB_LIB):
	cd $(WEB_SRC_DIR) && $(MAKE)

$(MIB_LIB): $(MIB_DEPEND_FILES)
	$(AR) $(ARFLAGS) $(MIB_LIB) $?
ifdef UCLINUX_BUILD_USER
	#$(LD) -shared --warn-common --warn-once -z combreloc -soname=$(MIB_LIB_SO).0 \
	#	-o $(MIB_LIB_SO) --whole-archive $(MIB_LIB)
	$(CC) -shared -Wl,-soname,$(MIB_LIB_SO).0 -o $(MIB_LIB_SO) $(MIB_LIB) $(MIB_DEPEND_FILES)
  ifdef CONFIG_USE_RSDK_WRAPPER
	install -m 644 $(MIB_LIB_SO) $(ROOTDIR)/lib/librtk/$(MIB_LIB_SO)
	install -m 644 $(MIB_LIB) $(ROOTDIR)/lib/librtk/$(MIB_LIB)
  else #CONFIG_USE_RSDK_WRAPPER
	install -m 644 $(MIB_LIB_SO) ../../../../uClibc/lib/$(MIB_LIB_SO)
  endif #CONFIG_USE_RSDK_WRAPPER
endif

#
#	Primary link
#
ifeq ($(CONFIG_USER_CLI),y)
ifeq ($(CONFIG_USER_MENU_CLI),y)
cli: climenu.o cli_utility.o $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -o cli \
		climenu.o cli_utility.o $(LIBCRYPT) $(LDFLAGS) -lpthread -lmib $(LIBMD5)
endif
#added by xl_yue
ifeq ($(CONFIG_USER_CMD_CLI),y)
cli: clicmd.o cfgutility.o cmdedit.o $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -o cli \
		clicmd.o cfgutility.o cmdedit.o $(LIBCRYPT) $(LDFLAGS) -lpthread -lmib $(LIBMD5)
endif
endif

mib: mibutil.c $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h mib.o mibtbl.o lzss.o $(MIB_LIB)
	$(CC) -c -o mibutil.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) mibutil.c
	$(CC) -o mib \
		mibutil.o mib.o mibtbl.o lzss.o $(LDFLAGS) -lmib

ifneq ($(CONFIG_USER_XMLCONFIG),y)
flash: flash.c $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h mib.o mibtbl.o lzss.o $(MIB_LIB)
	$(CC) -c -o flash.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) flash.c
	$(CC) -o flash \
		flash.o mib.o mibtbl.o lzss.o $(LDFLAGS) -lmib
endif

qc: qc.c mib.c mibtbl.c $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -c -o qc.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) qc.c
	$(CC) -o qc \
		qc.o $(LDFLAGS) -lmib

saveconfig: saveconfig.c $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -c -o saveconfig.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) saveconfig.c
	$(CC) -o saveconfig \
		saveconfig.o $(LDFLAGS) -lmib

loadconfig: loadconfig.c $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -c -o loadconfig.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) loadconfig.c
	$(CC) -o loadconfig \
		loadconfig.o $(LDFLAGS) -lmib

ShowStatus: ShowStatus.c mib.c mibtbl.c $(FLASHDRV).c mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -c -o ShowStatus.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) ShowStatus.c
	$(CC) -o ShowStatus \
		ShowStatus.o $(LDFLAGS) -lpthread -lmib

startup: Makefile $(STARTUP_FILES) mib.h mibtbl.h rtl_flashdrv.h $(MIB_LIB)
	$(CC) -o startup $(STARTUP_FILES) $(LDFLAGS) -lcrypt -lmib ${RTKLIB}
#	$(CC) -o startup startup.o $(LDFLAGS) -lcrypt libmib.a

configd: Makefile configd.c msgparser.c mib.o mibtbl.o lzss.o mib_reserve.o $(MIB_LIB)
	$(CC) -c -o configd.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) configd.c
	$(CC) -c -o msgparser.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) msgparser.c
	$(CC) -o configd \
		configd.o msgparser.o mib.o mibtbl.o lzss.o mib_reserve.o $(LDFLAGS) -lpthread -lmib

slogd: slogd.c
	$(CC) $(CFLAGS) -c -o slogd.o $(DEBUG) $(IFLAGS) slogd.c
	$(CC) $(LDFLAGS) -o slogd \
		slogd.o

webpage:
	rm webpages.bin -f
	find ../web -name "*.*" >web_files

fonservice: Makefile fonservice.c mib.h mibtbl.h $(MIB_LIB)
	$(CC) -c -o fonservice.o $(FLASH) $(DEBUG) $(CFLAGS) $(WEBFLAG) $(IFLAGS) fonservice.c
	$(CC) -o fonservice \
                fonservice.o $(LDFLAGS) -lmib

romfs:
	mkdir -p $(ROMFSDIR)/home/httpd
	$(ROMFSINST) ../web  /home/httpd/web
	$(ROMFSINST) ../web/graphics /home/httpd/web/admin/graphics
	$(ROMFSINST) ../web/menu-images /home/httpd/web/admin/menu-images
	$(ROMFSINST) -s /home/httpd/web/mtmcode.js  /home/httpd/web/admin/mtmcode.js
	$(ROMFSINST) -s /home/httpd/web/share.js  /home/httpd/web/admin/share.js
	$(ROMFSINST) -s /home/httpd/web/acl.asp  /home/httpd/web/admin/acl.asp
	$(ROMFSINST) -s /home/httpd/web/url_blocking.asp  /home/httpd/web/admin/url_blocking.asp
	$(ROMFSINST) -s /home/httpd/web/date.asp  /home/httpd/web/admin/date.asp
	$(ROMFSINST) -s /home/httpd/web/fw-macfilter.asp  /home/httpd/web/admin/fw-macfilter.asp
	$(ROMFSINST) -s /home/httpd/web/fw-macfilter_rg.asp  /home/httpd/web/admin/fw-macfilter_rg.asp
	$(ROMFSINST) -s /home/httpd/web/reboot.asp  /home/httpd/web/admin/reboot.asp
	$(ROMFSINST) -s /home/httpd/web/saveconf.asp  /home/httpd/web/admin/saveconf.asp
	$(ROMFSINST) -s /home/httpd/web/status.asp  /home/httpd/web/admin/status.asp
	$(ROMFSINST) -s /home/httpd/web/wanadsl.asp  /home/httpd/web/admin/wanadsl.asp
	$(ROMFSINST) -s /home/httpd/web/waneth.asp  /home/httpd/web/admin/waneth.asp
	$(ROMFSINST) -e CONFIG_IPV6 -s /home/httpd/web/status_ipv6.asp  /home/httpd/web/admin/status_ipv6.asp
	$(ROMFSINST) -s /home/httpd/web/title.html  /home/httpd/web/admin/title.html
	$(ROMFSINST) -s /home/httpd/web/upgrade.asp  /home/httpd/web/admin/upgrade.asp
	$(ROMFSINST) -s /home/httpd/web/upgrade2.asp  /home/httpd/web/admin/upgrade2.asp
	$(ROMFSINST) -s /home/httpd/web/upgrade3.asp  /home/httpd/web/admin/upgrade3.asp
	$(ROMFSINST) -s /home/httpd/web/wladvanced.asp  /home/httpd/web/admin/wladvanced.asp
	$(ROMFSINST) -s /home/httpd/web/wlbasic.asp  /home/httpd/web/admin/wlbasic.asp
	$(ROMFSINST) -s /home/httpd/web/wlstatbl.asp  /home/httpd/web/admin/wlstatbl.asp
	$(ROMFSINST) -s /home/httpd/web/wlwpa.asp  /home/httpd/web/admin/wlwpa.asp
	$(ROMFSINST) -s /home/httpd/web/wlactrl.asp  /home/httpd/web/admin/wlactrl.asp
	$(ROMFSINST) -e CONFIG_USER_WIRELESS_WDS -s /home/httpd/web/wlwds.asp  /home/httpd/web/admin/wlwds.asp
	$(ROMFSINST) -s /home/httpd/web/wlsurvey.asp  /home/httpd/web/admin/wlsurvey.asp
	$(ROMFSINST) -e CONFIG_WIFI_SIMPLE_CONFIG -s /home/httpd/web/wlwps.asp  /home/httpd/web/admin/wlwps.asp
	$(ROMFSINST) -s /home/httpd/web/wlwpa_mbssid.asp  /home/httpd/web/admin/wlwpa_mbssid.asp
	$(ROMFSINST) -s /home/httpd/web/wlstatus.asp  /home/httpd/web/admin/wlstatus.asp
	$(ROMFSINST) -s /home/httpd/web/wlbandmode.asp  /home/httpd/web/admin/wlbandmode.asp
	$(ROMFSINST) -s /home/httpd/web/wlmultipleap.asp  /home/httpd/web/admin/wlmultipleap.asp
	$(ROMFSINST) -s /home/httpd/web/wlfon.asp  /home/httpd/web/admin/wlfon.asp
	$(ROMFSINST) -s /home/httpd/web/wlstatbl_vap.asp  /home/httpd/web/admin/wlstatbl_vap.asp
	$(ROMFSINST) -s /home/httpd/web/graphics/del.gif  /home/httpd/web/admin/graphics/del.gif
	$(ROMFSINST) -s /home/httpd/web/graphics/edit.gif  /home/httpd/web/admin/graphics/edit.gif
	$(ROMFSINST) -s /home/httpd/web/graphics/topbar.gif  /home/httpd/web/admin/graphics/topbar.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_bar.gif  /home/httpd/web/admin/menu-images/menu_bar.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_corner.gif  /home/httpd/web/admin/menu-images/menu_corner.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_corner_minus.gif  /home/httpd/web/admin/menu-images/menu_corner_minus.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_corner_plus.gif  /home/httpd/web/admin/menu-images/menu_corner_plus.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_folder_closed.gif  /home/httpd/web/admin/menu-images/menu_folder_closed.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_folder_open.gif  /home/httpd/web/admin/menu-images/menu_folder_open.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_link_default.gif  /home/httpd/web/admin/menu-images/menu_link_default.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_pixel.gif  /home/httpd/web/admin/menu-images/menu_pixel.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_root.gif  /home/httpd/web/admin/menu-images/menu_root.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_tee.gif  /home/httpd/web/admin/menu-images/menu_tee.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_tee_minus.gif  /home/httpd/web/admin/menu-images/menu_tee_minus.gif
	$(ROMFSINST) -s /home/httpd/web/menu-images/menu_tee_plus.gif  /home/httpd/web/admin/menu-images/menu_tee_plus.gif
	$(ROMFSINST) -s /home/httpd/web/wan3gconf.asp  /home/httpd/web/admin/wan3gconf.asp
	$(ROMFSINST) -s /home/httpd/web/multi_wanptm.asp /home/httpd/web/admin/multi_wanptm.asp


	$(ROMFSINST) /bin/startup
#	$(ROMFSINST) -e CONFIG_USER_MENU_CLI /bin/cli
##added by xl_yue for supporting menu_cli and command_cli
	$(ROMFSINST) -e CONFIG_USER_CLI /bin/cli
ifneq ($(CONFIG_USER_XMLCONFIG),y)
	$(ROMFSINST) /bin/flash
endif
	$(ROMFSINST) /bin/mib
	$(ROMFSINST) /bin/qc
	$(ROMFSINST) /bin/ShowStatus
	$(ROMFSINST) /bin/qc
	$(ROMFSINST) /bin/saveconfig
	$(ROMFSINST) /bin/loadconfig
	$(ROMFSINST) /bin/configd
	$(ROMFSINST) -e CONFIG_USER_RTK_SYSLOG /bin/slogd
	$(ROMFSINST) -e CONFIG_USER_FON /bin/fonservice
	$(ROMFSINST) /lib/libmib.so
  ifdef CONFIG_USE_RSDK_WRAPPER
	$(ROMFSINST) -s libmib.so /lib/libmib.so.0
  else #CONFIG_USE_RSDK_WRAPPER
	$(ROMFSINST) -s /lib/libmib.so /lib/libmib.so.0
  endif #CONFIG_USE_RSDK_WRAPPER
	rm -f $(ROMFSDIR)/web/*.bak
	rm -f $(ROMFSDIR)/web/admin/*.bak

clean:
ifdef CONFIG_USE_RSDK_WRAPPER
	rm -rf $(ROOTDIR)/lib/librtk/$(MIB_LIB_SO)
	rm -rf $(ROOTDIR)/lib/librtk/$(MIB_LIB)
endif #CONFIG_USE_RSDK_WRAPPER
ifeq ($(CONFIG_USER_RTK_VOIP),y)
	rm -f $(WEB_LIB) $(MIB_LIB) $(MIB_LIB_SO) flash \
		webpages.bin startup cli qc \
		saveconfig loadconfig \
		ShowStatus configd slogd *.gdb $(FLASH_FILE) libflashlib.a

	make -C $(VOIP_APP)/web -f rtl867x.mak clean WEB_DIR=$(TOPDIR)/romfs/home/httpd/web
else
	rm -f $(WEB_LIB) $(MIB_LIB) $(MIB_LIB_SO) flash \
		webpages.bin startup cli qc \
		saveconfig loadconfig \
		ShowStatus configd slogd *.gdb
endif
ifdef CONFIG_USER_FON
	rm -f fonservice
endif

cleanall:
	rm -f *.o

cleanmib:
	rm -f flash.o mib.o mibtbl.o lzss.o $(FLASHDRV).o flash

#
#	Dependencies
#
../asp.o:  ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../balloc.o: ../balloc.c ../uemf.h

../base64.o:  ../base64.c ../webs.h ../wsIntrn.h  ../ej.h ../ejIntrn.h ../uemf.h

../cgi.o:  ../webs.h ../wsIntrn.h ../uemf.h

../default.o:  ../default.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../ejlex.o:  ../ejlex.c ../ej.h ../ejIntrn.h ../uemf.h

../ejparse.o:  ../ejparse.c ../ej.h ../ejIntrn.h ../uemf.h

../emfdb.o:  ../emfdb.h ../wsIntrn.h ../uemf.h

../form.o:  ../form.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../h.o:  ../h.c ../uemf.h

../handler.o:  ../handler.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../md5c.o:  ../md5.h ../wsIntrn.h ../uemf.h

../mime.o:  ../mime.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../misc.o:  ../misc.c ../uemf.h

../page.o:  ../page.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../ringq.o:  ../ringq.c ../uemf.h

../rom.o:  ../rom.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../msgutil.o: ../msgutil.c ../uemf.h

../security.o:  ../security.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../sock.o:  ../sock.c ../uemf.h

../sockGen.o:  ../sockGen.c ../uemf.h

../sym.o:  ../sym.c ../uemf.h

../uemf.o:  ../uemf.c ../uemf.h

../um.o:  ../webs.h ../wsIntrn.h ../um.h ../uemf.h

../umui.o:  ../webs.h ../wsIntrn.h ../um.h ../uemf.h

../url.o:  ../url.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../value.o:  ../value.c ../uemf.h

../webrom.o:  ../webrom.c ../webs.h ../wsIntrn.h ../uemf.h

../webs.o:  ../webs.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../websda.o:  ../webs.h ../wsIntrn.h ../websda.h ../uemf.h

../websuemf.o:  ../websuemf.c ../webs.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

../websSSL.o:  ../websSSL.c ../websSSL.h ../wsIntrn.h ../ej.h ../ejIntrn.h ../uemf.h

$(MIB_DEPEND_FILES): options.h

ifdef CONFIG_LUNA
ifdef CONFIG_RTK_RG_INIT
#FIXME: -DDO_NOT_USE_LOG10 use to avoid link -lm when other apps use libmib.so
rtusr_ponmac.o: CFLAGS += -DDO_NOT_USE_LOG10
rtusr_rg.o rtusr_i2c.o rtusr_intr.o rtusr_gpon.o rtusr_ponmac.o rtusr_port.o rtusr_rate.o rtusr_rldp.o rtusr_stat.o rtusr_stp.o rtusr_switch.o rtusr_trap.o: CFLAGS += -DCONFIG_RTK_L34_ENABLE=1 -DCONFIG_GPON_VERSION=2
rtusr_rg.o rtusr_i2c.o rtusr_intr.o rtusr_gpon.o rtusr_ponmac.o rtusr_port.o rtusr_rate.o rtusr_rldp.o rtusr_stat.o rtusr_stp.o rtusr_switch.o rtusr_trap.o: CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver

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
RTKLIB += -L$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/object/src/app/lib -lrtk -lpthread
else
ifdef  CONFIG_EPON_FEATURE
CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver
RTKLIB += -L$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/object/src/app/lib -lrtk -lpthread
endif
endif


mibtbl.o: mibtbl.c mib.h

lzss.o:lzss.c

mib.o: mib.c lzss.c mib.h

ifdef CONFIG_LUNA
ifdef CONFIG_RTK_RG_INIT
rtusr_rg_api.o:CFLAGS += -I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/linux \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/sdk/system/include \
-I$(ROOTDIR)/linux-2.6.x/drivers/net/rtl86900/romeDriver

endif

#rtusr_rg_api.c : rtusr_rg_api.o rtusr_rg_api.h
endif

ifdef CONFIG_USER_XDSL_SLAVE
SUBR_NFBI_API_DEP = $(ROOTDIR)/user/rtl867x_nfbi/ucd/uc_mib.c \
                    $(ROOTDIR)/user/rtl867x_nfbi/ucd/uc_mib.h \
                    $(ROOTDIR)/user/rtl867x_nfbi/ucd/uc_udp.c \
                    $(ROOTDIR)/user/rtl867x_nfbi/ucd/uc_udp.h
subr_nfbi_api.o: subr_nfbi_api.c subr_nfbi_api.h $(SUBR_NFBI_API_DEP)
endif #CONFIG_USER_XDSL_SLAVE

utility.o:utility.c utility.h

climenu.o:climenu.c
cli_utility.o:cli_utility.c cli_utility.h

ifeq ($(CONFIG_USER_CMD_CLI),y)
clicmd.o:clicmd.c
cfgutility.o:cfgutility.c cfgutility.h
cmdedit.o:cmdedit.c
endif

debug.o:debug.c debug.h

$(FLASHDRV).o:$(FLASHDRV).c rtl_types.h rtl_board.h rtl_flashdrv.h

#genscript_ui.o:genscript_ui.c

adsl_drv.o:adsl_drv.c

msgparser.o:msgparser.c

startup.o:startup.c mibtbl.h

arping.o:arping.c utility.h

sysconfig.o:sysconfig.c sysconfig.h ../msgq.h mibtbl.h ../../../../config/autoconf.h

mib_reserve.o:mib_reserve.c mib_reserve.h mib.h mibtbl.h

ShowStatus.o: ShowStatus.c

ifdef CONFIG_USER_WIRELESS_TOOLS
subr_wlan.o:subr_wlan.c
endif

ifeq ($(CONFIG_USER_RTK_VOIP),y)
#+++++add by Jack for VoIP project 20/03/07+++++
voip_flash.o: $(VOIP_APP)/flash/voip_flash.c $(VOIP_APP)/includes/voip_flash.h
	$(CC) -c -o $@ $(DEBUG) $(FLASH) $(CFLAGS) $(WEBFLAG) $(IFLAGS) $<

voip_flash_mib.o: $(VOIP_APP)/flash/voip_flash_mib.c $(VOIP_APP)/includes/voip_flash_mib.h
	$(CC) -c -o $@ $(DEBUG) $(FLASH) $(CFLAGS) $(WEBFLAG) $(IFLAGS) $<

voip_flash_tool.o: $(VOIP_APP)/flash/voip_flash_tool.c $(VOIP_APP)/includes/voip_flash_tool.h
	$(CC) -c -o $@ $(DEBUG) $(FLASH) $(CFLAGS) $(WEBFLAG) $(IFLAGS) $<

voip_flash_server.o: $(VOIP_APP)/flash/voip_flash_server.c $(VOIP_APP)/includes/voip_flash.h
	$(CC) -c -o $@ $(DEBUG) $(FLASH) $(CFLAGS) $(WEBFLAG) $(IFLAGS) $<
#-----end-----
endif

#flash_ui.o:flash_ui.c

#
#	Transition rules (add -o to put object in right directory)
#
.c.o: $(ROOTDIR)/include/linux/autoconf.h
	$(CC) -c -o $@ $(DEBUG) $(FLASH) $(CFLAGS) $(WEBFLAG) $(IFLAGS) $<
