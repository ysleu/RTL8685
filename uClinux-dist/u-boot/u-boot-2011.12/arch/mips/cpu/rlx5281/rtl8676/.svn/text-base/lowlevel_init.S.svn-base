#include <config.h>
#include <asm/asm.h>
#include <asm/regdef.h>
#include <asm/mipsregs.h>
#include <asm/arch/bspchip.h>
#include "macro.s"
	.set push
	.set noreorder
	.set nomips16
	

	
LEAF(lowlevel_init)
        /* Configure Zone 0 base address */
        li      t0, 0xB8001700
        #li     t1, 0x2000000
        #li     t2, 0x3ffffff
        #sw     t1, 0(t0)
        #sw     t2, 4(t0)
        sw      zero, 0(t0)
        nop
        /*
         * Initialize Memory controller
         * reserve k1 register
         */
        move    k1, ra
        la      t9, memctls_init
        nop
        jalr    t9
        nop
        move    ra, k1

	jr		ra
	nop	
END(lowlevel_init)
	
	
	.set pop
