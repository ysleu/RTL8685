#ifndef _FFTACC_REGS_H
#define _FFTACC_REGS_H

#ifdef CONFIG_RTK_VOIP_DRIVERS_PCM8676
#define FFT_BASE	0xB800B800
#else
#error "Please assign the FFT_BASE address for the used platform.\n"
//#define FFT_BASE	0xB8018800
#endif

#define FFT_TOPCNR	(FFT_BASE+0x00)

#define FFT_TOPCNR_BURST_4W	(0<<6)
#define FFT_TOPCNR_BURST_8W	(1<<6)
#define FFT_TOPCNR_BURST_16W	(2<<6)
#define FFT_TOPCNR_BURST_32W	(3<<6)

#define FFT_TOPIMR	(FFT_BASE+0x04)
#define FFT_TOPISR	(FFT_BASE+0x08)

#define FFT_CTRL	(FFT_BASE+0x10)


#define FFT_CTRL_FFT	(0)
#define FFT_CTRL_IFFT	(1<<31)
#define FFT_CTRL_4096PT	(3<<28)
#define FFT_CTRL_2048PT	(2<<28)
#define FFT_CTRL_1024PT	(1<<28)
#define FFT_CTRL_512PT	(0)
#define FFT_CTRL_BYPASS (1<<27)

#define FFT_CTRL_FFT_SCALE_SHIFT	19
#define FFT_CTRL_FFT_SCALE_MASK		(0x1F<<19)
#define FFT_CTRL_IFFT_SCALE_SHIFT	14
#define FFT_CTRL_IFFT_SCALE_MASK	(0x1F<<14)


#define FFT_SBP0	(FFT_BASE+0x20)
#define FFT_SBL0	(FFT_BASE+0x24)
#define FFT_SBP1	(FFT_BASE+0x28)
#define FFT_SBL1	(FFT_BASE+0x2c)


#define FFT_DBP0	(FFT_BASE+0x30)
#define FFT_DBL0	(FFT_BASE+0x34)
#define FFT_DBP1	(FFT_BASE+0x38)
#define FFT_DBL1	(FFT_BASE+0x3c)

#endif /* _FFTACC_REGS_H */
