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

.global main

matmult:

# Variable definitions
	push 	%ebp
	mov 	%esp, %ebp

	mov 	%ecx, mat_a_cols(%ebp)
	mov 	%edx, mat_b(%ebp) 
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

	mov 	word_size, %eax
	mov 	mat_a_rows(%ebp), %edx
	mul 	%edx
 	mov 	%eax, %edi
 	call 	malloc
 	mov 	%eax, mat_c(%ebp)

	sub 	$0x2c, %esp

# Mat_c memory allocation
	mov 	$0x0, %ecx
 	mov 	mat_c(%ebp), %ebx 	

	init_mat_c:
		mov 	word_size, %eax
		mov 	mat_b_cols(%ebp), %edx
		mul 	%edx
		mov 	%eax, %edi
		call 	malloc	

		lea 	(%ebx, %ecx, word_size), %esi
		mov 	%eax, (%esi)

		inc %ecx
		cmp %ecx, mat_a_rows(%ebp)
		jl 	init_mat_c




	
	mov 	mat_c(%ebp), %eax

	leave
	ret

main:
	push 	%ebp
	mov 	%esp, %ebp
	
	mov 	$0x2, %edi
	mov 	$0x2, %esi
	mov 	$0x2, %ecx
	mov 	

	call matmult

	leave
	ret
