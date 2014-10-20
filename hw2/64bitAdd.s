.data
	num1: 		.double 	1.1
	num2: 		.double 	1.2
	sum:			.double 	0.0

.text

.global main

main:
	push	%rbp
	mov		%rsp, %rbp
	sub		$0x8,	%rsp

	movsd num1, 		%xmm0	#Move num1 to ebx
	addsd	num2,			%xmm0 #Add num 2 to rax
	movsd %xmm0,		sum		#Save contents to sum
	
	movl 	sum, 			%eax	#Move lower 32 bits to eax
	movl	sum + 4,	%edx	#Move upper 32 bits to edx

	mov		$0x0, %eax
	leaveq
	retq
