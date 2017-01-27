	.global __start

	.section .traps,"ax"
__start:
	b	__start_ram1

	.text
	.type	__start_ram1, %function
__start_ram1:
	# Read processor number, move slave processors to an infinite loop
	mrs	x7, mpidr_el1
	and	x7, x7, #3
	cbz	x7, __start_master
0:	wfe				//  Busy loop
	b	0b

__start_master:
	# Load stack pointer (on 32bit)
	adrp	x2,__cpu0_stack_end
	add	x2, x2, #:lo12:__cpu0_stack_end
	mov	sp,x2

	# Clear BSS
	ldr	w0,bss_segment + 0
	ldr	w1,bss_segment + 4
0:	cbz	x1,1f
	str	xzr,[x0],#8
	sub	x1,x1,#1
	cbnz	x1,0b
1:
	bl	main	/* Call the main routine */
0:	b	0b	/* Wait forever in case of exit.  */
	.size	__start_ram1, . - __start_ram1

bss_segment:
	.word	__bss_start
	.word	__bss_dwords
