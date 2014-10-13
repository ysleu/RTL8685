
include $(TOPDIR)/config.mk

LIB	= $(obj)lib$(BOARD).o

#COBJS	:= $(BOARD).o flash.o \
	board_mem_diag.o board_cmd.o

COBJS	:= $(BOARD).o flash_spi.o \
	board_mem_diag.o board_cmd.o

SOBJS   = measur_cpu_clk.o

SRCS	:= $(SOBJS:.o=.S) $(COBJS:.o=.c)
OBJS	:= $(addprefix $(obj),$(COBJS))
SOBJS	:= $(addprefix $(obj),$(SOBJS))

all:	$(subdir) $(LIB)

$(LIB):	$(OBJS) $(SOBJS)
	$(call cmd_link_o_target, $(OBJS) $(SOBJS))

#########################################################################

# defines $(obj).depend target
include $(SRCTREE)/rules.mk

sinclude $(obj).depend

#########################################################################
