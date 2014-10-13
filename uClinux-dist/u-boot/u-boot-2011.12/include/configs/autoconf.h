/*
 * Automatically generated by make menuconfig: don't edit
 */
#define AUTOCONF_INCLUDED

/*
 * Board
 */
#undef  CONFIG_RTL8676
#define CONFIG_RTL8686 1
#define CONFIG_UART0 1
#undef  CONFIG_UART1

/*
 * Frequency configuration
 */
#define CONFIG_SOFTWARE_OVERWRITE_FREQ 1
#undef  CONFIG_SOFTWARE_FREQUENCY_ENV_DECIDE
#define CONFIG_CPUCLK_MHZ (700)
#define CONFIG_DSPCLK_MHZ (550)
#define CONFIG_MEMCLK_MHZ (300)

/*
 * Memory configuration
 */
#undef  CONFIG_DRAM_AUTO_SIZE_DETECTION
#undef  CONFIG_DRAM_FROCE_DCR_VALUE
#define CONFIG_DRAM_BUS_WIDTH_8BIT 1
#undef  CONFIG_DRAM_BUS_WIDTH_16BIT
#define CONFIG_DRAM_CHIP_NUM_ONE 1
#undef  CONFIG_DRAM_CHIP_NUM_TWO
#define CONFIG_ONE_DRAM_CHIP_SIZE_32MB 1
#undef  CONFIG_ONE_DRAM_CHIP_SIZE_64MB
#undef  CONFIG_ONE_DRAM_CHIP_SIZE_128MB
#undef  CONFIG_ONE_DRAM_CHIP_SIZE_256MB
#undef  CONFIG_ONE_DRAM_CHIP_SIZE_512MB
#define CONFIG_ONE_DRAM_CHIP_SIZE 0x2000000
#define CONFIG_ZQ_AUTO_CALI 1
#define CONFIG_DIGITAL_DELAY_LINE 1
#define CONFIG_AUTO_DRAM_TIMING_SETTING 1
#define CONFIG_DRAM_WR_NS (15)
#define CONFIG_DRAM_RTP_NS (8)
#define CONFIG_DRAM_WTR_NS (8)
#define CONFIG_DRAM_REFI_NS (7800)
#define CONFIG_DRAM_RP_NS (15)
#define CONFIG_DRAM_RCD_NS (15)
#define CONFIG_DRAM_RRD_NS (10)
#define CONFIG_DRAM_FAWG_NS (50)
#define CONFIG_DRAM_RFC_NS (328)
#define CONFIG_DRAM_RAS_NS (45)
#define CONFIG_DRAM_REFI_MS (64)
#define CONFIG_FLASH_SPI 1
#define CONFIG_FLASH_SPI_MAXCLK (50)
#undef  CONFIG_FLASH_SPI_OP_SIO
#undef  CONFIG_FLASH_SPI_OP_DIO
#define CONFIG_FLASH_SPI_OP_QIO 1

/*
 * Command Configuration
 */
#define CONFIG_CMD_DRAM_TEST 1
#define CONFIG_CMD_DRAM_DIG 1
#undef  CONFIG_CMD_GDMA_TEST
#undef  CONFIG_CMD_SRAM_TEST
#undef  CONFIG_CMD_IDMEM_TEST
#undef  CONFIG_CMD_CONCURENT_TEST
#undef  CONFIG_CMD_FOREVER_TEST
#undef  CONFIG_CMD_BOOT_BIN
#undef  CONFIG_CMD_BOOT_DSP
#undef  CONFIG_CMD_NEXT_FREQ
#undef  CONFIG_CMD_DRAM_AC_TEST
#undef  CONFIG_SYS_BOOTING_DIALOG
#undef  CONFIG_CMD_MEASURE_CPU_CLK
#define CFG_DCACHE_SIZE (32768)
#define CFG_ICACHE_SIZE (32768)
#define CFG_CACHELINE_SIZE (32)
#define CONFIG_SRAM_START 0x02000000
#define CFG_SRAM_SIZE 0x00008000
#define CFG_SRAM_SIZE_SET 0x00000008
#define CONFIG_CONS_INDEX (1)
#define CFG_NS16550 1
#define CFG_NS16550_SERIAL 1
#define CFG_NS16550_REG_SIZE (-4)
#define CFG_NS16550_COM1 0xB8002000
#undef  CONFIG_SERIAL_SOFTWARE_FIFO
#define CFG_SDRAM_BASE (0x80000000)
#define CONFIG_SYS_TEMP_SRAM_ADDR (0x90000000)
#define CONFIG_SYS_TEMP_SRAM_SIZE (0x8000)
#define CONFIG_ENV_OFFSET 0x80000
#define CONFIG_LXBUS_MHZ (200)
#define CONFIG_EXTRA_ENV_SETTINGS "upb=protect off all;erase bd000000 bd07ffff;cp.b 80000000 bd000000 7ffff;cmp.b 80000000 bd000000 7ffff;\0"