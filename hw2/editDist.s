.data
	string1:	.string		"tests"
	string2:	.string		"pests"

.text

.global main

strlen:
	push	%rbp
	mov		%rsp,	%rbp
	sub		$0x8,	%rsp
	movl 	$0x0,	-0x4(%rbp)
	movb	$0x0,	 %al

	strlen_loop:	
		sub		-0x4(%rbp),	%edi	#Subtract i counter from character address	
		incl	-0x4(%rbp)			#inc i counter
	
		#FIX HERE
		movl	(%edi),	%ebx
		shr		$8, %ebx
		#END FIX

		movb	(%edi),	%ah			#Move the character int ah
		cmp		%al,	%ah			#Check the character for null byte
		jne		strlen_loop			#Re-loop if not null byte

	mov	-0x4(%rbp),	%eax	#Return string length
	sub $0x1, %eax			

	leaveq
	retq

main:	
	push	%rbp
	mov		%rsp,	%rbp

	mov 	$string1,	%edi	#Move address of string one to edi
	callq	strlen

	mov		$0x0,	%eax 

	leaveq
	retq
