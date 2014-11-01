.data
	string1:	.string		"tests"
	string2:	.string		"pests"

.text

.global main

#min(int x, int y)
min:
	pushq 	%rbp
	mov 	%rsp, %rbp

	cmp 	%edi, %edx
	jl  	ret_x

	ret_y:
		mov 	%edi, %eax
		jmp 	min_ret

	ret_x:
		mov 	%edx, %eax
		jmp 	min_ret

	min_ret:
		leaveq
		retq

#int strlen(*str)
strlen:
	pushq 	%rbp
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
	pushq	%rbp
	mov 	%rsp, %rbp

#variable declarations
	mov		%edi, -0x8(%rbp)	# *string1
	mov		%edx, -0xc(%rbp)	# *string2
	movl	$0x0, -0x10(%rbp)	# int strlen1
	movl	$0x0, -0x14(%rbp)	# int strlen2
	movl	$0x1, -0x18(%rbp)	# int i
	movl	$0x1, -0x1c(%rbp)	# int n
	movl	$0x0, -0x20(%rbp)	# int x
	movl	$0x0, -0x24(%rbp)	# int y
	movl	$0x0, -0x28(%rbp)	# int z
	movl	$0x0, -0x2c(%rbp)	# *mat_addr

#get values of string  lengths
	callq	strlen
	mov 	%eax, -0x10(%rbp)
	mov		-0xc(%rbp), %edi
	callq 	strlen
	mov 	%eax, -0x14(%rbp)

#get mat_addr value	
	inc 	%eax
	mov 	-0x10(%rbp), %ebx
	inc 	%ebx
	mul 	%ebx	
	mov 	$0x4, %ebx
	mul 	%ebx
	mov 	%rbp, %rbx
	mov 	%eax, -0x40(%rbp)
	sub 	-0x40(%rbp), %rbx
	sub 	$0x2c, %rbx
	mov		%rbx, -0x2c(%rbp)

#for(int i = 0; i < strlen1.length + 1; i++)
	mov 	-0x18(%rbp), %ebx
	mov 	$0x0, %eax
	mov 	-0x10(%rbp), %ecx
	mul 	%ecx
	inc 	%ecx

	str1_for:
		
		mov 	%ebx, (%ebx, %eax, 1)

		inc 	%ebx
		cmp 	%ebx, %ecx
		jl  	str1_for
	
	mov 	$0x0, %ebx
	mov 	-0x14(%rbp), %ecx

	str2_for:
		mov 	%ebx, (%eax, %ebx, 1)

		inc 	%ebx
		cmp 	%ebx, %ecx
		jl  	str2_for


#for(int i = 1; i < strlen1; i++)
	ed_str1_for:

	#for(int n = 1; n < strlen2; n++)
		ed_str2_for:
			mov 	-0x2c(%rbp), %ebx

		# x = M[i-1][n] + 1
			mov 	-0x18(%rbp), %eax
			dec 	%eax
			mov 	-0x10(%rbp), %edx
			mul 	%edx
			add 	-0x1c(%rbp), %eax
			inc 	%eax
			mov 	(%ebx, %eax, 1), %ecx
			mov 	%ecx, -0x20(%rbp)

		# y = M[a][b-1] + 1
			mov 	-0x18(%rbp), %eax
			mov 	-0x10(%rbp), %edx
			mul 	%edx
			add 	-0x1c(%rbp), %eax
			dec 	%eax
			mov 	(%ebx, %eax, 1), %ecx
			mov 	%ecx, -0x24(%rbp)
	
		# z = M[a-1][b-1] + (A[a-1] == B[b-1] ? 0 : 2)
			mov 	-0x18(%rbp), %eax
			mov 	-0x10(%rbp), %edx
			mul 	%edx
			dec 	%eax
			add 	-0x1c(%rbp), %eax
			dec 	%eax
			mov 	(%ebx, %eax, 1), %ecx
			mov 	%ecx, -0x28(%rbp)

			mov 	-0x18(%rbp), %eax
			dec 	%eax
			mov 	-0x8(%rbp), %ebx
			mov 	(%ebx, %eax, 1), %ecx
			and 	$0x000000ff, %ecx 

			mov 	-0x1c(%rbp), %eax
			dec 	%eax
			mov 	-0xc(%rbp), %eax
			mov 	(%ebx, %eax, 1), %edx

			mov 	-0x28(%rbp), %edi
			cmp 	%ecx, %edx
			je  	min

			add 	$0x2, %edi
			mov 	-0x24(%rbp), %edx
			callq 	min

			mov 	%eax, %edi
			mov 	-0x20(%rbp), %edx
			callq 	min

			mov 	%eax, %edx

			mov 	-0x18(%rbp), %eax
			mov 	-0x14(%rbp), %ecx
			mul 	%ecx
			add 	-0x1c(%rbp), %eax
			mov 	%edx, (%ebx, %eax, 1) 

		#n--
			decl 	-0x1c(%rbp)
			mov 	-0x14(%rbp), %esi
			cmp 	-0x1c(%rbp), %esi 
			jl  	ed_str2_for
		
	#i--
		mov  	-0x10(%rbp), %edx
		decl 	-0x18(%rbp)
		mov 	-0x10(%rbp), %esi
		cmp 	-0x18(%rbp), %esi
		jl  	ed_str1_for

	ret_dist:
		mov 	-0x2c(%rbp), %ebx
		mov 	-0x10(%rbp), %eax
		
		mov 	-0x14(%rbp), %edx
		mul 	%edx
		
		add 	-0x14(%rbp), %eax
		mov 	(%ebx, %eax, 1), %ecx
		mov 	%ecx, %eax

		leaveq
		retq

#main()
main:	
	pushq	%rbp
	mov		%rsp,	%rbp

	mov 	$string1,	%edi	#Move address of string one to edi
	mov 	$string2, 	%edx
	callq	edit_dist

	mov		$0x0,	%eax 

	leaveq
	retq
