/*
* Copyright c                  Realtek Semiconductor Corporation, 2002  
* All rights reserved.
* 
* Program : GPIO Driver
* Abstract : 
* Author : 
*/

#include "gpio.h"

/*==================== FOR RTL8186 ==================*/

#ifdef CONFIG_RTK_VOIP_DRIVERS_PCM8186

/**************************** GPIO Driver **************************************/

enum GPIO_FUNC	
{
	GPIO_FUNC_DIRECTION,
	GPIO_FUNC_DATA,
	GPIO_FUNC_INTERRUPT_STATUS,
	GPIO_FUNC_INTERRUPT_ENABLE,
	GPIO_FUNC_MAX,
};


//******************************************* Direction

static uint32 regGpioDirectionRead[] =
{
	GPABDIR, 	/* Port A */
	GPABDIR, 	/* Port B */
	GPCDDIR, 	/* Port C */
	GPCDDIR, 	/* Port D */
	GPEFDIR,  	/* Port E */
	GPEFDIR,	/* Port F */
	GPGDIR,		/* Port G */
};

static uint32 bitStartGpioDirectionRead[] =
{
	0, 			/* Port A */
	16, 			/* Port B */
	0,  			/* Port C */
	16, 			/* Port D */
	0, 			/* Port E */
	0, 			/* Port F */	// according to modified Spec. 
	0, 			/* Port G */
};

static uint32 regGpioDirectionWrite[] =
{
	GPABDIR, 	/* Port A */
	GPABDIR, 	/* Port B */
	GPCDDIR, 	/* Port C */
	GPCDDIR, 	/* Port D */
	GPEFDIR,  	/* Port E */
	GPEFDIR,	/* Port F */
	GPGDIR,		/* Port G */
};

static uint32 bitStartGpioDirectionWrite[] =
{
	0, 			/* Port A */
	0, 			/* Port B */
	0,  			/* Port C */
	0, 			/* Port D */  
	0, 			/* Port E */
	0, 			/* Port F */
	0, 			/* Port G */
};

//******************************************* Data

static uint32 regGpioDataRead[] =
{
	GPABDATA, 	/* Port A */
	GPABDATA, 	/* Port B */
	GPCDDATA, 	/* Port C */
	GPCDDATA,  	/* Port D */
	GPEFDATA,  	/* Port E */
	GPEFDATA,	/* Port F */
	GPGDATA,	/* Port G */
};

static uint32 bitStartGpioDataRead[] =
{
	0, 			/* Port A */
	16, 			/* Port B */
	0,  			/* Port C */
	16, 			/* Port D */
	0, 			/* Port E */
	16, 			/* Port F */
	0, 			/* Port G */
};

static uint32 regGpioDataWrite[] =
{
	GPABDATA, 	/* Port A */
	GPABDATA, 	/* Port B */
	GPCDDATA, 	/* Port C */
	GPCDDATA,  	/* Port D */
	GPEFDATA,  	/* Port E */
	GPEFDATA,	/* Port F */
	GPGDATA,	/* Port G */
};

static uint32 bitStartGpioDataWrite[] =
{
	0, 			/* Port A */
	0, 			/* Port B */
	0,  			/* Port C */
	0, 			/* Port D */
	0, 			/* Port E */
	0, 			/* Port F */
	0, 			/* Port G */
};

//******************************************* ISR

static uint32 regGpioInterruptStatusRead[] =
{
	GPABISR, 	/* Port A */
	GPABISR, 	/* Port B */
	GPCDISR, 	/* Port C */
	GPCDISR,  	/* Port D */
	GPEFISR,  	/* Port E */
	GPEFISR,	/* Port F */
	GPGISR,		/* Port G */
};

static uint32 bitStartGpioInterruptStatusRead[] =
{
	0, 			/* Port A */
	16, 			/* Port B */
	0,  			/* Port C */
	16, 			/* Port D */
	0, 			/* Port E */
	16, 			/* Port F */
	0, 			/* Port G */
};

static uint32 regGpioInterruptStatusWrite[] =
{
	GPABISR, 	/* Port A */
	GPABISR, 	/* Port B */
	GPCDISR, 	/* Port C */
	GPCDISR,  	/* Port D */
	GPEFISR,  	/* Port E */
	GPEFISR,		/* Port F */
	GPGISR,		/* Port G */
};

static uint32 bitStartGpioInterruptStatusWrite[] =
{
	0, 			/* Port A */
	0, 			/* Port B */
	0,  			/* Port C */
	0, 			/* Port D */
	0, 			/* Port E */
	0, 			/* Port F */
	0, 			/* Port G */
};

//******************************************* IMR

static uint32 regGpioInterruptEnableRead[] =
{
	GPABIMR,	/* Port A */
	GPABIMR,	/* Port B */
	GPCDIMR, 	/* Port C */
	GPCDIMR,	/* Port D */
	GPEFIMR,		/* Port E */
	GPEFIMR,		/* Port F */
	GPGIMR,		/* Port G */
};

static uint32 bitStartGpioInterruptEnableRead[] =
{
	0, 			/* Port A */
	16,  			/* Port B */
	0,			/* Port C */
	16, 			/* Port D */
	0,  			/* Port E */
	16, 			/* Port F */
	0,  			/* Port G */
};

static uint32 regGpioInterruptEnableWrite[] =
{
	GPABIMR,	/* Port A */
	GPABIMR,	/* Port B */
	GPCDIMR, 	/* Port C */
	GPCDIMR,	/* Port D */
	GPEFIMR,		/* Port E */
	GPEFIMR,		/* Port F */
	GPGIMR,		/* Port G */
};

static uint32 bitStartGpioInterruptEnableWrite[] =
{
	0, 			/* Port A */
	0,  			/* Port B */
	0,			/* Port C */
	0, 			/* Port D */
	0,  			/* Port E */
	0, 			/* Port F */
	0,  			/* Port G */
};

int gpio_debug = 0;

/*
@func int32 | _getGpio | abstract GPIO registers 
@parm enum GPIO_FUNC | func | control/data/interrupt register
@parm enum GPIO_PORT | port | GPIO port
@parm uint32 | pin | pin number
@rvalue uint32 | value
@comm
This function is for internal use only. You don't need to care what register address of GPIO is.
This function abstracts these information.
*/
static uint32 _getGpio( enum GPIO_FUNC func, enum GPIO_PORT port, uint32 pin )
{
	//assert( port < GPIO_PORT_MAX );		
	//assert( func < GPIO_FUNC_MAX );
	//assert( pin < 8 );	

	GPIO_PRINT(4, "[%s():%d] func=%d port=%d pin=%d\n", __FUNCTION__, __LINE__, func, port, pin);
	switch( func )
	{
				
		case GPIO_FUNC_DIRECTION:
			GPIO_PRINT(5, "[%s():%d] regGpioDirectionRead[port]=0x%08x  bitStartGpioDirectionRead[port]=%d\n", __FUNCTION__, __LINE__, regGpioDirectionRead[port], bitStartGpioDirectionRead[port] );

			if ( REG32(regGpioDirectionRead[port]) & ( (uint32)1 << (pin+bitStartGpioDirectionRead[port]) ) )
				return 1;
			else
				return 0;
			break;
			
		case GPIO_FUNC_DATA:
			GPIO_PRINT(5, "[%s():%d] regGpioDataRead[port]=0x%08x  bitStartGpioDataRead[port]=%d\n", __FUNCTION__, __LINE__, regGpioDataRead[port], bitStartGpioDataRead[port] );

			if ( REG32(regGpioDataRead[port]) & ( (uint32)1 << (pin+bitStartGpioDataRead[port]) ) )
				return 1;
			else
				return 0;
			break;
			
		case GPIO_FUNC_INTERRUPT_ENABLE:
			GPIO_PRINT(5, "[%s():%d] regGpioInterruptEnableRead[port]=0x%08x  bitStartGpioInterruptEnableRead[port]=%d\n", __FUNCTION__, __LINE__, regGpioInterruptEnableRead[port], bitStartGpioInterruptEnableRead[port] );

			if ( REG32(regGpioInterruptEnableRead[port]) & ( (uint32)1 <<(pin+bitStartGpioInterruptEnableRead[port]) ))
				return 1;
			else
				return 0;
			break;

		case GPIO_FUNC_INTERRUPT_STATUS:
			GPIO_PRINT(5, "[%s():%d] regGpioInterruptStatusRead[port]=0x%08x  bitStartGpioInterruptEnableRead[port]=%d\n", __FUNCTION__, __LINE__, regGpioInterruptStatusRead[port], bitStartGpioInterruptStatusRead[port] );

			if ( REG32(regGpioInterruptStatusRead[port]) & ( (uint32)1 << (pin+bitStartGpioInterruptStatusRead[port]) ) )
				return 1;
			else
				return 0;
			break;
			
		case GPIO_FUNC_MAX:
			//assert( 0 );
			break;
	}
	return 0xffffffff;
}


/*
@func int32 | _setGpio | abstract GPIO registers 
@parm enum GPIO_FUNC | func | control/data/interrupt register
@parm enum GPIO_PORT | port | GPIO port
@parm uint32 | pin | pin number
@parm uint32 | data | value
@rvalue NONE
@comm
This function is for internal use only. You don't need to care what register address of GPIO is.
This function abstracts these information.
*/

static void _setGpio( enum GPIO_FUNC func, enum GPIO_PORT port, uint32 pin, uint32 data )
{
	//assert( port < GPIO_PORT_MAX );
	//assert( func < GPIO_FUNC_MAX );
	//assert( pin < 8 );

	GPIO_PRINT(4, "[%s():%d] func=%d port=%d pin=%d data=%d\n", __FUNCTION__, __LINE__, func, port, pin, data );
	switch( func )
	{
		
		case GPIO_FUNC_DIRECTION:
			GPIO_PRINT(5, "[%s():%d] regGpioDirectionWrite[port]=0x%08x  bitStartGpioDirectionWrite[port]=%d\n", __FUNCTION__, __LINE__, regGpioDirectionWrite[port], bitStartGpioDirectionWrite[port] );

			if ( data )
				REG32(regGpioDirectionWrite[port]) |= (uint32)1 << (pin+bitStartGpioDirectionWrite[port]);
			else
				REG32(regGpioDirectionWrite[port]) &= ~((uint32)1 << (pin+bitStartGpioDirectionWrite[port]));
			break;

		case GPIO_FUNC_DATA:
			GPIO_PRINT(5, "[%s():%d] regGpioDataWrite[port]=0x%08x  bitStartGpioDataWrite[port]=%d\n", __FUNCTION__, __LINE__, regGpioDataWrite[port], bitStartGpioDataWrite[port] );

			if (port == GPIO_PORT_D)
			{
				if ( data )
					REG32(regGpioDataWrite[port]) = (REG32(regGpioDataWrite[port])>>16) | ((uint32)1 << (pin+bitStartGpioDataWrite[port]));
				else
					REG32(regGpioDataWrite[port]) = (REG32(regGpioDataWrite[port])>>16) & (~((uint32)1 << (pin+bitStartGpioDataWrite[port])));
				break;
			}
			else
			{
				if ( data )
					REG32(regGpioDataWrite[port]) |= (uint32)1 << (pin+bitStartGpioDataWrite[port]);
				else
					REG32(regGpioDataWrite[port]) &= ~((uint32)1 << (pin+bitStartGpioDataWrite[port]));
				break;
			}

		case GPIO_FUNC_INTERRUPT_ENABLE:
			GPIO_PRINT(5, "[%s():%d] regGpioInterruptEnableWrite[port]=0x%08x  bitStartGpioInterruptEnableWrite[port]=%d\n", __FUNCTION__, __LINE__, regGpioInterruptEnableWrite[port], bitStartGpioInterruptEnableWrite[port] );

			if (data)
				REG32(regGpioInterruptEnableWrite[port]) |= (uint32)1 << (pin+bitStartGpioInterruptEnableWrite[port]);
			else
				REG32(regGpioInterruptEnableWrite[port]) &= ~((uint32)1 << (pin+bitStartGpioInterruptEnableWrite[port]));
			break;

		case GPIO_FUNC_INTERRUPT_STATUS:
			GPIO_PRINT(5, "[%s():%d] regGpioInterruptStatusWrite[port]=0x%08x  bitStartGpioInterruptStatusWrite[port]=%d\n", __FUNCTION__, __LINE__, regGpioInterruptStatusWrite[port], bitStartGpioInterruptStatusWrite[port] );

			if ( data )
				REG32(regGpioInterruptStatusWrite[port]) |= (uint32)1 << (pin+bitStartGpioInterruptStatusWrite[port]);
			else
				REG32(regGpioInterruptStatusWrite[port]) &= ~((uint32)1 << (pin+bitStartGpioInterruptStatusWrite[port]));
			break;

		case GPIO_FUNC_MAX:
			//assert( 0 );
			break;
	}
}


/*************************************************************************************/
/*
@func int32 | _rtl8186_initGpioPin | Initiate a specifed GPIO port.
@parm uint32 | gpioId | The GPIO port that will be configured
@parm enum GPIO_PERIPHERAL | dedicate | Dedicated peripheral type
@parm enum GPIO_DIRECTION | direction | Data direction, in or out
@parm enum GPIO_INTERRUPT_TYPE | interruptEnable | Interrupt mode
@rvalue SUCCESS | success.
@rvalue FAILED | failed. Parameter error.
@comm
This function is used to initialize GPIO port.
*/
int32 _rtl8186_initGpioPin( uint32 gpioId, enum GPIO_DIRECTION direction, 
                                           enum GPIO_INTERRUPT_TYPE interruptEnable )
 /* Note: In RTL8186, parm "dedicate" is not make sense. It can be any value because of nothing happen. */                                          
{
	uint32 port = GPIO_PORT( gpioId );
	uint32 pin = GPIO_PIN( gpioId );

	if ( port >= GPIO_PORT_MAX ) return FAILED;
	//if ( pin >= 8 ) return FAILED;	/* This judgment does not suit to RTL8186. GPIO PIN definition is not the same as RTL865x. */

		
	_setGpio( GPIO_FUNC_DIRECTION, port, pin, direction );

	_setGpio( GPIO_FUNC_INTERRUPT_ENABLE, port, pin, interruptEnable );
	

	return SUCCESS;
}


/*
@func int32 | _rtl8186_getGpioDataBit | Get the bit value of a specified GPIO ID.
@parm uint32 | gpioId | GPIO ID
@parm uint32* | data | Pointer to store return value
@rvalue SUCCESS | success.
@rvalue FAILED | failed. Parameter error.
@comm
*/
int32 _rtl8186_getGpioDataBit( uint32 gpioId, uint32* pData )
{
	uint32 port = GPIO_PORT( gpioId );
	uint32 pin = GPIO_PIN( gpioId );

	if ( port >= GPIO_PORT_MAX ) return FAILED;
	//if ( pin >= 8 ) return FAILED;
	if ( pData == NULL ) return FAILED;

	*pData = _getGpio( GPIO_FUNC_DATA, port, pin );
	GPIO_PRINT(3, "[%s():%d] (port=%d,pin=%d)=%d\n", __FUNCTION__, __LINE__, port, pin, *pData );

	return SUCCESS;
}


/*
@func int32 | _rtl8186_setGpioDataBit | Set the bit value of a specified GPIO ID.
@parm uint32 | gpioId | GPIO ID
@parm uint32 | data | Data to write
@rvalue SUCCESS | success.
@rvalue FAILED | failed. Parameter error.
@comm
*/
int32 _rtl8186_setGpioDataBit( uint32 gpioId, uint32 data )
{
	uint32 port = GPIO_PORT( gpioId );
	uint32 pin = GPIO_PIN( gpioId );

	if ( port >= GPIO_PORT_MAX ) return FAILED;
	//if ( pin >= 8 ) return FAILED;
#if 0
	if ( _getGpio( GPIO_FUNC_DIRECTION, port, pin ) == GPIO_DIR_IN ) return FAILED; /* read only */  
#endif

	GPIO_PRINT(3, "[%s():%d] (port=%d,pin=%d)=%d\n", __FUNCTION__, __LINE__, port, pin, data );

	_setGpio( GPIO_FUNC_DATA, port, pin, data );


	return SUCCESS;
}

#endif//CONFIG_RTK_VOIP_DRIVERS_PCM8186

