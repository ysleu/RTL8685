ifdef CONFIG_IPV6
CFLAGS += -DIPV6
endif

EXEC = tftpd
OBJS = tftpd.o tftpsubs.o
LDLIBS += -lmib $(LIBVOIP)

all: $(EXEC)

$(EXEC): $(OBJS) tftpd.h
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

romfs:
	$(ROMFSINST) /bin/$(EXEC)

clean:
	-rm -f $(EXEC) *.elf *.gdb *.o

