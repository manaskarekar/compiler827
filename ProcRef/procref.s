! PROCEDURE REFERENCE

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
		!(-, DECLARATIONEND,-,-)
		!(MAIN, LABEL,-,-)
	.global main

	.align 4

main:
	save	%sp, -120, %sp


		!(-, BEGINEXECUTION,-,-)
		!(i, SUBSTORE,2,-)
	mov	2, %g1

	st	%g1, [%fp-8]

		! (PRINT,PROCEDURECALL,-,-)
	set num, %o0

		! (-,ACTUALPARAMETER,i,-)
	ld	[%fp-8], %l0

	mov	%l0, %o1
	call printf

	nop

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

		!(i, MEMORY,-,-)
		!(-, DECLARATIONEND,-,-)
		!(i, SUBSTORE,198,-)
	mov	198, %g1

	st	%g1, [%fp-12]

		! (PRINT,PROCEDURECALL,-,-)
	set num, %o0

		! (-,ACTUALPARAMETER,i,-)
	ld	[%fp-12], %l0

	mov	%l0, %o1
	call printf

	nop

	nop
	ret 
	restore 
	.size	try, .-try

