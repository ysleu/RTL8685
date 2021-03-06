/* When we enter this piece of code, the program stack looks like this:
        argc            argument counter (integer)
        argv[0]         program name (pointer)
        argv[1...N]     program args (pointers)
        argv[argc-1]    end of args (integer)
	NULL
        env[0...N]      environment variables (pointers)
        NULL
*/

#include <features.h>
#include <sys/regdef.h>

.text
.global __start
.type __start,@function

__start:              
#ifdef __PIC__
        .set noreorder
        bltzal zero,0f
        nop
0:      .cpload $31
        .set reorder
#endif

	move $31, zero
	lw   a0, 0($29)	    /* argc */
	addu a1, $29, 4	    /* argv  */
	addu a2, a0, 1	    /* load envp */
        sll  a2, a2, 2
	add  a2, a2, a1
	/* Ok, now run uClibc's main() -- shouldn't return */
#if  1 
	lui	t0, 0xffff
	or      t0, 0xfff8
	and	$29, $29, t0
#endif	
	jal	__uClibc_main
	hlt:    b hlt                   /* Crash if somehow it does return.  */

/* Stick in a dummy reference to main(), so that if an application
 * is linking when the main() function is in a static library (.a)
 * we can be sure that main() actually gets linked in */
L_dummy_main_reference:
	.long	main

