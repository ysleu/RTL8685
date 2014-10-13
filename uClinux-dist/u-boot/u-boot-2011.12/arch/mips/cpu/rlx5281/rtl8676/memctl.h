#ifndef __MEMCTL_H__
#define __MEMCTL_H__
#ifndef __ASM__
#include "rtk_soc_common.h"
#endif

//#define MEMCTL_DDR_CALI_DEBUG
//#define MEMCTL_DDR_CALI_DEBUG_L2

/* Memory Controller Registers Definition */
#define MEMCTL_DTR_ADDR 	(0xb8001008)
#define MEMCTL_DTR1_ADDR 	(0xb800100c)
#define MEMCTL_DTR2_ADDR 	(0xb8001010)
#define MCR			(0xB8001000)
#define DCR			(0xB8001004)
#define DTR			(0xB8001008)
#define DMCR			(0xB800101C)
//#define DMCR			(0xB800100C)
#define DDCR			(0xB8001050)
#define DCDR			(0xB8001060)

/* Field start bit definition */
#define DTR_RP_FD_S 		(29)
#define DTR_RCD_FD_S 		(26)
#define DTR_RAS_FD_S 		(21)
#define DTR_RFC_FD_S 		(16)
#define DTR_WR_FD_S 		(6)
#define DTR_REFI_FD_S 		(12)
#define DTR_REFI_UNIT_FD_S 	(9)
#define DCR_ROWCNT_FD_S 	(25)
#define DDCR_DQS0_TAP_FD_S 	(25)
#define DDCR_DQS1_TAP_FD_S 	(20)
#define DDCR_CAL_MODE_FD_S 	(31)
#define DCDR_PHASE_SHIFT_FD_S 	(17)
#define DCR_CAS_FD_S		(30)
#define DCR_DBUSWID_FD_S	(28)
#define DCR_DCHIPSEL_FD_S	(27)
#define DCR_ROWCNT_FD_S		(25)
#define DCR_COLCNT_FD_S		(22)
#define DCR_BANKCNT_FD_S	(19)


/* The values of field in the registers related to the memory controller. */
#define DLL_MODE 		(0)
#define DIGITAL_MODE 		(1)
#define MCR_DRAMTYPE_MASK	(0xF0000000)
#define MCR_DRAMTYPE_DDR 	(0x00000000)
#define MCR_DRAMTYPE_DDR2 	(0x10000000)
#define MCR_DRAMTYPE_SDR 	(0x00000000)
#define MCR_PREFETCH_ENABLE_INS (0x00800000)
#define MCR_PREFETCH_MODE_IOLD (0x00000000)
#define MCR_PREFETCH_MODE_INEW (0x08000000)
#define MCR_PREFETCH_ENABLE_DATA (0x00400000)
#define MCR_PREFETCH_MODE_DOLD (0x00000000)
#define MCR_PREFETCH_MODE_DNEW (0x04000000)
#define MCR_PREFETCH_INS_SIDE  (0x2)
#define MCR_PREFETCH_DATA_SIDE (0x1)
#define MCR_PREFETCH_OLD_MECH	(0)
#define MCR_PREFETCH_NEW_MECH	(1)

/* Field masks used for extracting the value in the corresponding fields. */
//#define MCR_DRAMTYPE_MASK 	(0x80000000)
#define MCR_PREFETCH_DIS_IMASK (0xFF7FFFFF)
#define MCR_PREFETCH_DIS_DMASK (0xEFBFFFFF)
#define MCR_PREFETCH_MODE_IMASK (0xFF7FFFFF)
#define MCR_PREFETCH_MODE_DMASK (0xFFBFFFFF)
#define DDCR_DQS0_TAP_MASK 	(31 << DDCR_DQS0_TAP_FD_S)
#define DDCR_DQS1_TAP_MASK 	(31 << DDCR_DQS1_TAP_FD_S)
#define DDCR_CAL_MODE_MASK 	(1 << DDCR_CAL_MODE_FD_S)
#define DDCR_CAL_MODE_DLL 	(0 << DDCR_CAL_MODE_FD_S)
#define DDCR_CAL_MODE_DIG 	(1 << DDCR_CAL_MODE_FD_S)
#define DCDR_PHASE_SHIFT_MASK 	(31 << DCDR_PHASE_SHIFT_FD_S)
#define DTR_REFI_MASK 		(15 << DTR_REFI_FD_S)
#define DTR_REFI_UNIT_MASK 	(7 << DTR_REFI_UNIT_FD_S)
#define DTR_RP_MASK 		(7 << DTR_RP_FD_S)
#define DTR_RCD_MASK 		(7 << DTR_RCD_FD_S)
#define DTR_RAS_MASK 		(31 << DTR_RAS_FD_S)
#define DTR_RFC_MASK 		(31 << DTR_RFC_FD_S)
#define DTR_WR_MASK 		(7 << DTR_WR_FD_S)
#define DCR_CAS_MASK		(3 << DCR_CAS_FD_S)
#define DCR_DBUSWID_MASK	(3 << DCR_DBUSWID_FD_S)
#define DCR_DCHIPSEL_MASK	(1 << DCR_DCHIPSEL_FD_S)
#define DCR_ROWCNT_MASK		(3 << DCR_ROWCNT_FD_S)
#define DCR_COLCNT_MASK		(7 << DCR_COLCNT_FD_S)
#define DCR_BANKCNT_MASK	(1 << DCR_BANKCNT_FD_S)

/* Timing constraints definition used for DRAM diagnosis. */
#define DCR_CAS2_MAX_MHZ	(143)
#define DCR_CAS25_MAX_MHZ	(167)
#define STD_REF_MS 		(64)
#define STD_WR_NS 		(15)
#define STD_RP_NS 		(20)
#define STD_RCD_NS 		(20)
#define STD_RAS_NS 		(45)
#define STD_RFC_NS		(75)

/* DDR Calibration */
#define MEMCTL_DDR_DQS_SE		(1)
#define MEMCTL_DDR_DQS_DIFF		(0)
#define MEMCTL_DDR_DLL_MODE		(0)
#define MEMCTL_DDR_DIG_DELAY_MODE	(1)

#define MEMCTL_DDRTYPE_DDRI	(1)
#define MEMCTL_DDRTYPE_DDRII	(2)
#define MEMCTL_DDRTYPE_DDRIII	(3)

#define MEMCTL_DACCR_AC_MODE_DLL (0<<31)
#define MEMCTL_DACCR_AC_MODE_DIG (1<<31)
#define MEMCTL_DACCR_AC_MODE_MASK (~(1<<31))
#define MEMCTL_DACCR_DQS_MODE_SE (0<<31)
#define MEMCTL_DACCR_DQS_MODE_DIF (1<<31)
#define MEMCTL_DACCR_DQS_MODE_MASK (~(1<<31))
#define MEMCTL_DACCR_DQS0_GRUP_TAP_SHIFT (16)
#define MEMCTL_DACCR_DQS1_GRUP_TAP_SHIFT (8)
#define MEMCTL_DACSPCR_PERIOD_EN_MASK	(~(1 << 31))

#define _MEMCTL_CALI_FAIL	      (0xffff)
#define _MEMCTL_CALI_PASS	      (0)
#define _MEMCTL_CALI_STATUS_LOOKING_A (1)
#define _MEMCTL_CALI_STATUS_LOOKING_B (2)
#define _MEMCTL_CALI_STATUS_LOOKING_C (3)
#define _MEMCTL_CALI_SATAUS_DONE      (4)
#define _MEMCTL_CALI_SATAUS_FAIL      (5)
#define _MEMCTL_CALI_SATAUS_OVERFLOW  (6)
#define _MEMCTL_CALI_SATAUS_OK	      (7)
#define _MEMCTL_CALI_PHASE_A_OVERFLOW (8)
#define _MEMCTL_CALI_PHASE_B_OVERFLOW (9)
#define _MEMCTL_CALI_PHASE_C_OVERFLOW (10)
#define _MEMCTL_CALI_PHASE_A_SATAUS_OK   (11)
#define _MEMCTL_CALI_STATUS_UNKNOWN   (12)
#define MEMCTL_CALI_FAIL	      (-1)
#define MEMCTL_CALI_PASS	      (0)

#define MIN_READ_DELAY_WINDOW  (1)
#define MIN_WRITE_DELAY_WINDOW (1)
#define MIN_WRITE_MASK_DELAY_WINDOW (3)


/* STATUS defintiion */
#define CALI_FAIL_DCDR_VALUE    (0xFFFE0000)
#define CALI_FAIL_DDCR_VALUE    (0xFFFFFC00)

/* Memory Unmapping */
#define MEMCTL_UNMAP_REG_SET_SIZE	(0x10)
#define MEMCTL_UNMAP_REG_SET_NUM	(4)
#define MEMCTL_UNMAP_REG_BASE_ADDR	(0xB8001300)

#define C0UMSAR_REG_ADDR	(MEMCTL_UNMAP_REG_BASE_ADDR + 0x0)
#define C0UMSSR_REG_ADDR	(MEMCTL_UNMAP_REG_BASE_ADDR + 0x4)

#define C1UMSAR_REG_ADDR	(MEMCTL_UNMAP_REG_BASE_ADDR + 0x40)
#define C1UMSSR_REG_ADDR	(MEMCTL_UNMAP_REG_BASE_ADDR + 0x44)

#define MEMCTL_UNMAP_SEG_ENABLE		(0x1)

#define MEMCTL_UNMAP_SIZE_256B		(0x1)
#define MEMCTL_UNMAP_SIZE_512B		(0x2)
#define MEMCTL_UNMAP_SIZE_1KB		(0x3)
#define MEMCTL_UNMAP_SIZE_2KB		(0x4)
#define MEMCTL_UNMAP_SIZE_4KB		(0x5)
#define MEMCTL_UNMAP_SIZE_8KB		(0x6)
#define MEMCTL_UNMAP_SIZE_16KB		(0x7)
#define MEMCTL_UNMAP_SIZE_32KB		(0x8)
#define MEMCTL_UNMAP_SIZE_64KB		(0x9)
#define MEMCTL_UNMAP_SIZE_128KB		(0xA)
#define MEMCTL_UNMAP_SIZE_256KB		(0xB)
#define MEMCTL_UNMAP_SIZE_512KB		(0xC)
#define MEMCTL_UNMAP_SIZE_1MB		(0xD)

#ifndef __ASSEMBLY__

/* Data structure used for storing tap statics of the DDR calibration experiences. */
typedef struct tap_info {
		unsigned int mode;
		unsigned int mhz;
		unsigned int tap_min;
		unsigned int tap_max;
	} tap_info_t;


/* C function */
unsigned int memctlc_dram_size(void);
void memctlc_check_DRAM_config(void);
void memctlc_check_DQS_range(void);
void memctlc_check_90phase_range(void);
int  memctlc_ummap_en(unsigned int segNo, unsigned int cpu_addr, \
                    unsigned int size_in_byte);
int  memctlc_ummap_dis(unsigned int segNo);
void memctlc_show_ummapinfo(void);
void memctlc_clk_rev_check(void);
void memctlc_clk_rev_check(void);
unsigned int memctlc_is_DDR(void);
unsigned int memctlc_is_DDR2(void);
unsigned int memctlc_is_SDR(void);
unsigned int memctlc_dram_size_detect(void);

/* Assembly function */
unsigned int memctls_is_DDR(void);
unsigned int memctls_is_DDR2(void);
unsigned int memctls_is_DDR3(void);
unsigned int memctls_ddr_calibration(void);
unsigned int memctls_dram_auto_detect(void);
void memctls_ddr1_dll_reset(void);
void memctls_ddr2_dll_reset(void);
void memctls_enable_iprefeatch(void);
void memctls_enable_dprefeatch(void);
void memctlc_dqs_calibration_expansion(unsigned int dq, unsigned int buswidth);
void memctlc_dqm_calibration(void);
int memctlc_dqs_calibration(unsigned int dram_type, unsigned int ac_mode,\
                            unsigned int dqs_mode, unsigned int buswidth,\
                            unsigned int test_addr, unsigned int word_size);
unsigned int memctlc_DRAM_size_detection(void);
int memctlc_ddr_pin_detection(void);
int memctlc_hw_auto_calibration( unsigned int buswidth, unsigned int test_addr);
int memctl_unmapping(unsigned int segNo, unsigned int cpu_addr, \
		   unsigned int unmap_size_no);
int memctl_unmapping_disable(unsigned int segNo);
#endif


#endif //end of __MEMCTL_H__


