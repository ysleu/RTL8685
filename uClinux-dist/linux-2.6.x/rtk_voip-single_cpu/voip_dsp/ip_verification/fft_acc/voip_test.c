
#ifdef LINUX_TEST
#include <linux/kernel.h>
#endif

#define VOIPBASE	0xb8018000//0xB8018000
//#define VOIPBASE	0xb800B000//
                                              
#define VOIPTOPCNR	(VOIPBASE+0x00)       
#define VOIPIMR		(VOIPBASE+0x04)       
#define VOIPISR		(VOIPBASE+0x08)       
                                              
#define VOIPCTRL	(VOIPBASE+0x10)       
#define VOIPLSP		(VOIPBASE+0x14)       
#define VOIPACELP	(VOIPBASE+0x18)       
#define VOIPSBP0	(VOIPBASE+0x20)       
#define VOIPSBL0	(VOIPBASE+0x24)       
#define VOIPSBP1	(VOIPBASE+0x28)       
#define VOIPSBL1	(VOIPBASE+0x2C)       
#define VOIPDBP0	(VOIPBASE+0x30)       
#define VOIPDBL0	(VOIPBASE+0x34)       
#define VOIPDBP1	(VOIPBASE+0x38)       
#define VOIPDBL1	(VOIPBASE+0x3C)       
#define VOIPCROSS1	(VOIPBASE+0x40)       
#define VOIPCROSS2	(VOIPBASE+0x44)       
#define VOIPCROSS3	(VOIPBASE+0x48)       


#ifdef LINUX_TEST
#define printf	printk
#else
//#define printf	printf
#define printf	prom_printf
#endif


#define REG32(reg) 			(*((volatile unsigned int *)(reg)))
#define UNCACHE_ADDR(addr) (((int)addr)|0x20000000)

unsigned int test_input[50] __attribute__((aligned(32)));
unsigned int *puncache_in;

unsigned int test_output[10] __attribute__((aligned(32)));
unsigned int *puncache_out;

void voip_test(void)
{
	unsigned int temp;
	unsigned int voipacc_status;
	// Disable VOIPACC, enable it to reset.
	REG32(VOIPTOPCNR) = 0;
	REG32(VOIPTOPCNR) = 0x80000000;

	// test pattern begin
	// source data (h)

	puncache_in= (unsigned int *) UNCACHE_ADDR(test_input);

	puncache_in[0]=0x40000D78;
	if (0x40000D78 !=puncache_in[0] )
		printf("error(%d)\n", __LINE__);

	puncache_in[1]=0x09C80954;
	puncache_in[2]=0x06EC0568;
	puncache_in[3]=0x03F4027C;
	puncache_in[4]=0x01AC00CC;
	puncache_in[5]=0x00640054;
	puncache_in[6]=0x0028000C;
	puncache_in[7]=0x0000FFF8;
	puncache_in[8]=0xFFF8FFF8;
	puncache_in[9]=0xFFF8FFFC;

	puncache_in[10]=0xFFFCFFFC;
	puncache_in[11]=0xFFFCFFFC;
	puncache_in[12]=0x00000000;
	puncache_in[13]=0x00000000;
	puncache_in[14]=0x00000000;
	puncache_in[15]=0x00000000;
	puncache_in[16]=0x00000000;
	puncache_in[17]=0x00000000;
	puncache_in[18]=0x00000000;
	puncache_in[19]=0x00000000;

	puncache_in[20]=0x00C03EFB;
	puncache_in[21]=0xE8084407;
	puncache_in[22]=0x4008BA02;
	puncache_in[23]=0x6C00AD03;
	puncache_in[24]=0xEB03FA01;
	puncache_in[25]=0x68000510;
	puncache_in[26]=0x7406EB00;
	puncache_in[27]=0x0500FC02;
	puncache_in[28]=0x6F047E02;
	puncache_in[29]=0x05041205;

	puncache_in[30]=0x0C021508;
	puncache_in[31]=0x1603AA06;
	puncache_in[32]=0xE000EF02;
	puncache_in[33]=0x7D07CC00;
	puncache_in[34]=0x7E01D803;
	puncache_in[35]=0x6A014C0C;
	puncache_in[36]=0xD8084402;
	puncache_in[37]=0x8F07F805;
	puncache_in[38]=0x40025D00;
	puncache_in[39]=0x28021102;

	puncache_in[40]=0xDF088005;
	puncache_in[41]=0xEF000000;
	puncache_in[42]=0x00000001;
	puncache_in[43]=0x0226CC02;
	puncache_in[44]=0x0;
	puncache_in[45]=0x0;
	puncache_in[46]=0x0;
	puncache_in[47]=0x0;
	puncache_in[48]=0x0;
	puncache_in[49]=0x0;

	temp= puncache_in[49];

	// config VOIPACC
	REG32(VOIPSBP0) = 0x0FFFFFFF & ((unsigned int) test_input);
	REG32(VOIPSBL0) = 0x800000B0;
	REG32(VOIPDBP0) = 0x0FFFFFFF & ((unsigned int) test_output);
	REG32(VOIPDBL0) = 0x8000000A;
	REG32(VOIPCTRL) = 0x10000000;
	REG32(VOIPACELP) = 0x05283800;
	REG32(VOIPTOPCNR) = 0xCD0000C0;

	voipacc_status = REG32(VOIPCTRL);
	while (1) {
		voipacc_status = REG32(VOIPCTRL);

		if(voipacc_status&0x01000000)
			break;
	}

	puncache_out= (unsigned int*) UNCACHE_ADDR(test_output);

	if (0x02090A15 !=puncache_out[0])
		printf("error(%d)\n", __LINE__);
	if (0x00000000 !=puncache_out[1])
		printf("error(%d)\n", __LINE__);
	if (0x00000000 !=(puncache_out[2] &0xffff0000))
		printf("error(%d)\n", __LINE__);
}


/*

// source data (h)
cpuwrite(32'h000921C4,2'h2,32'h40000D78);
cpuread_bitcomp(32'h000921C4, 32'h40000D78, 32'hffff_ffff); 
cpuwrite(32'h000921C8,2'h2,32'h09C80954);
cpuwrite(32'h000921CC,2'h2,32'h06EC0568);
cpuwrite(32'h000921D0,2'h2,32'h03F4027C);
cpuwrite(32'h000921D4,2'h2,32'h01AC00CC);
cpuwrite(32'h000921D8,2'h2,32'h00640054);
cpuwrite(32'h000921DC,2'h2,32'h0028000C);
cpuwrite(32'h000921E0,2'h2,32'h0000FFF8);
cpuwrite(32'h000921E4,2'h2,32'hFFF8FFF8);
cpuwrite(32'h000921E8,2'h2,32'hFFF8FFFC);
cpuwrite(32'h000921EC,2'h2,32'hFFFCFFFC);
cpuwrite(32'h000921F0,2'h2,32'hFFFCFFFC);
cpuwrite(32'h000921F4,2'h2,32'h00000000);
cpuwrite(32'h000921F8,2'h2,32'h00000000);
cpuwrite(32'h000921FC,2'h2,32'h00000000);
cpuwrite(32'h00092200,2'h2,32'h00000000);
cpuwrite(32'h00092204,2'h2,32'h00000000);
cpuwrite(32'h00092208,2'h2,32'h00000000);
cpuwrite(32'h0009220C,2'h2,32'h00000000);
cpuwrite(32'h00092210,2'h2,32'h00000000);

// source data (p_sign)~dn[1]
cpuwrite(32'h00092214,2'h2,32'h00C03EFB);
cpuwrite(32'h00092218,2'h2,32'hE8084407);
// source data (dn[1]~dn[39])
cpuwrite(32'h0009221C,2'h2,32'h4008BA02);
cpuwrite(32'h00092220,2'h2,32'h6C00AD03);
cpuwrite(32'h00092224,2'h2,32'hEB03FA01);
cpuwrite(32'h00092228,2'h2,32'h68000510);
cpuwrite(32'h0009222C,2'h2,32'h7406EB00);
cpuwrite(32'h00092230,2'h2,32'h0500FC02);
cpuwrite(32'h00092234,2'h2,32'h6F047E02);
cpuwrite(32'h00092238,2'h2,32'h05041205);
cpuwrite(32'h0009223C,2'h2,32'h0C021508);
cpuwrite(32'h00092240,2'h2,32'h1603AA06);
cpuwrite(32'h00092244,2'h2,32'hE000EF02);
cpuwrite(32'h00092248,2'h2,32'h7D07CC00);
cpuwrite(32'h0009224C,2'h2,32'h7E01D803);
cpuwrite(32'h00092250,2'h2,32'h6A014C0C);
cpuwrite(32'h00092254,2'h2,32'hD8084402);
cpuwrite(32'h00092258,2'h2,32'h8F07F805);
cpuwrite(32'h0009225C,2'h2,32'h40025D00);
cpuwrite(32'h00092260,2'h2,32'h28021102);
cpuwrite(32'h00092264,2'h2,32'hDF088005);
// source data (dn2)
cpuwrite(32'h00092268,2'h2,32'hEF000000);
// source data (pos_max)
cpuwrite(32'h0009226C, 2'h2,32'h00000001);
cpuwrite(32'h00092270, 2'h2,32'h0226CC02);
// config VOIPACC
//cpuwrite(32'h1800B004,2'h2,32'h00000000);
//cpuwrite(32'h1800B008,2'h2,32'h00000000);
//cpuwrite(32'h1800B00C,2'h2,32'h00000000);

cpuwrite(32'h1800B020,2'h2,32'h000921C4);
cpuwrite(32'h1800B024,2'h2,32'h800000B0);
cpuwrite(32'h1800B030,2'h2,32'h00096680);
cpuwrite(32'h1800B034,2'h2,32'h8000000A);
cpuwrite(32'h1800B010,2'h2,32'h10000000);
cpuwrite(32'h1800B018,2'h2,32'h05283800);
cpuwrite(32'h1800B000,2'h2,32'hCD0000C0);
cpuread(32'h1800B010); //0x12000000 or 0x110000?
wait(sim.chip_i.lxbus_core_inst.VOIPACC_inst.uPROCTOP.u_voip_accproc.bvastatus[0]==1'd1);

cpuread_bitcomp(32'h00096680, 32'h02090A15, 32'hFFFF_FFFF);
cpuread_bitcomp(32'h00096684, 32'h00000000, 32'hFFFF_FFFF);
cpuread_bitcomp(32'h00096688, 32'h00000000, 32'hFFFF_0000);
cpuread_bitcomp(32'h1800B010, 32'h11000000, 32'hFFFF_FFFF);
*/


