.global knapsack

.equ weights, 8
.equ wordsize, 4
.equ values, 12
.equ num_items, 16
.equ capacity,  20
.equ cur_value, 24
.equ i, -4
.equ best_value, -8

.text

knapsack:
	push 	%ebp	
	mov  	%esp, %ebp

	movl  	cur_value(%ebp), %edx		
	movl  	%edx, best_value(%ebp)	
	subl 	$8, %esp	

# for(i = 0; i < num_items; i++)
	movl 	$0x0, i(%ebp) 	
	for_each_item:
		mov 	i(%ebp), %ecx
		cmp  	num_items(%ebp), %ecx
		jge 	ret_best_value

#if (capacity - weights[i] >= 0 )
		if_capacity:
			movl  	capacity(%ebp), %ebx	
			movl  	weights(%ebp), %esi		
			movl  	i(%ebp), %ecx			
			leal  	(%esi, %ecx, wordsize), %esi	
			subl  	(%esi), %ebx			

			cmpl  	$0, %ebx			
			jge  	find_best_value	
			jmp  	for_end		
	
		find_best_value:

		# cur_values + values[i]
			mov 	i(%ebp), %ecx

			mov 	cur_value(%ebp), %eax		
			mov 	values(%ebp), %ebx
			lea 	(%ebx, %ecx, wordsize), %edi
			addl 	(%edi), %eax
			push 	%eax	
	
		# capacity - weights[i]
			mov 	capacity(%ebp),%eax
			mov  	weights(%ebp), %ebx
			lea 	(%ebx, %ecx, wordsize), %esi
			subl 	(%esi), %eax		
			push 	%eax			
			
		# num_items - i - 1
			mov 	num_items(%ebp), %eax	
			sub 	%ecx, %eax
			dec 	%eax
			push 	%eax
			
		# values + i + 1
			mov 	values(%ebp), %ebx
			mov 	%ecx, %edx
			inc 	%edx
			lea 	(%ebx, %edx, wordsize), %edi
			push 	%edi
			
		# weights + i + 1
			mov 	weights(%ebp), %ebx
			mov 	%ecx, %edx
			inc 	%edx
			lea 	(%ebx, %edx, wordsize), %esi
			push  	%esi
			
			call knapsack

			push %eax		
			
			movl best_value(%ebp), %eax	
			push %eax				
			
			call max
			movl %eax, best_value(%ebp)

			for_end:
				incl  	i(%ebp)
				jmp  	for_each_item

	ret_best_value:
		movl  	best_value(%ebp), %eax			
		leave
		ret 	$20



max:
	push %ebp
	movl %esp, %ebp

	movl values(%ebp), %ebx			#move returned value from knapsack, into ebx forba
	movl weights(%ebp), %edx		#move best_value, into eax for a
	cmpl %ebx, %edx			#compare if a greater than b


	ja ret_a			#if a is greater than b, go to ret_a to return a
	movl %ebx, %eax			#else move b into eax and return
	leave
	ret $8
ret_a:
	movl %edx, %eax			#move a into eax and return
	leave

	ret $8

