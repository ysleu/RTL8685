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

	# strapping pin 
	move	k0, ra
	li		t1, BSP_MISC_PINOCR
	lw		t0, 0(t1)
	nop
	and		t0, t0, 0x40
	beqz	t0, boot_from_SPI
	nop
	
boot_from_SPI:	
	Mem_Init_RTL8676
	
	SRAM_Map 0x00600000, 0x7, 0x30, 0x2000	/* map 0x80600000 (16K) to SRAM segment 2 */
	Mem_Set_Word 0xa0600000,0x4000,0x0		/* fill 0 */

	/* copied from romInit.s */
###############################################
	li		t0,0xb8000308		//detect DDR or SDR on board.
	lw		t9,0(t0)
	nop
	srl 	t9,8
	and		t8,t9,0x2
	beqz	t8,is_SDRAM
	nop
###############################################	////////////// //Disable clock SSD  //////////////////////////
	li		t0,0x80000000		//Disable clock SSD for DDR, DDR SDRAM
	li		t1,0xb8000220
	sw		t0,0(t1)
	nop	
	Noop_Delay	100
############################################## 		
//	SDR & DDR I/O PAD current select for test only. 	
	//li		t0,0x00000407		//all DDR bus, driving upgrade	
	//li		t0,0x00000404		//DDR bus,data, clock driving upgrade	
	li		t0,0x0000400			//data bus, driving upgrade
	//li		t0,0x0				//driving normally
	li		t1,0xb8000314
	sw		t0,0(t1)
	nop	
############################################## 		
# SDRAM/DDR Memory timing register, MUST set before MCR(config. reg)
#ifdef LX_210_DDR166
	li		t0,0x6CEC8480
	li		t2,0x54A00000		//RX DQS calibration default value, PLL analog calibration value for DDR only.*	.	
#else										//DRAM_133MHz:
	li		t0,0x6CEBE280		//DTR parameter
	li		t2,0x5EF00000		//RX DQS calibration default value, PLL analog calibration value for DDR only.*	.
#endif
	nop
	li		t1,0xb8001008		//set_DTR:
	sw		t0,0(t1)
	nop	
	li		t1,0xb8001050
	sw		t2,0(t1)
	nop	
############################################## 	 	
#if 1		//DRAM PLL reset
		li 		t0,0x10000131
		li		t1,0xb800100c
	sw		t0,0(t1)
	nop		
		li		t0,0x524a0000
		li		t1,0xb8001004		
		sw		t0,0(t1)		
		Noop_Delay 1200		
#endif
	
############################################## 	 	
	li		t0,0x52480000							//16M, for SDRAM & DDR
	li		t1,0xB8001004							//initial DDR signal re-send
	sw		t0,0(t1)
	nop			
#################################################		
 	and		t8,t9,0x1
 	beqz	t8,is_DDR1
 	nop
is_DDR2:
##############################################
// MRS configuration for DDR setting.
#if 1
// MRS configuration for DDR setting.
#define	MCR_PARA			t0
#define	MRS_VALUE			t1
#define	EMRS_VALUE			t2
#define	EDTCR_ADDR			t3
#define	EDTCR_ORG			t4
#define	MCR_ADDR			t5
#define	REG_TEMP			t6
#define	REG_TEMP2			t7
#define	MCR_ORG			t8
#define	REG_TEMP1			t9
	li		MCR_ADDR,0xb8001004
	li		EDTCR_ADDR,0xb800100c
	//li		MRS_VALUE,0x31					//DLL reset=0, TM=0, CAS# Latency=3, BurstType=0, BurstLength=1(2), n15..n14=00(Mode Register)
	//li		EMRS_VALUE,0x4406				//I/O Strength reduce (half), n15..n14=01(EMR), ODT 75ohm,DQS# disable
	lw		MCR_ORG,0(MCR_ADDR)			//Load MCR
	nop	
	or		MCR_PARA,MCR_ORG,0x20000		//MR MODE EN.	
#if defined(CONFIG_DDR2_8banks)
	li		REG_TEMP,0x50004406						//set EMRS value, supported 8 banks for DDR2, and modified WTR from 111b -> 010b
#else
	li		REG_TEMP,0x10004406						//set EMRS value, supported 4 banks for DDR2, and modified WTR from 111b -> 010b
#endif	
	nop
#if 1
	sw		REG_TEMP,0(EDTCR_ADDR)				//set EMRS for DDR1 initial 
1:																		
	lw		REG_TEMP2,0(MCR_ADDR)
	nop
	and		REG_TEMP2,REG_TEMP2,0x1				//check DCR_WR_BUSY
	nop
	bnez	REG_TEMP2,1b
	nop
#endif
	sw		MCR_PARA,0(MCR_ADDR)					//set MR mode enable 
1:
	lw		REG_TEMP2,0(MCR_ADDR)
	nop
	and		REG_TEMP2,REG_TEMP2,0x1				//check DCR_WR_BUSY
	nop
	bnez	REG_TEMP2,1b
	nop
#if 1	
	sw		MCR_ORG,0(MCR_ADDR)						//MR MODE Disable.
	nop
1:
	lw		REG_TEMP2,0(MCR_ADDR)
	nop
	and		REG_TEMP2,REG_TEMP2,0x1				//check DCR_WR_BUSY
	nop
	bnez	REG_TEMP2,1b
	nop
#endif
#undef	MCR_PARA
#undef	MRS_VALUE
#undef	EMRS_VALUE
#undef	EDTCR_ADDR
#undef	MCR_ADDR
#undef	REG_TEMP
#undef	MCR_ORG
#undef	REG_TEMP2
#undef	EDTCR_ORG
	b			DDR_Pre_Setup_finish
	nop
#endif	
##############################################	
is_DDR1:
#if 1
	li		t5,0xb8001004
	li		t1,0x52480000
	sw		t1,0(t5)
1:
	lw		t2,0(t5)
	nop
	and		t2,t2,0x1				//check DCR_WR_BUSY
	nop
	bnez		t2,1b
	nop	
	li		t0,0xb800100c
	li		t1,0x10004002								//modified WTR from 111b -> 010b
	sw		t1,0(t0)
	nop
	nop
	li		t1,0x524a0000
	sw		t1,0(t5)
	nop
	Noop_Delay 100
1:
	lw		t2,0(t5)
	nop
	and		t2,t2,0x1				//check DCR_WR_BUSY
	nop
	bnez		t2,1b
	nop		
	li		t1,0x52480000
	sw		t1,0(t5)
	nop
#endif

DDR_Pre_Setup_finish:
	Noop_Delay 1200		
###############################################
	////////////enable GDMA module 
	//enable GDMA module 0xb800030c[n10]=1
	li	t1,0xb800030c	
	lw	t7,0(t1)			//load 0xb800030c
	nop
	ori	t7,t7,0x400		//set 0xb800030c[n10]=1
 	nop
 	sw	t7,0(t1)			//enable GDMA module
 	nop
###############################################
//////// Global paramter setup //////
#if defined(CONFIG_RAM_AUTO)
#define CLK_133MHZ_FLAG	s2
#ifdef	LX_210_DDR166
 	move	CLK_133MHZ_FLAG,zero		//default run 166MHz
#else	 	
	li		CLK_133MHZ_FLAG,1		//run in 133MHz
#endif	
#endif	
///////copy GENERATE PATTERN code to SRAM 0xA0606000 ////////
#define		CP_BLK_START_ADDR		t0
#define		CP_BLK_END_ADDR		t1
#define		CP_BLK_LENGTH			t2
#define		CP_BLK_TEMP1			t3
#define		CP_BLK_TEMP2			t4
	la		CP_BLK_START_ADDR, DQS_CALIBRATION_BEGIN
	la		CP_BLK_END_ADDR, DQS_CALIBRATION_FINISH
	sub		CP_BLK_LENGTH,CP_BLK_END_ADDR,CP_BLK_START_ADDR
	li		CP_BLK_TEMP1,0xa0600050											//save copy block length
	sw		CP_BLK_LENGTH,0(CP_BLK_TEMP1)

	li		CP_BLK_TEMP1,0xbfc00000											//boot start address.
	or		CP_BLK_START_ADDR,CP_BLK_START_ADDR,CP_BLK_TEMP1				//transfer DRAM(0x80000000) to FLASH(0xbfc00000) address
	or		CP_BLK_END_ADDR,CP_BLK_END_ADDR,CP_BLK_TEMP1					//transfer DRAM(0x80000000) to FLASH(0xbfc00000) address
	
	li		CP_BLK_TEMP1, 0xA0600100										//start address of SRAM reserve area  
	
1:	
	lw		CP_BLK_TEMP2, 0(CP_BLK_START_ADDR)								//load code from flash
	nop
	sw		CP_BLK_TEMP2, 0(CP_BLK_TEMP1)									//restore code to SRAM
	addi		CP_BLK_START_ADDR, CP_BLK_START_ADDR, 4
	addi		CP_BLK_TEMP1, CP_BLK_TEMP1, 4
	bne		CP_BLK_START_ADDR, CP_BLK_END_ADDR, 1b
	nop
	li		CP_BLK_TEMP1, 0xA0600100										//
	jal		CP_BLK_TEMP1													//jump to SRAM
	nop
	//nop	

#undef		CP_BLK_START_ADDR
#undef		CP_BLK_END_ADDR
#undef		CP_BLK_LENGTH
#undef		CP_BLK_TEMP1
#undef		CP_BLK_TEMP2
///////////////////////////////////////////////////////// 	
DQS_CALIBRATION_BEGIN:
	nop
	move	t6,ra																//save ra address
	li		t7,0xa0600054
	sw		t6,0(t7)
////GENERATE PATTERN /////////////////////////////
GENERATE_PATTERN:
#define	PATTERN_TEMP1		t1
#define	PATTERN_TEMP2		t2
#define	PATTERN_LENGTH		t3
#define	PATTERN				t4		
#define	PATTERN1			t5
PATTERN_START:
	li		PATTERN,0x5a5aa5a5							//default pattern
	li		PATTERN1,0x0FFFF								//default pattern
////////////GEN data from 0xa0602000 to 0xa0602FFF, 4k bytes
	li		PATTERN_TEMP1,0xa0602000				//start address
	li		PATTERN_LENGTH,0x1000						//4k bytes, end address
1:	
	sw		PATTERN1,0(PATTERN_TEMP1)				//pattern1(0x0FFFF)
	addi	PATTERN_TEMP1,PATTERN_TEMP1,4
	not		PATTERN_TEMP2,PATTERN1					//pattern1 reverse (0xFFFF0000)
	sw		PATTERN_TEMP2,0(PATTERN_TEMP1)
	addi	PATTERN_TEMP1,PATTERN_TEMP1,4
	sw		PATTERN,0(PATTERN_TEMP1)				//pattern(0x5a5aa5a5)
	addi	PATTERN_TEMP1,PATTERN_TEMP1,4
	not		PATTERN_TEMP2,PATTERN						//pattern reverse(0xa5a55a5a)
	sw		PATTERN_TEMP2,0(PATTERN_TEMP1)
	addi	PATTERN_TEMP1,PATTERN_TEMP1,4
	subu	PATTERN_LENGTH,0x10
	bnez	PATTERN_LENGTH,1b
	nop
#undef	PATTERN_TEMP1
#undef	PATTERN_TEMP2
#undef	PATTERN_LENGTH	
#undef	PATTERN					
#undef	PATTERN1
GENERATE_PATTERN_FINISH:
///////// generate data finish /////////

#======Start  DDR calibration (GDMA)===========
#if 1
/////////  DQS calibration start  /////////
#define 	SW_SRAM_ADDR		t0
#define 	DQS_TEMP5		 	t1
#define 	RUN_CYCLE	 		t2
#define 	SW_DDCR_VAL 		t3
#define 	DQS_TEMP1	 		t4
#define 	DQS_TEMP2	 		t5
#define 	DQS_TEMP3	 		t6
#define 	DQS_TEMP4	 		t7
#define 	POINT_CURSOR 		t8
#define 	UP_LIMIT		 		t9
#define 	DQS_CALI_TEMP		s0
#define 	DATA_MASK			s1
//s2 reg. is for global parameter.
#define 	L0 					s3
#define 	R0 					s4
#define 	L1 					s5
#define 	R1 					s6
#define 	L_DONE_BIT			s7
	//.set reorder
//// insert DDR calibration version, record in 0xA0600018 //start///	
	li		DQS_TEMP1,0xA0600018
	li		DQS_TEMP2,0x1D02					//version: 1.02
	sw		DQS_TEMP2,0(DQS_TEMP1)
//// insert DDR calibration version, record in 0xA0600018 //end///	
DQS_CALIBRATION_START:	
///////Initial REG. default value ///////////
	li		SW_SRAM_ADDR,0xa0603000
	li		DQS_TEMP1, 0xb8001050
 	li		SW_DDCR_VAL, 0x40000000           			//  [n31]=1:sw cal, 0:hw cal
	sw		SW_DDCR_VAL, 0(DQS_TEMP1)
	li		DQS_CALI_TEMP,0
 	li		UP_LIMIT, 31
 	li		RUN_CYCLE,0
 	move	L0, zero
 	move	L1, zero
 	move	L_DONE_BIT, zero
 	li		R0, 0
 	li		R1, 0

///////Initial REG. default value finish///////////	
////////////GEN data to DDR, the address from 0xa0602000 to 0xa0602FFF, 4k bytes  ////////
	nop
	li		DQS_TEMP1,0xA0612000				//start address	(DDR start address)
	li		DQS_TEMP2,0xA0613000				//end address	(DDR end address)
	li		DQS_TEMP4,0xA0602000				//start address	(SRAM start address)
1:	
	lw		DQS_TEMP3,0(DQS_TEMP4)				//read data form SRAM
	sw		DQS_TEMP3,0(DQS_TEMP1)				//write data to DDR
	addiu	DQS_TEMP1,DQS_TEMP1,4
	addiu	DQS_TEMP4,DQS_TEMP4,4	
	bne		DQS_TEMP1,DQS_TEMP2,1b	
	nop
//////////// GEN data to DDR finish ///////////////
CALIBRATE_DQS0:
#if defined(CONFIG_RAM_AUTO)
	bgt		RUN_CYCLE,2,RUN133MHz					//if RUN_CYCLE > 2, jump RUN133MHz
#else
	bgt		RUN_CYCLE,2,FIXED_DQS					//if RUN_CYCLE > 2, jump FIXED_DQS
#endif	
	nop
 	li		POINT_CURSOR, 0
CALIBRATE_DQS0_LOOP1:
////////////Clearn data from 0xa0603000 to 0xa0603FFF, 4k bytes
	move	DQS_TEMP1,SW_SRAM_ADDR			//start address
	li		DQS_TEMP2,0x1000					//Clean length 4k bytes
	li		DQS_TEMP3,0
1:	
	sw		DQS_TEMP3,0(DQS_TEMP1)
	addiu	DQS_TEMP1,DQS_TEMP1,4
	subu		DQS_TEMP2,4
	nop
	bnez		DQS_TEMP2,1b
	nop
///////// Clearn data  finish /////////
DQS_PARAMETER_CH:
	li		SW_DDCR_VAL,0x40000000
	bltu	UP_LIMIT, POINT_CURSOR, CALIBRATE_DQS0_LOOP1_OUT
	nop
	sll		DQS_TEMP1, POINT_CURSOR, 25
	or		SW_DDCR_VAL, SW_DDCR_VAL, DQS_TEMP1				// SW_DDCR_VAL default equ 0x40000000, write DQS0 value.
	li		DQS_TEMP1,0xb8001050
	sw		SW_DDCR_VAL, 0(DQS_TEMP1)						//setting DQS0 value to 0xb8001050.
////////GDMA move data from DDR to SRAM  ///////////////////////////
//// GDMA use TX_TEMP1,TX_TEMP2,TX_TEMP3 REG.	/////////////////
 	li		DQS_TEMP1,0xb800a000
 	li		DQS_TEMP2,0x0
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Software reset GDMA, 0xb800a000[n31]=0	-> 1
 	li		DQS_TEMP2,0x80000000
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Enable GDMA, 0xb800a000[n31]=1, and func set to memory copy [n27..n24]=0
 	li		DQS_TEMP2,0x0
 	li		DQS_TEMP1,0xb800a004
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Interrupt Mask Register clean
 	li		DQS_TEMP2,0x90000000
 	li		DQS_TEMP1,0xb800a008
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Interrupt status Register, [n31] and [n28] write 1 to clean
 ///////////GDMA memory copy (setup source)/////////////////////////////////
 	li		DQS_TEMP2,0x00612000			//source data address
 	li		DQS_TEMP1,0xb800a020
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting source data address
  li		DQS_TEMP2,0x80001000			//[n31]=1, last data block, and source data length[n12..n0]
 	li		DQS_TEMP1,0xb800a024
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting source data length
/////////////GDMA memory copy (setup destination)/////////////////////////////////
	and		DQS_TEMP2,SW_SRAM_ADDR,0x0FFFFFFF	//destination data address
 	li		DQS_TEMP1,0xb800a060
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting destination data address
 	li		DQS_TEMP2,0x80001000			//[n31]=1, last data block, and destination data length[n12..n0]
 	li		DQS_TEMP1,0xb800a064
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting destination data length
//////////////startting  GDMA process 	/////////////////////////////////
  li		DQS_TEMP2,0xC0000000			//GDMA_ENABLE | GDMA_POLL | GDMA_MEMCPY	//startting  GDMA process
 	li		DQS_TEMP1,0xb800a000
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//startting  GDMA 
//////////////polling GDMA copy done flag	/////////////////////////////////
  li		DQS_TEMP2,0x0					// clean data buffer
  li		DQS_TEMP3,0x80000000
 	li		DQS_TEMP1,0xb800a008			// GDMA	Interrupt Status Register
1:
 	lw		DQS_TEMP2,0(DQS_TEMP1)			// load 
 	nop
 	and 		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3	
 	beqz		DQS_TEMP2,1b					//GDMA_not_complete
 	nop	
////////GDMA move data from DDR to SRAM  finish ///////////////////////////	
	bnez		L_DONE_BIT, CALIBRATE_DQS0_R0_SET
	nop
//////////software compare data /////////////////
	move	DQS_TEMP1,SW_SRAM_ADDR							//start compare address
	li		DQS_TEMP3,0xA0612000
	li		DQS_TEMP5,0x1000									//length, end compare address
 	li		DATA_MASK,0x00FF00FF	
 	subu	DQS_TEMP5,4	
	//bnez		L_DONE_BIT, CALIBRATE_DQS0_R0_SET
	//nop 	

1:	
	lw		DQS_TEMP2,0(DQS_TEMP1)								//read data from SRAM ( just use GDMA copy data from DDR to SRAM)
	nop
	lw		DQS_TEMP4,0(DQS_TEMP3)								//read data from DRAM ( just use GDMA copy data from DDR to SRAM)
	nop
	and		DQS_TEMP2,DQS_TEMP2,DATA_MASK					//data and mask.
	and		DQS_TEMP4,DQS_TEMP4,DATA_MASK
	addiu	DQS_TEMP1,DQS_TEMP1,4								//address plus 4
	addiu	DQS_TEMP3,DQS_TEMP3,4								//address plus 4
	bne		DQS_TEMP2,DQS_TEMP4,CALIBRATE_DQS0_LOOP1_REENTRY	//compare pattern
	nop
	subu	DQS_TEMP5,4
	bnez	DQS_TEMP5,1b
	nop
	move 	L0, POINT_CURSOR
	addiu	L_DONE_BIT,L_DONE_BIT,1	
CALIBRATE_DQS0_R0_SET:	
	move	DQS_TEMP1,SW_SRAM_ADDR							//start compare address						
	li		DQS_TEMP3,0xA0612000
	li		DQS_TEMP5,0x1000									//length, end compare address
 	li		DATA_MASK,0x00FF00FF	
	subu	DQS_TEMP5,4 	
1:	
	lw		DQS_TEMP2,0(DQS_TEMP1)								//read data from SRAM ( just use GDMA copy data from DDR to SRAM)
	nop
	lw		DQS_TEMP4,0(DQS_TEMP3)								//read data from DRAM ( just use GDMA copy data from DDR to SRAM)
	nop
	and		DQS_TEMP2,DQS_TEMP2,DATA_MASK						//data and mask.
	and		DQS_TEMP4,DQS_TEMP4,DATA_MASK
	addiu	DQS_TEMP1,DQS_TEMP1,4								//address plus 4
	addiu	DQS_TEMP3,DQS_TEMP3,4								//address plus 4	
	bne		DQS_TEMP2,DQS_TEMP4,Check_R0_value					//compare pattern
	nop
	subu		DQS_TEMP5,4
	bnez		DQS_TEMP5,1b
	nop	
	move 	R0, POINT_CURSOR
	//b		CALIBRATE_DQS0_LOOP1_REENTRY	
	nop		
CALIBRATE_DQS0_LOOP1_REENTRY:	
	addiu 	POINT_CURSOR, POINT_CURSOR, 1
	b 		CALIBRATE_DQS0_LOOP1
  nop
Check_R0_value:  	
  	beqz		R0,L0_plus1_CLR_L_DONE					//if R0=0, L0 plus 1
  	nop
  	beq		R0,L0,L0_plus1_CLR_L_DONE				//if R0=L0, L0 plus 1
  	nop
  	sub		DQS_TEMP1,R0,L0
	blt		DQS_TEMP1,2,L0_plus1_CLR_L_DONE  		//if (R0-L0) < 2 ,L0 plus 1
	nop
  	b		CALIBRATE_DQS0_LOOP1_R0_OUT
  	nop
L0_plus1_CLR_L_DONE:
	li		L_DONE_BIT,0
	li		R0,0
	b		CALIBRATE_DQS0_LOOP1_REENTRY
	nop
##################
CALIBRATE_DQS0_LOOP1_R0_OUT:
	addiu	RUN_CYCLE,RUN_CYCLE,1
	beqz		R0,CALIBRATE_DQS0
	nop
	add		DQS_TEMP1,R0,L0
	beqz		DQS_TEMP1,CALIBRATE_DQS0				//if (R0+L0) = 0, re-try agaim.
	nop
	sub		DQS_TEMP1,R0,L0
	blt		DQS_TEMP1,2,CALIBRATE_DQS0				//if (R0-L0) < 2 , the vale is very close, so re-try again.
	nop
	beq		R0,L0,CALIBRATE_DQS0					//if R0=L0, re-try again.
	nop
CALIBRATE_DQS0_LOOP1_OUT:	
###################
	beqz		R0,CALIBRATE_DQS0_LOOP1_R0_OUT
	nop
	move	DQS_TEMP1, L0										//move L0 to DQS_TEMP1
	add		DQS_TEMP1, DQS_TEMP1, R0				//DQS_TEMP1 equ sum( L0 + R0 )
	srl 		DQS_TEMP1, DQS_TEMP1, 1					//calibration value div 2		

#######################	
	sll		DQS_TEMP1, DQS_TEMP1, 25
	li		SW_DDCR_VAL, 0x40000000 				//initial analog calibration.		
	or		DQS_CALI_TEMP, SW_DDCR_VAL, DQS_TEMP1	//finish DQS0 calibration, save in DQS_CALI_TEMP
	li		DQS_TEMP1,0xb8001050
	sw		DQS_CALI_TEMP, 0(DQS_TEMP1)
//////////Starting DQS1 calibration //////////////
	move	L_DONE_BIT, zero
	li		RUN_CYCLE,0
CALIBRATE_DQS1:
#if defined(CONFIG_RAM_AUTO)
	bgt		RUN_CYCLE,2,RUN133MHz					//if RUN_CYCLE > 2, jump RUN133MHz
#else	
	bgt		RUN_CYCLE,2,FIXED_DQS					//if RUN_CYCLE > 2, jump FIXED_DQS	
#endif	
	nop
 	move	POINT_CURSOR, zero	
CALIBRATE_DQS1_LOOP1: 	
////////////Clearn data from 0xa0603000 to 0xa0603FFF, 4k bytes
	move	DQS_TEMP1,SW_SRAM_ADDR				//start address
	li		DQS_TEMP2,0x1000						//Clean length 4k bytes
	li		DQS_TEMP3,0
1:	
	sw		DQS_TEMP3,0(DQS_TEMP1)
	addiu	DQS_TEMP1,DQS_TEMP1,4
	subu		DQS_TEMP2,4
	bnez		DQS_TEMP2,1b
	nop
///////// Clearn data  finish /////////
DQS1_PARAMETER_CH:
	move	SW_DDCR_VAL,DQS_CALI_TEMP							//load calibration method and DQS0 value.
	bltu	UP_LIMIT, POINT_CURSOR, CALIBRATE_DQS1_LOOP1_OUT	//out of parameter range
	nop
	sll		DQS_TEMP1, POINT_CURSOR, 20							//DQS1 set bit[n24..n20]
	or		SW_DDCR_VAL, SW_DDCR_VAL, DQS_TEMP1				// SW_DDCR_VAL default equ 0x40000000, write DQS0 value.
	li		DQS_TEMP1,0xb8001050
	sw		SW_DDCR_VAL, 0(DQS_TEMP1)						//setting DQS1 value to 0xb8001050.
////////GDMA move data from DDR to SRAM  ///////////////////////////
//// GDMA use TX_TEMP1,TX_TEMP2,TX_TEMP3 REG.	/////////////////
 	li		DQS_TEMP1,0xb800a000
 	li		DQS_TEMP2,0x0
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Software reset GDMA, 0xb800a000[n31]=0	-> 1
 	li		DQS_TEMP2,0x80000000
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Enable GDMA, 0xb800a000[n31]=1, and func set to memory copy [n27..n24]=0
 	li		DQS_TEMP2,0x0
 	li		DQS_TEMP1,0xb800a004
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Interrupt Mask Register clean
 	li		DQS_TEMP2,0x90000000
 	li		DQS_TEMP1,0xb800a008
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//Interrupt status Register, [n31] and [n28] write 1 to clean
 ///////////GDMA memory copy (setup source)/////////////////////////////////
 	li		DQS_TEMP2,0x00612000			//source data address
 	li		DQS_TEMP1,0xb800a020
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting source data address
  	li		DQS_TEMP2,0x80001000			//[n31]=1, last data block, and source data length[n12..n0]
 	li		DQS_TEMP1,0xb800a024
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting source data length
/////////////GDMA memory copy (setup destination)/////////////////////////////////
	and		DQS_TEMP2,SW_SRAM_ADDR,0x0FFFFFFF	//destination data address
 	li		DQS_TEMP1,0xb800a060
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting destination data address
 	li		DQS_TEMP2,0x80001000			//[n31]=1, last data block, and destination data length[n12..n0]
 	li		DQS_TEMP1,0xb800a064
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//setting destination data length
//////////////startting  GDMA process 	/////////////////////////////////
  li		DQS_TEMP2,0xC0000000			//GDMA_ENABLE | GDMA_POLL | GDMA_MEMCPY	//startting  GDMA process
 	li		DQS_TEMP1,0xb800a000
 	sw		DQS_TEMP2,0(DQS_TEMP1)			//startting  GDMA 	
//////////////polling GDMA copy done flag	/////////////////////////////////
  li		DQS_TEMP2,0x0					// clean data buffer
  li		DQS_TEMP3,0x80000000
 	li		DQS_TEMP1,0xb800a008			// GDMA	Interrupt Status Register
1:
 	lw		DQS_TEMP2,0(DQS_TEMP1)					// load 
 	nop
 	and 		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3	
 	beqz		DQS_TEMP2,1b					//GDMA_not_complete
 	nop	
////////GDMA move data from DDR to SRAM  finish ///////////////////////////	
	bnez		L_DONE_BIT, CALIBRATE_DQS1_R1_SET
	nop
//////////software compare data /////////////////
	move	DQS_TEMP1,SW_SRAM_ADDR							//start compare address
	li		DQS_TEMP3,0xA0612000
	li		DQS_TEMP5,0x1000									//length, end compare address
 	li		DATA_MASK,0xFF00FF00	
	subu		DQS_TEMP5,4 	
	//bnez		L_DONE_BIT, CALIBRATE_DQS1_R1_SET
	//nop
1:	
	lw		DQS_TEMP2,0(DQS_TEMP1)								//read data from SRAM ( just use GDMA copy data from DDR to SRAM)
	nop
	lw		DQS_TEMP4,0(DQS_TEMP3)								//read data from DRAM ( just use GDMA copy data from DDR to SRAM)
	nop
	and		DQS_TEMP2,DQS_TEMP2,DATA_MASK						//data and mask.
	and		DQS_TEMP4,DQS_TEMP4,DATA_MASK
	addiu	DQS_TEMP1,DQS_TEMP1,4								//address plus 4
	addiu	DQS_TEMP3,DQS_TEMP3,4								//address plus 4	
	bne		DQS_TEMP2,DQS_TEMP4,CALIBRATE_DQS1_LOOP1_REENTRY	//compare pattern
	nop
	subu		DQS_TEMP5,4
	bnez		DQS_TEMP5,1b
	nop
	move 	L1, POINT_CURSOR
	addiu	L_DONE_BIT,L_DONE_BIT,1		
CALIBRATE_DQS1_R1_SET:	
	move	DQS_TEMP1,SW_SRAM_ADDR							//start compare address
	li		DQS_TEMP3,0xA0612000
	li		DQS_TEMP5,0x1000									//length, end compare address
 	li		DATA_MASK,0xFF00FF00	
	subu		DQS_TEMP5,4 	
1:	
	lw		DQS_TEMP2,0(DQS_TEMP1)								//read data from SRAM
	nop
	lw		DQS_TEMP4,0(DQS_TEMP3)								//read data from DRAM
	nop
	and		DQS_TEMP2,DQS_TEMP2,DATA_MASK						//data and mask.
	and		DQS_TEMP4,DQS_TEMP4,DATA_MASK
	addiu	DQS_TEMP1,DQS_TEMP1,4								//address plus 4
	addiu	DQS_TEMP3,DQS_TEMP3,4								//address plus 4	
	bne		DQS_TEMP2,DQS_TEMP4,Check_R1_value					//compare pattern
	nop
	subu		DQS_TEMP5,4
	bnez		DQS_TEMP5,1b
	nop	
	move 	R1, POINT_CURSOR
	nop		
CALIBRATE_DQS1_LOOP1_REENTRY:	
	addiu 	POINT_CURSOR, POINT_CURSOR, 1
	b 		CALIBRATE_DQS1_LOOP1
  nop
Check_R1_value:  	
  	beqz		R1,L1_plus1_CLR_L_DONE					//if R1=0, L1 plus 1
  	nop
  	beq		R1,L1,L1_plus1_CLR_L_DONE				//if R1=L1, L1 plus 1
  	nop
  	sub		DQS_TEMP1,R1,L1
	blt		DQS_TEMP1,2,L1_plus1_CLR_L_DONE  		//if (R1-L1) < 2 ,L1 plus 1
	nop
  	b		CALIBRATE_DQS1_LOOP1_R1_OUT
	nop
L1_plus1_CLR_L_DONE:
	li		L_DONE_BIT,0
	li		R1,0
	b		CALIBRATE_DQS1_LOOP1_REENTRY
	nop
CALIBRATE_DQS1_LOOP1_R1_OUT:
	addiu	RUN_CYCLE,RUN_CYCLE,1
	beqz		R1,CALIBRATE_DQS1						//if R1=0, re-try again.
	nop
	add		DQS_TEMP1,R1,L1
	beqz	DQS_TEMP1,CALIBRATE_DQS1				//if (R1+L1) = 0, re-try agaim.
	nop
	sub		DQS_TEMP1,R1,L1
	blt		DQS_TEMP1,2,CALIBRATE_DQS1				//if (R1-L1) < 2 , the vale is very close, so re-try again.
	nop
	beq		R1,L1,CALIBRATE_DQS1					//if R1=L1, re-try again.
	nop
	beqz	R1,CALIBRATE_DQS1_LOOP1_REENTRY
	nop	
CALIBRATE_DQS1_LOOP1_OUT:	
####################
	beqz		R1,CALIBRATE_DQS1_LOOP1_R1_OUT
	nop
	add		DQS_TEMP1, L1, R1							//DQS_TEMP1 equ sum( L1 + R1 )
	srl 	DQS_TEMP1, DQS_TEMP1, 1						//calibration value div 2		

#######################	
	sll		DQS_TEMP1, DQS_TEMP1, 20					// left shift 20 bit for DQS1 parameter.
	or		DQS_CALI_TEMP, DQS_CALI_TEMP, DQS_TEMP1	//finish DQS1 calibration, save in DQS_CALI_TEMP
	li		DQS_TEMP1,0xb8001050
	sw		DQS_CALI_TEMP, 0(DQS_TEMP1)
////////////////////////////////////////////////////
RECORD_DATA:
	li		DQS_TEMP3,0x0
#if defined(CONFIG_RAM_AUTO)	
	beqz		CLK_133MHZ_FLAG,CLK_166MHZ_RECORD_DATA
	nop
	li		DQS_TEMP3,0x10
#endif	
CLK_166MHZ_RECORD_DATA:	
	move	DQS_TEMP1, L0
	li		DQS_TEMP2, 0xa0600020
	add		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3
	nop
	sw		DQS_TEMP1, 0(DQS_TEMP2)
	move	DQS_TEMP1, R0
	li		DQS_TEMP2, 0xa0600024
	add		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3	
	sw		DQS_TEMP1, 0(DQS_TEMP2)
	move	DQS_TEMP1, L1
	li		DQS_TEMP2, 0xa0600028	
	add		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3
	sw		DQS_TEMP1, 0(DQS_TEMP2)
	move	DQS_TEMP1, R1
	li		DQS_TEMP2, 0xa060002c		
	add		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3	
	sw		DQS_TEMP1, 0(DQS_TEMP2)
//////if 166MHz not stable, change to 133MHz/////////////////////////////////////////////
#if defined(CONFIG_RAM_AUTO)
	li		DQS_TEMP2,0x8								//if (R0-L0)<8, the DRAM clock will down gread to 133MHz
	sub		DQS_TEMP1,R0,L0
	bnez		CLK_133MHZ_FLAG,DQS_133MHz_ONGOING
	nop	
	bge		DQS_TEMP2,DQS_TEMP1,RUN133MHz  
	nop
	sub		DQS_TEMP1,R1,L1	
	bge		DQS_TEMP2,DQS_TEMP1,RUN133MHz  
	nop
DQS_133MHz_ONGOING:
	//nop
	b		CALIBRATE_OUT
	nop
RUN133MHz:
///////CLK_166MHZ_RECORD_DATA: start/////////
	move	DQS_TEMP1, L0
	li		DQS_TEMP2, 0xa0600020
	sw		DQS_TEMP1, 0(DQS_TEMP2)
	move	DQS_TEMP1, R0
	li		DQS_TEMP2, 0xa0600024
	sw		DQS_TEMP1, 0(DQS_TEMP2)
	move	DQS_TEMP1, L1
	li		DQS_TEMP2, 0xa0600028	
	sw		DQS_TEMP1, 0(DQS_TEMP2)
	move	DQS_TEMP1, R1
	li		DQS_TEMP2, 0xa060002c		
	sw		DQS_TEMP1, 0(DQS_TEMP2)
///////CLK_166MHZ_RECORD_DATA: end/////////	
	bnez		CLK_133MHZ_FLAG,FIXED_DQS
	nop
	li		DQS_TEMP1,0xb8000200
	lw		DQS_TEMP2,0(DQS_TEMP1)
	li		DQS_TEMP3,~0x0F0000
	and		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3
	li		DQS_TEMP3,0x6								//0xb8000200[n19..n16] to setup DRAM clock rate. RTL8676(8:166MHz, 6:133MHz)
	sll		DQS_TEMP3,16
	or		DQS_TEMP2,DQS_TEMP2,DQS_TEMP3
	sw		DQS_TEMP2,0(DQS_TEMP1)
	li		DQS_TEMP3,300						//delay count.
1:
	subu		DQS_TEMP3,1
	bnez		DQS_TEMP3,1b
	nop		
	li		DQS_TEMP1,0xb8001008
	li		DQS_TEMP2,0x6CEB84C0
	sw		DQS_TEMP2,0(DQS_TEMP1)
	li		DQS_TEMP1,0xb8001050
	li		DQS_TEMP2,0x5ef00000
	sw		DQS_TEMP2,0(DQS_TEMP1)
############################################## 	 	
	//DRAM PLL reset
	li 		t0,0x10000131
	li		t1,0xb800100c
	sw		t0,0(t1)
	nop
	li		t0,0x524a0000
	li		t1,0xb8001004		
	sw		t0,0(t1)		
	Noop_Delay 1200
############################################## 		
	li		DQS_TEMP1,0xb8001004
	li		DQS_TEMP2,0x52480000
	sw		DQS_TEMP2,0(DQS_TEMP1)
	li		CLK_133MHZ_FLAG,0x1
	b		DQS_CALIBRATION_START
	nop	
#endif	
	
CALIBRATE_OUT:
	beqz		R0,FIXED_DQS
	nop
	beqz		R1,FIXED_DQS
	nop
	b		FINISH_CALI_DQS
	nop
	//nop
FIXED_DQS:
#ifdef LX_210_DDR166
 	li		DQS_TEMP2,0x54a00000					//RUN in 166MHz
#else
 	li		DQS_TEMP2,0x5ef00000					//RUN in 133MHz
#endif
 	li		DQS_TEMP1,0xb8001050
 	sw		DQS_TEMP2,0(DQS_TEMP1)					//fixed DQS
FINISH_CALI_DQS:
	
#if	0		//fixd DQS
  li		DQS_TEMP2,0x54A00000					//RUN in 166MHz
 	li		DQS_TEMP1,0xb8001050
 	sw		DQS_TEMP2,0(DQS_TEMP1)					//fixed DQS
#endif 	
	nop
    .set noreorder
#undef 	SW_SRAM_ADDR		
#undef 	CLK_133MHZ_FLAG
#undef 	RUN_CYCLE 		
#undef 	SW_DDCR_VAL 			
#undef 	DQS_TEMP1	 		
#undef 	DQS_TEMP2	 		
#undef 	DQS_TEMP3	 		
#undef 	DQS_TEMP4	 		
#undef 	POINT_CURSOR 		
#undef 	UP_LIMIT		 		
#undef 	DQS_CALI_TEMP		
#undef 	DQS_TEMP5			
#undef 	L0 					
#undef 	R0 					
#undef 	L1 					
#undef 	R1 					
#undef 	L_DONE_BIT
#else
#ifdef LX_210_DDR166
 	li		t0,0x54a00000			//RUN in 166MHz
#else
 	li		t0,0x5ef00000				//RUN in 133MHz
#endif
 	li		t1,0xb8001050
 	sw		t0,0(t1)					//fixed DQS	
#endif	
////////////////////////////////////////////////////////////////////
#undef CLK_133MHZ_FLAG
	li		t7,0xa0600054			//load ra into t6
	lw		t6,0(t7)
	nop
	li		t7,0xa0600050
	lw		t8,0(t7)
	nop
	add		ra,t6,t8					//ra addr plus copy length offset
	j		ra
	nop

DQS_CALIBRATION_FINISH:
	nop
#################################################
	nop
  b               MEM_CONF_DONE
	nop
#===== end DDR calibration ================

is_SDRAM:
##############################################
//	SDR & DDR I/O PAD current select for test only. 
	//li		t0,0x3407				//for SoC module QAboard
	//li		t0,0x3000
	li		t0,0x0
	li		t1,0xb8000314
	sw		t0,0(t1)
	nop	
////////////// //Set Tx/Rx delay for SDRAM  //////////////////////////
	li		t0,0x06000E00		//SDRAM TX hold time(1.95ns) and RX delay parameter setup for RTL8676,
	li		t1,0xb8000220
	sw		t0,0(t1)
	nop	

###############################################
# SDRAM/DDR Memory timing register, MUST set before MCR(config. reg)
	li		t0,0x6d0b0ac0		//SDR
	li		t1,0xb8001008
	sw		t0,0(t1)
	nop
	nop
	nop
###############################################
	li		t0,0x52480000		//16M, for SDRAM & DDR
	//li		t0,0x54480000		//32M, for SDRAM & DDR
	//li		t0,MCR0_VAL
	li		t1,0xB8001004
	sw		t0,0(t1)
	nop
#if	1	//SDRAM RX calibration......
#if	1	//copy code to DMEM
///////copy SDRAM RX delay calibraton code to SRAM 0xA0606000 ////////
#define		CP_BLK_START_ADDR	t0
#define		CP_BLK_END_ADDR		t1
#define		CP_BLK_LENGTH			t2
#define		CP_BLK_TEMP1			t3
#define		CP_BLK_TEMP2			t4
	la		CP_BLK_START_ADDR, SDRAM_RX_CALI_BEGIN
	la		CP_BLK_END_ADDR, SDRAM_RX_CALI_FINISH
	sub		CP_BLK_LENGTH,CP_BLK_END_ADDR,CP_BLK_START_ADDR
	li		CP_BLK_TEMP1,0xa0600050											//save copy block length
	sw		CP_BLK_LENGTH,0(CP_BLK_TEMP1)

	li		CP_BLK_TEMP1,0xbfc00000											//boot start address.
	or		CP_BLK_START_ADDR,CP_BLK_START_ADDR,CP_BLK_TEMP1				//transfer DRAM(0x80000000) to FLASH(0xbfc00000) address
	or		CP_BLK_END_ADDR,CP_BLK_END_ADDR,CP_BLK_TEMP1					//transfer DRAM(0x80000000) to FLASH(0xbfc00000) address
	
	li		CP_BLK_TEMP1, 0xA0600100															//start address of SRAM reserve area  
	
1:	
	lw		CP_BLK_TEMP2, 0(CP_BLK_START_ADDR)								//load code from flash
	nop
	sw		CP_BLK_TEMP2, 0(CP_BLK_TEMP1)									//restore code to SRAM
	addi		CP_BLK_START_ADDR, CP_BLK_START_ADDR, 4
	addi		CP_BLK_TEMP1, CP_BLK_TEMP1, 4
	bne		CP_BLK_START_ADDR, CP_BLK_END_ADDR, 1b
	nop
	li		CP_BLK_TEMP1, 0xA0600100										//
	jal		CP_BLK_TEMP1													//jump to SRAM
	nop

#undef		CP_BLK_START_ADDR
#undef		CP_BLK_END_ADDR
#undef		CP_BLK_LENGTH
#undef		CP_BLK_TEMP1
#undef		CP_BLK_TEMP2
#endif		//copy code to DMEM
/////////////////////////////////////////////////////////
SDRAM_RX_CALI_BEGIN:
	nop
#if	1		//copy code to DMEM	
	move	t6,ra																//save ra address
	li		t7,0xa0600054
	sw		t6,0(t7)
#endif		//copy code to DMEM	
#======SDRAM RX Calibration start	===========
#define	RX_TEMP1		t1
#define	RX_TEMP2		t2
#define	RX_TEMP6		t3
#define	RX_REG_ADDR	t4
#define	RX_REG_VAL		t5
#define	RX_TEMP5		t6
#define	RX_PARA			t7
#define	RX_TEMP3		t8
#define	RX_TEMP4		t9
#define	RX_L0			s0
#define	RX_MSB__flag		s5
//// insert SDR calibration version, record in 0xA0600018 //start///	
	li		RX_TEMP1,0xA0600018
	li		RX_TEMP2,0x1D00					//version: 1.00
	sw		RX_TEMP2,0(RX_TEMP1)
//// insert SDR calibration version, record in 0xA0600018 //end///

	li		RX_REG_ADDR,0xb8000220			//Delayline Control Register
	lw		RX_REG_VAL,0(RX_REG_ADDR)		//reload orginal value
	nop
	li		RX_PARA,0
	move	RX_L0,zero
RX_PRAR_CH:
/////////	set RX value	/////////
	and		RX_REG_VAL,RX_REG_VAL,0xFFFFE0FF	//[n12..n8]
	nop
	sll		RX_TEMP1,RX_PARA,8
	nop
	or		RX_REG_VAL,RX_REG_VAL,RX_TEMP1
	nop
	sw		RX_REG_VAL,0(RX_REG_ADDR)
	nop
////////////save start GDMA address  ////////////////////////////////////////// 	
	li		RX_TEMP1,0xA0600020				//save  start GDMA address to 0xA0600020
 	li		RX_TEMP2,0xA0800000				//start GDMA address
 	sw		RX_TEMP2,0(RX_TEMP1)
 	nop
	li		RX_TEMP1,0xA0600028				//save  current GDMA address to 0xA0600028
	li		RX_TEMP3,0x1FFFFFFF
 	and		RX_TEMP2,RX_TEMP2,RX_TEMP3		//start GDMA address
 	sw		RX_TEMP2,0(RX_TEMP1)
 	nop 	 	
	li		RX_TEMP1,0xA0600024				//save  end GDMA address to 0xA0600024 
 	li		RX_TEMP2,0xA0820000				//end GDMA address
 	sw		RX_TEMP2,0(RX_TEMP1)
 	nop 	
////////////Clearn data from 0xa0612000 to 0xa0612FFF,  this will write area. /////
////////////Clearn data from 0xa0800000 to 0xa08FFFFF,  this will write area. /////
	li		RX_TEMP1,0xA0600020				//load start GDMA address from 0xA0600020
	lw		RX_TEMP2,0(RX_TEMP1)
	nop
	li		RX_TEMP1,0xA0600024				//load end GDMA address from 0xA0600024
	lw		RX_TEMP3,0(RX_TEMP1)
	nop	
	li		RX_TEMP4,0
1:	
	sw		RX_TEMP4,0(RX_TEMP2)
	nop
	addi		RX_TEMP2,RX_TEMP2,4
	nop
	bgt		RX_TEMP3,RX_TEMP2,1b
	nop
///////// Clearn data  finish /////////
#if	1		//GENERATE PATTERN
////GENERATE PATTERN /////////////////////////////
	li		RX_TEMP4,0x5a5aa5a5		//default pattern
	li		RX_TEMP5,0x0FFFF			//default pattern
////////////GEN data from 0xa0610000 to 0xa061FFFF, 64k bytes
	li		RX_TEMP2,0xA0600020					//load start GDMA address from 0xA0600020
	lw		RX_TEMP1,0(RX_TEMP2)
	nop
	li		RX_TEMP3,0x8000						//32k bytes, end address
1:	
	sw		RX_TEMP5,0(RX_TEMP1)				//pattern1(0x0FFFF)
	addi		RX_TEMP1,RX_TEMP1,4
	not		RX_TEMP2,RX_TEMP5					//pattern1 reverse (0xFFFF0000)
	sw		RX_TEMP2,0(RX_TEMP1)
	addi		RX_TEMP1,RX_TEMP1,4
	sw		RX_TEMP4,0(RX_TEMP1)				//pattern(0x5a5aa5a5)
	addi		RX_TEMP1,RX_TEMP1,4
	not		RX_TEMP2,RX_TEMP4					//pattern reverse(0xa5a55a5a)
	sw		RX_TEMP2,0(RX_TEMP1)
	addi		RX_TEMP1,RX_TEMP1,4
	subu		RX_TEMP3,0x10	
	bnez		RX_TEMP3,1b
	nop	
///////// generate data finish /////////	
#endif		//generate data finish
	
RX_GDMA_START:
/////////	GDMA setup	,GDMA cp DRAM to DMEM /////////
 	li		RX_TEMP1,0xb800a000
 	li		RX_TEMP2,0x0
 	sw		RX_TEMP2,0(RX_TEMP1)			//Software reset GDMA, 0xb800a000[n31]=0	-> 1
	nop
 	li		RX_TEMP2,0x80000000
 	sw		RX_TEMP2,0(RX_TEMP1)			//Enable GDMA, 0xb800a000[n31]=1, and func set to memory copy [n27..n24]=0
 	nop
 	li		RX_TEMP2,0x0
 	li		RX_TEMP1,0xb800a004
 	sw		RX_TEMP2,0(RX_TEMP1)			//Interrupt Mask Register clean
 	nop
 	li		RX_TEMP2,0x90000000
 	li		RX_TEMP1,0xb800a008
 	sw		RX_TEMP2,0(RX_TEMP1)			//Interrupt status Register, [n31] and [n28] write 1 to clean
 	nop
 	li		RX_TEMP5,0x8000					//set cp block size
 ///////////GDMA memory copy (setup source, BLK0)/////////////////////////////////
 	li		RX_TEMP4,0xA0600028
 	lw		RX_TEMP3,0(RX_TEMP4)			//load current GDMA address.
 	nop
 	li		RX_TEMP1,0xb800a020
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a024
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK0)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a060
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a064
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop
 ///////////GDMA memory copy (setup source, BLK1)/////////////////////////////////
 	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a028
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a02C
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK1)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a068
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a06C
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop 	
 ///////////GDMA memory copy (setup source, BLK2)/////////////////////////////////
 	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a030
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a034
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK2)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a070
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a074
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop 	 	
 ///////////GDMA memory copy (setup source, BLK3)/////////////////////////////////
 	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a038
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a03C
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK3)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a078
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a07C
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop 	 	 	
 ///////////GDMA memory copy (setup source, BLK4)/////////////////////////////////
 	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a040
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a044
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK4)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a080
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a084
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop 	 	 	 	
  ///////////GDMA memory copy (setup source, BLK5)/////////////////////////////////
  	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a048
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a04C
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK5)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a088
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a08C
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop 	
  ///////////GDMA memory copy (setup source, BLK6)/////////////////////////////////
  	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a050
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a054
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK6)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a090
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x00001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a094
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop  	
  ///////////GDMA memory copy (setup source, BLK7)/////////////////////////////////
 	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
 	li		RX_TEMP1,0xb800a058
 	sw		RX_TEMP3,0(RX_TEMP1)			//setting source data address
 	nop
  	li		RX_TEMP2,0x80001000				//[n31]=1, last data block, and source data length[n12..n0]
 	li		RX_TEMP1,0xb800a05C
 	sw		RX_TEMP2,0(RX_TEMP1)					//setting source data length
 	nop
/////////////GDMA memory copy (setup destination, BLK7)/////////////////////////////////
	add		RX_TEMP4,RX_TEMP3,RX_TEMP5
 	li		RX_TEMP1,0xb800a098
 	sw		RX_TEMP4,0(RX_TEMP1)			//setting destination data address
 	nop
 	li		RX_TEMP2,0x80001000				//[n31]=1, last data block, and destination data length[n12..n0]
 	li		RX_TEMP1,0xb800a09C
 	sw		RX_TEMP2,0(RX_TEMP1)			//setting destination data length
 	nop
/////////////Save current GDMA address.  /////////////////////////////////////////////////////////
	addiu	RX_TEMP3,RX_TEMP3,0x1000		//source data address
	li		RX_TEMP1,0xA0600028				
	sw		RX_TEMP3,0(RX_TEMP1)			//Save current GDMA address.
	nop
//////////////startting  GDMA process 	/////////////////////////////////
  	li		RX_TEMP2,0xC0000000				//GDMA_ENABLE | GDMA_POLL | GDMA_MEMCPY	//startting  GDMA process
 	li		RX_TEMP1,0xb800a000
 	sw		RX_TEMP2,0(RX_TEMP1)					//startting  GDMA 
 	nop
//////////////polling GDMA copy done flag	/////////////////////////////////
  	li		RX_TEMP2,0x0					// clean data buffer
  	li		RX_TEMP3,0x80000000
 	li		RX_TEMP1,0xb800a008				// GDMA	Interrupt Status Register
 	li		RX_TEMP4,0xb800030c				//RX_TEMP4 IP module status
 	lw		RX_TEMP5,0(RX_TEMP4)			//RX_TEMP5 0xb800030c value.
 	nop
 	
1:
 	lw		RX_TEMP2,0(RX_TEMP1)			// load 
 	nop
 	/////////////add IP module power on/off start/////////////////////////// 	
	//li		RX_TEMP4,0xb800030c
	//lw		RX_TEMP5,0(RX_TEMP4)
	//nop
 	ori		RX_TEMP6,RX_TEMP5,0x1FFF	//enable all IP module
 	sw		RX_TEMP6,0(RX_TEMP4)
 	nop
 	li		RX_TEMP6,0x50
 3:	
 	subu		RX_TEMP6,1
 	nop
 	bnez		RX_TEMP6,3b
 	nop
 	and		RX_TEMP6,RX_TEMP5,~0x1BFF		//enable GDMA only
 	sw		RX_TEMP6,0(RX_TEMP4)
 	nop
 	li		RX_TEMP6,0x50
 3:	
 	subu		RX_TEMP6,1
 	nop
 	bnez		RX_TEMP6,3b
 	nop 	
 	/////////////add IP module power on/off end/////////////////////////// 	
 	and 		RX_TEMP2,RX_TEMP2,RX_TEMP3	
 	nop
 	beqz		RX_TEMP2,1b						//GDMA_not_complete
 	nop 	 	
 	/////////////add IP module power on/off start /////////////////////////// 	
 	sw		RX_TEMP5,0(RX_TEMP4)			//restore IP module status.
 	nop 	
 	/////////////add IP module power on/off end/////////////////////////// 	
//////////load current GDMA adddress, if not equ finish GDMA address, it will jump to
	li		RX_TEMP1,0xA0600028
	lw		RX_TEMP2,0(RX_TEMP1)			//load current GDMA adddress
	nop
	li		RX_TEMP4,0xA0000000
	or		RX_TEMP2,RX_TEMP2,RX_TEMP4
	/////////////////////////////
	li		RX_TEMP1,0xA0600024
	lw		RX_TEMP3,0(RX_TEMP1)			//load finish GDMA adddress
	nop	
 	bgt		RX_TEMP3,RX_TEMP2,RX_GDMA_START	//if finish address > current adddress, jump to RX_GDMA_START
 	nop

//////////software compare data /////////////////
	li		RX_TEMP3,0x8000					//compare size 32k
	li		RX_TEMP4,0xA0600024
	lw		RX_TEMP6,0(RX_TEMP4)	//load finish GDMA address
	nop	
	sub		RX_TEMP3,RX_TEMP6,RX_TEMP3	//compare last block
	nop
	li		RX_TEMP1,0x0FFFF			//Pattern 
	li		RX_TEMP2,0x5a5aa5a5		//Pattern1
	li		RX_TEMP5,0				//compare length
1:
	lw		RX_TEMP4,0(RX_TEMP3)		//load data source data from SRAM
	nop
	bne		RX_TEMP1,RX_TEMP4,SDRAM_RX_COMPARE_FAIL
	nop
	addiu	RX_TEMP3,RX_TEMP3,4			//load address plus 4
	lw		RX_TEMP4,0(RX_TEMP3)		//load data source data from SRAM
	nop
	not		RX_TEMP5,RX_TEMP1
	bne		RX_TEMP5,RX_TEMP4,SDRAM_RX_COMPARE_FAIL
	nop	
	addiu	RX_TEMP3,RX_TEMP3,4			//load address plus 4
	lw		RX_TEMP4,0(RX_TEMP3)		//load data source data from SRAM
	nop
	bne		RX_TEMP2,RX_TEMP4,SDRAM_RX_COMPARE_FAIL
	nop	
	addiu	RX_TEMP3,RX_TEMP3,4			//load address plus 4
	lw		RX_TEMP4,0(RX_TEMP3)		//load data source data from SRAM
	nop
	not		RX_TEMP5,RX_TEMP2
	bne		RX_TEMP5,RX_TEMP4,SDRAM_RX_COMPARE_FAIL
	nop	
	addiu	RX_TEMP3,RX_TEMP3,4			//load address plus 4
	bgt		RX_TEMP6,RX_TEMP3,1b
	nop
	li		RX_TEMP3,1

SAVE_RX_VALUE:
	li		RX_TEMP1,0xA060001C
	lw		RX_TEMP2,0(RX_TEMP1)				//load rx pass parameter
	nop
	sll		RX_TEMP3,RX_TEMP3,RX_PARA
	nop
	or		RX_TEMP2,RX_TEMP2,RX_TEMP3
	sw		RX_TEMP2,0(RX_TEMP1)				//save rx pass parameter
	nop
	/////////////////////////////////////////////
	addiu	RX_PARA,RX_PARA,1					//Rx parameter plus 
	nop
	bne		RX_PARA,0x1F,RX_PRAR_CH			//if Rx parameter more then 0x10, set R0 value
	nop
	b			RX_FINISH										//add 20110601
	nop

SDRAM_RX_COMPARE_FAIL:
	addiu	RX_PARA,RX_PARA,1				//Tx parameter plus 
	nop
	beq		RX_PARA,0x1F,RX_FINISH			//TX_PRAR max 0x10
	nop
	b		RX_PRAR_CH
	nop	
	
RX_FINISH:
	////////////////////////////////////////////
	li		RX_TEMP1,0xA060001C
	lw		RX_TEMP2,0(RX_TEMP1)				//load rx pass parameter
	nop
	li		RX_TEMP3,0
	li		RX_TEMP4,1
1:	
	srl		RX_TEMP6,RX_TEMP2,RX_TEMP3
	and		RX_TEMP5,RX_TEMP4,RX_TEMP6
	addiu	RX_TEMP3,RX_TEMP3,1
	beq		RX_TEMP3,0x20,SDRAM_FIXED_VALUE
	nop
	beqz		RX_TEMP5,1b
	nop
	subu		RX_TEMP3,1
	move	RX_L0,RX_TEMP3
1:	
	addiu	RX_TEMP3,RX_TEMP3,1
	srl		RX_TEMP6,RX_TEMP2,RX_TEMP3
	and		RX_TEMP5,RX_TEMP4,RX_TEMP6	
	beq		RX_TEMP3,0x20,SDRAM_FIXED_VALUE
	nop	
	bnez		RX_TEMP5,1b
	nop
	add		RX_TEMP3,RX_TEMP3,RX_L0
	srl		RX_TEMP3,RX_TEMP3,1						//
	nop
	li		RX_TEMP2,0x8
	bge		RX_TEMP2,RX_TEMP3,SDRAM_FIXED_VALUE			//if R0-L0 <= 8, jump to Fixed value
	nop
	sll		RX_TEMP3,RX_TEMP3,8
	////////////////////////////////////
	li		RX_TEMP1,0xb8000220
	li		RX_TEMP4,0xFFFFE0FF
	lw		RX_TEMP2,0(RX_TEMP1)
	nop
	and		RX_TEMP2,RX_TEMP2,RX_TEMP4
	or		RX_TEMP3,RX_TEMP3,RX_TEMP2
	sw		RX_TEMP3,0(RX_TEMP1)				//load rx pass parameter
	nop	
	b		SDRAM_CALI_FINISH
	nop
	
SDRAM_FIXED_VALUE:	
 	li		RX_TEMP2,0x08000E00
 	li		RX_TEMP1,0xb8000220
 	sw		RX_TEMP2,0(RX_TEMP1)					//fixed RX delay
 	nop
 	nop	

SDRAM_CALI_FINISH:

#undef	RX_TEMP1
#undef	RX_TEMP2
#undef	RX_TEMP6
#undef	RX_REG_ADDR
#undef	RX_REG_VAL
#undef	RX_TEMP5
#undef	RX_PARA
#undef	RX_TEMP3
#undef	RX_TEMP4
#undef	RX_L0
#undef	RX_MSB__flag
#======SDRAM RX Calibration end===========
###############################################	
#if	1		//copy code to DMEM
	li		t7,0xa0600054			//load ra into t6
	lw		t6,0(t7)
	nop
	li		t7,0xa0600050
	lw		t8,0(t7)
	nop
	add		ra,t6,t8					//ra addr plus copy length offset
	j		ra
	nop
#endif		//copy code to DMEM	
SDRAM_RX_CALI_FINISH:
				nop
#endif		//RX calibration......				
				nop	
###############################################	
        b               MEM_CONF_DONE
        nop

///////////////////////////////////////////////////////////
MEM_CONF_DONE:
	Detect_RAM_Size
	
	move	ra, k0
	j		ra
	nop	
	END(lowlevel_init)
	
	
	.set pop