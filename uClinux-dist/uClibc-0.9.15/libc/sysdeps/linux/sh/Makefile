# Makefile for uClibc
#
# Copyright (C) 2000 by Lineo, inc.
# Copyright (C) 2001 by Hewlett-Packard Australia
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Library General Public License for more
# details.
#
# You should have received a copy of the GNU Library General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
# Derived in part from the Linux-8086 C library, the GNU C Library, and several
# other sundry sources.  Files within this library are copyright by their
# respective copyright holders.

TOPDIR=../../../../
include $(TOPDIR)Rules.mak

CFLAGS+= -I../
SFLAGS= $(CFLAGS) -D__ASSEMBLER__ -DASM_GLOBAL_DIRECTIVE=.globl

TARGET_MACHINE_TYPE=$(shell $(CC) -dumpmachine)

CRT0=crt0.S
CRT0_OBJ=$(patsubst %.S,%.o, $(CRT0))

SSRC=setjmp.S bsd-setjmp.S bsd-_setjmp.S __longjmp.S vfork.S clone.S
SOBJS=$(patsubst %.S,%.o, $(SSRC))

CSRC=_mmap.c longjmp.c pipe.c __init_brk.c brk.c sbrk.c
COBJS=$(patsubst %.c,%.o, $(CSRC))

OBJS=$(SOBJS) $(MOBJ) $(COBJS)


all: $(OBJS) $(LIBC)

$(LIBC): ar-target 

ar-target: $(OBJS) $(CRT0_OBJ)
	$(AR) $(ARFLAGS) $(LIBC) $(OBJS)
	cp $(CRT0_OBJ) $(TOPDIR)lib/$(CRT0_OBJ)

$(CRT0_OBJ): %.o : %.S
	$(CC) $(SFLAGS) -c $< -o $@
	$(STRIPTOOL) -x -R .note -R .comment $*.o

$(SOBJS): %.o : %.S
	$(CC) $(SFLAGS) -c $< -o $@
	$(STRIPTOOL) -x -R .note -R .comment $*.o

$(COBJS): %.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@
	$(STRIPTOOL) -x -R .note -R .comment $*.o

headers:

clean:
	rm -f *.[oa] *~ core
	rm -f bits/syscall.h

