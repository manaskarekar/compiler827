! PROCEDURE VALUES
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
		!(i, MEMORY,-,-)
		!(j, MEMORY,-,-)
		!(-, DECLARATIONEND,-,-)
		!(MAIN, LABEL,-,-)
	.global main

	.align 4

main:
	save	%sp, -128, %sp


		!(-, BEGINEXECUTION,-,-)
		!(i, SUBSTORE,2,-)
	mov	2, %g1

	st	%g1, [%fp-8]

		! (try,PROCEDURECALL,-,-)
	ld	  [%fp-8], %o0

call try,0

	nop

		! (PRINT,PROCEDURECALL,-,-)
	set num, %o0

		! (-,ACTUALPARAMETER,i,-)
	ld	[%fp-8], %l0

	mov	%l0, %o1
	call printf

	nop

		!(-, PROGRAMEND,-,-)

	ret

	restore

	.align 4 
	.global try
	.type try, #function
try:
		! (k,FPARAMETER,-,-)
	save	%sp, -120 , %sp


	st	%i0, [%fp-4]

		! (I$0,IADD,k,1)
	mov	1, %o1

	ld	  [%fp--112], %o0

	add %o0, %o1, %l1

		!(k, SUBSTORE,I$0,-)
	mov	%l1, %g1

	add	%fp, 112, %g2

	st	%g1, [%g2]

		! (PRINT,PROCEDURECALL,-,-)
	set num, %o0

		! (-,ACTUALPARAMETER,k,-)
	ld	[%fp+112], %l2

	mov	%l2, %o1
	call printf

	nop

	nop
	ret 
	restore 
	.size	try, .-try

