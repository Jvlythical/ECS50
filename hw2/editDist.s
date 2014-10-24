.data
	string1:	.string		"tests"
	string2:	.string		"pests"

.text

.global main

strlen:
	push	%rbp
	mov		%rsp,	%rbp
	sub		$0x8,	%rsp		
	
	movl 	$0x0,	-0x4(%rbp)	#Initialize i = 0
	movb	$0x0,	 %al		#Set the nullbyte value

	strlen_loop:
		movl	(%edi),	%ebx	#Get the next word

		strlen_sub_loop:
			
			cmp		%bl,	%al			#Check the character for null byte
			je		ret_len				#Re-loop if not null byte

			incl	-0x4(%rbp)			#inc i counter
			shr		$8, 	%ebx

			cmp		$0x0, %ebx
			jne		strlen_sub_loop

		add		$0x4,	%edi	#Compute the word address 	
		jmp		strlen_loop

	ret_len:
		mov	-0x4(%rbp),	%eax	#Return string length

		leaveq
		retq

edit_dist:
	push	%rbp
	mov 	%rsp, $rbp
	sub		$0x24, %rsp

	mov 	$string1, %edi
	callq	strlen
	mov 	%eax, -0x16(%rbp)
	
	mov		$string2, %edi
	callq	strlen
	mov		%eax, -0x24(%rbp)
	mov		%eax, %ebx

	#if strlen_2 < strlen_1 jump to loop
	cmp		%ebx, -0x16(%rbp)
	jl		ed_for
	
	#else	mov strlen_2 to ebx
	mov 	-0x16(%rbp), %ebx

	ed_for:
		

		dec	%ebx
		dec %ecx

		cmp %ecx, $0x0
		jne	ed_for

		
		mov	$0x4, %ecx

		cmp	%ebx, $0x0
		jne ed_for

	ret_dist:
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
