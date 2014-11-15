.extern malloc
.text

	.equ word_size, 4

	.equ mat_a, -4
	.equ mat_a_rows, -8
	.equ mat_a_cols, -12
	.equ mat_b, -16
	.equ mat_b_rows, -20
	.equ mat_b_cols, -24
	.equ mat_a_size, -28
	.equ mat_b_size, -32
	.equ mat_c, -36
	.equ i, -40
	.equ k, -44
	.equ sum, -48

.global matMult

matMult:

# Variable definitions
	push 	%ebp
	mov 	%esp, %ebp

	mov 	%eax, mat_a(%ebp)
	mov 	%edx, mat_a_rows(%ebp)
	mov 	%ecx, mat_a_cols(%ebp)
	mov 	%ebx, mat_b(%ebp) 
	mov 	%esi, mat_b_rows(%ebp)
	mov 	%edi, mat_b_cols(%ebp) 
	
	mov 	mat_a_rows(%ebp), %eax
	mov 	mat_b_cols(%ebp), %edx
	mul 	%edx
	mov 	%eax, mat_a_size(%ebp)
	
	mov 	mat_b_rows(%ebp), %eax
	mov 	mat_b_cols(%ebp), %edx
	mul 	%edx
	mov 	%eax, mat_b_size(%ebp)

	mov 	$word_size, %eax
	mov 	mat_a_rows(%ebp), %edx
	mul 	%edx
	sub 	$0x20, %esp

 	push 	%eax
 	call 	malloc
 	mov 	%eax, mat_c(%ebp)

	movl 	$0x0, i(%ebp)
	movl 	$0x0, k(%ebp)
	movl 	$0x0, sum(%ebp) 	

	sub 	$0xc, %esp

# Mat_c memory allocation
 	mov 	mat_c(%ebp), %ebx 	

	init_mat_c:
		mov 	$word_size, %eax
		mov 	mat_b_cols(%ebp), %edx
		mul 	%edx
		
		push 	%eax
		call 	malloc	

		mov 	i(%ebp), %edx
		mov 	%eax, (%ebx, %edx, word_size)

		incl	i(%ebp)
		mov 	i(%ebp), %edx
		cmp 	mat_a_rows(%ebp), %edx
		jl 	init_mat_c

# Calculate matrix elements
	movl 	$0x0, i(%ebp)
	for_mat_a_rows:
		movl 	$0x0, k(%ebp)
		for_mat_b_cols:

			movl 	$0x0, sum(%ebp)
			movl 	$0x0, %ecx
			
			for_mat_c_ele:
				mov 	mat_a(%ebp), %ebx
				mov 	i(%ebp), %edi
				mov 	(%ebx,%edi, word_size), %ebx
				mov 	%ecx, %edi
				mov 	(%ebx, %edi, word_size), %eax

				mov 	mat_b(%ebp), %ebx
				mov 	%ecx, %edi
				mov 	(%ebx, %edi, word_size), %ebx
				mov 	k(%ebp), %edi
				mov 	(%ebx, %edi, word_size), %edx
				
				mul 	%edx
				add 	%eax, sum(%ebp)

				incl 	%ecx
				cmp 	mat_a_cols(%ebp), %ecx
				jl  	for_mat_c_ele

		# Assign the sum to mat_c element
			
			mov 	sum(%ebp), %edx
			mov 	mat_c(%ebp), %ebx
			mov 	i(%ebp), %edi
			mov 	(%ebx, %edi, word_size), %ebx
			mov 	k(%ebp), %edi
			mov 	%edx, (%ebx, %edi, word_size)

			incl 	k(%ebp)
			mov 	k(%ebp), %edx
			cmp 	mat_b_cols(%ebp), %edx
			jl  	for_mat_b_cols

		incl 	i(%ebp)
		mov 	i(%ebp), %edx
		cmp 	mat_a_rows(%ebp), %edx
		jl  	for_mat_a_rows

# Return mat_c address	
	mov 	mat_c(%ebp), %eax

	leave
	ret

