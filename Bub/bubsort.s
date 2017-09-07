! BUBBLE SORT

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
		!(a, MEMORY,7,-)
		!(i, MEMORY,-,-)
		!(j, MEMORY,-,-)
		!(temp, MEMORY,-,-)
		!(-, DECLARATIONEND,-,-)
		!(MAIN, LABEL,-,-)
	.global main

	.align 4

main:
	save	%sp, -160, %sp


		!(-, BEGINEXECUTION,-,-)
		!(a, SUBSTORE,7,0)
	mov	0, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	7, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,6,1)
	mov	1, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	6, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,5,2)
	mov	2, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	5, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,4,3)
	mov	3, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	4, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,3,4)
	mov	4, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	3, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,2,5)
	mov	5, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	2, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,1,6)
	mov	6, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	1, %g1

	st	%g1, [%g2]

		!(i, SUBSTORE,0,-)
	st	%g0, [%fp-36]

		!(L$0, LABEL,-,-)

.LL0:

		!(B$0, IL,i,7)
	ld	[%fp-36], %l0

	cmp	%l0,7

		!(L$1, CJUMPF,B$0,-)
	bge	.LL1

	nop

		!(j, SUBSTORE,0,-)
	st	%g0, [%fp-40]

		!(L$2, LABEL,-,-)

.LL2:

		!(B$1, IL,j,6)
	ld	[%fp-40], %l0

	cmp	%l0,6

		!(L$3, CJUMPF,B$1,-)
	bge	.LL3

	nop

		! (I$2,IADD,j,1)
	mov	1, %o1

	ld	  [%fp-40], %o0

	add %o0, %o1, %l3

		!(I$3, SUBLOAD,a,I$2)
	mov	%l3, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%g1], %l3

		!(I$4, SUBLOAD,a,j)
	ld	[%fp-40], %l0

	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%fp-40], %l0

	ld	[%g1], %l0

		!(B$5, IL,I$3,I$4)
	cmp	%l3,%l0

		!(L$4, CJUMPF,B$5,-)
	bge	.LL4

	nop

		! (I$6,IADD,j,1)
	mov	1, %o1

	ld	  [%fp-40], %o0

	add %o0, %o1, %l6

		!(I$7, SUBLOAD,a,I$6)
	mov	%l6, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%g1], %l6

		!(temp, SUBSTORE,I$7,-)
	mov	%l6, %g1

	add	%fp, -44, %g2

	st	%g1, [%g2]

		! (I$8,IADD,j,1)
	mov	1, %o1

	ld	  [%fp-40], %o0

	add %o0, %o1, %l7

		!(I$9, SUBLOAD,a,j)
	ld	[%fp-40], %l0

	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%fp-40], %l0

	ld	[%g1], %l0

		!(a, SUBSTORE,I$9,I$8)
	mov	%l7, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	mov	%l0, %g1

	st	%g1, [%g2]

		!(a, SUBSTORE,temp,j)
	ld	[%fp-40], %l0

	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g1

	add	%g2, %g1, %g2

	ld	[%fp-44], %l0

	mov	%l0, %g1

	st	%g1, [%g2]

		!(L$4, LABEL,-,-)

.LL4:

		! (I$10,IADD,j,1)
	mov	1, %o1

	ld	  [%fp-40], %o0

	add %o0, %o1, %l0

		!(j, SUBSTORE,I$10,-)
	mov	%l0, %g1

	add	%fp, -40, %g2

	st	%g1, [%g2]

		!(L$2, JUMP,-,-)
	ba	.LL2
	nop

		!(L$3, LABEL,-,-)

.LL3:

		! (I$11,IADD,i,1)
	mov	1, %o1

	ld	  [%fp-36], %o0

	add %o0, %o1, %l0

		!(i, SUBSTORE,I$11,-)
	mov	%l0, %g1

	add	%fp, -36, %g2

	st	%g1, [%g2]

		!(L$0, JUMP,-,-)
	ba	.LL0
	nop

		!(L$1, LABEL,-,-)

.LL1:

		!(i, SUBSTORE,0,-)
	st	%g0, [%fp-36]

		!(L$5, LABEL,-,-)

.LL5:

		!(B$12, IL,i,7)
	ld	[%fp-36], %l0

	cmp	%l0,7

		!(L$6, CJUMPF,B$12,-)
	bge	.LL6

	nop

		!(I$13, SUBLOAD,a,i)
	ld	[%fp-36], %l0

	mov	%l0, %g1

	sll	%g1, 2, %g2

	add	%fp, -32, %g3

	add	%g2, %g3, %g1

	ld	[%g1], %o1

	ld	[%fp-36], %l0

	ld	[%g1], %l0

		!(temp, SUBSTORE,I$13,-)
	mov	%l0, %g1

	add	%fp, -44, %g2

	st	%g1, [%g2]

		! (PRINT,PROCEDURECALL,-,-)
	set num, %o0

		! (-,ACTUALPARAMETER,temp,-)
	ld	[%fp-44], %l3

	mov	%l3, %o1
	call printf

	nop

		! (I$14,IADD,i,1)
	mov	1, %o1

	ld	  [%fp-36], %o0

	add %o0, %o1, %l4

		!(i, SUBSTORE,I$14,-)
	mov	%l4, %g1

	add	%fp, -36, %g2

	st	%g1, [%g2]

		!(L$5, JUMP,-,-)
	ba	.LL5
	nop

		!(L$6, LABEL,-,-)

.LL6:

		!(-, PROGRAMEND,-,-)

	ret

	restore

