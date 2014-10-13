############################################################################

#
# Makefile -- Top level uClinux makefile.
#
# Copyright (c) 2001-2002, SnapGear (www.snapgear.com)
# Copyright (c) 2001, Lineo
#

############################################################################
#
# Lets work out what the user wants, and if they have configured us yet
#

ifeq (.config,$(wildcard .config))
include .config

all: subdirs romfs modules modules_install image
else
all: config_error
endif

############################################################################
#
# Software Version
#
ifeq ($(CONFIG_LINUXDIR),linux-2.6.x)
VERSIONPKG = 2.0.1
else
VERSIONPKG = 1.4.1-RC
endif
#VERSIONSTR = $(CONFIG_VENDOR)/$(CONFIG_PRODUCT) Version $(VERSIONPKG)
VERSIONSTR = $(VERSIONPKG)


############################################################################
#
# Get the core stuff worked out
#

LINUXDIR = $(CONFIG_LINUXDIR)
ifndef CONFIG_USE_RSDK_WRAPPER
LIBCDIR  = $(CONFIG_LIBCDIR)
endif #CONFIG_USE_RSDK_WRAPPER
ROOTDIR  = $(shell pwd)
PATH	 := $(PATH):$(ROOTDIR)/tools
HOSTCC   = unset GCC_EXEC_PREFIX; cc
IMAGEDIR = $(ROOTDIR)/images
ROMFSDIR = $(ROOTDIR)/romfs
ROMFSINST= romfs-inst.sh
SCRIPTSDIR = $(ROOTDIR)/config/scripts
TFTPDIR    = /tftpboot
#Added by Mason Yu. for ipv6
BUSYBOXDIR = $(ROOTDIR)/user/busybox-1.12.4

LINUX_CONFIG  = $(ROOTDIR)/$(LINUXDIR)/.config
CONFIG_CONFIG = $(ROOTDIR)/config/.config
MODULES_CONFIG = $(ROOTDIR)/modules/.config

CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

ifeq (config.arch,$(wildcard config.arch))
include config.arch
ARCH_CONFIG = $(ROOTDIR)/config.arch
export ARCH_CONFIG
endif



ifdef CONFIG_USE_RSDK_WRAPPER
	MAKEARCH = $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
  ifdef CONFIG_KERNEL_2_6_30
	MAKEARCH_KERNEL = $(MAKE) ARCH=rlx CROSS_COMPILE=$(CROSS_KERNEL_COMPILE)
  else #CONFIG_KERNEL_2_6_30
	MAKEARCH_KERNEL = $(MAKEARCH)
  endif #CONFIG_KERNEL_2_6_30
else #CONFIG_USE_RSDK_WRAPPER
ifneq ($(SUBARCH),)
# Using UML, so make the kernel and non-kernel with different ARCHs
MAKEARCH = $(MAKE) ARCH=$(SUBARCH) CROSS_COMPILE=$(CROSS_COMPILE)
MAKEARCH_KERNEL = $(MAKE) ARCH=$(ARCH) SUBARCH=$(SUBARCH) CROSS_COMPILE=$(CROSS_COMPILE)
else
MAKEARCH = $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
MAKEARCH_KERNEL = $(MAKEARCH)
endif
endif #CONFIG_USE_RSDK_WRAPPER



DIRS    = $(VENDOR_TOPDIRS) lib user
VENDDIR = $(ROOTDIR)/vendors/$(CONFIG_VENDOR)/$(CONFIG_PRODUCT)/.

export VENDOR PRODUCT ROOTDIR LINUXDIR HOSTCC CONFIG_SHELL
export CONFIG_CONFIG LINUX_CONFIG ROMFSDIR SCRIPTSDIR
export VERSIONPKG VERSIONSTR ROMFSINST PATH IMAGEDIR TFTPDIR

############################################################################

#
# Config stuff,  we recall ourselves to load the new config.arch before
# running the kernel and other config scripts
#

.PHONY: config.tk config.in

config.in:
	config/mkconfig > config.in

config.tk: config.in
	$(MAKE) -C $(SCRIPTSDIR) tkparse
	ARCH=dummy $(SCRIPTSDIR)/tkparse < config.in > config.tmp
	@if [ -f /usr/local/bin/wish ];	then \
		echo '#!'"/usr/local/bin/wish -f" > config.tk; \
	else \
		echo '#!'"/usr/bin/wish -f" > config.tk; \
	fi
	cat $(SCRIPTSDIR)/header.tk >> ./config.tk
	cat config.tmp >> config.tk
	rm -f config.tmp
	echo "set defaults \"/dev/null\"" >> config.tk
	echo "set help_file \"config/Configure.help\"" >> config.tk
	cat $(SCRIPTSDIR)/tail.tk >> config.tk
	chmod 755 config.tk

.PHONY: xconfig
xconfig: config.tk
	@wish -f config.tk
	@if [ ! -f .config ]; then \
		echo; \
		echo "You have not saved your config, please re-run make config"; \
		echo; \
		exit 1; \
	 fi
	@config/setconfig defaults
	@if egrep "^CONFIG_DEFAULTS_KERNEL=y" .config > /dev/null; then \
		$(MAKE) linux_xconfig; \
	 fi
	@if egrep "^CONFIG_DEFAULTS_MODULES=y" .config > /dev/null; then \
		$(MAKE) modules_xconfig; \
	 fi
	@if egrep "^CONFIG_DEFAULTS_VENDOR=y" .config > /dev/null; then \
		$(MAKE) config_xconfig; \
	 fi
	@config/setconfig final

.PHONY: config
config: config.in
	@HELP_FILE=config/Configure.help \
		$(CONFIG_SHELL) $(SCRIPTSDIR)/Configure config.in
	@config/setconfig defaults
	@if egrep "^CONFIG_DEFAULTS_KERNEL=y" .config > /dev/null; then \
		$(MAKE) linux_config; \
	 fi
	@if egrep "^CONFIG_DEFAULTS_MODULES=y" .config > /dev/null; then \
		$(MAKE) modules_config; \
	 fi
	@if egrep "^CONFIG_DEFAULTS_VENDOR=y" .config > /dev/null; then \
		$(MAKE) config_config; \
	 fi
	@config/setconfig final

.PHONY: menuconfig
menuconfig: config.in voip_prepare
	$(MAKE) -C $(SCRIPTSDIR)/lxdialog all
	@HELP_FILE=config/Configure.help \
		$(CONFIG_SHELL) $(SCRIPTSDIR)/Menuconfig config.in
	@if [ ! -f .config ]; then \
		echo; \
		echo "You have not saved your config, please re-run make config"; \
		echo; \
		exit 1; \
	 fi
	@config/setconfig defaults
	@if egrep "^CONFIG_DEFAULTS_KERNEL=y" .config > /dev/null; then \
		$(MAKE) linux_menuconfig; \
	 fi
	@if egrep "^CONFIG_DEFAULTS_MODULES=y" .config > /dev/null; then \
		$(MAKE) modules_menuconfig; \
	 fi
	@if egrep "^CONFIG_DEFAULTS_VENDOR=y" .config > /dev/null; then \
		$(MAKE) config_menuconfig; \
	 fi
	#Added by Mason Yu. for ipv6	
	@if egrep "^CONFIG_MCONF_BZBOX=y" .config > /dev/null; then \
		$(MAKEARCH) -C $(BUSYBOXDIR) menuconfig; \
	fi
	@config/setconfig final
	@if egrep "^VOIP_SOLAR_1_6=y" $(CONFIG_CONFIG) >/dev/null; then\
		cd $(ROOTDIR)/user; ln -fsn ../rtk_voip/solar_1.6 rtk_voip; cd -;\
	fi
	@if egrep "^VOIP_SOLAR_1_5=y" $(CONFIG_CONFIG) >/dev/null; then\
		cd $(ROOTDIR)/user; ln -fsn ../rtk_voip/solar_1.5 rtk_voip; cd -;\
	fi
	@if egrep "^VOIP_MASERATI_2_0=y"  $(CONFIG_CONFIG) >/dev/null; then\
		cd $(ROOTDIR)/user; ln -fsn ../rtk_voip/maserati_2.0 rtk_voip; cd -;\
	fi


.PHONY: menuconfig_phase1
menuconfig_phase1: config.in voip_prepare
	$(MAKE) -C $(SCRIPTSDIR)/lxdialog all
	@HELP_FILE=config/Configure.help \
		$(CONFIG_SHELL) $(SCRIPTSDIR)/Menuconfig config.in
	@if [ ! -f .config ]; then \
		echo; \
		echo "You have not saved your config, please re-run make config"; \
		echo; \
		exit 1; \
	 fi
	@config/setconfig defaults

.PHONY: menuconfig_phase2
menuconfig_phase2:
	@if egrep "^CONFIG_DEFAULTS_KERNEL=y" .config > /dev/null; then \
		$(MAKE) linux_menuconfig; \
	fi
	@if egrep "^CONFIG_DEFAULTS_MODULES=y" .config > /dev/null; then \
		$(MAKE) modules_menuconfig; \
	fi
	@if egrep "^CONFIG_DEFAULTS_VENDOR=y" .config > /dev/null; then \
		$(MAKE) config_menuconfig; \
	fi
	@if egrep "^CONFIG_MCONF_BZBOX=y" .config > /dev/null; then \
		$(MAKEARCH) -C $(BUSYBOXDIR) menuconfig; \
	fi
	@if egrep "^CONFIG_USE_PRELOADER_PARAMETERS=y" .config > /dev/null; then \
		$(MAKE) soc_h_prepare; \
	fi



.PHONY: oldconfig
oldconfig:
	@$(MAKE) oldconfig_linux
	@$(MAKE) oldconfig_modules
	@$(MAKE) oldconfig_config
	@config/setconfig final

.PHONY: modules
modules:
	. $(LINUXDIR)/.config; if [ "$$CONFIG_MODULES" = "y" ]; then \
		[ -d $(LINUXDIR)/modules ] || mkdir $(LINUXDIR)/modules; \
		$(MAKEARCH_KERNEL) -C $(LINUXDIR) modules; \
	fi

.PHONY: modules_install
modules_install:
	. $(LINUXDIR)/.config; if [ "$$CONFIG_MODULES" = "y" ]; then \
		[ -d $(ROMFSDIR)/lib/modules ] || mkdir -p $(ROMFSDIR)/lib/modules; \
		$(MAKEARCH_KERNEL) -C $(LINUXDIR) INSTALL_MOD_PATH=$(ROMFSDIR) DEPMOD=true modules_install; \
		rm -f $(ROMFSDIR)/lib/modules/*/build; \
	fi

linux_xconfig:
	$(MAKEARCH_KERNEL) -C $(LINUXDIR) xconfig
linux_menuconfig: voip_prepare 
	$(MAKEARCH_KERNEL) -C $(LINUXDIR) menuconfig
linux_config:
	$(MAKEARCH_KERNEL) -C $(LINUXDIR) config
modules_xconfig:
	[ ! -d modules ] || $(MAKEARCH) -C modules xconfig
modules_menuconfig:
	[ ! -d modules ] || $(MAKEARCH) -C modules menuconfig
modules_config:
	[ ! -d modules ] || $(MAKEARCH) -C modules config
modules_clean:
	-[ ! -d modules ] || $(MAKEARCH) -C modules clean
config_xconfig:
	$(MAKEARCH) -C config xconfig
config_menuconfig:
	$(MAKEARCH) -C config menuconfig
config_config:
	$(MAKEARCH) -C config config
oldconfig_config:
	$(MAKEARCH) -C config oldconfig
oldconfig_modules:
	[ ! -d modules ] || $(MAKEARCH) -C modules oldconfig
oldconfig_linux:
	$(MAKEARCH_KERNEL) -C $(LINUXDIR) oldconfig

	
.PHONY: uc26_combo uc26_1pwifi uc26_4p uc26_4pwifi uc26_4pwifiotg uc26_iad
preconfig_%:	
	@if [ -f $(ROOTDIR)/vendors/Realtek/RTL8670/conf/config_kernel_$(@:preconfig_%=%) ] ; then \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf/config .config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf/config_kernel_$(@:preconfig_%=%) $(LINUXDIR)/.config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf/config_user_$(@:preconfig_%=%) config/.config && \
		if [ $(@:preconfig_%=%) -eq 10 ] ; then \
			cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf/config_uClibc_$(@:preconfig_%=%) uClibc/.config ; \
		fi; \
		echo "Configuration $(@:preconfig_%=%) loaded." ; \
		rm *_loaded ; \
		touch $@_loaded ; \
	else \
		echo "No configuration found" ; \
	fi

preconfig2630_%:
	@if [ -f $(ROOTDIR)/vendors/Realtek/RTL8670/conf2630/config_kernel_$(@:preconfig2630_%=%) ] ; then \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf2630/config_$(@:preconfig2630_%=%) .config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf2630/config_kernel_$(@:preconfig2630_%=%) $(LINUXDIR)/.config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf2630/config_user_$(@:preconfig2630_%=%) config/.config && \
		if [ -f $(ROOTDIR)/vendors/Realtek/RTL8670/conf2630/config_busybox_$(@:preconfig2630_%=%) ]; then \
			cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf2630/config_busybox_$(@:preconfig2630_%=%) $(BUSYBOXDIR)/.config ; \
		fi; \
		echo "Configuration2630 $(@:preconfig2630_%=%) loaded." ; \
		rm *_loaded ; \
		touch $@_loaded ; \
	else \
		echo "No configuration found" ; \
	fi

preconfig34_%:
	@if [ -f $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_kernel_$(@:preconfig34_%=%) ] ; then \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_$(@:preconfig34_%=%) .config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_kernel_$(@:preconfig34_%=%) linux-3.4.x/.config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_user_$(@:preconfig34_%=%) config/.config && \
		cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_oldconfig .oldconfig && \
		if [ -f $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_busybox_$(@:preconfig34_%=%) ]; then \
			cp $(ROOTDIR)/vendors/Realtek/RTL8670/conf34/config_busybox_$(@:preconfig34_%=%) $(BUSYBOXDIR)/.config ; \
		fi; \
		echo "Configuration34 $(@:preconfig34_%=%) loaded." ; \
		rm *_loaded ; \
		touch $@_loaded ; \
	else \
		echo "No configuration found" ; \
	fi	

#uc26_combo:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config-kernel26 linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config-user config/.config
#
#uc26_1pwifi:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/1Pwifi/config_kernel linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/1Pwifi/config_user config/.config
#
#uc26_4p:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4P/config_kernel linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4P/config_user config/.config
#uc26_4pwifi:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4Pwifi/config_kernel linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4Pwifi/config_user config/.config
#
#uc26_4pwifiotg:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4PwifiOTGhost/config_kernel linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4PwifiOTGhost/config_user config/.config
#
#uc26_4pwifi_11n:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4Pwifi_11n/config_kernel linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/4Pwifi_11n/config_user config/.config
#
#uc26_iad:
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/combo/config .config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/voip-iad/config-kernel2.6 linux-2.6.x/.config
#	cp $(ROOTDIR)/vendors/Realtek/RTL8670/voip-iad/config-user config/.config
#
	
ifdef CONFIG_USE_RSDK_WRAPPER
LSTRIP = PATH=$(RSDK)/bin:$(PATH); rsdk-linux-lstrip
endif #CONFIG_USE_RSDK_WRAPPER
	
############################################################################
#
# normal make targets
#

.PHONY: romfs
romfs:
  ifdef CONFIG_USE_RSDK_WRAPPER
	$(MAKEARCH) -C $(VENDDIR) mkromfsdir
  endif #CONFIG_USE_RSDK_WRAPPER
	rm -rf $(ROMFSDIR)/bin
	for dir in $(DIRS) ; do $(MAKEARCH) -C $$dir romfs || exit 1 ; done
	-find $(ROMFSDIR)/. -name CVS | xargs -r rm -rf
  ifdef CONFIG_USE_RSDK_WRAPPER
	cp -R $(RSDK)/lib/*.so $(ROMFSDIR)/lib
	cp -R $(RSDK)/lib/*.so.* $(ROMFSDIR)/lib
	cp -R $(ROOTDIR)/lib/librtk/*.so $(ROMFSDIR)/lib
	chmod 755 $(ROMFSDIR)/lib/*.so
  endif #CONFIG_USE_RSDK_WRAPPER


.PHONY: rcX
rcX: rcX_clean
	for dir in $(VENDDIR) user2/proc_var user ; do \
		[ "`grep "^rcX:" $$dir/Makefile`" ] && $(MAKEARCH) -C $$dir rcX || exit 1 ;\
	done
	for rcfile in $(ROMFSDIR)/etc/init.d/rc[0-9]*; do \
		chmod -f 755 $$rcfile; \
	done

.PHONY: rcX_clean
rcX_clean:
	rm -rf $(ROMFSDIR)/etc/init.d/rc[0-9]*


.PHONY: dev
dev:
	$(MAKEARCH) -C user dev

.PHONY: image
sinclude $(LINUXDIR)/.config
sinclude config/.config


ifdef CONFIG_SQUASHFS
RUN_SQUASHFS_SCRIPT=y
else
ifdef CONFIG_BLK_DEV_INITRD
RUN_SQUASHFS_SCRIPT=y
endif
endif


image:
ifdef CONFIG_ROMFS_FS
	[ -d $(IMAGEDIR) ] || mkdir $(IMAGEDIR)
	$(MAKEARCH) -C $(VENDDIR) image
endif
ifdef CONFIG_CRAMFS
	[ -d $(IMAGEDIR) ] || mkdir $(IMAGEDIR)
	./mkcramfs $(ROMFSDIR) rootfs
endif
ifdef RUN_SQUASHFS_SCRIPT
	[ -d $(IMAGEDIR) ] || mkdir $(IMAGEDIR)
  ifdef CONFIG_USE_RSDK_WRAPPER
  ifeq ($(findstring 1.3.6,$(RSDK)),1.3.6)
	$(LSTRIP) $(ROMFSDIR) $(ROOTDIR)/lib/librtk
  else
	$(LSTRIP) $(ROMFSDIR)
  endif
  else  #CONFIG_USE_RSDK_WRAPPER
	./tools/libstrip/libstrip
  endif #CONFIG_USE_RSDK_WRAPPER
  ifdef CONFIG_KERNEL_2_6_19
	./mksquashfs-lzma $(ROMFSDIR) rootfs -be -noappend
  endif
  ifdef CONFIG_KERNEL_2_6_30
	$(LINUXDIR)/mksquashfs $(ROMFSDIR) rootfs -comp lzma  -noappend -pf $(VENDDIR)/squashfs-pf.list -always-use-fragments
  endif
  ifdef CONFIG_DEFAULTS_KERNEL_3_4
	$(LINUXDIR)/mksquashfs $(ROMFSDIR) rootfs -comp gzip  -noappend -pf $(VENDDIR)/squashfs-pf.list -always-use-fragments -no-xattrs
  endif
ifeq ($(ZTE_531B_BRIDGE_SC),y)
	@printf "Now the image you are compiling is  for:\33[0;31mZTE BRIDGE\n\33[0m"
endif
ifeq ($(ZTE_GENERAL_ROUTER_SC),y)
	@printf "Now the image you are compiling is  for:\33[0;31mZTE Router\n\33[0m"
endif
ifeq ($(CONFIG_DEFAULT_WEB),y)
	@printf "Now the image you are compiling is  for:\33[0;31mdefault\n\33[0m"
endif
ifeq ($(CONFIG_GUI_WEB),y)
	@printf "Now the image you are compiling is  for:\33[0;31mGUI menu\n\33[0m"
endif
ifeq ($(CONFIG_BOA_WEB_E8B_CH),y)
	@printf "Now the image you are compiling is  for:\33[0;31mCTC E8B CH VER!\n\33[0m"
endif
ifndef CONFIG_USER_BOA_SRC_BOA
	@printf "Now the image you are compiling is  for:\33[0;31mNo BOA\n\33[0m"
endif
endif
#
# fancy target that allows a vendor to have other top level
# make targets,  for example "make vendor_flash" will run the
# vendor_flash target in the vendors directory
#

vendor_%:
	$(MAKEARCH) -C $(VENDDIR) $@

.PHONY: linux
linux linux_only:
ifdef CONFIG_BLK_DEV_INITRD
	[ -d $(ROMFSDIR) ] || mkdir -p $(ROMFSDIR)
endif #CONFIG_BLK_DEV_INITRD
	@if [ $(LINUXDIR) != linux-3.4.x -a $(LINUXDIR) != linux-2.6.x -a ! -f $(LINUXDIR)/.depend ] ; then \
		echo "ERROR: you need to do a 'make dep' first" ; \
		exit 1 ; \
	fi
	$(MAKEARCH_KERNEL) -C $(LINUXDIR) $(LINUXTARGET) || exit 1
	if [ -f $(LINUXDIR)/vmlinux ]; then \
		ln -f $(LINUXDIR)/vmlinux $(LINUXDIR)/linux ; \
	fi
  ifdef CONFIG_USE_RSDK_WRAPPER
	[ -d $(ROOTDIR)/include ] || mkdir -p $(ROOTDIR)/include
	[ -d $(ROOTDIR)/include/linux ] || mkdir -p $(ROOTDIR)/include/linux
ifdef CONFIG_DEFAULTS_KERNEL_2_6
	cp -f $(LINUXDIR)/include/linux/config.h include/linux
	cp -f $(LINUXDIR)/include/linux/autoconf.h include/linux 
endif
ifdef CONFIG_DEFAULTS_KERNEL_3_4
	mkdir -p $(ROOTDIR)/include/generated
	cp -f $(LINUXDIR)/include/linux/kconfig.h include/linux/config.h
	cp -f $(LINUXDIR)/include/generated/autoconf.h include/linux/ 
	cp -f $(LINUXDIR)/include/generated/autoconf.h include/generated/
endif
  endif #CONFIG_USE_RSDK_WRAPPER

.PHONY: voip_prepare
voip_prepare:
	@if [ -d $(ROOTDIR)/rtk_voip ] ; then \
		cd $(LINUXDIR)/drivers/char ; ln -fsn ../../../rtk_voip/aipc_char  aipc     ; cd - ; \
		cd $(LINUXDIR)              ; ln -fsn ../rtk_voip/kernel           rtk_voip ; cd - ; \
		cd $(ROOTDIR)/user          ; ln -fsn ../rtk_voip/maserati_2.0     rtk_voip ; cd - ; \
		cd $(ROOTDIR)/user          ; ln -fsn ../rtk_voip/aipc_util        aipc_util; cd - ; \
	else \
		cd $(LINUXDIR)/drivers/char ; ln -fsn ../../dummy aipc ; \
		cd $(LINUXDIR)              ; ln -fsn dummy rtk_voip   ; \
	fi
#ifeq ($(CONFIG_VOIP_IPC_DSP_ARCHITECTURE) , y)
#	@cd $(LINUXDIR)              ; ln -fsn ../rtk_voip/kernel           rtk_voip   ; cd -
#	@cd $(LINUXDIR)/drivers/char ; ln -fsn ../../../rtk_voip/aipc_char  aipc       ; cd -
#	@cd $(ROOTDIR)/user          ; ln -fsn ../rtk_voip/maserati_2.0        rtk_voip   ; cd -
#	@cd $(ROOTDIR)/user          ; ln -fsn ../rtk_voip/solar_1.6        rtk_voip   ; cd -
#	@cd $(ROOTDIR)/user          ; ln -fsn ../rtk_voip/aipc_util        aipc_util  ; cd -
#else
#
#for single cpu
#ifdef CONFIG_DEFAULTS_KERNEL_2_6
#	if [ -d $(LINUXDIR)/rtk_voip-single_cpu ]; then \
#		cd $(LINUXDIR)/drivers/char ; \
#		ln -fsn ../../../rtk_voip/aipc_char aipc ; \
#		cd - ; \
#		cd $(LINUXDIR) ; \
#		ln -fsn rtk_voip-single_cpu rtk_voip ; \
#		cd - ; \
3		cd $(LINUXDIR)/rtk_voip/voip_drivers/ ; \
#		ln -fsn proslic_api-v7.0.2 proslic_api ; \
#		cd - ; \
#	fi
#endif
#ifdef CONFIG_DEFAULTS_KERNEL_3_4
#	@cd $(LINUXDIR) ; ln -fsn ../rtk_voip/kernel rtk_voip	; cd -
#	@cd $(LINUXDIR)/drivers/char ; ln -fsn ../../../rtk_voip/aipc_char  aipc       ; cd -
#endif
#	
#endif



.PHONY: subdirs
subdirs: linux
ifdef CONFIG_KERNEL_2_6_30
	for dir in $(DIRS) ; do $(MAKEARCH) -C $$dir || exit 1 ; done
else  #CONFIG_KERNEL_2_6_30
	for dir in $(DIRS) ; do $(MAKEARCH_KERNEL) -C $$dir || exit 1 ; done
endif #CONFIG_KERNEL_2_6_30

dep:
	@if [ ! -f $(LINUXDIR)/.config ] ; then \
		echo "ERROR: you need to do a 'make config' first" ; \
		exit 1 ; \
	fi
	$(MAKEARCH_KERNEL) -C $(LINUXDIR) dep

# This one removes all executables from the tree and forces their relinking
.PHONY: relink
relink:
	find user -name '*.gdb' | sed 's/^\(.*\)\.gdb/\1 \1.gdb/' | xargs rm -f
	find $(VENDDIR) -name '*.gdb' | sed 's/^\(.*\)\.gdb/\1 \1.gdb/' | xargs rm -f

# This one build a rom image including boot code and run-time image
.PHONY: rom vmimg
ifeq ($(CONFIG_SINGLE_IMAGE),y)
ROOTFS_OFFSET := 0x40000
endif
ifeq ($(CONFIG_DOUBLE_IMAGE),y)
ROOTFS_OFFSET := 0x100000
endif
rom: rom.script
	@if [ ! -f dummy.S ] ; then \
		touch dummy.S; \
	fi
	$(CC) $(CFLAG) -c dummy.S -o dummy.o
	$(OBJCOPY) --add-section .boot=boot.bin dummy.o
	$(OBJCOPY) --add-section .pad=pad_file dummy.o
	$(OBJCOPY) --add-section .run=linux-2.6.x/vmbin.img dummy.o
	$(OBJCOPY) --remove-section=.text --remove-section=.bss --remove-section=.reginfo --remove-section=.pdr dummy.o
	$(LD) -nostdlib -Trom.script dummy.o -o rom.elf
	$(OBJCOPY) -Obinary rom.elf rombin.img
	./tools/packimg/genhead  -i rombin.img -o rom.hdr -k 0xa0000003 -f 0xbd000000  -a 0x80000000 -e 0x80000000
	cat rom.hdr rombin.img > rom.img

rom.script: rom.script.in
	sed -e 's/@@ROOTFS_OFFSET@@/$(ROOTFS_OFFSET)/' <$< >$@

vmimg:
  ifdef CONFIG_KERNEL_2_6_30
  	ifdef CONFIG_BOA_WEB_E8B_CH
		$(MAKEARCH_KERNEL) -C $(LINUXDIR) vmimg_e8b
  	else
          ifdef CONFIG_BLK_DEV_INITRD
		#make sure the initramfs is updated
		make linux
		make linux
		$(MAKEARCH_KERNEL) -C $(LINUXDIR) vmimg_kernel
          else #CONFIG_BLK_DEV_INITRD
		$(MAKEARCH_KERNEL) -C $(LINUXDIR) vmimg
          endif #CONFIG_BLK_DEV_INITRD
  	endif
  else #CONFIG_KERNEL_2_6_30
	$(MAKEARCH) -C $(LINUXDIR) vmimg
  endif #CONFIG_KERNEL_2_6_30

dep26:
	find ./user/boa/ -type l | xargs rm
	rm user/boa/default_web_id

clean: modules_clean
	#for dir in $(LINUXDIR) $(DIRS); do $(MAKEARCH) -C $$dir clean ; done
	for dir in  $(DIRS); do $(MAKEARCH) -C $$dir clean ; done
	-rm -rf $(ROMFSDIR)/*
	rm -rf $(IMAGEDIR)/*
	rm -f config.tk
	#rm -f $(LINUXDIR)/linux
	rm -rf $(LINUXDIR)/net/ipsec/alg/libaes $(LINUXDIR)/net/ipsec/alg/perlasm
  ifdef CONFIG_USE_RSDK_WRAPPER
	rm -rf $(ROOTDIR)/include
  endif #CONFIG_USE_RSDK_WRAPPER
	make -C config/scripts/lxdialog/ clean

real_clean mrproper: clean
	-$(MAKEARCH_KERNEL) -C $(LINUXDIR) mrproper
	-$(MAKEARCH) -C config clean
	-rm -rf romfs config.in config.arch config.tk images
	rm -f modules/config.tk
	rm -rf .config .config.old .oldconfig autoconf.h

distclean: mrproper
	-$(MAKEARCH_KERNEL) -C $(LINUXDIR) distclean

%_menuconfig:
	[ ! -d "$(@:_menuconfig=)" ] || $(MAKEARCH) -C $(@:_menuconfig=) menuconfig

%_only:
	if [ -d "$(@:_only=)" ]; then \
		if [ -n "$(findstring user/,$@)" ]; then \
			$(MAKEARCH) -C user $(@:user/%=%); \
		else \
			if [ ! -f $(@:_only=)/Makefile ]; then \
				cd $(@:_only=) && ./configure --host=mips-linux --target=mips-linux && cd -; \
			fi; \
			$(MAKEARCH) -C $(@:_only=); \
		fi; \
	fi

%_romfs:
	[ ! -d "$(@:_romfs=)" ] || $(MAKEARCH) -C $(@:_romfs=) romfs

ifdef CONFIG_KERNEL_2_6_30
linux%_clean:
	[ ! -d "$(@:_clean=)" ] || $(MAKEARCH_KERNEL) -C $(@:_clean=) clean
endif #CONFIG_KERNEL_2_6_30

%_clean:
	[ ! -d "$(@:_clean=)" ] || $(MAKEARCH) -C $(@:_clean=) clean

config_error:
	@echo "*************************************************"
	@echo "You have not run make config."
	@echo "The build sequence for this source tree is:"
	@echo "1. 'make config' or 'make xconfig'"
	@echo "2. 'make dep'"
	@echo "3. 'make'"
	@echo "*************************************************"
	@exit 1

prune:
	$(MAKE) -C user prune

dist-prep:
	-find $(ROOTDIR) -name 'Makefile*.bin' | while read t; do \
		$(MAKEARCH) -C `dirname $$t` -f `basename $$t` $@; \
	 done

############################################################################
