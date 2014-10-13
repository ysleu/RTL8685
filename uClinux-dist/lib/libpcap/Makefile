#VER = libpcap-0.9.8
VER = libpcap-1.5.3

CONFIGURE_OPTS = --host=mips-linux --target=mips-linux

CONF_OPTS = --with-pcap=linux --disable-bluetooth --disable-can --disable-canusb --disable-dbus
ifdef CONFIG_IPV6
CONF_OPTS += --enable-ipv6
endif

all: build-$(VER)/Makefile
	mkdir -p install
	$(MAKE) -C build-$(VER) install DESTDIR=$(shell pwd)/install

build-$(VER)/Makefile:
	find $(VER) -type f -print0 | xargs -0 touch -r $(VER)/configure
	set -e ; \
	rm -rf build-$(VER) ; \
	mkdir build-$(VER) ; \
	cd build-$(VER) ; \
	ac_cv_linux_vers=2 \
	ac_cv_lbl_unaligned_fail=yes \
	../$(VER)/configure $(CONFIGURE_OPTS) $(CONF_OPTS)

clean:
	rm -rf build* install

romfs:
	$(ROMFSINST) install/usr/local/lib/libpcap.so.1.5.3 /lib/libpcap.so.1.5.3
	$(ROMFSINST) -s libpcap.so.1.5.3 /lib/libpcap.so.1
	$(ROMFSINST) -s libpcap.so.1 /lib/libpcap.so
	#$(ROMFSINST) -d -e CONFIG_FMT_USE_FDPIC_ELF $(STAGEDIR)/usr/lib/libSDL-1.2.so.0 /usr/lib/libSDL-1.2.so.0

.PHONY: all clean romfs
