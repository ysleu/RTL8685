#include <linux/kernel.h>
#include <linux/timer.h>
#include <linux/sched.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/version.h>
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
#include "bspchip.h"
#endif

#include "rtk_voip.h"
#include "voip_types.h"
#include "snd_mux_slic.h"
#include "con_ring.h"

static con_mrc_t mrc[CON_CH_NUM] = {[0 ... CON_CH_NUM-1] = {0, 0, 2000, 4000, 0, 0, 0, 0, 0, 0, 0, 0}};

void MultiRingCadenceEnable_con(const voip_con_t *p_con, unsigned int enable, unsigned int on1, unsigned int off1, unsigned int on2, unsigned int off2)
{
	con_mrc_t *p_mrc = p_con ->mrc;

	p_mrc->bMulti_rc = enable;
	p_mrc->vMrc_on1 = on1;
	p_mrc->vMrc_off1 = off1;
	p_mrc->vMrc_on2 = on2;
	p_mrc->vMrc_off2 = off2;	
	
	if ( (on1!=0) && (off1!=0))
	{
		p_mrc->vMrc_num = 1;

		if ( (on2!=0) && (off2!=0))
		{
			p_mrc->vMrc_num = 2;
		}
	}
}

uint32 MultiRingCadenceEnableCheck_con(const voip_con_t *p_con)
{
	con_mrc_t *p_mrc = p_con ->mrc;

	return p_mrc->bMulti_rc;
}

void MultiRingStart_con(const voip_con_t *p_con)
{
	con_mrc_t *p_mrc = p_con ->mrc;
	voip_snd_t *p_snd = p_con ->snd_ptr;

	if (1 == p_mrc->bMulti_rc)
	{
		// check hook status if on-hook
		if ( 0 == p_snd ->fxs_ops ->SLIC_Get_Hook_Status(p_snd, 1) )
		{
			p_mrc->bMrc_ring_flag = 1;
			PRINT_MSG("MultiRingStart, ch%d\n", p_con ->cch);
		}
		else
			PRINT_R("%s: warning, SLIC is off-hook, can NOT Ringing, ch%d\n", __FUNCTION__, p_con ->cch);
	}
}

void MultiRingStop_con(const voip_con_t *p_con)
{
	con_mrc_t *p_mrc = p_con ->mrc;

	if (1 == p_mrc->bMulti_rc)
	{
		p_mrc->bMrc_ring_flag = 0;
		p_mrc->bMrc_off1_flag = 0;
		p_mrc->bMrc_off2_flag = 0;
		p_mrc->bMrc_prev_ring_flag = 0;
		p_mrc->vMrc_step = 0;
	}
	PRINT_MSG("MultiRingStop, ch%d\n", p_con ->cch);
}

uint32 MultiRingStatusCheck_con(const voip_con_t *p_con)
{
	con_mrc_t *p_mrc = p_con ->mrc;

	return 	p_mrc->bMrc_ring_flag;
}

uint32 MultiRingOffCheck_con(const voip_con_t *p_con)
{
	con_mrc_t *p_mrc = p_con ->mrc;

	if (p_mrc->vMrc_num == 1)
		return 	p_mrc->bMrc_off1_flag;
	else if (p_mrc->vMrc_num == 2)
	{
		if (p_mrc->vMrc_off1 >=  p_mrc->vMrc_off2)
			return p_mrc->bMrc_off1_flag;
		else
			return p_mrc->bMrc_off2_flag;
	}
}

void MultiRingCadenceProcess_con(const voip_con_t *p_con)
{

	con_mrc_t *p_mrc = p_con ->mrc;
	voip_snd_t *p_snd = p_con ->snd_ptr;

	if ( 0 == p_mrc->bMulti_rc)
		return;		
	
	if ( (0 == p_mrc->bMrc_ring_flag) && ( p_mrc->bMrc_prev_ring_flag != 0) )
	{
		p_snd ->fxs_ops ->FXS_Ring(p_snd, 0 + MRC_RING_CTRL_OFFSET);			// Stop Ring
		//FXS_Ring(cch, 0 + MRC_RING_CTRL_OFFSET);			// Stop Ring
		p_mrc->vMrc_step = 0; 		// Go to Idel step
		//p_mrc->bMrc_prev_ring_flag = 0;	// ring off state
		PRINT_MSG("Stop Ring, ch%d\n", p_con ->cch);
	}
		
	
	if ( (1 == p_mrc->bMrc_ring_flag) && ( p_mrc->bMrc_prev_ring_flag != 1) )
	{
		p_mrc->vMrc_step = 1; 		// Go to Start Ring step
		//p_mrc->bMrc_prev_ring_flag = 1;	// ring on state
		PRINT_MSG("Start Ring, ch%d\n", p_con ->cch);
	}
	
	p_mrc->bMrc_prev_ring_flag = p_mrc->bMrc_ring_flag;
	
#if 0	// debug
	if (p_mrc->vMrc_step != 0)
		printk("%d, %d\n", p_mrc->vMrc_step, p_con ->cch);
#endif
	
	switch(p_mrc->vMrc_step)
	{
		case 0:	// Idel
			break;
		case 1:	// Start Ring
			p_snd ->fxs_ops ->FXS_Ring(p_snd, 1 + MRC_RING_CTRL_OFFSET);			// Stop Ring
			//FXS_Ring(cch, 1 + MRC_RING_CTRL_OFFSET);
			p_mrc->bMrc_off1_flag = 0;
			p_mrc->bMrc_off2_flag = 0;
			p_mrc->vMrc_step++;
			p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_on1;
			break;
		case 2:	// Cad on1
			if (timetick_after(timetick, p_mrc->vMrc_time_out))
			{
				p_snd ->fxs_ops ->FXS_Ring(p_snd, 0 + MRC_RING_CTRL_OFFSET);			// Stop Ring
				//FXS_Ring(cch, 0 + MRC_RING_CTRL_OFFSET);
				p_mrc->bMrc_off1_flag = 1;
				p_mrc->vMrc_step++;
				p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_off1;
			}
			break;
		case 3: // Cad off1
			if (timetick_after(timetick, p_mrc->vMrc_time_out))
			{
				p_snd ->fxs_ops ->FXS_Ring(p_snd, 1 + MRC_RING_CTRL_OFFSET);			// Stop Ring
				//FXS_Ring(cch, 1 + MRC_RING_CTRL_OFFSET);
				p_mrc->bMrc_off1_flag = 0;
				if (p_mrc->vMrc_on2 != 0)
				{
					p_mrc->vMrc_step++;
					p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_on2;
				}
				else
				{
					p_mrc->vMrc_step--;
					p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_on1;
				}
			}
			break;
		case 4: // Cad on2
			if (timetick_after(timetick, p_mrc->vMrc_time_out))
			{
				if (p_mrc->vMrc_off2 != 0)
				{
					p_snd ->fxs_ops ->FXS_Ring(p_snd, 0 + MRC_RING_CTRL_OFFSET);			// Stop Ring
					p_mrc->bMrc_off2_flag = 1;
					//FXS_Ring(cch, 0 + MRC_RING_CTRL_OFFSET);
					p_mrc->vMrc_step++;
					p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_off2;
				}
				else
				{
					p_mrc->vMrc_step-=2;
					p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_on1;
				}
			}
			break;
		case 5: // Cad off2
			if (timetick_after(timetick, p_mrc->vMrc_time_out))
			{
				p_snd ->fxs_ops ->FXS_Ring(p_snd, 1 + MRC_RING_CTRL_OFFSET);			// Stop Ring
				//FXS_Ring(cch, 1 + MRC_RING_CTRL_OFFSET);
				p_mrc->bMrc_off2_flag = 0;
				p_mrc->vMrc_step-=3;
				p_mrc->vMrc_time_out = timetick + p_mrc->vMrc_on1;
			}
			break;
		default:
			PRINT_R("error mrc step = %d, ch%d\n", p_mrc->vMrc_step, p_con ->cch);
			break;
	}
			
}

void mrc_cch_init( voip_con_t voip_con[], int num )
{
	int i;
	voip_con_t *p_con;
	con_mrc_t *p_mrc;

	//printk("mrc_cch_init:\n");

	for( i = 0; i < num; i ++ )
	{
		//printk("sizeof(mrc)/sizeof(con_mrc_t) = %d\n", sizeof(mrc)/sizeof(con_mrc_t));

		if (i > (sizeof(mrc)/sizeof(con_mrc_t)-1))
			printk("error size in %s, line%d\n", __FUNCTION__, __LINE__);

		p_con = &voip_con[ i ];
		p_con ->mrc = (void*)(&mrc[i]);
		p_mrc = (con_mrc_t*) p_con ->mrc;

		//printk("cch = %d\n", p_con->cch);
		//printk("p_con = %p\n", p_con);
		//printk("p_mrc = %p\n", p_mrc);

		p_mrc->bMulti_rc = 0;
		p_mrc->vMrc_step = 0;
		p_mrc->vMrc_on1 = 2000;
		p_mrc->vMrc_off1 = 4000;
		p_mrc->vMrc_on2 = 0;
		p_mrc->vMrc_off2 = 0;
		p_mrc->vMrc_num = 0;
		p_mrc->bMrc_off1_flag = 0;
		p_mrc->bMrc_off2_flag = 0;
		p_mrc->bMrc_ring_flag = 0;
		p_mrc->bMrc_prev_ring_flag = 0;
		p_mrc->vMrc_time_out = 0;
	}
}

