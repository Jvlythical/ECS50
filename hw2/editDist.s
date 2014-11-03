.data
	string1:	.string		"donuts"
	string2:	.string		"picture"

.text

.global main

#min(int x, int y)
min:
	push 	%ebp
	mov 	%esp, %ebp

	cmp 	%edi, %edx
	jl  	ret_x

	ret_y:
		mov 	%edi, %eax
		jmp 	min_ret

	ret_x:
		mov 	%edx, %eax
		jmp 	min_ret

	min_ret:
		leave
		ret

#int strlen(*str)
strlen:
	push 	%ebp
	mov 	%esp, %ebp
	
	movl 	$0x0, -0x4(%ebp)	#Initialize i = 0
	movb 	$0x0, %al		#Set the nullbyte value

	strlen_loop:
		movl 	(%edi),	%ebx	#Get the next word

		strlen_sub_loop:
			
			cmp 	%bl,	%al			#Check the character for null byte
			je  	ret_len				#Re-loop if not null byte

			incl 	-0x4(%ebp)			#inc i counter
			shr 	$8, %ebx

			cmp 	$0x0, %ebx
			jne 	strlen_sub_loop

		add 	$0x4,	%edi	#Compute the word address 	
		jmp 	strlen_loop

	ret_len:
		mov	-0x4(%ebp),	%eax	#Return string length

		leave
		ret

#int edit_dist(*string1, *string2)
edit_dist:
	push	%ebp
	mov 	%esp, %ebp

#variable declarations
	mov		%edi, -0x8(%ebp)	# *string1
	mov		%edx, -0xc(%ebp)	# *string2
	movl	$0x0, -0x10(%ebp)	# int strlen1
	movl	$0x0, -0x14(%ebp)	# int strlen2
	movl	$0x1, -0x18(%ebp)	# int i
	movl	$0x1, -0x1c(%ebp)	# int n
	movl	$0x0, -0x20(%ebp)	# int x
	movl	$0x0, -0x24(%ebp)	# int y
	movl	$0x0, -0x28(%ebp)	# int z
	movl	$0x0, -0x2c(%ebp)	# *mat_addr
	sub 	$0x2c, %esp

#get values of string  lengths
	call	strlen
	mov 	%eax, -0x10(%ebp)
	mov		-0xc(%ebp), %edi
	call 	strlen
	mov 	%eax, -0x14(%ebp)

#allocate space for mat	and save its address
	inc 	%eax
	mov 	-0x10(%ebp), %edx
	inc 	%edx
	mul 	%edx	
	mov 	$0x4, %ebx
	mul 	%ebx

	sub 	%eax, %esp
	mov 	%esp, -0x2c(%ebp)

#for(int i = 0; i < strlen1.length + 1; i++)
	mov 	-0x2c(%ebp), %ebx 	# %ebx = &mat
	mov 	$0x0, %ecx 	# %ecx = i = 0
	mov 	-0x14(%ebp), %edi 	# %edi = strlen2
	inc 	%edi

	str1_for:
		mov 	%edi, %eax 	# %eax = i * strlen2
		mul 	%ecx
		mov 	%ecx, (%ebx, %eax, 4)
		
		inc 	%ecx
		cmp 	-0x10(%ebp), %ecx
		jle  	str1_for
	
	mov 	$0x0, %ecx
	mov 	-0x14(%ebp), %edi 	# %edx = strlen2

	str2_for:
		mov 	%ecx, (%ebx, %ecx, 4)
		
		inc 	%ecx
		cmp 	%edi, %ecx
		jle  	str2_for


#for(int i = 1; i < strlen1; i++)
	ed_str1_for:
	
	movl 	$0x1, -0x1c(%ebp) 

	#for(int n = 1; n < strlen2; n++)
		ed_str2_for:
			mov 	-0x2c(%ebp), %ebx

		# x = M[i-1][n] + 1
			mov 	-0x18(%ebp), %eax
			dec 	%eax
			mov 	-0x14(%ebp), %edx	# %edx = strlen2 + 1
			inc 	%edx
			mul 	%edx
			add 	-0x1c(%ebp), %eax
			mov 	(%ebx, %eax, 4), %edx

			inc 	%edx
			mov 	%edx, -0x20(%ebp)

		# y = M[a][b-1] + 1
			mov 	-0x18(%ebp), %eax
			mov 	-0x14(%ebp), %edx	# %edx = strlen2 + 1
			inc 	%edx
			mul 	%edx
			add 	-0x1c(%ebp), %eax
			dec 	%eax
			mov 	(%ebx, %eax, 4), %edx

			inc 	%edx
			mov 	%edx, -0x24(%ebp)

		# z = M[a-1][b-1] + (A[a-1] == B[b-1] ? 0 : 2)
			mov 	-0x18(%ebp), %eax
			dec 	%eax
			mov 	-0x14(%ebp), %edx	# %edx = strlen2 + 1
			inc 	%edx
			mul 	%edx
			add 	-0x1c(%ebp), %eax
			dec 	%eax
			mov 	(%ebx, %eax, 4), %edx
			mov 	%edx, -0x28(%ebp)

		#Compare characters
			mov 	-0x18(%ebp), %esi
			dec 	%esi
			mov 	-0x8(%ebp), %ebx
			mov 	(%ebx, %esi, 1), %eax
			and 	$0x000000ff, %eax 

			mov 	-0x1c(%ebp), %esi
			dec 	%esi
			mov 	-0xc(%ebp), %ebx
			mov 	(%ebx, %esi, 1), %ecx
			and 	$0x000000ff, %ecx

		# Find the min of x, y, z
			mov 	-0x28(%ebp), %edi
			mov 	-0x24(%ebp), %edx
			cmp 	%eax, %ecx
			je  	find_min
			add 	$0x1, %edi

			find_min:
				mov 	%edi, -0x28(%ebp)
				call 	min
				mov 	%eax, %edi
				mov 	-0x20(%ebp), %edx
				call 	min

				mov 	%eax, %edi

			# M[A.size()][B.size()] = min(x,y,z) 
				mov 	-0x2c(%ebp), %ebx
				mov 	-0x18(%ebp), %eax
				mov 	-0x14(%ebp), %ecx
				inc 	%ecx
				mul 	%ecx
				add 	-0x1c(%ebp), %eax
				mov 	%edi, (%ebx, %eax, 4) 

		#n++
			incl 	-0x1c(%ebp)
			mov 	-0x14(%ebp), %esi
			cmp 	%esi, -0x1c(%ebp)
			jle  	ed_str2_for
		
	#i++
		mov  	-0x10(%ebp), %edx
		incl 	-0x18(%ebp)
		mov 	-0x10(%ebp), %esi
		cmp 	%esi, -0x18(%ebp)
		jle  	ed_str1_for

	ret_dist:
		mov 	-0x2c(%ebp), %ebx
		mov 	-0x10(%ebp), %eax
		
		mov 	-0x14(%ebp), %edx
		inc 	%edx
		mul 	%edx
		
		add 	-0x14(%ebp), %eax
		mov 	(%ebx, %eax, 4), %ecx
		mov 	%ecx, %eax

		leave
		ret

#main()
main:	
	push	%ebp
	mov		%esp,	%ebp

	mov 	$string1,	%edi	#Move address of string one to edi
	mov 	$string2, 	%edx
	call	edit_dist

	mov		$0x0,	%eax 

	leave
	ret
