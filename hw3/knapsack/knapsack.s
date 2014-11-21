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
	movl  	%esp, %ebp

	movl  	cur_value(%ebp), %edx		
	movl  	%edx, best_value(%ebp)	
	subl 	$8, %esp	

# for(i = 0; i < num_items; i++)
	movl 	$0x0, i(%ebp) 	
	for_each_item:
		movl 	i(%ebp), %ecx
		cmpl  	num_items(%ebp), %ecx
		jae 	ret_best_value

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
			movl 	i(%ebp), %ecx

			movl 	cur_value(%ebp), %ebx		
			movl 	values(%ebp), %eax
			leal 	(%eax, %ecx, wordsize), %edi
			addl 	(%edi), %ebx
			push 	%ebx	
	
		# capacity - weights[i]
			movl 	capacity(%ebp),%ebx
			movl  	weights(%ebp), %eax
			leal 	(%eax, %ecx, wordsize), %esi
			subl 	(%esi), %ebx	
			push 	%ebx			
			
		# num_items - i - 1 
			movl 	num_items(%ebp), %ebx	
			subl 	%ecx, %ebx
			decl 	%ebx
			push 	%ebx
			
		# values + i + 1
			movl 	values(%ebp), %ebx
			movl 	%ecx, %edx
			incl 	%edx
			leal 	(%ebx, %edx, wordsize), %edi
			push 	%edi
			
		# weights + i + 1
			movl 	weights(%ebp), %ebx
			movl 	%ecx, %edx
			incl 	%edx
			leal 	(%ebx, %edx, wordsize), %esi
			push  	%esi
			
			call knapsack

			addl $20, %esp			

			movl %eax, %ebx
			push %ebx		
			
			movl best_value(%ebp), %ebx	
			push %ebx				
			
			call max

			addl $8, %esp			

			movl %eax, best_value(%ebp)

			for_end:
				incl  	i(%ebp)
				jmp  	for_each_item

	ret_best_value:
		movl  	best_value(%ebp), %eax			
		leave
		ret 	



max:
	push %ebp
	movl %esp, %ebp

	movl values(%ebp), %ebx			#move returned value from knapsack, into ebx forba
	movl weights(%ebp), %edx		#move best_value, into eax for a
	cmpl %ebx, %edx			#compare if a greater than b


	ja ret_a			#if a is greater than b, go to ret_a to return a
	movl %ebx, %eax			#else move b into eax and return
	leave
	ret 
ret_a:
	movl %edx, %eax			#move a into eax and return
	leave

	ret 

