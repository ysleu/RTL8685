/* ========================================================================== */
/*                                                                            */
/*   fft_test.c                                                         */
/*                                                                            */
/*                                                                            */
/*   Description: for FFT ACC test                                        */
/*                                                                            */
/* ========================================================================== */

#include <linux/types.h>
#ifdef LINUX_TEST
#include <linux/kernel.h>
#include "lexraregs.h"
#else
#include <asm/lexraregs.h>
#endif


#include "dsplib.h"
#include "lexra_radiax.h"

#include "lexra_asm_tool.h"


#define MAX_FFT_POINTS 2048//4096	// Thlin change to 2048
#define TEST_FFT_LOGSIZE 11 // 11 for 2048, 10 for 1024
#define TEST_FILTER_LENGTH (1<<(TEST_FFT_LOGSIZE-1))
#define TEST_SIGNAL 2	//0->sine wave, 1-> random, 2-> square wave

#define	TEST_POINT 2048 // Thlin add. org: 4096

//#define FFTACC_TEST4096PT 1	// test 512~4096point fft, or test 512~2048pt fft	// Thlin disable

#define UNCACHE_ADDR(addr) (((int)addr)|0x20000000)

//#define printk	prom_printf
#ifndef LINUX_TEST
#define printk	dprintf
#endif

int32_t fftacc_api(int16_t input[], int16_t output[], int32_t length, int32_t* nTry);
int32_t ifftacc_api(int16_t input[], int16_t output[], int32_t length, int32_t* nTry);


static int16_t fft_test_data_real[MAX_FFT_POINTS] __attribute__((aligned(32)));
static int16_t fft_test_data_real_o[MAX_FFT_POINTS] __attribute__((aligned(32)));
static int16_t fft_test_data[MAX_FFT_POINTS*2] __attribute__((aligned(32)));
static int16_t fft_test_data_FREQ[MAX_FFT_POINTS*2] __attribute__((aligned(32)));
static int16_t fft_twiddles[MAX_FFT_POINTS*2] __attribute__((aligned(32)));


static int16_t input_complex[MAX_FFT_POINTS*2] __attribute__((aligned(32)));
static void real_scale_fft(int16_t *output, const int16_t *input, const int16_t *twiddles, int logsize)
{

	int i;

	for (i=0;i<(1<<logsize);i++) {
		input_complex[i<<1]=input[i];
		input_complex[(i<<1)+1]=0;
	}
	complex_scale_fft(output, input_complex, twiddles, logsize);
}

static void real_unscale_fft(int16_t *output, const int16_t *input, const int16_t *twiddles, int logsize)
{

	int i;

	for (i=0;i<(1<<logsize);i++) {
		input_complex[i<<1]=input[i];
		input_complex[(i<<1)+1]=0;
	}
	complex_unscale_fft(output, input_complex, twiddles, logsize);
}

static int16_t output_complex[MAX_FFT_POINTS*2] __attribute__((aligned(8)));
static void real_scale_ifft(int16_t *output, const int16_t *input, const int16_t *twiddles, int logsize)
{
	int i;


	complex_scale_ifft(output_complex, input, twiddles, logsize);

	for (i=0;i<(1<<logsize);i++) {
		output[i]=output_complex[i<<1];
	}
}

static void real_unscale_ifft(int16_t *output, const int16_t *input, const int16_t *twiddles, int logsize)
{
	int i;


	complex_unscale_ifft(output_complex, input, twiddles, logsize);

	for (i=0;i<(1<<logsize);i++) {
		output[i]=output_complex[i<<1];
	}
}

static void complex_mult(int16_t *output, const int16_t *input1, const int16_t *input2, int length)
{
	int32_t acc;
	int i;

	// input1[i<<1]=a,input1[(i<<1)+1]=b,input2[i<<1]=c,input2[(i<<1)+1]=d
	// (a+bi) * (c+di)
	// real part = a*c - b*d
	// img part = a*d + b*c

	for (i=0;i<length;i++) {
		acc = (int32_t)input1[i<<1]*input2[i<<1] - (int32_t)input1[(i<<1)+1]*input2[(i<<1)+1];
		output[i<<1] = (acc + 0x4000) >>15;

		acc = (int32_t)input1[i<<1]*input2[(i<<1)+1] + (int32_t)input1[(i<<1)+1]*input2[i<<1];
		output[(i<<1)+1] = (acc + 0x4000) >>15;
	}

}

/* report value is multipy 100000 */
int calc_error_rate(int16_t* input, int32_t* output_fftacc, int length)
{
	int sum, error, i, rate;
	sum = 0;
	error = 0;
	for (i=0; i<length; i++) {
		if (*input < 0)
			sum-= (int)*input;
		else
			sum+= (int)*input;
		if (((int)*input) < (*output_fftacc))
			error+= (*output_fftacc - (int)*input);
		else
			error+= (((int)*input) - *output_fftacc);
		input++;
		output_fftacc++;
	}

	sum/=100;
	rate=error*1000/sum;
	return rate;
}



/* Random generator  */
//from g.729 function: g729_util.c
static int16_t Random(int16_t *seed)
{
	/* seed = seed*31821 + 13849; */
	*seed = (int16_t)((*seed * 31821+ 13849L)&0xffff);
	return(*seed);
}

static void enable_CP3(void)
{
	__write_32bit_c0_register(CP0_STATUS, 0, __read_32bit_c0_register(CP0_STATUS, 0)|0x80000000);
}


int output_temp[4096];
int16_t random_seed;
void fft_test( void )
{
	//int fft_logsize=TEST_FFT_LOGSIZE;
	int test_point = TEST_POINT;//4096;
	int i, j, k, nTry, shift[8], shifti[8];
	int length=512;
	int testmode;/* 512, 1024, 2048pt */
	int input_select;
	short* puncache_in;
	short* puncache;
	short* puncache_freq;

	unsigned long long cycle_array[12], now_cycle, pre_cycle;

	long saved_mmd;

	enable_CP3();

	change_cp3_con_control0(0xff, CP3_COUNT_STOP);
	write_32bit_cp3_general_register(CP3_MONCNT0LO, 0);
	write_32bit_cp3_general_register(CP3_MONCNT0HI, 0);
	change_cp3_con_control0(0xff, CP3_COUNT_CYCLE);
#define TEST_K_CNT (4*3)
//#define TEST_K_CNT (3*3)
    for (k=0; k<TEST_K_CNT; k++) {
    //for (k=9; k<TEST_K_CNT; k++) {
    	testmode=k/3;
    	input_select=k%3;

	random_seed = 1;
	puncache_in=UNCACHE_ADDR(fft_test_data_real);
#if 1
	saved_mmd = read_32bit_radiax_register(RADIAX_MMD);
	write_32bit_radiax_register(RADIAX_MMD, SET_MMD_MS|SET_MMD_MF);
	create_tone( puncache_in, test_point, 8000, 1000, 0);
	create_fft_twiddles( fft_twiddles, TEST_FFT_LOGSIZE);

	if (input_select==1) {
		for (i=0 ; i<test_point ; i++) {
			puncache_in[i] = (Random(&random_seed)>>1);
		}
	}
	if (input_select==2) {
		for (i=0 ; i<test_point ; i++) {
			if (i%8 > 3)
				puncache_in[i] = -32768;
			else
				puncache_in[i] = 32767;
		}
	}
#else
	short my_test_sine1khz[]={0, 23171, 32767, 23171, 0, -23170, -32768, -23170};
	short my_test_sine2khz[]={0, 32767, 0, -32768};
	short my_test_sine3khz[]={0, 23170, -32768, 23170, 0, -23170, 32767, -23170};
	
	for (i=0 ; i<test_point ; i++) {
		puncache_in[i] = (my_test_sine1khz[i%8]);
	}

	if (input_select==1) {
		for (i=0 ; i<test_point ; i++) {
			puncache_in[i] = (my_test_sine2khz[i%4]);
		}
	}
	if (input_select==2) {
		for (i=0 ; i<test_point ; i++) {
			puncache_in[i] = (my_test_sine3khz[i%8]);
		}
	}
#endif

	if (testmode==0)
		length=512;
	else if (testmode==1)
		length=1024;
	else if (testmode==2)
		length=2048;
#if defined(FFTACC_TEST4096PT)
	else
		length=4096;
#endif

	printk("fft_length=%d", length);
	//write_32bit_radiax_register(RADIAX_MMD, SET_MMD_MF);
	//real_scale_fft( fft_test_data_FREQ, fft_test_data_real, fft_twiddles, fft_logsize);
	pre_cycle=cp3_counter0_get_64bit();
	for (j=0 ; j<(test_point/length) ; j++) {
	//for (j=0 ; j<(1) ; j++) {
		shift[j]=fftacc_api( &fft_test_data_real[j*length], &fft_test_data_FREQ[j*length], length, &nTry);
		printk("(f%d)", nTry);


		for (i=0 ; i<test_point*2 ; i++) {
			//fft_test_data_FREQ[i] = fft_test_data_FREQ[i]*64;//for radnom 2048point frequency can gain up 64x.
			//fft_test_data_FREQ[i] = fft_test_data_FREQ[i]*32;//for radnom 1024point frequency can gain up 32x.
		}


		//real_scale_ifft( fft_test_data_real_o, fft_test_data_FREQ, fft_twiddles, fft_logsize);
		shifti[j]=ifftacc_api(&fft_test_data_FREQ[j*length], &fft_test_data_real_o[j*length], length, &nTry);
		printk("(i%d)", nTry);
	}
	now_cycle=cp3_counter0_get_64bit();
	write_32bit_radiax_register(RADIAX_MMD, saved_mmd);


	printk("\ninput:\n");
	for (i=0;i<test_point;i++) {
		printk("%d, ",puncache_in[i]);
		if ((i%512)==511)
			printk("\n");
	}

	puncache_freq=(short*)UNCACHE_ADDR(fft_test_data_FREQ);
	printk("\nfreq:\n");
	for (i=0;i<test_point;i++) {
		printk("%d, ",puncache_freq[i]);
		if ((i%512)==511)
			printk("\n");
		puncache_freq[i]=0;
	}

	puncache=(short*)UNCACHE_ADDR(fft_test_data_real_o);
	printk("\noutput:\n");
	for (i=0;i<test_point;i++) {
		printk("%d, ",puncache[i]);
		if ((i%512)==511)
			printk("\n");
		output_temp[i]=((int)puncache[i])*(1<<(shift[i/length]+shifti[i/length]))/(length/2);
		puncache[i]=0;
	}

	printk("\nshift:\n");
	for (j=0 ; j<(test_point/length) ; j++) {
		printk("%d, ", shift[j]);
	}

	printk("\nshifti:\n");
	for (j=0 ; j<(test_point/length) ; j++) {
		printk("%d, ", shifti[j]);
	}
	cycle_array[k]=now_cycle-pre_cycle;
	printk("\n\n");
	printk("@@%d-%d_%d@@\n", length, input_select, calc_error_rate(puncache_in, output_temp, test_point));
    }

	for (k=0; k<TEST_K_CNT; k++) {
		printk("{%d, %X%08X}\n", k, (unsigned int)(cycle_array[k]>>32),  (unsigned int)(cycle_array[k]));
	}

}
//#include "st_org_4096_data.h"
#include "test2_mst_org_4096_data.h"
#include "test1_mst_org_4096_data.h"

const long tbl_data[]={
	(const long)st_org_4096_20bit_int,
	(const long)mt_org_4096_20bit_int,
	(const long)st_org_4096_16bit_int,
	(const long)mt_org_4096_16bit_int,
	(const long)t2_mt_org_4096_20bit_1_int,
	(const long)t2_mt_org_4096_20bit_2_int,
	(const long)t2_mt_org_4096_20bit_3_int,
	(const long)t2_mt_org_4096_20bit_4_int,
	(const long)t2_mt_org_4096_20bit_5_int,
	(const long)t2_mt_org_4096_20bit_6_int,
	(const long)t2_mt_org_4096_20bit_7_int,
	(const long)t2_mt_org_4096_20bit_8_int,
	(const long)t2_mt_org_4096_20bit_9_int,
	(const long)t2_mt_org_4096_20bit_10_int,
	};

const char *str_data[]={
	"st_org_4096_20bit_int", "mt_org_4096_20bit_int", "st_org_4096_16bit_int", "mt_org_4096_16bit_int",
	"t2_mt_org_4096_20bit_1_int", "t2_mt_org_4096_20bit_2_int", "t2_mt_org_4096_20bit_3_int", "t2_mt_org_4096_20bit_4_int", "t2_mt_org_4096_20bit_5_int", 
	"t2_mt_org_4096_20bit_6_int", "t2_mt_org_4096_20bit_7_int", "t2_mt_org_4096_20bit_8_int", "t2_mt_org_4096_20bit_9_int", "t2_mt_org_4096_20bit_10_int"
	};

#define TEST_NUM 14

void fft_test3( void )
{
	long saved_mmd;

	int test_point=TEST_POINT;//4096;
	int length=512;
	int testmode; /* 512, 1024, 2048pt */
	int input_select;
	int fft_logsize=12;

	int i, j, k, shift[8], shifti[8], nTry;
	short* puncache;
	short* puncache_freq;
	short* input;

	unsigned long long cycle_array[TEST_NUM*4], now_cycle, pre_cycle;

	enable_CP3();

	change_cp3_con_control0(0xff, CP3_COUNT_STOP);
	write_32bit_cp3_general_register(CP3_MONCNT0LO, 0);
	write_32bit_cp3_general_register(CP3_MONCNT0HI, 0);
	change_cp3_con_control0(0xff, CP3_COUNT_CYCLE);

#define TEST3_K_CNT (TEST_NUM*4)
//#define TEST3_K_CNT (14*3)
//#define TEST3_K_CNT (13)
    for (k=0; k<(TEST3_K_CNT); k++) {
    //for (k=TEST_NUM*3; k<(TEST3_K_CNT); k++) {
	testmode=k/TEST_NUM;
	input_select=k%TEST_NUM;

	input=(short*)(tbl_data[input_select]);
	printk("\ntest_vector:%s\n", str_data[input_select]);

	saved_mmd = read_32bit_radiax_register(RADIAX_MMD);
	write_32bit_radiax_register(RADIAX_MMD, SET_MMD_MS|SET_MMD_MF);
	create_fft_twiddles( fft_twiddles, fft_logsize);

	if (testmode==0)
		length=512;
	else if (testmode==1)
		length=1024;
	else if (testmode==2)
		length=2048;
#if defined(FFTACC_TEST4096PT)
	else
		length=4096;
#endif

	printk("fft_length=%d", length);

	//for (i=0 ; i<test_point ; i++) {
	//	fft_test_data_real[i]=st_org_4096_20bit_int[i]<<SHIFT_UP;
	//}

	write_32bit_radiax_register(RADIAX_MMD, SET_MMD_MF);
	//real_scale_fft( fft_test_data_FREQ, fft_test_data_real, fft_twiddles, fft_logsize);
	//real_unscale_ifft( fft_test_data_real_o, fft_test_data_FREQ, fft_twiddles, fft_logsize);

	write_32bit_radiax_register(RADIAX_MMD, saved_mmd);

	pre_cycle=cp3_counter0_get_64bit();
	for (j=0 ; j<(test_point/length) ; j++) {
		shift[j]=fftacc_api( &input[j*length], &fft_test_data_FREQ[j*length], length, &nTry);
		printk("(f%d)", nTry);
		shifti[j]=ifftacc_api(&fft_test_data_FREQ[j*length], &fft_test_data_real_o[j*length], length, &nTry);
		printk("(i%d)", nTry);
	}
	now_cycle=cp3_counter0_get_64bit();

	printk("\ninput:\n");
	for (i=0;i<test_point;i++) {
		printk("%d, ",input[i]);
	}

	puncache_freq=(short*)UNCACHE_ADDR(fft_test_data_FREQ);
	puncache=(short*)UNCACHE_ADDR(fft_test_data_real_o);
	printk("\noutput_fftacc:\n");
	for (i=0;i<test_point;i++) {
		printk("%d, ",puncache[i]);
		output_temp[i]=puncache[i]*(1<<(shift[i/length]+shifti[i/length]))/(length/2);
		puncache_freq[i]=0;
		puncache[i]=0;
	}

	printk("\nshift:\n");
	for (j=0 ; j<(test_point/length) ; j++) {
		printk("%d, ", shift[j]);
	}

	printk("\nshifti:\n");
	for (j=0 ; j<(test_point/length) ; j++) {
		printk("%d, ", shifti[j]);
	}
	cycle_array[k]=now_cycle-pre_cycle;
	printk("\n\n");
	printk("@@%d-%s_%d@@\n", length, str_data[input_select], calc_error_rate(input, output_temp, test_point));
    }

	for (k=0; k<TEST3_K_CNT; k++) {
		printk("{%d, %X%08X}\n", k, (unsigned int)(cycle_array[k]>>32),  (unsigned int)(cycle_array[k]));
	}
}

#define FILTER_LENGTH 1024
#define BLOCK_CNT 3

int16_t filter_data[FILTER_LENGTH];

static void filter_init(void)
{
	int i;
	for (i=0;i<(FILTER_LENGTH);i++)
		filter_data[i]= 0;
}

int16_t h_filter[FILTER_LENGTH] __attribute__((aligned(8))) = {
	     -1,       2,     -10,      14,     -21,      27,     -29,      39,     -40,      44,
	    -47,     336,    -187,    -220,    -346,     566,     -46,    -644,    -498,     525,
	   1007,     700,     760,   -1586,   -2297,   -1354,    1177,    2289,    1829,    1054,
	    149,    -693,   -2001,   -2441,   -1547,     613,    1801,    1650,     996,     397,
	   -318,   -1298,    -727,      43,     855,     283,    -139,    -681,    -978,    -505,
	    605,    1033,     626,     287,      15,    -390,    -722,    -523,    -194,    -110,
	    218,     635,     499,     245,     -61,     -65,    -113,    -174,    -245,    -389,
	   -214,    -130,     234,     589,     528,     -18,    -252,    -327,    -434,    -287,
	     48,     345,     367,     331,     123,      98,     -84,    -117,    -115,     -99,
	   -214,    -186,    -136,     142,     256,     267,     106,     -63,    -117,    -147,
	    -69,      -6,      26,     180,     132,     215,      81,     -88,    -111,    -127,
	    -96,     -39,      94,      69,     -68,     -28,      81,     231,      77,      20,
	     68,     -51,    -177,     -27,     -22,    -105,       4,       6,      64,      93,
	    141,     -31,      30,      19,      77,      92,      24,      54,     -26,    -115,
	   -137,       0,     -42,      20,      41,     -35,      12,      39,      29,     143,
	     71,      80,     -22,     -39,     -34,       3,       0,      28,     -28,      12,
	    -51,    -101,     -68,      14,      28,     107,     135,     150,      64,       0,
	    -60,    -108,     -84,     -32,     -39,      60,      74,      45,      40,       6,
	    -21,     -76,      -3,      28,      51,      71,      69,      23,      34,     -13,
	      1,     -35,      -9,     -19,       2,      51,      66,      16,      42,       5,
	    -12,      30,      18,      22,      26,     -14,       5,      12,     -12,      19,
	     14,       0,      26,      53,      31,       5,      20,      20,       2,     -18,
	     44,     -22,      -5,      22,     -21,     -31,       0,      -8,     -42,      14,
	     50,       2,      22,      34,      -4,       9,       5,     -37,      18,     -33,
	     -5,      -1,     -18,       9,      -4,     -28,     -17,       2,       1,      39,
	    -17,      47,      15,       9,      11,      36,     -21,      19,      -9,     -14,
	    -10,      14,     -17,      21,       2,      27,      20,     -10,      24,      19,
	      4,      55,      55,      23,      47,      -4,      16,       3,      -1,      14,
	     14,       4,      42,      17,      12,      14,       5,       5,      25,      43,
	     38,      62,      22,      22,      26,       2,      -2,      17,       3,       6,
	     24,       0,       4,      20,      -2,     -11,      29,      -2,       6,      31,
	     14,       9,      19,      21,       5,     -20,       0,      13,     -21,      -5,
	      8,     -11,       0,       2,       2,      14,       0,       5,     -11,     -10,
	     17,      12,      18,       0,      14,      -2,       7,      14,      16,      -9,
	     20,      14,       5,      18,      19,      12,      -7,      20,       9,      21,
	     20,      32,      18,      37,      25,      23,      38,      12,       8,      38,
	      9,      12,      34,      12,       1,      21,      29,       8,      18,      16,
	     27,      17,      29,      18,      27,      -7,      -1,      15,      -3,      -1,
	      8,      -4,      -7,       3,      -4,     -14,       6,       4,      -6,       3,
	     11,     -20,      12,     -27,      -4,      -5,     -19,     -12,      -2,     -25,
	     -7,      -1,     -28,      11,     -14,       0,      -9,      11,     -10,      12,
	     -9,       6,      -1,       3,       3,       6,      -4,      21,       5,       7,
	     11,      17,      18,      23,      17,      30,      12,      33,      20,      31,
	     28,      29,      14,      49,      11,      31,      17,      33,      17,      33,
	     24,      42,      33,      22,      38,      23,      19,      28,      24,      11,
	     30,      21,      13,      23,      12,      18,       9,       0,       9,       5,
	     11,       9,      13,      -3,       8,      -3,       0,      -2,       1,      -4,
	     -6,       3,      -9,       1,      -7,     -10,      -8,      -8,      -5,      -6,
	      1,      -5,     -12,      -5,      -6,      -7,       0,       4,       1,      -4,
	     11,      -3,       0,      -2,      11,      -7,      11,       8,       7,       6,
	     18,       4,      20,      13,      15,      16,      14,      21,      13,      17,
	     17,       6,      29,       6,      22,      11,      24,      10,      23,       8,
	     21,       9,      19,      17,      11,      17,      19,       5,      13,       5,
	      9,       4,       8,       5,      10,       0,      10,       0,       6,      -9,
	     19,     -10,      14,      -1,       7,       0,       6,      -9,       9,      -8,
	      6,      -2,       7,      -1,       3,      -1,      11,       0,       8,       8,
	      7,      12,      19,       1,      24,       6,      15,       6,      35,      -5,
	     41,       8,      28,       7,      33,       9,      35,       6,      44,      16,
	     33,      17,      31,      20,      27,      20,      29,      23,      28,      25,
	     22,      21,      21,      20,      15,      21,      13,      18,      12,      23,
	      6,      25,       1,      23,      -4,      22,      -2,      15,       0,       4,
	      7,      -4,       5,       0,       2,      -6,       2,      -5,       4,      -8,
	      1,      -7,       5,      -7,       6,     -11,       2,      -7,       0,      -4,
	      0,       2,      -6,       4,      -3,       0,       1,       4,       4,       6,
	      2,       6,       4,       0,       4,      11,      -1,      12,       7,       6,
	      5,      14,       2,      10,       5,      10,       5,       8,      14,       6,
	     20,       3,      14,       4,       8,       7,       9,       9,       8,       9,
	      5,       2,      13,       1,      10,       7,       7,       3,      12,      -3,
	     13,       6,       8,       5,      11,       0,      12,       0,      14,       1,
	     17,       3,      10,      10,      13,      10,      11,      19,       2,      23,
	      9,      20,      12,      21,      12,      22,      18,      16,      18,      20,
	     21,      17,      26,      20,      24,      18,      25,      20,      25,      26,
	     18,      32,      15,      29,      17,      25,      14,      25,      12,      25,
	      9,      30,       0,      28,       0,      25,      -4,      28,       0,      18,
	      2,      16,      -2,       8,      -6,       6,      -6,       3,      -4,       2,
	    -10,       0,      -8,      -8,      -7,      -6,      -9,     -10,      -8,     -10,
	    -10,     -13,     -10,     -10,     -14,      -8,      -9,     -11,     -11,      -9,
	    -12,      -9,      -8,      -2,     -12,      -3,      -8,      -1,     -10,       1,
	     -8,       6,      -5,       2,       1,       0,       6,      -1,      15,      -1,
	     12,       2,      14,       5,      15,      10,      15,      13,      16,      13,
	     17,      15,      14,      20,      14,      21,      14,      22,      13,      20,
	     19,      16,      20,      21,      15,      25,      15,      20,      16,      22,
	      9,      24,      11,      21,      17,      17,      17,      15,      17,      15,
	     17,      11,      23,       4,      24,       1,      23,       2,      21,       2,
	     23,       0,      18,       3,      12,       8,      10,       5,      14,       6,
	      9,       8,       6,       8,       7,       8,       7,      10,       4,       7,
	      7,       2,       6,       5,       7,       6,       7,       8,       8,       5,
	     12,       7,      11,      10,      10,      10,       8,      13,      10,      14,
	     10,      17,       8,      12,      14,       9,      14,      10,      16,      10,
	     16,       8,      19,       6,      18,       3,      19,       4,      15,       6,
	     14,       8,      10,      10,       8,       5,      12,       3,       5,       6,
	      3,       4,       4,       3,       5,       3,       5,      -1,       9,      -1,
	      2,       2,       3,       0,       6,       0,       3,       1,       1,       2,
	      0,       5,       0,       3,       2,       5,       0,       8,       2,       6,
	      7,       5,       6,       7,       6,       4,      11,       4,      12,       9,
	     11,      12,       7,      14,       3,      16,       4,      18,       4,      20,
	      6,      14,      10,      14,      11,      14,      11,      13,      11,      10,
	     14,      10,      11,       7,      13,       5,      12,       6,      11,       7,
	      9,       5,       4,       5,       4,       7,       3,       8,       0,       3,
	      2,       2,       4,       1,       3,      -1,       5,      -8,      10,      -8,
	      7,      -3,       5,      -2,       4,      -2,      -1,       2,      -4,       1,
	     -3,       2,      -4,       1,      -3,       2,      -1,       2,      -2,       4,
	     -5,       6,      -1,       2};
int16_t h_filter_fft[FILTER_LENGTH*4] __attribute__((aligned(8)));


short filter16_256(short x)
{
	int i;
	long sum=0;

	for (i=0;i<(256-1);i++)
		filter_data[(256-1)-i]=filter_data[(256-1)-1-i];

	filter_data[0]=x;

	for (i=0;i<256;i++)
		sum+=h_filter[i]*filter_data[i];

	return (sum>>15);
}

short filter16_512(short x)
{
	int i;
	long sum=0;

	for (i=0;i<(512-1);i++)
		filter_data[(512-1)-i]=filter_data[(512-1)-1-i];

	filter_data[0]=x;

	for (i=0;i<512;i++)
		sum+=h_filter[i]*filter_data[i];

	return (sum>>15);
}

short filter16_1024(short x)
{
	int i;
	long sum=0;

	for (i=0;i<(1024-1);i++)
		filter_data[(1024-1)-i]=filter_data[(1024-1)-1-i];

	filter_data[0]=x;

	for (i=0;i<1024;i++)
		sum+=h_filter[i]*filter_data[i];

	return (sum>>15);
}

static int16_t fft_test_data_real2[MAX_FFT_POINTS*BLOCK_CNT/2] __attribute__((aligned(8)));
static int16_t fft_test_data_real_o2[MAX_FFT_POINTS*BLOCK_CNT/2] __attribute__((aligned(8)));
//static int16_t fft_test_data[MAX_FFT_POINTS*2] __attribute__((aligned(8)));
static int16_t fft_test_data_FREQ2[MAX_FFT_POINTS*2] __attribute__((aligned(8)));

static int16_t FreqDomain_H[MAX_FFT_POINTS*2] __attribute__((aligned(8)));
static int32_t FreqDomain_H_32bit[MAX_FFT_POINTS*2] __attribute__((aligned(8)));
static int16_t FreqDomain_H_norm[MAX_FFT_POINTS*2] __attribute__((aligned(8)));

static int16_t fft_test_echo_out_time[MAX_FFT_POINTS*BLOCK_CNT/2];
static int16_t fft_test_echo_out_freq[MAX_FFT_POINTS*BLOCK_CNT/2];
static int16_t fft_test_echo_out_freq_unscale[MAX_FFT_POINTS*BLOCK_CNT/2];

static int16_t est_echo[MAX_FFT_POINTS];
static int16_t est_echo_FreqDomain[MAX_FFT_POINTS*2] __attribute__((aligned(8)));//complex

static int16_t input_buf[MAX_FFT_POINTS];
static int16_t input_buf_norm[MAX_FFT_POINTS];

const char* orig_test_str[]={"sine", "random", "square"};

void fft_test2( void )
{

	int fft_logsize=TEST_FFT_LOGSIZE; //2048
	int test_point = TEST_POINT;//4096;
	int taps=test_point/2;
	int log2taps=fft_logsize-1;
	int i, j, k, kk, shift[16], shifti[16], shifth[16];
	int testmode, length, nTry;
	int input_select;

	long value;
	long ls_input;
	long ls_temp1;
	long ls_input_F;
	long ls_freq_H;
	long ls_est_echo;
	long echo_shift;

	long saved_mmd;

	short* puncache;
	short* puncache_freq;
	short* input;
#define TEST2_K_CNT (4*17)
//#define TEST2_K_CNT (3*17)
    for (kk=0 ; kk<TEST2_K_CNT ; kk+=1) {
	testmode=kk/17;
	input_select=kk%17;

	random_seed = 1;

	if (testmode==0)
		length=512;
	else if (testmode==1)
		length=1024;
	else if (testmode==2)
		length=2048;
#if defined(FFTACC_TEST4096PT)
	else
		length=4096;
#endif
	taps=length/2;

	if (input_select<3) {
		input=fft_test_data_real2;
		printk("\ntest_vector:%s\n", orig_test_str[input_select]);
	} else {
		input=(short*)(tbl_data[input_select-3]);
		printk("\ntest_vector:%s\n", str_data[input_select-3]);
	}
		

	saved_mmd = read_32bit_radiax_register(RADIAX_MMD);
	write_32bit_radiax_register(RADIAX_MMD, SET_MMD_MS|SET_MMD_MF);
	create_tone( fft_test_data_real2, test_point, 8000, 1000, 0);
	create_fft_twiddles( fft_twiddles, TEST_FFT_LOGSIZE);

	if (input_select==1) {
		for (i=0 ; i<test_point ; i++) {
			fft_test_data_real2[i] = (Random(&random_seed)>>1);
		}
	}

	if (input_select==2) {
		for (i=0 ; i<test_point ; i++) {
			if (i%8 > 3)
				fft_test_data_real2[i] = -32768;
			else
				fft_test_data_real2[i] = 32767;
		}
	}

	// time domain test
	filter_init();
	printk("\ntime\n");
	for (i=0 ; i<test_point ; i++) {
		if (testmode==0)
			fft_test_echo_out_time[i]= filter16_256(input[i]);
		else if (testmode==1)
			fft_test_echo_out_time[i]= filter16_512(input[i]);
		else
			fft_test_echo_out_time[i]= filter16_1024(input[i]);

		printk("%d, ", fft_test_echo_out_time[i]);
		if ((i%80)==79)
			printk("...\n");

	}

	//freq domain fft_acc test

	for (i=0 ; i<length ; i++)
		input_buf[i]=0;

	write_32bit_radiax_register(RADIAX_MMD, SET_MMD_MF);
	for (i=0 ; i<(test_point/taps) ; i++) {
	//for (i=0 ; i<(1) ; i++) {
		for (j=0 ; j<length/2 ; j++) {
			input_buf[j]=input_buf[j+(length/2)];
			input_buf[j+(length/2)]=input[j+i*length/2];
		}
		//printk("[%d]\n", i);
		for (j=0 ; j<length ; j++) {
			//printk(" %d,", input_buf[j]);
			
		}
		//printk("\n");

		vector_max_abs(input_buf, length,&k);
		value = input_buf[k];

		ls_input = leadsign(value);
		//printk("\n{%d, %d, ", value, ls_input);


		if (ls_input > 28) {
			ls_input = 28;
		}

		puncache=(short*)UNCACHE_ADDR(input_buf_norm);
		for (j=0 ; j<length;j++) {
			puncache[j]=input_buf[j]<<(ls_input-16);
		}

		//for (j=0 ; j<20 ; j++) {
		//	printk("[%d, ",input_buf[j+(length/2)]);
		//	printk("%d], ",input_buf_norm[j+(length/2)]);
		//}

		//real_scale_fft(fft_test_data_FREQ2, input_buf_norm, fft_twiddles, fft_logsize);
		shift[i]=fftacc_api( &puncache[0], &fft_test_data_FREQ2[0], length, &nTry);
		printk("(f%d)", nTry);

		for (j=0; j<length/2 ; j++) {
			if (j<FILTER_LENGTH)
				h_filter_fft[j]=h_filter[j];
			h_filter_fft[j+length/2]=0;
		}

		//for (j=0 ; j<20 ; j++) {
		//	printk("[!%d, ",h_filter[j]);
		//	printk("%d], ",h_filter_fft[j]);
		//}

		vector_max_abs(h_filter_fft, length, &k);
		value = h_filter_fft[k];
		ls_temp1 = leadsign(value);
		//printk("%d, %d, ", value, ls_temp1);
		puncache=UNCACHE_ADDR(h_filter_fft);
		for (j=0 ; j<length ; j++) {
			puncache[j] = h_filter_fft[j] <<(ls_temp1-16);
		}

		//real_scale_fft(FreqDomain_H_norm, h_filter_fft, fft_twiddles, fft_logsize);
		shifth[i]=fftacc_api( &puncache[0], &FreqDomain_H_norm[0], length, &nTry);
		printk("(f%d)", nTry);
		puncache=(short*)UNCACHE_ADDR(FreqDomain_H_norm);
		for (j=0 ; j<length ; j++) {
			FreqDomain_H[j]=puncache[j]>>(ls_temp1-16);
			FreqDomain_H_32bit[j]=((int32_t)puncache[j])<<(32-ls_temp1);
		}

		//for (j=0 ; j<20 ; j++) {
		//	printk("(%d, ",FreqDomain_H[j]);
		//	printk("%d), ",FreqDomain_H_32bit[j]);
		//}


		vector_max_abs(FreqDomain_H, length, &k);
		value = FreqDomain_H[k];

		ls_freq_H = leadsign(value);
		//printk("%d, %d, }", value, ls_freq_H);
		if (ls_freq_H > 28) {
			ls_freq_H = 28;
		}

		if (ls_freq_H < 18) {
			//ls_freq_H = 18;
		}

		//printk("\nls_freq_H=%d\n", ls_freq_H);

		for (j=0;j<taps*2;j++) {
			//FreqDomain_H [i] = FreqDomain_H[i]  << (ls_freq_H - 16);
			
			//FreqDomain_H_norm [j] = FreqDomain_H_32bit[j] >> (32 - ls_freq_H);
			puncache[j] = FreqDomain_H_32bit[j] >> (32 - ls_freq_H);
		}

		//for (j=0 ; j<20 ; j++) {
		//	printk("(%d) ",FreqDomain_H_norm[j]);
		//}

		vector_max_abs(fft_test_data_FREQ2, length, &k);
		value = fft_test_data_FREQ2[k];
		//printk("f_i=%d*\n",value);
		ls_input_F = leadsign(value);
		//printk("\n{%d, %d}", value, ls_input_F);
		if (ls_input_F > 28) {
			ls_input_F =28;
		}

		if (ls_input_F < 17)
			ls_input_F = 17;

		//printk("\nls_input_F=%d\n", ls_input_F);
		puncache=(short*)UNCACHE_ADDR(fft_test_data_FREQ2);
		for (j=0;j<length;j++) {
			puncache[j] = puncache[j]<<(ls_input_F -16 -1);
		}

		complex_mult(UNCACHE_ADDR(est_echo_FreqDomain), fft_test_data_FREQ2, FreqDomain_H_norm, taps);


		//real_scale_ifft(est_echo, est_echo_FreqDomain, fft_twiddles, log2taps +1);
		shifti[i]=ifftacc_api( &est_echo_FreqDomain[0], &est_echo[0], length, &nTry);
		printk("(if%d)", nTry);
		//printk("echo_shift=%d",(ls_input-16 + ls_freq_H-16 -8 + ls_input_F-17 ));

		puncache_freq=UNCACHE_ADDR(est_echo);

		fft_logsize= top_bit_asm(length);
		echo_shift = (ls_input-16 + ls_freq_H-16 +(/*8*/ fft_logsize-1) + ls_input_F-17 - shift[i] -shifti[i] - shifth[i]);
		printk("\necho_shift=%d\n", echo_shift);
		if (echo_shift>=0) {
			for (j=0;j<taps;j++) {
				//est_echo[i]=0; //clear the first part of est_echo,
				//est_echo[128+i]=echo[i]-est_echo[128+i];
				fft_test_echo_out_freq[j+i*length/2]=puncache_freq[taps+j]>>echo_shift;
				//est_echo_out[i]=est_echo[128+i]>>(ls_input-16 + ls_freq_H-16 -16 -8 + ls_input_F-17 );
				//est_echo_out[i]=est_echo[aec->taps+i]>>echo_shift;
				//est_echo[aec->taps+i]=output[i]; //store the error signal in the last part of est_echo
			}
		} else {
			for (j=0;j<taps;j++) {
				//est_echo[i]=0; //clear the first part of est_echo,
				//est_echo[128+i]=echo[i]-est_echo[128+i];
				fft_test_echo_out_freq[j+i*length/2]=puncache_freq[taps+j]<<(-echo_shift);
				//est_echo_out[i]=est_echo[128+i]>>(ls_input-16 + ls_freq_H-16 -16 -8 + ls_input_F-17 );
				//est_echo_out[i]=est_echo[aec->taps+i]<<(-echo_shift);

				//est_echo[aec->taps+i]=output[i]; //store the error signal in the last part of est_echo
			}
		}

	}

	printk("\nfreq_out:\n");
	for (i=0 ; i<test_point ; i++) {
	//for (i=0 ; i<test_point*1/2 ; i++) {
		printk("%d, ", fft_test_echo_out_freq[i]);
		output_temp[i] = fft_test_echo_out_freq[i];
		if ((i%80)==79)
			printk("...\n");

	}

	printk("\nshift:\n");
	for (j=0 ; j<(test_point/taps) ; j++) {
		printk("%d, ", shift[j]);
	}

	printk("\nshifth:\n");
	for (j=0 ; j<(test_point/taps) ; j++) {
		printk("%d, ", shifth[j]);
	}

	printk("\nshifti:\n");
	for (j=0 ; j<(test_point/taps) ; j++) {
		printk("%d, ", shifti[j]);
	}

	printk("\n");
	printk("@@%d-%d_%d@@\n", length, input_select, calc_error_rate(fft_test_echo_out_time, output_temp, test_point));
    }
	write_32bit_radiax_register(RADIAX_MMD, saved_mmd);

}

void fft_acc_init(void)
{
	int temp;
	
#ifdef CONFIG_RTK_VOIP_DRIVERS_PCM8676
	//FFTACC_IE: FFTACC interrupt enable.
	//FFTACC_IP: FFTACC interrupt pending flag.
	//FFTACC_RS: FFTACC interrupt route select.
	//EN_FFTACC 0xB800-030C bit 15
	temp = *((volatile int *)0xb800030c);
	*((volatile int *)0xb800030c) = (temp | 0x8000);
#else
#error "Please implement the fft_acc init code for the used platform.\n"
#endif
}





