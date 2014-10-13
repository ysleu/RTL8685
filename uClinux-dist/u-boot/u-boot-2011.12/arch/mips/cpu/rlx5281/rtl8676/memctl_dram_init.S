#include <asm/regdef.h>
#include <asm/au1x00.h>
#include <config.h>
#include <asm/mipsregs.h>
#include "memctl.h"


#define MEMCTLS_INIT_BK_RA_REG		AT
#define MEMCTLS_DRAM_INIT_BK_RA_REG	s7


	/* k1 is not avaliable  
	 * reserve MEMCTLS_INIT_BK_RA_REG
	 */
        .text
        .set noreorder
        .set nomips16
	.globl memctls_init
	.ent memctls_init
memctls_init:
	move	MEMCTLS_INIT_BK_RA_REG, ra

	/* Add memory controller version detection here */
	/* speed up SPI clock*/
	li	t9, 0xB8001200
	li	t0, 0x1fc00000
	sw	t0, 0(t9)
	nop

	/* dram init */
	la	t9, memctls_dram_init
	nop
	jalr	t9
	nop

	move	ra, MEMCTLS_INIT_BK_RA_REG
	jr	ra
	nop

	.end memctls_init



	/* reserve MEMCTLS_DRAM_INIT_BK_RA_REG */
        .text
        .set noreorder
        .set nomips16
	.globl memctl_dram_init
	.ent memctls_dram_init
memctls_dram_init:
	/* Back up ra register */
	move	MEMCTLS_DRAM_INIT_BK_RA_REG, ra

        /* Runtime deterministic DRAM intialization.
         * Enter DRAM timing calibration if it is enabled.
         * Determine whether we run in DRAM.
         */
         /* If we run in DRAM, skip DRAM initialization.*/
        la      t0, skip_dram_config
        li      t1, 0xF0000000
        li      t2, 0x80000000
        li      t3, 0xA0000000
        and     t1, t1, t0
        beq     t1, t2, skip_dram_config
        nop
        beq     t1, t3, skip_dram_config
        nop


	/* 
	 * Determine wheather it is DDR1 SDRAM
	 * v0 = 1: it is DDR1 SDRAM
	 * v0 = 0: it is not DDR1 SDRAM 
	 */
	la	t9, memctls_is_DDR
	nop
	jalr	t9
	nop
	beq	zero, v0, 2f
	nop

	/* DDR1 */
	la	t9, memctls_ddr1_dll_reset
	nop
	jalr	t9
	nop
	j	1f
	nop

2:
	la	t9, memctls_is_DDR2
	nop
	jalr	t9
	nop
	beq	zero, v0, 3f
	nop

	/* DDR2 */
	la	t9, memctls_ddr2_dll_reset
	nop
	jalr	t9
	nop
	j	1f
	nop
3:
	/* DDR3 */
	la	t9, memctls_ddr3_dll_reset
	nop
	jalr	t9
	nop
	#li 	t9, 1
	#bne	zero, t9, skip_dram_config
	#nop
1:

	/* Configure DTR */
//	li	t0, 0xb8001008
//	li	t1, 0xE0226080
//	li	t1, 0x6c214080 /* MIC pass */
//	li	t1, 0x4c214080 /* MIC pass */
//	li	t1, 0x48214080 /* MIC fail */
//	li	t1, 0x44214080 /* MIC fail */
//	li	t1, 0x2c214080 /* MIC fail */
//	li	t1, 0x0c214080 /* MIC fail */
//	li	t1, 0x00214080 /* MIC fail */
//	li	t1, 0xFFFF40C0 /* MIC fail */
//	li 	t1, 0x230FF070
//	sw	t1, 0(t0)
//	nop

	la	t9, memctls_ddr_calibration
	nop
	jalr	t9
	nop

#if 0
	la	t9, memctls_dram_auto_detect
	nop
	jalr	t9
	nop
#endif

skip_dram_config:
	move	ra, MEMCTLS_DRAM_INIT_BK_RA_REG
	jr	ra
	nop
        .end  memctls_dram_init



        .text
        .set noreorder
        .set nomips16
	.globl memctls_is_DDR
	.ent memctls_is_DDR
memctls_is_DDR:
	li	t0, MCR
	lw	t1, 0(t0)
	nop
	li	t2, 0x00000000
	li	t3, 0xF0000000
	and	t1, t1, t3
	beq	t2, t1, 2f
	nop

	/* DDR2 */
	move	v0, zero
	jr	ra
	nop
2:
	/* DDR1 */
	li	v0, 0x1
	jr 	ra
	nop
        .end  memctls_is_DDR

        .text
        .set noreorder
        .set nomips16
	.globl memctls_is_DDR2
	.ent memctls_is_DDR2
memctls_is_DDR2:
	li	t0, MCR
	lw	t1, 0(t0)
	nop
	li	t2, 0x10000000
	li	t3, 0xF0000000
	and	t1, t1, t3
	beq	t2, t1, 2f
	nop

	/* Not DDR2 */
	move	v0, zero
	jr	ra
	nop
2:
	/* DDR2 */
	li	v0, 0x1
	jr 	ra
	nop
        .end  memctls_is_DDR2


        .text
        .set noreorder
        .set nomips16
	.globl memctls_is_DDR3
	.ent memctls_is_DDR3
memctls_is_DDR3:
	li	t0, MCR
	lw	t1, 0(t0)
	nop
	li	t2, 0x20000000
	li	t3, 0xF0000000
	and	t1, t1, t3
	beq	t2, t1, 2f
	nop

	/* Not DDR3 */
	move	v0, zero
	jr	ra
	nop
2:
	/* DDR3 */
	li	v0, 0x1
	jr 	ra
	nop

	jr 	ra
	nop
	.end  memctls_is_DDR3



        .text
        .set noreorder
        .set nomips16
	.globl memctls_ddr_calibration
	.ent memctls_ddr_calibration
memctls_ddr_calibration:
/*
 * DDR SDRAM Auto-Calibration
 */
/*
 * Write tap  
 *31 |
 *30 |
 *29 |
 *28 |
 *27 |
 *26 |
 *25 |
 *24 |
 *23 |
 *22 |
 *21 |
 *20 |
 *19 |
 *18 |
 *17 |
 *16 |
 *15 |
 *14 |
 *13 |
 *12 |                                  B
 *11 |                                  ^
 *10 |                                  |
 * 9 |                                  |
 * 8 |                                  |
 * 7 |                                  |
 * 6 |                                  |--------------------X--------------------->C
 * 5 |                                  |
 * 4 |                                  |
 * 3 |                                  |
 * 2 |--------------------------------->A
 * 1 |-------------------------------------------------------------------------------------------------------------------
 * 0 |-------------------------------------------------------------------------------------------------------------------
 *   |____________________________________________________________________________________________________________________
 *    0  1  2  3  4  5  6  7  8  9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31 Read tap
 */

#define UMSAR0 (0xB8001300)
#define UMSAR1 (UMSAR0+0x10)
#define UMSAR2 (UMSAR0+0x20)
#define UMSAR3 (UMSAR0+0x30)
#define UMSSR0 (UMSAR0+0x4)

#define SRAMSAR0 (0xB8004000)
#define SRAMSAR1 (SRAMSAR0+0x10)
#define SRAMSAR2 (SRAMSAR0+0x20)
#define SRAMSAR3 (SRAMSAR0+0x30)
#define SRAMSSR0 (SRAMSAR0+0x4)
#define SRAMSBR0 (SRAMSAR0+0x8)

#define CFG_DCACHE_SIZE 	(0x8000)
#define CFG_DCACHE_LINE 	(0x20)
#define DRAM_PAT_ADDR 		(0x80000000)
#define DRAM_PAT_LEN  		CFG_DCACHE_SIZE
#define DCAHE_WINVAL 		(1<<9) 
#define DCACHE_WALLOC 		(1<<7)
#define DCACHE_INVAL 		(1<<0x0)
#define DACDQF_BASE_ADDR 	(0xB8001550)
#define DACDQR_BASE_ADDR 	(0xB8001510)
#define	DACCR_ADDR		(0xB8001500)
#define	DACSPCR_ADDR		(0xB8001504)
#define DCR_ADDR		(0xB8001004)
#define DMCR_ADDR		(0xB800101C)
#define REG_CCTL $20
#define REG_TEMP  t9
#define REG_TEMP1 t8
#define REG_TEMP2 t6
#define REG_TEMP3 t5
#define REG_TEMP4 t3
#define REG_TEMP5 s0
#define REG_TEMP6 s1
#define REG_XOR   t7
#define REG_RDQC t4
#define REG_WTAPS_ERR_THIS_ROUND a2
#define REG_WTAP_ERR_FOUND a1
#define REG_ERR_FOUND a1
#define REG_ERR_BITS  a2
#define REG_PAT_DIST_ADDR t0
#define REG_PAT_SRC_ADDR t1
#define REG_PAT_END_ADDR a3
#define REG_PAT_LEN t2
#define REG_DCR v0
#define REG_DMCR v0
#define REG_DCR_BUSY_MASK v1
#define REG_DMCR_BUSY_MASK v1
#define REG_DACCR k0


#define CODE_INV_DCACHE	 \
	mfc0 	REG_TEMP1, REG_CCTL; \
	li      REG_TEMP, DCACHE_INVAL;\
	not	REG_TEMP, REG_TEMP; \
	and	REG_TEMP1, REG_TEMP1, REG_TEMP; \
	mtc0 	REG_TEMP1, REG_CCTL; \
	nop;				 \
	li	REG_TEMP, DCACHE_INVAL;\
	or	REG_TEMP1, REG_TEMP1, REG_TEMP; \
	mtc0	REG_TEMP1, REG_CCTL;\
	nop;

#define CODE_WINV_DCACHE	 \
	mfc0 	REG_TEMP1, REG_CCTL; \
	li      REG_TEMP, DCAHE_WINVAL;\
	not	REG_TEMP, REG_TEMP; \
	and	REG_TEMP1, REG_TEMP1, REG_TEMP; \
	mtc0 	REG_TEMP1, REG_CCTL; \
	nop;				 \
	li	REG_TEMP, DCAHE_WINVAL;\
	or	REG_TEMP1, REG_TEMP1, REG_TEMP; \
	mtc0 	REG_TEMP1, REG_CCTL;\
	nop;

#define CODE_ENABLE_WALLO \
	mfc0 	REG_TEMP1, REG_CCTL; \
	li      REG_TEMP, DCACHE_WALLOC;\
	not	REG_TEMP, REG_TEMP; \
	and	REG_TEMP1, REG_TEMP1, REG_TEMP; \
	mtc0 	REG_TEMP1, REG_CCTL; \
	nop;				 \
	li	REG_TEMP, DCACHE_WALLOC;\
	or	REG_TEMP1, REG_TEMP1, REG_TEMP; \
	mtc0 	REG_TEMP1, REG_CCTL;\
	nop;

#define RESET_PHY_BUFPTR \
    li REG_DACCR, DACCR_ADDR; \
    li REG_DCR_BUSY_MASK, 0xFFFFFFEF; \
    lw REG_DACCR, 0(REG_DACCR); \
    nop; \
    and REG_DCR_BUSY_MASK, REG_DCR_BUSY_MASK, REG_DACCR; \
    li REG_DACCR, DACCR_ADDR; \
    sw REG_DCR_BUSY_MASK, 0(REG_DACCR); \
    nop; \
    lw REG_DCR_BUSY_MASK, 0(REG_DACCR); \
    li REG_DACCR, 0x10; \
    or REG_DCR_BUSY_MASK, REG_DCR_BUSY_MASK, REG_DACCR; \
    li REG_DACCR, DACCR_ADDR; \
    sw REG_DCR_BUSY_MASK, 0(REG_DACCR); \
    nop;

#define CODE_DUMMY_READ \
    li  REG_DCR_BUSY_MASK, 0x1 ; \
9:  li	REG_DCR, DCR_ADDR; \
    lw	REG_DCR, 0(REG_DCR); \
    nop; \
    and	REG_DCR, REG_DCR, REG_DCR_BUSY_MASK; \
    bne zero, REG_DCR, 9b; \
    nop;

#if 0
#define SYNC_DRAM_PARAM \
    li	REG_TEMP6, DCR_ADDR; \
    lw	REG_TEMP5, 0(REG_TEMP6); \
    nop; \
    sw	REG_TEMP5, 0(REG_TEMP6); \
    nop; \
    li  REG_DCR_BUSY_MASK, 0x1 ; \
9:  li	REG_DCR, DCR_ADDR; \
    lw	REG_DCR, 0(REG_DCR); \
    nop; \
    and	REG_DCR, REG_DCR, REG_DCR_BUSY_MASK; \
    bne zero, REG_DCR, 9b; \
    nop;
#else

#define SYNC_DRAM_PARAM \
    li	REG_DMCR, DMCR_ADDR; \
    lw  REG_TEMP6, 0(REG_DMCR); \
    nop; \
    sw	REG_TEMP6, 0(REG_DMCR); \
    nop; \
9:\
    li  REG_DMCR_BUSY_MASK, 0x80000000 ; \
    li	REG_DMCR, DMCR_ADDR; \
    lw	REG_DMCR, 0(REG_DMCR); \
    nop; \
    and	REG_DMCR, REG_DMCR, REG_DMCR_BUSY_MASK; \
    bne zero, REG_DMCR, 9b; \
    nop; 
    #li  REG_DMCR_BUSY_MASK, 0x1 ; \
    #li	REG_DMCR, 0xb8001004; \
    #lw	REG_DMCR, 0(REG_DMCR); \
    #nop; \
    #and	REG_DMCR, REG_DMCR, REG_DMCR_BUSY_MASK; \
    #bne zero, REG_DMCR, 9b; \
    #nop;

#endif


//#define OLD_CODE
/* 0. Initialize DRAM setting and DDR Phy controll setting */

	RESET_PHY_BUFPTR

	li	REG_TEMP, DACDQR_BASE_ADDR
	li	REG_TEMP1, 32
init_dacq_loop:
	#li	REG_TEMP2, 0x00000400
	sw	zero, 0(REG_TEMP)
	#sw	REG_TEMP2, 0(REG_TEMP)
	add	REG_TEMP1, REG_TEMP1, -1
	add REG_TEMP, REG_TEMP, 4
	bne zero, REG_TEMP1, init_dacq_loop
	nop

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP, DCR_ADDR
	lw	REG_TEMP1, 0(REG_TEMP)
	nop
	sw	REG_TEMP1, 0(REG_TEMP)
	nop

	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/


	move REG_TEMP1, ra //store return address
	la	REG_TEMP, a_setting_data
	jr	REG_TEMP
	nop
/* 1. Find current tap fuzzy area with single write and read operations. */

/*
 * Phase A.
 */

a_setting_data:
	move ra, REG_TEMP1 //Restore return address

	CODE_WINV_DCACHE

	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	li REG_PAT_LEN, DRAM_PAT_LEN
	/* Remap pat_start to uncached area. */
	li REG_TEMP1, 0x20000000
	la REG_PAT_SRC_ADDR, pat_start
	or REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP1
	la REG_PAT_END_ADDR, pat_end
	or REG_PAT_END_ADDR, REG_PAT_END_ADDR, REG_TEMP1
1:
	lw  REG_TEMP, 0(REG_PAT_SRC_ADDR)
	add REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, 4
	sw  REG_TEMP, 0(REG_PAT_DIST_ADDR)
	bne REG_PAT_SRC_ADDR, REG_PAT_END_ADDR, a_skip_src_wrapped
	nop
	la  REG_PAT_SRC_ADDR, pat_start
	or  REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP1
a_skip_src_wrapped:
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, 4
	add REG_PAT_LEN, REG_PAT_LEN, -4
	bne REG_PAT_LEN, zero, 1b
	nop

	CODE_WINV_DCACHE

	//Read it back with connected burst request.
	li REG_TEMP, CFG_DCACHE_LINE
	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	li REG_PAT_LEN, DRAM_PAT_LEN
1:
	lw  REG_TEMP1, 0(REG_PAT_DIST_ADDR)
	sub REG_PAT_LEN, REG_PAT_LEN, REG_TEMP
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, REG_TEMP
	bne zero, REG_PAT_LEN, 1b
	nop


	//Verify Data
	move REG_ERR_BITS, zero
a_verify_data:
	li REG_TEMP2, 0x20000000
	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	la REG_PAT_SRC_ADDR, pat_start
//	or REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP2
	li REG_PAT_LEN, DRAM_PAT_LEN
	la REG_PAT_END_ADDR, pat_end
//	or REG_PAT_END_ADDR, REG_PAT_END_ADDR, REG_TEMP2

a_verify_loop:	
	lw  REG_TEMP, 0(REG_PAT_DIST_ADDR)
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, 4
	lw  REG_TEMP1, 0(REG_PAT_SRC_ADDR)
	add REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, 4
	bne REG_PAT_SRC_ADDR, REG_PAT_END_ADDR, av_skip_src_wrapped
	nop
	la  REG_PAT_SRC_ADDR, pat_start
//	or  REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP2
av_skip_src_wrapped:

	add REG_PAT_LEN, REG_PAT_LEN, -4
	not REG_XOR, REG_TEMP1
	and REG_XOR, REG_XOR, REG_TEMP
	not REG_TEMP, REG_TEMP
	and REG_TEMP, REG_TEMP, REG_TEMP1
	or  REG_XOR, REG_XOR, REG_TEMP

	or  REG_ERR_BITS, REG_ERR_BITS, REG_XOR
	bne REG_PAT_LEN, zero, a_verify_loop
	nop
	beq zero, REG_ERR_BITS, 3f
	nop
	move REG_XOR, REG_ERR_BITS
	
	li	REG_TEMP, DCR_ADDR
	lw	REG_TEMP2, 0(REG_TEMP)
	li	REG_TEMP1, 0x0F000000
	and	REG_TEMP1, REG_TEMP1, REG_TEMP2
	bne	zero, REG_TEMP1, a_skip_8bit	
	nop
	/* 
	 * 8bit mode: shift (11,22,33,44) to (00,(11|33),00,(22|44))
	 */
	move	REG_TEMP1, REG_XOR
	li	REG_TEMP2, 0x000000FF
	and	REG_TEMP1, REG_TEMP1, REG_TEMP2
	li      REG_TEMP2, 0x00FF0000
	and 	REG_TEMP2, REG_TEMP2, REG_XOR
	srl	REG_TEMP2, REG_TEMP2, 16
	or	REG_TEMP1, REG_TEMP1, REG_TEMP2
	
	move	REG_TEMP, REG_XOR
	li	REG_TEMP2, 0x0000FF00
	and	REG_TEMP, REG_TEMP, REG_TEMP2
	sll	REG_TEMP, REG_TEMP, 8
	li      REG_TEMP2, 0xFF000000
	and 	REG_TEMP2, REG_TEMP2, REG_XOR
	srl	REG_TEMP2, REG_TEMP2, 8
	or	REG_TEMP, REG_TEMP, REG_TEMP2
	or	REG_XOR, REG_TEMP, REG_TEMP1
a_skip_8bit:

	/* Adjust tap delay setting */
	li REG_TEMP, 0x1
	li REG_TEMP1, 0
	li REG_TEMP2, 32
	li REG_TEMP3, 16
	li REG_RDQC, DACDQF_BASE_ADDR
a_tap_adj_loop:
	bne REG_TEMP1, REG_TEMP3, 1f
	nop
	li REG_RDQC, DACDQR_BASE_ADDR
1:
	and REG_TEMP, REG_TEMP, REG_XOR
	beq zero, REG_TEMP, a_next_dq
	nop
	lw REG_TEMP4, 0(REG_RDQC)
	nop
	sll REG_TEMP6, REG_TEMP4, 3
	srl REG_TEMP6, REG_TEMP6, 27
	sll REG_TEMP5, REG_TEMP4, 16
	srl REG_TEMP5, REG_TEMP5, 24
	add REG_TEMP5, REG_TEMP5, 1
	bne REG_TEMP2, REG_TEMP5, a_skip_add_wtap
	nop
	add REG_TEMP6, REG_TEMP6, 1
	beq REG_TEMP2, REG_TEMP6, cali_fail
	nop
	move REG_TEMP5, zero
a_skip_add_wtap:
	sll REG_TEMP5, 8
	sll REG_TEMP6, 24
	or  REG_TEMP5, REG_TEMP5, REG_TEMP6
	sw	REG_TEMP5, 0(REG_RDQC)

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/


a_next_dq:
	add REG_TEMP1, REG_TEMP1, 1
	add REG_RDQC, REG_RDQC, 4
	srl REG_XOR, REG_XOR, 1
	bne zero, REG_XOR, a_tap_adj_loop	
	nop
	move REG_ERR_BITS, zero
	j	a_setting_data
	nop
3:


/*
 * Phase B.
 */

/* Store write tap value to Max tap tempolarily .*/
	li	REG_TEMP, DACDQR_BASE_ADDR
	li	REG_TEMP5, DCR_ADDR
	li	REG_TEMP1, 16
wtap_to_max_loop:
	//extract wtap store wtap+1 to wtap.
	li	REG_TEMP3, 0x1f000000
	lw	REG_TEMP2, 0(REG_TEMP)
	nop
	and REG_TEMP4, REG_TEMP2, REG_TEMP3
	move REG_TEMP6, REG_TEMP4

	srl REG_TEMP6, REG_TEMP6, 24
	add REG_TEMP6, REG_TEMP6, 1
	sll REG_TEMP6, REG_TEMP6, 24
	srl REG_TEMP4, REG_TEMP4, 8
	li	REG_TEMP3, 0x0000FFFF
	and REG_TEMP2, REG_TEMP2, REG_TEMP3
	or	REG_TEMP2, REG_TEMP2, REG_TEMP4
	or  REG_TEMP2, REG_TEMP2, REG_TEMP6
	sw	REG_TEMP2, 0(REG_TEMP)

	add	REG_TEMP1, REG_TEMP1, -1
	add REG_TEMP, REG_TEMP, 4
	bne zero, REG_TEMP1, wtap_to_max_loop
	nop

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/

	li  REG_WTAP_ERR_FOUND, 	0x0
	li  REG_WTAPS_ERR_THIS_ROUND, 	0x0

b_setting_data:
	CODE_INV_DCACHE
/* write data and verify, search untill REG_XOR = 0xffffffff */
	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	li REG_PAT_LEN, DRAM_PAT_LEN
	/* Remap pat_start to uncached area. */
	li REG_TEMP1, 0x20000000
	la REG_PAT_SRC_ADDR, pat_start
//	or REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP1
	la REG_PAT_END_ADDR, pat_end
//	or REG_PAT_END_ADDR, REG_PAT_END_ADDR, REG_TEMP1
1:
	lw  REG_TEMP, 0(REG_PAT_SRC_ADDR)
	add REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, 4
	sw  REG_TEMP, 0(REG_PAT_DIST_ADDR)
	bne REG_PAT_SRC_ADDR, REG_PAT_END_ADDR, b_skip_src_wrapped
	nop
	la  REG_PAT_SRC_ADDR, pat_start
//	or  REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP1
b_skip_src_wrapped:
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, 4
	add REG_PAT_LEN, REG_PAT_LEN, -4
	bne REG_PAT_LEN, zero, 1b
	nop

	CODE_WINV_DCACHE

	//Verify written data
b_verify_data:
	li REG_TEMP2, 0x20000000
	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	la REG_PAT_SRC_ADDR, pat_start
//	or REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP2
	li REG_PAT_LEN, DRAM_PAT_LEN
	la REG_PAT_END_ADDR, pat_end
//	or REG_PAT_END_ADDR, REG_PAT_END_ADDR, REG_TEMP2

b_verify_loop:	
	lw  REG_TEMP, 0(REG_PAT_DIST_ADDR)
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, 4
	lw  REG_TEMP1, 0(REG_PAT_SRC_ADDR)
	add REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, 4
	bne REG_PAT_SRC_ADDR, REG_PAT_END_ADDR, bv_skip_src_wrapped
	nop
	la  REG_PAT_SRC_ADDR, pat_start
//	or  REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP2
bv_skip_src_wrapped:
	add REG_PAT_LEN, REG_PAT_LEN, -4
	not REG_XOR, REG_TEMP1
	and REG_XOR, REG_XOR, REG_TEMP
	not REG_TEMP, REG_TEMP
	and REG_TEMP, REG_TEMP, REG_TEMP1
	or  REG_XOR, REG_XOR, REG_TEMP

	// ford 32 bit status to 16bit status
	srl	REG_TEMP3, REG_XOR, 16
	sll REG_TEMP4, REG_XOR, 16
	srl REG_TEMP4, REG_TEMP4, 16
	or  REG_TEMP3, REG_TEMP3, REG_TEMP4
	or	REG_WTAPS_ERR_THIS_ROUND, REG_WTAPS_ERR_THIS_ROUND, REG_TEMP3

	bne REG_PAT_LEN, zero, b_verify_loop
	nop

	//We adjust those DQs with correct data.
	not REG_XOR, REG_WTAPS_ERR_THIS_ROUND
	li  REG_TEMP5, 0x0000ffff
	and REG_XOR, REG_XOR, REG_TEMP5

	li	REG_TEMP, DCR_ADDR
	lw	REG_TEMP2, 0(REG_TEMP)
	li	REG_TEMP1, 0x0F000000
	and	REG_TEMP1, REG_TEMP1, REG_TEMP2
	bne	zero, REG_TEMP1, b_skip_8bit	
	nop
	/* 
	 * 8bit mode: shift (11,22,33,44) to (00,(11|33),00,(22|44))
	 */
	li	REG_TEMP, 0xFF00
	or	REG_WTAP_ERR_FOUND, REG_WTAP_ERR_FOUND, REG_TEMP
	li	REG_TEMP, 0xFF00
	and	REG_TEMP, REG_TEMP, REG_XOR
	srl	REG_TEMP, REG_TEMP, 8
	li	REG_TEMP1, 0xFF
	and	REG_TEMP1, REG_TEMP1, REG_XOR
	or	REG_XOR, REG_TEMP, REG_TEMP1
b_skip_8bit:

	/* Adjust tap delay setting */
	li REG_TEMP, 0x00000001
	li REG_TEMP1, 0
	li REG_TEMP2, 32
	li REG_TEMP3, 16
	li REG_RDQC, DACDQR_BASE_ADDR
b_tap_adj_loop:
	and REG_TEMP5, REG_TEMP, REG_XOR
	beq REG_TEMP5, zero, b_next_dq
	nop

	sll REG_TEMP4, REG_TEMP, REG_TEMP1
	//skip dq already found wrong
	and REG_TEMP4, REG_TEMP4, REG_WTAP_ERR_FOUND
	bne zero, REG_TEMP4, b_next_dq
	nop

	lw REG_TEMP4, 0(REG_RDQC)
	nop
	sll REG_TEMP6, REG_TEMP4, 3
	srl REG_TEMP6, REG_TEMP6, 27
	add REG_TEMP6, REG_TEMP6, 1
	bne REG_TEMP2, REG_TEMP6, b_tap_adj_loop_w_noMax
	nop
	sll REG_TEMP4, REG_TEMP, REG_TEMP1
	or  REG_WTAP_ERR_FOUND, REG_WTAP_ERR_FOUND, REG_TEMP4
	b   b_next_dq
	nop
b_tap_adj_loop_w_noMax:
	li REG_TEMP5, 0x00ffffff
	and REG_TEMP4, REG_TEMP4, REG_TEMP5
	sll REG_TEMP6, REG_TEMP6, 24
	or  REG_TEMP4, REG_TEMP4, REG_TEMP6
	sw	REG_TEMP4, 0(REG_RDQC)

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/


b_next_dq:
	add REG_TEMP1, REG_TEMP1, 1
	add REG_RDQC, REG_RDQC, 4
	li	REG_TEMP5, 0xFFFEFFFE
	and REG_XOR, REG_XOR, REG_TEMP5
	srl REG_XOR, REG_XOR, 1
	bne zero, REG_XOR, b_tap_adj_loop	
	nop
3:
	or  REG_WTAP_ERR_FOUND, REG_WTAPS_ERR_THIS_ROUND, REG_WTAP_ERR_FOUND
	move REG_WTAPS_ERR_THIS_ROUND, REG_WTAP_ERR_FOUND
	li  REG_TEMP5, 0xffff
	beq REG_WTAP_ERR_FOUND, REG_TEMP5, b_completed
	nop
	j	b_setting_data
	nop
b_completed:

	/*
	 * Set Wtap with (WTAP+MAX_TAP-1)/2
     */
	li REG_TEMP, 16
	li REG_RDQC, DACDQR_BASE_ADDR
b_wtap_setting_loop:
	lw	REG_TEMP1, 0(REG_RDQC)
	move REG_TEMP2, REG_TEMP1
	srl  REG_TEMP1, REG_TEMP1, 24 // assign TEMP1 with WTAP
	sll  REG_TEMP2, REG_TEMP2, 8
	srl  REG_TEMP2, REG_TEMP2, 24 // assign TEMP2 with MAX_TAP
	add  REG_TEMP1, REG_TEMP1, REG_TEMP2
	add  REG_TEMP1, REG_TEMP1, -1
	srl  REG_TEMP1, REG_TEMP1, 1
	sll  REG_TEMP1, REG_TEMP1, 24

	lw   REG_TEMP2, 0(REG_RDQC)
	li	 REG_TEMP3, 0x0000FF00
	and  REG_TEMP2, REG_TEMP2, REG_TEMP3
	or	 REG_TEMP2, REG_TEMP2, REG_TEMP1
	sw 	 REG_TEMP2, 0(REG_RDQC)
	add  REG_TEMP, REG_TEMP, -1
	add	 REG_RDQC, REG_RDQC, 4

/*====================================*/
#ifdef  OLD_CODE
	//update phy parameters with DCR
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/

	bne zero, REG_TEMP, b_wtap_setting_loop
	nop



	/* Move all CUR tap fileds to Min tap fileds */
	li REG_TEMP, 32
	li REG_RDQC, DACDQR_BASE_ADDR
c_curtap_to_mintap_loop:
	lw	 REG_TEMP1, 0(REG_RDQC)
	move REG_TEMP2, REG_TEMP1
	li	 REG_TEMP3, 0x0000FF00
	and  REG_TEMP2, REG_TEMP2, REG_TEMP3
	srl	 REG_TEMP2, REG_TEMP2, 8
	or	 REG_TEMP2, REG_TEMP2, REG_TEMP1
	sw 	 REG_TEMP2, 0(REG_RDQC)
	add  REG_TEMP, REG_TEMP, -1
	add	 REG_RDQC, REG_RDQC, 4

/*====================================*/
#ifdef  OLD_CODE
	//update phy parameters with DCR
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/

	bne zero, REG_TEMP, c_curtap_to_mintap_loop
	nop


/*
 * Phase C.
 */
c_setting_data:
	CODE_WINV_DCACHE

	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	li REG_PAT_LEN, DRAM_PAT_LEN
	/* Remap pat_start to uncached area. */
	li REG_TEMP1, 0x20000000
	la REG_PAT_SRC_ADDR, pat_start
//	or REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP1
	la REG_PAT_END_ADDR, pat_end
//	or REG_PAT_END_ADDR, REG_PAT_END_ADDR, REG_TEMP1
1:
	lw  REG_TEMP, 0(REG_PAT_SRC_ADDR)
	add REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, 4
	sw  REG_TEMP, 0(REG_PAT_DIST_ADDR)
	bne REG_PAT_SRC_ADDR, REG_PAT_END_ADDR, c_skip_src_wrapped
	nop
	la  REG_PAT_SRC_ADDR, pat_start
//	or  REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP1
c_skip_src_wrapped:
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, 4
	add REG_PAT_LEN, REG_PAT_LEN, -4
	bne REG_PAT_LEN, zero, 1b
	nop

	CODE_WINV_DCACHE

	li REG_ERR_FOUND, 0x0
	//Verify Data
c_verify_data:

	CODE_INV_DCACHE
	//Read it back with connected burst request.
	li REG_TEMP, CFG_DCACHE_LINE
	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	li REG_PAT_LEN, DRAM_PAT_LEN
1:
	lw  REG_TEMP1, 0(REG_PAT_DIST_ADDR)
	sub REG_PAT_LEN, REG_PAT_LEN, REG_TEMP
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, REG_TEMP
	bne zero, REG_PAT_LEN, 1b
	nop

	li REG_TEMP2, 0x20000000
	li REG_PAT_DIST_ADDR, DRAM_PAT_ADDR
	la REG_PAT_SRC_ADDR, pat_start
//	or REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP2
	li REG_PAT_LEN, DRAM_PAT_LEN
	la REG_PAT_END_ADDR, pat_end
//	or REG_PAT_END_ADDR, REG_PAT_END_ADDR, REG_TEMP2

	li  REG_ERR_BITS, 0x0
c_verify_loop:	
	lw  REG_TEMP, 0(REG_PAT_DIST_ADDR)
	add REG_PAT_DIST_ADDR, REG_PAT_DIST_ADDR, 4
	lw  REG_TEMP1, 0(REG_PAT_SRC_ADDR)
	add REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, 4
	bne REG_PAT_SRC_ADDR, REG_PAT_END_ADDR, cv_skip_src_wrapped
	nop
	la  REG_PAT_SRC_ADDR, pat_start
//	or  REG_PAT_SRC_ADDR, REG_PAT_SRC_ADDR, REG_TEMP2
cv_skip_src_wrapped:

	add REG_PAT_LEN, REG_PAT_LEN, -4
	not REG_XOR, REG_TEMP1
	and REG_XOR, REG_XOR, REG_TEMP
	not REG_TEMP, REG_TEMP
	and REG_TEMP, REG_TEMP, REG_TEMP1
	or  REG_XOR, REG_XOR, REG_TEMP
	or	REG_ERR_BITS, REG_ERR_BITS, REG_XOR
	li	REG_TEMP1, 0xffffffff

	//Check wheather REG_ERR_BITS == 0xffffffff. We skip all data left when it's true. 
	beq REG_ERR_BITS, REG_TEMP1, c_err_bit_satisfied
	nop
	bne REG_PAT_LEN, zero, c_verify_loop
	nop
c_err_bit_satisfied:
	not REG_XOR, REG_ERR_BITS


	li	REG_TEMP, DCR_ADDR
	lw	REG_TEMP2, 0(REG_TEMP)
	li	REG_TEMP1, 0x0F000000
	and	REG_TEMP1, REG_TEMP1, REG_TEMP2
	bne	zero, REG_TEMP1, c_skip_8bit	
	nop
	/* 
	 * 8bit mode: shift (11,22,33,44) to (00,(11|33),00,(22|44))
	 */
	li	REG_TEMP, 0xFF00FF00
	or	REG_ERR_FOUND, REG_ERR_FOUND, REG_TEMP
	move	REG_TEMP1, REG_XOR
	li	REG_TEMP2, 0x000000FF
	and	REG_TEMP1, REG_TEMP1, REG_TEMP2
	li      REG_TEMP2, 0x00FF0000
	and 	REG_TEMP2, REG_TEMP2, REG_XOR
	srl	REG_TEMP2, REG_TEMP2, 16
	or	REG_TEMP1, REG_TEMP1, REG_TEMP2
	
	move	REG_TEMP, REG_XOR
	li	REG_TEMP2, 0x0000FF00
	and	REG_TEMP, REG_TEMP, REG_TEMP2
	sll	REG_TEMP, REG_TEMP, 8
	li      REG_TEMP2, 0xFF000000
	and 	REG_TEMP2, REG_TEMP2, REG_XOR
	srl	REG_TEMP2, REG_TEMP2, 8
	or	REG_TEMP, REG_TEMP, REG_TEMP2
	or	REG_XOR, REG_TEMP, REG_TEMP1
c_skip_8bit:


	/* Adjust tap delay setting */
	li REG_TEMP, 0x1
	li REG_TEMP1, 0
	li REG_TEMP2, 32
	li REG_TEMP3, 16
	li REG_RDQC, DACDQF_BASE_ADDR
c_tap_adj_loop:
	bne REG_TEMP1, REG_TEMP3, 1f
	nop
	li REG_RDQC, DACDQR_BASE_ADDR
1:
	//check wheather it's the found dq.
	li	REG_TEMP6, 0x1
	sll REG_TEMP6, REG_TEMP6, REG_TEMP1
	and REG_TEMP6, REG_TEMP6, REG_ERR_FOUND
	bne zero, REG_TEMP6, c_next_dq
	nop

	and REG_TEMP, REG_TEMP, REG_XOR
	beq zero, REG_TEMP, c_next_dq
	nop
	lw REG_TEMP4, 0(REG_RDQC)
	nop
	sll REG_TEMP5, REG_TEMP4, 16
	srl REG_TEMP5, REG_TEMP5, 24
	add REG_TEMP5, REG_TEMP5, 1
	bne REG_TEMP2, REG_TEMP5, c_set_curtap
	nop
	//Max tap == 32, mark it found.
	li	REG_TEMP5, 0x1
	sll	REG_TEMP5, REG_TEMP5, REG_TEMP1
	or	REG_ERR_FOUND, REG_ERR_FOUND, REG_TEMP5
	li  REG_TEMP5, 31
c_set_curtap:
	li	REG_TEMP6, 0xffff00ff
	and REG_TEMP6, REG_TEMP6, REG_TEMP4
	sll REG_TEMP5, 8
	or	REG_TEMP5, REG_TEMP5, REG_TEMP6
	sw	REG_TEMP5, 0(REG_RDQC)

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/

c_next_dq:
	add REG_TEMP1, REG_TEMP1, 1
	add REG_RDQC, REG_RDQC, 4
	srl REG_XOR, REG_XOR, 1
	bne zero, REG_XOR, c_tap_adj_loop	
	nop

	or  REG_ERR_FOUND, REG_ERR_FOUND, REG_ERR_BITS

	li	REG_TEMP5, 0xffffffff
	bne REG_ERR_FOUND, REG_TEMP5, c_verify_data
	nop


	/* Move all CUR tap fileds to Max tap fileds and set (Min+Max)/2 to CUR tap*/
	li REG_TEMP, 32
	li REG_RDQC, DACDQR_BASE_ADDR
c_set_max_cur_tap_loop:
	lw	 REG_TEMP1, 0(REG_RDQC)
	move REG_TEMP2, REG_TEMP1
	//extract CUR tap
	li	 REG_TEMP3, 0x0000FF00
	li	 REG_TEMP4, 0x000000FF
	li	 REG_TEMP5, 0xFF0000FF
	and	 REG_TEMP4, REG_TEMP4, REG_TEMP1
	and  REG_TEMP2, REG_TEMP2, REG_TEMP3
	srl	 REG_TEMP2, REG_TEMP2, 8
	add  REG_TEMP2, REG_TEMP2, -1
	add  REG_TEMP4, REG_TEMP4, REG_TEMP2
	srl	 REG_TEMP4, REG_TEMP4, 1
	sll	 REG_TEMP4, REG_TEMP4, 8
	sll	 REG_TEMP2, REG_TEMP2, 16
	and	 REG_TEMP5, REG_TEMP5, REG_TEMP1
	or	 REG_TEMP5, REG_TEMP5, REG_TEMP4
	or	 REG_TEMP5, REG_TEMP5, REG_TEMP2
	sw 	 REG_TEMP5, 0(REG_RDQC)
	add  REG_TEMP, REG_TEMP, -1
	add	 REG_RDQC, REG_RDQC, 4

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/

	bne zero, REG_TEMP, c_set_max_cur_tap_loop
	nop


	//Setup silence pattern
	li	REG_TEMP, DRAM_PAT_LEN
	srl	REG_TEMP, REG_TEMP, 2
	add	REG_TEMP, REG_TEMP, -1
	li  REG_TEMP1, 0xFFFFFF00
	li  REG_TEMP2, DACSPCR_ADDR
	lw  REG_TEMP3, 0(REG_TEMP2)
	and	REG_TEMP3, REG_TEMP3, REG_TEMP1
	not REG_TEMP1, REG_TEMP1
	and REG_TEMP, REG_TEMP, REG_TEMP1
	or  REG_TEMP1, REG_TEMP, REG_TEMP3
	sw	REG_TEMP1, 0(REG_TEMP2)

/*====================================*/
#ifdef  OLD_CODE
	li	REG_TEMP6, DCR_ADDR
	lw	REG_TEMP5, 0(REG_TEMP6)
	nop
	sw	REG_TEMP5, 0(REG_TEMP6)
	nop
	lw	REG_TEMP5, 0(REG_TEMP6)
	CODE_DUMMY_READ
#else
	SYNC_DRAM_PARAM
#endif
/*====================================*/
	li	v0, 0x0
	j	cali_pass
	nop

cali_fail:
	li	v0, 0x1
cali_pass:
	jr	ra
	nop
	.end memctls_ddr_calibration



        .text
        .set noreorder
        .set nomips16
	.globl memctls_dram_auto_detect
	.ent memctls_dram_auto_detect
memctls_dram_auto_detect:

/*
 * t0 = DCR_Addr
 * t1 = 0x124855aa, test pattern
 * t2 = 1;
 * t3 = 0xa0000000
 * t4 = Bus Width
 * t5 = DCR_Value
 * t6 = i, iterator
 * t7/8/9, s5/6 for tmp
 * s0 = BANK_BIT, 1/2 for 2/4 bank
 * s1 = R_CNT, initial = 0
 * s2 = C_CNT, initial = 0
 * s3 = R_BITS = Row Count bits, initial = 11
 * s4 = C_BITS = Col Count bits, initial = 8
 */
#define DRAM_DETECT_DCR_ADDR      t0
#define DRAM_DETECT_WRITE_DATA    t1
#define DRAM_DETECT_UNCACHED_ADDR t3
#define DRAM_DETECT_BUS_WIDTH     t4
#define DRAM_DETECT_DCR_VALUE     t5
#define DRAM_DETECT_ITERATOR      t6
#define DRAM_MAX_ROW 4
#define DRAM_MAX_COL 5
#define DRAM_DETECT_R_CNT         s1
#define DRAM_DETECT_C_CNT         s2
#define DRAM_DETECT_R_BITS        s3
#define DRAM_DETECT_C_BITS        s4
#define DRAM_DETECT_BANK_BIT      s0

	.set reorder
	li	t7, UMSAR0
	sw	zero, 0(t7)
	li	t7, SRAMSAR0
	sw	zero, 0(t7)
	
	
	li	DRAM_DETECT_DCR_ADDR, DCR
	//li	DRAM_DETECT_WRITE_DATA, 0x124855aa
	li	DRAM_DETECT_WRITE_DATA, 0xcccc55aa
	li	t2, 1
	li	DRAM_DETECT_UNCACHED_ADDR, 0xa0000000
	li	DRAM_DETECT_DCR_VALUE, 0x40000000   //Latency=3
	move	DRAM_DETECT_R_CNT, zero
	move	DRAM_DETECT_C_CNT, zero
	move	DRAM_DETECT_BANK_BIT, t2
	
	li	t7, MCR  
	lw	t8, 0(t7)
	li	t9, 0x80400000
	
	and	t8, t8, t9
	bne	zero, t8, DRAM_DETECT_DDR
	nop

DRAM_DETECT_SDR:
	li	DRAM_DETECT_BUS_WIDTH, 2       //32 bits
	b 	DRAM_DETECT_WIDTH
DRAM_DETECT_DDR:
	li	DRAM_DETECT_BUS_WIDTH, 1       //16 bits
	
DRAM_DETECT_WIDTH:
	li	t7, 0x40000000    //CS0, R11C8, 2bank
	sll	t9, DRAM_DETECT_BUS_WIDTH, 28
	or	t7, t7, t9
	sw	t7, 0(DRAM_DETECT_DCR_ADDR)
	nop

1:
	lw	t7, 0(DRAM_DETECT_DCR_ADDR)
	li	k0, 0x1
	and 	k0, k0, t7
	bne	zero, k0, 1b
	nop	
	.set noreorder
	.set reorder
	sw	DRAM_DETECT_WRITE_DATA, 0(DRAM_DETECT_UNCACHED_ADDR)
	lw	t8, 0(DRAM_DETECT_UNCACHED_ADDR)
	beq	DRAM_DETECT_WRITE_DATA, t8, DRAM_DETECT_WIDTH_OUT
	
DRAM_DETECT_WIDTH_SDR16_DDR8:
	addiu	DRAM_DETECT_BUS_WIDTH, -1

DRAM_DETECT_WIDTH_OUT:
	sll	t9, DRAM_DETECT_BUS_WIDTH, 28
	or	DRAM_DETECT_DCR_VALUE, t9


	li	t7, MCR  
	lw	t8, 0(t7)
	li	t9, 0x80400000
	li	t7, 0x80000000
	and	t8, t8, t9
	bne	t7, t8, DRAM_DETECT_BANK
	nop

DDR2_DRAM_DETECT_BANK: //DDR2
	li	DRAM_DETECT_BANK_BIT, 2
	li	t7, 0xb800100c
	lw	t7, 0(t7)
	li	t8, (1<<30)
	or	t8, t7, t8
	li	t7, 0xb800100c
	sw	t8, 0(t7)
	.set noreorder
	.set reorder

	li	t2, 3	
	add	t7, DRAM_DETECT_BUS_WIDTH, 19  //R11C8, bank offset
	li	t8, 7
	sll	t8, t8, t7                         //set bank = 7
	or	t8, t8, DRAM_DETECT_UNCACHED_ADDR  //or 0xa0000000
	sll	t9, t2, t7                         //set bank = 3, t2 = 3
	or	t9, t9, DRAM_DETECT_UNCACHED_ADDR  //or 0xa0000000	

DDR2_DRAM_DETECT_BANK_TEST:
	sw	zero, 0(t8)
	sw	zero, 0(t9)
	sw	DRAM_DETECT_WRITE_DATA, 0(t8)
	lw	s5, 0(t8)
	lw	s6, 0(t9)
	bne	DRAM_DETECT_WRITE_DATA, s5, 1f
	nop
        bne     DRAM_DETECT_WRITE_DATA, s6, 1f
        nop
	li	t7, 0xb800100c
	li	t8, 0x3FFFFFFF
	lw	t9, 0(t7)
	and	t8, t8, t9
	sw	t8, 0(t7)
	nop
1:
	beq	s5, s6, DRAM_DETECT_BANK_OUT
	li	t7, (1<<19)
	or	DRAM_DETECT_DCR_VALUE, t7
	li	DRAM_DETECT_BANK_BIT, 3

DDR2_DRAM_DETECT_BANK_OUT:
	j	DRAM_DETECT_BANK_OUT
	nop

DRAM_DETECT_BANK: //DDR1
	move	t7, DRAM_DETECT_DCR_VALUE    //CS0, R11C8
	li	t8, (1<<19)
	or	t7, t7, t8
	sw	t7, 0(DRAM_DETECT_DCR_ADDR)
	.set noreorder
	.set reorder
	
	add	t7, DRAM_DETECT_BUS_WIDTH, 19  //R11C8, bank offset
	li	t8, 3
	sll	t8, t8, t7                         //set bank = 3
	or	t8, t8, DRAM_DETECT_UNCACHED_ADDR  //or 0xa0000000
	sll	t9, t2, t7                         //set bank = 1
	or	t9, t9, DRAM_DETECT_UNCACHED_ADDR  //or 0xa0000000	

DRAM_DETECT_BANK_TEST:
	sw	zero, 0(t8)
	sw	zero, 0(t9)
	sw	DRAM_DETECT_WRITE_DATA, 0(t8)
	lw	s5, 0(t8)
	lw	s6, 0(t9)
	beq	s5, s6, DRAM_DETECT_BANK_OUT
	li	t7, (1<<19)
	or	DRAM_DETECT_DCR_VALUE, t7
	li	DRAM_DETECT_BANK_BIT, 2

DRAM_DETECT_BANK_OUT:

DRAM_DETECT_CHECK_ROW:
	li	t7, (3<<25) | (0<<22)
	or	t7, t7, DRAM_DETECT_DCR_VALUE
	sw	t7, 0(DRAM_DETECT_DCR_ADDR)
	li	DRAM_DETECT_R_BITS, 11
	move DRAM_DETECT_R_CNT, zero // for init
	li	s5, DRAM_MAX_ROW
	
DRAM_DETECT_CHECK_ROW_LOOP:	
	beq s5, DRAM_DETECT_R_CNT, DRAM_DETECT_CHECK_ROW_OUT // for cheak
	
	// t7 for addr
	add	t8, DRAM_DETECT_BUS_WIDTH, DRAM_DETECT_R_BITS
	//addiu	t8, t8, 7
	//sll	t7, t2, t8
	addiu	t8, t8, 8
	li	t7, 1
	sll	t7, t7, t8
	or	t7, DRAM_DETECT_UNCACHED_ADDR
	sw	zero, 0(t7)
	sw	DRAM_DETECT_WRITE_DATA, 0(DRAM_DETECT_UNCACHED_ADDR)
	lw	t9, 0(t7)
	beq	DRAM_DETECT_WRITE_DATA, t9, DRAM_DETECT_CHECK_ROW_OUT
	

	addiu DRAM_DETECT_R_CNT, DRAM_DETECT_R_CNT, 1 // for reentry
	addiu DRAM_DETECT_R_BITS, DRAM_DETECT_R_BITS, 1
	b DRAM_DETECT_CHECK_ROW_LOOP

DRAM_DETECT_CHECK_ROW_OUT:
	//addi DRAM_DETECT_R_CNT, DRAM_DETECT_R_CNT, -1
	addi DRAM_DETECT_R_CNT, DRAM_DETECT_R_CNT, 0


DRAM_DETECT_CHECK_COL:
	li	t7, (0<<25) | (4<<22)
	or	t7, t7, DRAM_DETECT_DCR_VALUE
	sw	t7, 0(DRAM_DETECT_DCR_ADDR)
	li	DRAM_DETECT_C_BITS, 8
	move DRAM_DETECT_C_CNT, zero // for init
	li	s5, DRAM_MAX_COL
	
DRAM_DETECT_CHECK_COL_LOOP:
	beq s5, DRAM_DETECT_C_CNT, DRAM_DETECT_CHECK_COL_OUT // for cheak
	
	// t7 for addr
	add	t8, DRAM_DETECT_BUS_WIDTH, DRAM_DETECT_C_BITS
	addi	t8, t8, -1
	sll	t7, t2, t8
	or	t7, DRAM_DETECT_UNCACHED_ADDR
	sw	zero, 0(t7)
	sw	DRAM_DETECT_WRITE_DATA, 0(DRAM_DETECT_UNCACHED_ADDR)
	lw	t9, 0(t7)
	beq	DRAM_DETECT_WRITE_DATA, t9, DRAM_DETECT_CHECK_COL_OUT
	

	addiu DRAM_DETECT_C_CNT, DRAM_DETECT_C_CNT, 1 // for reentry
	addiu DRAM_DETECT_C_BITS, DRAM_DETECT_C_BITS, 1
	b DRAM_DETECT_CHECK_COL_LOOP
	
DRAM_DETECT_CHECK_COL_OUT:
	addi DRAM_DETECT_C_CNT, DRAM_DETECT_C_CNT, -1
	
DRAM_DETECT_CHECK_OUT:

DRAM_DETECT_CHECK_CHIP:
	add	t7, DRAM_DETECT_R_CNT, DRAM_DETECT_C_CNT
	add	t8, DRAM_DETECT_BUS_WIDTH, 19
	add	t7, t7, t8
	add	t7, t7, DRAM_DETECT_BANK_BIT
	//sll	t8, t2, t7
	li	t8, 1
	sll	t8, t8, t7
	or	t8, t8, DRAM_DETECT_UNCACHED_ADDR
	sll	DRAM_DETECT_R_CNT, DRAM_DETECT_R_CNT, 25
	sll	DRAM_DETECT_C_CNT, DRAM_DETECT_C_CNT, 22
	or	DRAM_DETECT_DCR_VALUE, DRAM_DETECT_DCR_VALUE, DRAM_DETECT_C_CNT
	or	DRAM_DETECT_DCR_VALUE, DRAM_DETECT_DCR_VALUE, DRAM_DETECT_R_CNT
	li	t9, (1<<27)
	or	t9, DRAM_DETECT_DCR_VALUE
	sw	t9, 0(DRAM_DETECT_DCR_ADDR)
	.set noreorder
	.set reorder
	sw	DRAM_DETECT_WRITE_DATA, 0(t8)
	sw	zero, 0(DRAM_DETECT_UNCACHED_ADDR)
	//lw	t9, 0(DRAM_DETECT_UNCACHED_ADDR)
	lw	t9, 0(t8)
	beq	DRAM_DETECT_WRITE_DATA, t9, DRAM_DETECT_CHECK_CHIP_OUT
	sw	DRAM_DETECT_DCR_VALUE, 0(DRAM_DETECT_DCR_ADDR)
	
DRAM_DETECT_CHECK_CHIP_OUT:

	RESET_PHY_BUFPTR

	.set noreorder
	jr	ra
	nop
	.end memctls_dram_auto_detect



/*
 * Write Pattern {
 *	0x5A5AA5A5,
 *	0xA5A55A5A,
 *	0x5A5AA5A5,
 *	0xA5A55A5A,
 *	0xA5A55A5A,
 *	0x5A5AA5A5,
 *	0xA5A55A5A,
 *	0x5A5AA5A5,
 *	0x5555AAAA,
 *	0xAAAA5555,
 *	0x5555AAAA,
 *	0xAAAA5555,
 *	0xAAAA5555,
 *	0x5555AAAA,
 *	0xAAAA5555,
 *	0x5555AAAA }
 */
pat_start:
 .word  0x00010000
 .word  0x00000000
 .word  0xFFFFFFFF
 .word  0x0000FFFF
 .word  0xFFFF0000
 .word  0x00FF00FF
 .word  0xFF00FF00
 .word  0xF0F0F0F0
 .word  0x0F0F0F0F
 .word	0x5A5AA5A5
 .word	0xA5A55A5A
 .word	0x5A5AA5A5
 .word	0xA5A55A5A
 .word	0xA5A55A5A
 .word	0x5A5AA5A5
 .word	0xA5A55A5A
 .word	0x5A5AA5A5
 .word	0x5555AAAA
 .word	0xAAAA5555
 .word	0x5555AAAA
 .word	0xAAAA5555
 .word	0xAAAA5555
 .word	0x5555AAAA
 .word	0xAAAA5555
 .word  0x5555AAAA
 .word  0xFFFFFFFF
 .word  0x00000000
pat_end:


        .text
        .set noreorder
        .globl  memctls_ddr1_dll_reset	
	.ent memctls_ddr1_dll_reset
memctls_ddr1_dll_reset:

	li	t0, 0xb8001004
	li	t1, 0x11220000 #1 chip, 16bit mode
	#li	t1, 0x10220000 #1 chip, 8bit mode
	sw	t1,0(t0)
	nop
	/* 
	 * Set mode register for DRAM DLL reset. 
	 */

	# Maximize the refresh cycles for the 200 clock cycles delay requirement of DLL reset
	li	t0, 0xb8001008
	li	t1, 0x23000800
	#li	t1, 0x23033800
	sw	t1, 0(t0)
	nop
	li	t0, 0xb800100c
	li	t1, 0x00000000
	#li	t1, 0x05050313
	sw	t1, 0(t0)
	nop
	li	t0, 0xb8001010
	li	t1, 0x00301000
	#li	t1, 0x02d0e000
	sw	t1, 0(t0)
	nop

	# (1) Disable DLL
	li	t0, 0xB800101C
	li	t1, 0x00110001
	sw	t1, 0(t0)
	#  waiting for MRS busy
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	# (2) Enable DLL
	li	t0, 0xB800101C
	li	t1, 0x00110000 #enable dll, normal driving
	//li	t1, 0x00110002 #enable dll, weak driving
	sw	t1, 0(t0)
	#  waiting for MRS busy 
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	# (3) DLL Reset 
	li	t0, 0xB800101C
	li	t1, 0x00100131
	sw	t1, 0(t0)
	#  waiting for MRS busy
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop
	#  wait 200 clock cycles
	li	t0, 800
1:
	bne	zero, t0, 1b
	add	t0, t0, -1


	# (4) Normal operation 
	li	t0, 0xB800101C
	li	t1, 0x00100031
	li 	t5, DCR
	lw	t7, 0(t5)
	li	t6, 0x0F000000
	and	t7, t7, t6
	bne	zero, t7, 2f
	nop
	li	t1, 0x00100032
2:
	sw	t1, 0(t0)
	#  waiting for MRS busy 
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	# (6) Reset DDR PHY
	li 	t0, 0xb8001500
	li	t1, 0x80000000
	sw	t1, 0(t0)
	nop
	li	t1, 0x80000010
	sw	t1, 0(t0)
	nop
	jr	ra
	nop

	.end memctls_ddr1_dll_reset



        .text
        .set noreorder
        .globl  memctls_ddr2_dll_reset
	.ent memctls_ddr2_dll_reset
memctls_ddr2_dll_reset:

	li	t0, 0xb8001004
	li	t1, 0x10220000 #1 chip, 8bit mode
	#li	t1, 0x11220000 #1 chip, 16bit mode
	sw	t1,0(t0)
	nop

	li	t0, 0xb800100c
	li	t1, 0x04040311 #1 chip
	sw	t1,0(t0)
	nop

	li	t0, 0xb8001010
	li	t1, 0x03211000 #1 chip
	sw	t1,0(t0)
	nop
#if 0
	/* 
	 * Set mode register for DRAM DLL reset. 
	 */
	/* Maximize the refresh cycles for the 200 clock cycles delay requirement of DLL reset */
	li	t0, 0xb8001008
	#li	t1, 0x231FF800
	li	t1, 0x23122800
	sw	t1, 0(t0)
	nop

	/* 1. Disable DLL */
	li	t0, 0xB800101C
	li	t1, 0x00110401
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* 1. Enable DLL */
	li	t0, 0xB800101C
	li	t1, 0x00110400 // Disable ODT, full strength
	//li	t1, 0x00110444 // 50ohm, full strength
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	/* 2. Reset DLL */
	li	t0, 0xB800101C
	li	t1, 0x00100332
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop
	/* wait 200 clock cycles */
	li	t0, 0x800
1:
	bne	zero, t0, 1b
	add	t0, t0, -1



	/* 3. Set EMR2 */
	li	t0, 0xB800101C
	li	t1, 0x00120000
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* 4. Enter normal operation */
	li	t0, 0xB800101C
	li	t1, 0x00100232
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop
#else
#define DRAM_CAS	(6)
#define DRAM_WR		(4)
	/* 
	 * Set mode register for DRAM DLL reset. 
	 */
	/* Maximize the refresh cycles for the 200 clock cycles delay requirement of DLL reset */
	li	t0, 0xb8001008
	li	t1, ((0x00022900) | ((DRAM_WR-1)<<24) | ((DRAM_CAS-1)<<28) | ((DRAM_CAS-2)<<20))
	#li	t1, ((0x00022a30) | ((DRAM_WR-1)<<24) | ((DRAM_CAS-1)<<28) | ((DRAM_CAS-2)<<20))
	sw	t1, 0(t0)
	nop

	/* 1. Disable DLL */
	li	t0, 0xB800101C
	li	t1, 0x00110401
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* 1. Enable DLL */
	li	t0, 0xB800101C
	li	t1, 0x00110400 // Disable ODT, full strength
	//li	t1, 0x00110444 // 50ohm, full strength
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	/* 2. Reset DLL */
	li	t0, 0xB800101C
	li	t1, (0x00100102) | (DRAM_CAS << 4) | ((DRAM_WR-1) << 9)
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop
	/* wait 200 clock cycles */
	li	t0, 0x800
1:
	bne	zero, t0, 1b
	add	t0, t0, -1



	/* 3. Set EMR2 */
	li	t0, 0xB800101C
	li	t1, 0x00120000
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* 4. Enter normal operation */
	li	t0, 0xB800101C
	li	t1, (0x00100002) | (DRAM_CAS << 4) | ((DRAM_WR-1) << 9)
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

#endif
	/* reset DDR PHY */
	li 	t0, 0xb8001500
	li	t1, 0x80000000
	sw	t1, 0(t0)
	nop
	li	t1, 0x80000010
	sw	t1, 0(t0)
	nop

	jr	ra
	nop
	.end memctls_ddr2_dll_reset


        .text
        .set noreorder
        .globl  memctls_ddr3_dll_reset
	.ent memctls_ddr3_dll_reset
memctls_ddr3_dll_reset:
#if 0
	# configure DDR calibration parameters
	li	t0, 0xb8001510
	la	t2, DDR3_param_start
	li	t3, 36
1:
	addi	t3, t3, -1
	lw	t1, 0(t2)
	addi	t2, t2, 4
	sw	t1, 0(t0)
	addi	t0, t0, 4
	bne	zero, t3, 1b
	nop
	# TX delay, clkm delay, clkm90 delay and dqs rx delay
	li	t0, 0xb8000214
	lw	t1, 0(t2)
	nop
	#sw	t1, 0(t0)
	lw	t1, 8(t2)
	nop
	#sw	t1, 8(t0)
	nop
#endif
	li	t0, 0xb8001590
	li	t1, 0x08080000 #DM delay
	sw	t1,0(t0)
	nop

	li	t0, 0xb8001004
	li	t1, 0x21220000 #1 chip, 16bit
	#li	t1, 0x20220000 #1 chip, 8bit
	sw	t1,0(t0)
	nop
	li	t0, 0xb800100c
	li	t1, 0x05050313 # tRP = 6, tRCD=6, tRRD=4, tFAWG=20
	sw	t1,0(t0)
	nop
	li	t0, 0xb8001010 
	li	t1, 0x02d0e000 # tRFC = 44, tRAS=15
	sw	t1,0(t0)
	nop

	/* 
	 * Set mode register for DRAM DLL reset. 
	 */
	/* Maximize the refresh cycles for the 200 clock cycles delay requirement of DLL reset */
	li	t0, 0xb8001008
	li	t1, 0x44533f00 # tCAS = 5, tWR = 5, tCWL = 6, tRTP = 4, tWTR = 4
	#li	t1, 0x54588800
	#li	t1, 0x44600800
	#li	t1, 0x44588800
	#li	t1, 0x44533800
	sw	t1, 0(t0)
	nop

	/* 1. Disable DLL */
	li	t0, 0xB800101C
	li	t1, 0x00110001
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* 2. Set MR2 */
	li	t0, 0xB800101C
	li	t1, 0x00120008
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* 3. Set MR3 */
	li	t0, 0xB800101C
	li	t1, 0x00130000
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	/* 4. Set MR1 */
	li	t0, 0xB800101C
	li	t1, 0x00110040 # enable DLL, Rtt_Nom/2
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	/* 4. Set MR0 */
	li	t0, 0xB800101C
	li	t1, 0x00100320 # Reset DLL, Cas==6
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	/* wait 200 clock cycles */
	li	t0, 0x800
1:
	bne	zero, t0, 1b
	add	t0, t0, -1


	/* 5. Set MR0 normal */
	li	t0, 0xB800101C
	li	t1, 0x00100220 # Cas==6
	sw	t1, 0(t0)

	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop


	/* 5. ZQ Long calibation */
	li	t0, 0xb8001080
	lw	t3, 0(t0)
	li	t2, 0x80000000
	or	t3, t3, t2
	sw	t3, 0(t0)
	
	/* waiting for MRS busy */
	li	t1, 0x80000000
1:
	lw	t4, 0(t0)
	nop
	and 	t4, t4, t1
	bne	zero, t4, 1b
	nop

	/* reset DDR PHY */
	li 	t0, 0xb8001500
	li	t1, 0x80000000
	sw	t1, 0(t0)
	nop
	li	t1, 0x80000010
	sw	t1, 0(t0)
	nop

	jr	ra
	nop
	.end memctls_ddr3_dll_reset


DDR3_param_start:
#if 0
	.word 0x0d190d01, 0x0a160b01, 0x0b170c01, 0x091b0e01
	.word 0x0d180c01, 0x08180c01, 0x0a180c01, 0x09180c01
	.word 0x0b160b01, 0x09180c01, 0x0a160b01, 0x0b190d01
	.word 0x0a150b01, 0x0b180c01, 0x081a0d01, 0x091a0d01
	.word 0x00170c01, 0x00150b01, 0x00160b01, 0x001a0d01
	.word 0x00160b01, 0x00160b01, 0x00190d01, 0x001a0d01
	.word 0x00160b01, 0x00170c01, 0x001c0e01, 0x00170c01
	.word 0x00130a01, 0x00160b01, 0x00190d01, 0x00170c01
#else
	.word 0x0b0d0701, 0x07110901, 0x08140a01, 0x0b140a01
	.word 0x07120901, 0x07170c01, 0x07110901, 0x08130a01
	.word 0x07160b01, 0x07150b01, 0x07160b01, 0x07150b01
	.word 0x09150b01, 0x07180c01, 0x08170c01, 0x07180c01
	.word 0x000d0701, 0x00110901, 0x00130a01, 0x00140a01
	.word 0x00110901, 0x00180c01, 0x00110901, 0x00140a01
	.word 0x00160b01, 0x00160b01, 0x00130a01, 0x00140a01
	.word 0x00160b01, 0x00180c01, 0x00180c01, 0x00190d01
#endif
	.word 0x00000000, 0x00000000, 0x00000000, 0x00000000
	.word 0x00000000, 0x00000000, 0x00000000, 0x00000000 # tx, clkm, clkm90 and dqs rx delay

