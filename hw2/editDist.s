.data
	string1:	.string		"testssss"
	string2:	.string		"pests"

.text

.global main

#min(int x, int y)
min:
	push 	%ebp
	mov 	%esp, %ebp

	cmp 	%edi, %edx
	jl  	ret_x

	ret_y:
		mov 	%edx, %eax
		jump 	min_ret

	ret_x:
		mov 	%edi, %eax
		jmp 	min_ret

	min_ret:
		leaveq
		retq

#int strlen(*str)
strlen:
	push 	%rbp
	mov 	%rsp, %rbp
	sub 	$0x8, %rsp		
	
	movl 	$0x0, -0x4(%rbp)	#Initialize i = 0
	movb 	$0x0, %al		#Set the nullbyte value

	strlen_loop:
		movl 	(%edi),	%ebx	#Get the next word

		strlen_sub_loop:
			
			cmp 	%bl,	%al			#Check the character for null byte
			je  	ret_len				#Re-loop if not null byte

			incl 	-0x4(%rbp)			#inc i counter
			shr 	$8, %ebx

			cmp 	$0x0, %ebx
			jne 	strlen_sub_loop

		add 	$0x4,	%edi	#Compute the word address 	
		jmp 	strlen_loop

	ret_len:
		mov	-0x4(%rbp),	%eax	#Return string length

		leaveq
		retq

#int edit_dist(*string1, *string2)
edit_dist:
<<<<<<< HEAD
	push	%ebp
	mov 	%esp, %ebp

#variable declarations
	mov		%edi, -0x8(%ebp)	# *string1
	mov		%edx, -0xc(%ebp)	# *string2
	mov		$0x0, -0x10(%ebp)	# int strlen1
	mov		$0x0, -0x14(%ebp)	# int strlen2
	mov		$0x1, -0x18(%ebp)	# int i
	mov		$0x1, -0x1c(%ebp)	# int n
	mov		$0x0, -0x20(%ebp)	# int x
	mov		$0x0, -0x24(%ebp)	# int y
	mov		$0x0, -0x28(%ebp)	# int z
	mov		$0x0, -0x2c(%ebp)	# *mat_addr

#get values of string  lengths
	callq	strlen
	mov 	%eax, -0x10(%ebp)
	mov		-0xc(%ebp), %edi
	callq 	strlen
	mov 	%eax, -0x14(%ebp)

#get mat_addr value	
	inc 	%eax
	mov 	-0x10(%ebp), %ebx
	inc 	%ebx
	mul 	%ebx	
	mov 	$0x4, %ebx
	mul 	%ebx
	mov 	%ebp, %ebx
	sub 	%eax, %ebx
	subl 	0x2c, %ebx
	mov		%ebx, -0x2c(%ebp)

#for(int i = 0; i < strlen1.length + 1; i++)
	mov 	-0x18(%ebp), %eax
	mov 	$0x0, %ebx
	mov 	-0x10(%ebp), %ecx
	inc 	%ecx

	str1_for:
		mov 	%ebx, (%eax, %ebx, %ecx)

		inc 	%ebx
		cmp 	%ebx, %ecx
		jlt 	str1_for
=======
	push	%rbp
	mov 	%rsp, %rbp
	sub		$0x24, %rsp

	mov 	$string1, %edi
	callq	strlen
	movl 	%eax, -0x16(%rbp)
>>>>>>> 36ccb6ac0cd0f1ea05ead60b843050eb80579f75
	
	mov 	$0x0, %ebx
	mov 	-0x14(%ebp), %ecx

	str2_for:
		mov 	%ebx, (%eax, %ebx, 1)

		inc 	%ebx
		cmp 	%ebx, %ecx
		jlt 	str2_for


#for(int i = 1; i < strlen1; i++)
	ed_str1_for:

	#for(int n = 1; n < strlen2; n++)
		ed_str2_for:
			mov 	-0x2c(%ebp), %ebx

		# x = M[i-1][n] + 1
			mov 	-0x18(%ebp), %eax
			dec 	%eax
			mul 	-0x10(%ebp)
			add 	-0x1c(%bp), %eax
			inc 	%eax
			mov 	(%ebx, %eax, 1), %ecx
			mov 	%ecx, -0x20(%ebp)

		# y = M[a][b-1] + 1
			mov 	-0x18(%ebp), %eax
			mul 	-0x14(%ebp)
			add 	-0x1c(%ebp), %eax
			dec 	%eax
			mov 	(%ebx, %eax, 1), %ecx
			mov 	%ecx, -0x24(%ebp)
	
<<<<<<< HEAD
		# z = M[a-1][b-1] + (A[a-1] == B[b-1] ? 0 : 2)
			mov 	-0x18(%ebp), %eax
			mul 	-0x14(%ebp)
			dec 	%eax
			add 	-0x1c(%ebp), %eax
			dec 	%eax
			mov 	(%ebx, %eax, 1), %ecx
			mov 	%ecx, -0x28(%ebp)

			mov 	-0x18(%ebp), %eax
			dec 	%eax
			mov 	-0x8(%ebp), %ebx
			mov 	(%ebx, %eax, 1), %ecx
			and 	$0x000000ff, %ecx 

			mov 	-0x1c(%ebp), %eax
			dec 	%eax
			mov 	-0xc($ebp), %eax
			mov 	(%ebx, %eax, 1), %edx

			mov 	-0x28(%ebp), %edi
			cmp 	%ecx, %edx
			je  	min

			add 	$0x2, %edi
			mov 	-0x24(%ebp), %edx
			callq 	min

			mov 	%eax, %edi
			mov 	-0x20(%ebp), %edx
			callq 	min

			mov 	%eax, %edx

			mov 	-0x18(%ebp), %eax
			mul 	-0x14(%ebp)
			add 	-0x1c(%ebp), %eax
			mov 	%edx, (%ebx, %eax, 1) 

		#n--
			dec -0x1c(%rbp)
			cmp	-0x1c(%rbp), strlen2
			jl	ed_str2_for
		
	#i--
		dec	-0x18(%rbp)
		cmp	-0x18(%ebp), strlen1
		jl	ed_str1_for
=======
	#else	mov strlen_2 to ebx
	mov 	-0x16(%rbp), %ebx

	ed_for:
		

		dec	%ebx
		dec %ecx

		cmp $0x0, %ecx
		jne	ed_for

		
		mov	$0x4, %ecx

		cmp	0x0, %ebx
		jne ed_for
>>>>>>> 36ccb6ac0cd0f1ea05ead60b843050eb80579f75

	ret_dist:
		mov 	-0x2c(%ebp), %ebx
		mov 	-0x10(%ebp), %eax
		mul 	-0x14(%ebp)
		add 	-0x14(%ebp), %eax
		mov 	(%ebx, %eax, 1), %ecx
		mov 	%ecx, %eax

		leaveq
		retq

#main()
main:	
	push	%rbp
	mov		%rsp,	%rbp

	mov 	$string1,	%edi	#Move address of string one to edi
	callq	edit_dist

	mov		$0x0,	%eax 

	leaveq
	retq
