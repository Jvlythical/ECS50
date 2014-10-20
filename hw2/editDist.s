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

main:	
	push	%rbp
	mov		%rsp,	%rbp

	mov 	$string1,	%edi	#Move address of string one to edi
	callq	strlen

	mov		$0x0,	%eax 

	leaveq
	retq
