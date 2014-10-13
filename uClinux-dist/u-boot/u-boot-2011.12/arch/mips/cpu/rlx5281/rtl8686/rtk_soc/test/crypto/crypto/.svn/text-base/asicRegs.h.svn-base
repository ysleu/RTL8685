/*
* ----------------------------------------------------------------
* Copyright c                  Realtek Semiconductor Corporation, 2002  
* All rights reserved.
* 
* $Header: /usr/local/dslrepos/uClinux-dist/u-boot/u-boot-2011.12/arch/mips/cpu/rlx5281/rtl8686/rtk_soc/test/crypto/crypto/asicRegs.h,v 1.1 2012/08/07 02:58:32 krammer Exp $
*
* Abstract: ASIC specific definitions -- common part.
*
* $Author: krammer $
*
* -----------------------------------------------------------------
*	The following definitions are shared by 865xB/865xC series IC.
* -----------------------------------------------------------------
*/

#include "rtl_types.h"
#define CONFIG_RTL865XC
/*********************************************************************
 **                                                                 **
 **    Common Parts -- Add Common Definitions Here !                **
 **                                                                 **
 *********************************************************************/
#define UNCACHED_ADDRESS(x) ((void *)(0x20000000 | (uint32)x ))
#define CACHED_ADDRESS(x) ((void*)(~0x20000000 & (uint32)x ))
#define PHYSICAL_ADDRESS(x) (((uint32)x) & 0x1fffffff)
#define KSEG0_ADDRESS(x) ((void*)(PHYSICAL_ADDRESS(x) | 0x80000000))
#define KSEG1_ADDRESS(x) ((void*)(PHYSICAL_ADDRESS(x) | 0xA0000000))


/*********************************************************************
 **                                                                 **
 ** IC-Dependent Part --Add in the Specific Definitions in its file **
 **                                                                 **
 *********************************************************************/
#ifdef CONFIG_RTL865XC
#include "rtl865xc_asicregs.h"
#else
#include "rtl865xb_asicregs.h"
#endif
