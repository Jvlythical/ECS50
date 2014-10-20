.data
	string1:	.string		"test"
	string2:	.string		"pest"

.text

.global main

strlen:
	push	%rbp
	mov		%rsp,	%rbp
	sub		$0x8,	%rsp
	movl 	$0x0,	-0x4(%rbp)
	movb	$0x0,	 %al

	strlen_loop:	
		sub		-0x4(%rbp),	%edi		
		incl	-0x4(%rbp)
		
		movb	(%edi),	%ah
		cmp		%al,	%ah
		jne		strlen_loop

	mov	-0x4(%rbp),	%eax	#Return string length

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
