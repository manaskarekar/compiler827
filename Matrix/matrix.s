! Matrix Addition

	.file "fourTuple" 
	.global .umul
	.section ".rodata"
	num:	.asciz "%d\n"

	.align 8
.LLC0:
	.asciz "%d "
	.align 8
.LLC1:
	.asciz "%d"
	.section ".text"

		!(-, PROGRAMBEGIN,-,-)
		!(a, MEMORY,2,2)
		!(i, MEMORY,-,-)
		!(j, MEMORY,-,-)
		!(temp, MEMORY,-,-)
		!(-, DECLARATIONEND,-,-)
		!(MAIN, LABEL,-,-)
	.global main

	.align 4

main:
	save	%sp, -144, %sp


		!(-, BEGINEXECUTION,-,-)
		! (I$0,IMULT,0,2)
	mov	2, %o1

	mov	0, %o0

	call	.umul, 0

	nop

	mov	%o0, %l1

		! (I$1,IADD,I$0,0)
	mov	0, %o1

	mov   %l1, %o0

	add %o0, %o1, %l2

		!(a, SUBSTORE,1,I$0)
	mov	%l1, %g1

	sll	%g1, 2, %g2

	add	%fp, -20, %g1

	add	%g2, %g1, %g2

	mov	1, %g1

	st	%g1, [%g2]

		! (I$2,IMULT,0,2)
	mov	2, %o1

	mov	0, %o0

	call	.umul, 0

	nop

	mov	%o0, %l4

		! (I$3,IADD,I$2,1)
	mov	1, %o1

	mov   %l4, %o0

	add %o0, %o1, %l5

		!(a, SUBSTORE,2,I$2)
	mov	%l4, %g1

	sll	%g1, 2, %g2

	add	%fp, -20, %g1

	add	%g2, %g1, %g2

	mov	2, %g1

	st	%g1, [%g2]

		! (I$4,IMULT,0,2)
	mov	2, %o1

	mov	0, %o0

	call	.umul, 0

	nop

	mov	%o0, %l7

		! (I$5,IADD,I$4,0)
	mov	0, %o1

	mov   %l7, %o0

	add %o0, %o1, %l0

		!(I$6, SUBLOAD,a,I$5)
	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -20, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%g1], %l0

		!(temp, SUBSTORE,I$6,-)
	mov	%l0, %g1

	add	%fp, -32, %g2

	st	%g1, [%g2]

		! (I$7,IMULT,0,2)
	mov	2, %o1

	mov	0, %o0

	call	.umul, 0

	nop

	mov	%o0, %l0

		! (I$8,IADD,I$7,1)
	mov	1, %o1

	mov   %l0, %o0

	add %o0, %o1, %l0

		!(I$9, SUBLOAD,a,I$8)
	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -20, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%g1], %l0

		!(j, SUBSTORE,I$9,-)
	mov	%l0, %g1

	add	%fp, -28, %g2

	st	%g1, [%g2]

		! (I$10,IADD,j,temp)
	ld	  [%fp-32], %o1

	ld	  [%fp-28], %o0

	add %o0, %o1, %l0

		! (I$11,IMULT,1,2)
	mov	2, %o1

	mov	1, %o0

	call	.umul, 0

	nop

	mov	%o0, %l0

		! (I$12,IADD,I$11,1)
	mov	1, %o1

	mov   %l0, %o0

	add %o0, %o1, %l0

		!(a, SUBSTORE,I$10,I$11)
	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -20, %g1

	add	%g2, %g1, %g2

	mov	%l0, %g1

	st	%g1, [%g2]

		! (I$13,IMULT,1,2)
	mov	2, %o1

	mov	1, %o0

	call	.umul, 0

	nop

	mov	%o0, %l0

		! (I$14,IADD,I$13,1)
	mov	1, %o1

	mov   %l0, %o0

	add %o0, %o1, %l0

		!(I$15, SUBLOAD,a,I$14)
	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -20, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%g1], %l0

		!(i, SUBSTORE,I$15,-)
	mov	%l0, %g1

	add	%fp, -24, %g2

	st	%g1, [%g2]

		! (PRINT,PROCEDURECALL,-,-)
	set num, %o0

		! (-,ACTUALPARAMETER,i,-)
	ld	[%fp-24], %l0

	mov	%l0, %o1
	call printf

	nop

		!(-, PROGRAMEND,-,-)

	ret

	restore

