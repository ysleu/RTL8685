#
#	Makefile -- Build instructions for Realtek/RTL8670
#
ifdef CONFIG_BOA_WEB_E8B_CH
CONFIGPATH=$(shell pwd)/e8b
else
CONFIGPATH=$(shell pwd)
endif
include $(ROOTDIR)/$(LINUXDIR)/.config
ROMFSIMG = $(IMAGEDIR)/romfs.img
IMAGE    = $(IMAGEDIR)/image.bin
ifdef CONFIG_ROMFS_FS
	DEVCMD = for i in $(DEVICES); do \
			touch $(ROMFSDIR)/dev/@$$i; \
		done
	ROMFS_DIRS = bin dev etc home lib mnt proc usr var etc/scripts 
else
	DEVCMD =
	ROMFS_DIRS = bin etc home lib mnt proc usr var etc/scripts 

ifdef CONFIG_USER_FLATFSD_XXX
	ROMFS_DIRS += etc/default
endif

endif

ifeq ($(CONFIG_RTL8686_IPC_DEV),y)
ROMFS_DIRS = bin dev etc home lib proc usr var etc/scripts usr/local usr/local/ct image 
else
ROMFS_DIRS = bin dev etc home lib proc usr var etc/scripts usr/local usr/local/ct
endif

ROMFS_DIRS += sys

DEVICES = \
	tty,c,5,0      console,c,5,1      cua0,c,5,64      cua1,c,5,65  \
	\
	mem,c,1,1      kmem,c,1,2         null,c,1,3       ram0,b,1,0 \
	ram1,b,1,1 \
	\
	ptyp0,c,2,0    ptyp1,c,2,1        ptyp2,c,2,2      ptyp3,c,2,3 \
	ptyp4,c,2,4    ptyp5,c,2,5        ptyp6,c,2,6      ptyp7,c,2,7 \
	ptyp8,c,2,8    ptyp9,c,2,9        ptypa,c,2,10     ptypb,c,2,11 \
	ptypc,c,2,12   ptypd,c,2,13       ptype,c,2,14     ptypf,c,2,15 \
	\
	rom0,b,31,0    rom1,b,31,1        rom2,b,31,2      rom3,b,31,3 \
	rom4,b,31,4    rom5,b,31,5        rom6,b,31,6      rom7,b,31,7 \
	rom8,b,31,8    rom9,b,31,9 \
	\
	tty0,c,4,0     tty1,c,4,1         tty2,c,4,2       tty3,c,4,3 \
	ttyS0,c,4,64   ttyS1,c,4,65 \
	\
	ttyp0,c,3,0    ttyp1,c,3,1        ttyp2,c,3,2      ttyp3,c,3,3 \
	ttyp4,c,3,4    ttyp5,c,3,5        ttyp6,c,3,6      ttyp7,c,3,7 \
	ttyp8,c,3,8    ttyp9,c,3,9        ttypa,c,3,10     ttypb,c,3,11 \
	ttypc,c,3,12   ttypd,c,3,13       ttype,c,3,14     ttypf,c,3,15 \
	\
	mtd0,c,90,0    mtd1,c,90,1        mtd2,c,90,2      mtd3,c,90,3 \
	\
	zero,c,1,5     random,c,1,8       urandom,c,1,9    ppp,c,108,0 \
	\
	adsl0,c,100,0  wlchr,c,13,0 \
	\
	aipc_dev,c,254,0  dsp_console,c,253,0



clean:


mkromfsdir:
	[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)
	for i in $(ROMFS_DIRS); do \
		[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)/$$i; \
	done


romfs:
	[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)
	for i in $(ROMFS_DIRS); do \
		[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)/$$i; \
	done
	$(DEVCMD)
	$(ROMFSINST) -s /var/tmp /tmp
	$(ROMFSINST) -s /var/mnt /mnt
	$(ROMFSINST) -s /bin /sbin
	$(ROMFSINST) -s /var/ppp /etc/ppp
	$(ROMFSINST) -s /var/config /etc/config
	$(ROMFSINST) -s /var/passwd /etc/passwd
	$(ROMFSINST) -s /var/TZ /etc/TZ
	$(ROMFSINST) $(CONFIGPATH)/rc-first /etc/rc-first
	$(ROMFSINST) -e CONFIG_YAFFS_FS -a "mkdir -p /var/config" /etc/rc-first
	$(ROMFSINST) -e CONFIG_YAFFS_FS -a "mount -t yaffs2 -o inband-tags /dev/mtdblock1 /var/config/" /etc/rc-first
	$(ROMFSINST) -e CONFIG_YAFFS_FS -a "mkdir -p /var/config/mib" /etc/rc-first
#	$(ROMFSINST) -e CONFIG_YAFFS_FS -a "mount -t yaffs -o tags-ecc-off /dev/mtdblock2 /var/media/" /etc/rc-first
	$(ROMFSINST) -e CONFIG_USER_XMLCONFIG /etc/config_default_hs.xml
	$(ROMFSINST) -e CONFIG_USER_XMLCONFIG /etc/config_default.xml
ifdef CONFIG_DEFAULTS_KERNEL_2_6
ifdef CONFIG_SPANSION_16M_FLASH
	$(ROMFSINST) $(CONFIGPATH)/rc-16m-2.6.x /etc/rc
else
	$(ROMFSINST) $(CONFIGPATH)/rc-2.6.x /etc/rc
endif

ifdef CONFIG_LUNA_DUAL_LINUX 
ifndef CONFIG_ARCH_LUNA_SLAVE	
ifeq ($(CONFIG_RTK_VOIP),y)
	$(ROMFSINST) -a /etc/rc_dev_voip    /etc/rc
endif
	$(ROMFSINST) -a "echo 'Bootup Slave CPU'" /etc/rc
	$(ROMFSINST) -a "/etc/rc_boot_dual_linux" /etc/rc
	$(ROMFSINST) -a "mkdir -p /tmp/slave" /etc/rc
endif
endif

	$(ROMFSINST) -a "echo 200 > /proc/sys/net/core/netdev_max_backlog" /etc/rc
	$(ROMFSINST) -a "echo 600 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established" /etc/rc
else 
ifdef CONFIG_DEFAULTS_KERNEL_3_4
	$(ROMFSINST) $(CONFIGPATH)/rc-3.4.x /etc/rc
else
	$(ROMFSINST) /etc/rc  
endif
endif

ifndef CONFIG_LUNA_DUAL_LINUX 
ifeq ($(CONFIG_RTK_VOIP),y)
	$(ROMFSINST) -a /etc/rc_dev_voip    /etc/rc
endif
endif

ifdef CONFIG_USER_WT_146
	$(ROMFSINST) -a "mkdir -p /var/bfd/" /etc/rc
endif
	$(ROMFSINST) -a "/bin/mount -t sysfs sysfs /sys" /etc/rc-first

ifndef CONFIG_ARCH_LUNA_SLAVE
	$(ROMFSINST) -a "/bin/echo /sbin/mdev > /proc/sys/kernel/hotplug" /etc/rc-first
endif
	$(ROMFSINST) -a "/bin/mount -t tmpfs mdev /dev" /etc/rc-first
ifndef CONFIG_ARCH_LUNA_SLAVE
	$(ROMFSINST) -a "/bin/mknod /dev/adsl0 c 100 0" /etc/rc-first
endif
	$(ROMFSINST) mdev.conf /etc/mdev.conf
	$(ROMFSINST) -a "mdev -s" /etc/rc-first
ifdef CONFIG_USER_SAMBA
	$(ROMFSINST) -s /var/group /etc/group
	$(ROMFSINST) -a "mkdir -p /var/samba/" /etc/rc
endif
ifdef CONFIG_JFFS2_FS
ifdef CONFIG_BOA_WEB_E8B_CH
	$(ROMFSINST) -a "mount -t jffs2 /dev/mtdblock7 /usr/local/ct" /etc/rc
endif
endif

ifeq ($(CONFIG_RTK_VOIP),y)
#ifeq ($(CONFIG_RTL8686_IPC_DEV),y)
	$(ROMFSINST) /etc/rc_dev_voip
#endif
endif

ifdef CONFIG_8M_SDRAM
#	$(ROMFSINST) -a "echo 256 > /proc/sys/net/ipv4/ip_conntrack_max" /etc/rc
	$(ROMFSINST) -a "echo 768 > /proc/sys/net/ipv4/route/max_size" /etc/rc
	$(ROMFSINST) -a "echo 256 > /proc/sys/net/ipv4/route/gc_thresh" /etc/rc
	$(ROMFSINST) -a "echo 1 > /proc/sys/net/ipv4/route/gc_elasticity" /etc/rc
	$(ROMFSINST) -a "echo 60 > /proc/sys/net/ipv4/route/gc_interval" /etc/rc
	$(ROMFSINST) -a "echo 20 > /proc/sys/net/ipv4/route/gc_timeout" /etc/rc
else
  ifdef CONFIG_MEM_LIMITATION
	$(ROMFSINST) -a "echo 1500 > /proc/sys/net/ipv4/route/max_size" /etc/rc
	$(ROMFSINST) -a "echo 1500 > /proc/sys/net/ipv4/inet_peer_threshold" /etc/rc
	$(ROMFSINST) -a "echo 20 > /proc/sys/net/ipv4/inet_peer_minttl" /etc/rc
	$(ROMFSINST) -a "echo 60 > /proc/sys/net/ipv4/inet_peer_maxttl" /etc/rc
	$(ROMFSINST) -a "echo 50 > /proc/sys/net/ipv4/netfilter/ip_conntrack_generic_timeout" /etc/rc
  endif
endif
	$(ROMFSINST) -a "echo 10 > /proc/sys/net/ipv4/tcp_keepalive_intvl" /etc/rc
	$(ROMFSINST) -a "echo 3 > /proc/sys/net/ipv4/tcp_keepalive_probes" /etc/rc
	$(ROMFSINST) -a "echo 10 > /proc/sys/net/ipv4/tcp_keepalive_time" /etc/rc
ifeq ($(CONFIG_RTK_VOIP),y)
	$(ROMFSINST) -a "echo 16384 > /proc/sys/kernel/msgmax" /etc/rc
	$(ROMFSINST) -a "echo 24576 > /proc/sys/kernel/msgmnb" /etc/rc
endif
	# Added by Mason Yu. for DHCPv6
ifdef CONFIG_USER_DHCPV6_ISC_DHCP411
	$(ROMFSINST) -a "cp /etc/dhclient-script /var/dhclient-script" /etc/rc
	$(ROMFSINST) -a "mkdir -p /var/db/" /etc/rc	
endif
	# Added by Mason Yu.
ifdef CONFIG_IPV6
	$(ROMFSINST) -a "echo 2 > /proc/sys/net/ipv6/conf/default/accept_dad" /etc/rc
endif		
ifdef CONFIG_BOA_WEB_E8B_CH
	$(ROMFSINST) -a "echo 200 > /proc/sys/vm/dirty_writeback_centisecs" /etc/rc
	$(ROMFSINST) -a "echo 200 > /proc/sys/vm/dirty_expire_centisecs" /etc/rc
endif
ifdef CONFIG_USER_FLATFSD_XXX
	$(ROMFSINST) -a "/bin/flatfsd -r" /etc/rc
endif
ifdef CONFIG_USER_BOA_SRC_BOA
	$(ROMFSINST) -a "configd&" /etc/rc
	$(ROMFSINST) -e CONFIG_USER_XMLCONFIG -a "/etc/scripts/config_xmlconfig.sh -b" /etc/rc
	$(ROMFSINST) -a "startup&" /etc/rc		
endif #CONFIG_USER_BOA_SRC_BOA
ifdef CONFIG_USER_NFBI_SLAVE
	$(ROMFSINST) -a "/bin/ucd&" /etc/rc
endif	
ifeq ($(CONFIG_RTK_VOIP),y)
ifdef CONFIG_BOA_WEB_E8B_CH
	$(ROMFSINST) /etc/rc_rcmvoip
	$(ROMFSINST) -a "/etc/rc_rcmvoip" /etc/rc
else
ifeq ($(CONFIG_RTL8686_IPC_DEV),y)
ifeq ($(CONFIG_RTL8686_IPC_DUAL_LINUX),y)
	$(ROMFSINST) rc_voip.dual_linux   /etc/rc_voip
else
	$(ROMFSINST) rc_voip.aipc     /etc/rc_voip
endif
	$(ROMFSINST) -a "/etc/rc_voip&" /etc/rc
ifeq ($(CONFIG_RTL8686_IPC_DSP_CONSOLE),y)
	$(ROMFSINST) /etc/rc_dsp_console
	$(ROMFSINST) -a "/etc/rc_dsp_console" /etc/rc
	$(ROMFSINST) -a "tcp2dev /dev/dsp_console:5432 &" /etc/rc
endif
else
	$(ROMFSINST) /etc/rc_voip	
	$(ROMFSINST) -a "/etc/rc_voip" /etc/rc
endif
endif
endif
	#$(ROMFSINST) /etc/inittab
	rm -f $(ROMFSDIR)/etc/inittab
ifndef CONFIG_ARCH_LUNA_SLAVE
ifeq ($(CONFIG_USER_INETD_INETD),y)
	echo "inet:unknown:/bin/inetd" >> $(ROMFSDIR)/etc/inittab
endif
ifeq ($(CONFIG_USER_LOGIN_LOGIN),y)
	echo "console:unknown:/bin/login -p" >> $(ROMFSDIR)/etc/inittab
else
##ifeq ($(CONFIG_USER_MENU_CLI),y)
ifeq ($(CONFIG_USER_CLI),y)
	echo "console:unknown:/bin/cli -c" >> $(ROMFSDIR)/etc/inittab
else
	echo "console:unknown:/bin/sh" >> $(ROMFSDIR)/etc/inittab
endif
endif
else
	mkdir -p $(ROMFSDIR)/etc
	cat inittab_slave > $(ROMFSDIR)/etc/inittab
endif
	$(ROMFSINST) /etc/shells
#	$(ROMFSINST) scripts/init.sh /etc/scripts/init.sh
#	$(ROMFSINST) scripts/init-if.sh /etc/scripts/init-if.sh
#	$(ROMFSINST) scripts/init-wan.sh /etc/scripts/init-wan.sh
#	$(ROMFSINST) scripts/adsl-ppp-start.sh /etc/scripts/adsl-ppp-start.sh
#	$(ROMFSINST) scripts/adsl-ppp-close.sh /etc/scripts/adsl-ppp-close.sh
#	$(ROMFSINST) scripts/init-br.sh /etc/scripts/init-br.sh
	
#	$(ROMFSINST) scripts/dhcpc.sh /etc/scripts/dhcpc.sh
ifeq ($(CONFIG_USER_UDHCP099PRE2),y)
	$(ROMFSINST) scripts/udhcpc2.sh /etc/scripts/udhcpc.sh
else
	$(ROMFSINST) scripts/udhcpc.sh /etc/scripts/udhcpc.sh
endif
#	$(ROMFSINST) scripts/udhcpc.bound /etc/scripts/udhcpc.bound
	$(ROMFSINST) scripts/udhcpc.deconfig /etc/scripts/udhcpc.deconfig
#	$(ROMFSINST) scripts/dhcpd.sh /etc/scripts/dhcpd.sh
	
#	$(ROMFSINST) scripts/firewall.sh /etc/scripts/firewall.sh
#	$(ROMFSINST) scripts/dnsmasq.sh /etc/scripts/dnsmasq.sh
#	$(ROMFSINST) scripts/zebra.sh /etc/scripts/zebra.sh
	
	$(ROMFSINST) services /etc/services
	case "$(LINUXDIR)" in \
	*2.4.*) ;; \
	*2.6.*) ;; \
	*3.*) ;; \
	*) echo "ttyS0:linux:/bin/sh" >> $(ROMFSDIR)/etc/inittab ;; \
	esac
	$(ROMFSINST) /etc/motd
#	$(ROMFSINST) /bin/busybox
#	$(ROMFSINST) -s /bin/busybox /bin/telnet
#	$(ROMFSINST) -s /bin/busybox /bin/route
#	$(ROMFSINST) -s /bin/busybox /bin/ping
#	$(ROMFSINST) -s /bin/busybox /bin/tftp
#	$(ROMFSINST) -s /bin/busybox /bin/reboot
#	$(ROMFSINST) -s /bin/busybox /bin/uptime
#	$(ROMFSINST) -s /bin/busybox /bin/ifconfig
#	$(ROMFSINST) /etc/passwd
#	$(ROMFSINST) /etc/termcap
#	$(ROMFSINST) /etc/mime.types
#	$(ROMFSINST) /www/index.html
#	$(ROMFSINST) /etc/config/boa.conf
	echo "$(VERSIONSTR) -- " `date` > $(ROMFSDIR)/etc/version
ifdef CONFIG_DEFAULTS_KERNEL_2_6
	$(ROMFSINST) ethertypes /etc/ethertypes
endif
ifdef CONFIG_USER_CUPS
	$(ROMFSINST) -a "mkdir -p /var/cups/" /etc/rc
	$(ROMFSINST) -a "mkdir -p /var/cups/conf/" /etc/rc
	$(ROMFSINST) -a "mkdir -p /var/cups/requests/" /etc/rc
	$(ROMFSINST) -a "mkdir -p /var/cups/filter/" /etc/rc
	$(ROMFSINST) -a "mkdir -p /var/cups/jobs/" /etc/rc
	$(ROMFSINST) -a "cp /etc/cups/conf/* /var/cups/conf/" /etc/rc
endif
	$(ROMFSINST) /etc/profile
ifneq ("$(CONFIG_KERNEL_2_6_30)$(CONFIG_DEFAULTS_KERNEL_3_4)","")
	cat squashfs-pf.in > squashfs-pf.list
	mkdir -p $(ROMFSDIR)/dev/misc
	mkdir -p $(ROMFSDIR)/dev/voip
	$(ROMFSINST) -s /tmp/log /dev/log
endif	

.PHONY: rcX
rcX:
	mkdir -p $(ROMFSDIR)/etc/init.d
	$(ROMFSINST) /etc/init.d/rcS

dev:
ifdef CONFIG_SQUASHFS
	[ -d $(ROMFSDIR) ] || mkdir -p $(ROMFSDIR)
	[ -d $(ROMFSDIR)/dev ] || mkdir -p $(ROMFSDIR)/dev
	rm $(ROMFSDIR)/dev/*
	for i in $(DEVICES); do \
		name=`echo $$i |cut -d"," -f1`;\
		type=`echo $$i |cut -d"," -f2`;\
		major=`echo $$i |cut -d"," -f3`;\
		minor=`echo $$i |cut -d"," -f4`;\
		mknod -m644 $(ROMFSDIR)/dev/$$name $$type $$major $$minor;\
	done
endif

image:
	[ -d $(IMAGEDIR) ] || mkdir -p $(IMAGEDIR)
	genromfs -v -V "ROMdisk" -f $(ROMFSIMG) -d $(ROMFSDIR)
	$(CROSS_COMPILE)objcopy -O binary --remove-section=.romvec \
			--remove-section=.text --remove-section=.ramvec \
			--remove-secti/on=.init \
			--remove-section=.bss --remove-section=.eram \
			$(ROOTDIR)/$(LINUXDIR)/linux $(IMAGEDIR)/linux.data
	$(CROSS_COMPILE)objcopy -O binary --remove-section=.ramvec \
			--remove-section=.bss --remove-section=.data \
			--remove-section=.eram \
			--set-section-flags=.romvec=CONTENTS,ALLOC,LOAD,READONLY,CODE \
			$(ROOTDIR)/$(LINUXDIR)/linux $(IMAGEDIR)/linux.text
	cat $(IMAGEDIR)/linux.text $(IMAGEDIR)/linux.data $(ROMFSIMG) > $(IMAGE)
	[ -n "$(NO_BUILD_INTO_TFTPBOOT)" ] || cp $(IMAGE) /tftpboot

