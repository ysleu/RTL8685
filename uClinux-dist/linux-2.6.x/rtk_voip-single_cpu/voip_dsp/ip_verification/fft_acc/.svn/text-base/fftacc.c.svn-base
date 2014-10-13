/* ========================================================================== */
/*                                                                            */
/*   fftacc.c                                                         */
/*                                                                            */
/*                                                                            */
/*   Description: for FFT ACC                                           */
/*                                                                            */
/* ========================================================================== */
//#define STANDALONE_TEST 1

#ifdef LINUX_TEST
#include <linux/kernel.h>
#endif

#ifdef STANDALONE_TEST
typedef unsigned short		uint16_t;
typedef signed short		int16_t;
typedef unsigned int		uint32_t;
typedef signed int		int32_t;
#else
#include <linux/types.h>
#endif
#include "fftacc_regs.h"

#ifdef STANDALONE_TEST
#undef printk
#define printk(fmt, args...) /* nothing: it's a placeholder */
#else
#ifndef LINUX_TEST
#define printk prom_printf
#endif
#endif

#define REG32(reg) 			(*((volatile unsigned int *)(reg)))

//#define FFTACC_TEST4096PT 1	// test 512~4096point fft, or test 512~2048pt fft
//#define FFTACC_BYPASS_TEST_MODE 1
#define CPU_BYPASS	0

#define FFT_TOPCNR_BURST FFT_TOPCNR_BURST_4W

/*  fftacc_api
    int16_t input[],         (i) 
    int16_t output[],       (o) frequency domain half output, (realfft is symmetric in frequency doman, only need half point)
    int32_t length,    (i)     ie 512pt real input in time = 256pt real + 256pt imag output in frequency
    int32_t* nTry	(o)
 */
int32_t fftacc_api(int16_t input[], int16_t output[], int32_t length, int32_t* nTry)
{
	int32_t fftacc_status, fft_mode, shift=0, i;

	REG32(FFT_TOPCNR) = 0;			//disable FFT, enable it to reset
	REG32(FFT_TOPCNR) = 0x80000000;	//enable FFT
	REG32(FFT_SBP0) = (unsigned long)input&0x0FFFFFFF;		//FFT src
	REG32(FFT_SBL0) = 0x80000000|(length<<1);				//src len length is short change to byte

	REG32(FFT_DBP0) = (unsigned long)output&0x0FFFFFFF;			//FFT dest
	REG32(FFT_DBL0) = 0x80000000|(length<<1);			//dest len

	fft_mode=FFT_CTRL_512PT;

	if (length==512)
		fft_mode=FFT_CTRL_512PT;
	else if (length==1024)
		fft_mode=FFT_CTRL_1024PT;
	else if (length==2048)
		fft_mode=FFT_CTRL_2048PT;
	else {
#if defined(FFTACC_TEST4096PT)
		if (length==4096)
			fft_mode=FFT_CTRL_4096PT;
		else {
			*nTry=0;
			goto error;
			printk("error");
		}
#else
		*nTry=0;
		goto error;
		printk("error");
#endif
	}

#ifdef FFTACC_BYPASS_TEST_MODE
	REG32(FFT_CTRL) = FFT_CTRL_FFT|FFT_CTRL_BYPASS|fft_mode;	//set FFTacc to FFT
#else
	REG32(FFT_CTRL) = FFT_CTRL_FFT|fft_mode;	//set FFTacc to FFT
#endif

#ifdef FFTACC_BYPASS_TEST_MODE
    if (CPU_BYPASS) {
	for (i=0 ; i< length; i++)
		output[i]=input[i];
	shift=0;
    } else
#endif
    {
	REG32(FFT_TOPCNR) = 0xC0000000 | FFT_TOPCNR_BURST;

	for (i=0 ; i<500 ; i++);

	*nTry = 0;
	(*nTry)++;
	//printk("{FFT_TOPCNR=%x}", REG32(FFT_TOPCNR));
	while (*nTry<2000000)
	{
		(*nTry)++;
		fftacc_status = REG32(FFT_CTRL);
		if(fftacc_status&0x01000000)
			break;
	}


	shift=(fftacc_status&FFT_CTRL_FFT_SCALE_MASK)>>FFT_CTRL_FFT_SCALE_SHIFT;
    }

error:
	return shift;


}


/*  ifftacc_api
    int16_t input[],         (i) 
    int16_t output[],       (o) 
    int32_t length,    (i)     Time domain real-point number
    int32_t* nTry	(o)
 */
int32_t ifftacc_api(int16_t input[], int16_t output[], int32_t length, int32_t* nTry)
{
	int32_t fftacc_status, fft_mode, shift=0, i;

	REG32(FFT_TOPCNR) = 0;			//disable FFT, enable it to reset
	REG32(FFT_TOPCNR) = 0x80000000;	//enable FFT
	REG32(FFT_SBP0) = (unsigned long)input&0x0FFFFFFF;		//FFT src
	REG32(FFT_SBL0) = 0x80000000|(length<<1);				//src len

	REG32(FFT_DBP0) = (unsigned long)output&0x0FFFFFFF;			//FFT dest
	REG32(FFT_DBL0) = 0x80000000|(length<<1);			//dest len

	fft_mode=FFT_CTRL_512PT;

	if (length==512)
		fft_mode=FFT_CTRL_512PT;
	else if (length==1024)
		fft_mode=FFT_CTRL_1024PT;
	else if (length==2048)
		fft_mode=FFT_CTRL_2048PT;
	else {
#if defined(FFTACC_TEST4096PT)
		if (length==4096)
			fft_mode=FFT_CTRL_4096PT;
		else {
			*nTry=0;
			goto error;
			printk("error");
		}
#else
		*nTry=0;
		goto error;
		printk("error");
#endif
	}

#ifdef FFTACC_BYPASS_TEST_MODE
	REG32(FFT_CTRL) = FFT_CTRL_IFFT|FFT_CTRL_BYPASS|fft_mode;	//set FFTacc to FFT
#else
	REG32(FFT_CTRL) = FFT_CTRL_IFFT|fft_mode;	//set FFTacc to FFT
#endif

#ifdef FFTACC_BYPASS_TEST_MODE
    if (CPU_BYPASS) {
	for (i=0 ; i< length; i++)
		output[i]=input[i];
	shift=0;
    } else
#endif
    {

	REG32(FFT_TOPCNR) = 0xC0000000 | FFT_TOPCNR_BURST;

	for (i=0 ; i<500 ; i++);

	*nTry = 0;
	(*nTry)++;
	while (*nTry<2000000)
	{
		(*nTry)++;
		fftacc_status = REG32(FFT_CTRL);
		if(fftacc_status&0x01000000)
			break;
	}

	shift=(fftacc_status&FFT_CTRL_IFFT_SCALE_MASK)>>FFT_CTRL_IFFT_SCALE_SHIFT;
    }

error:
	return shift;


}

