.global knapsack
.equ wordsize, 4

.text

max:
	

knapsack:
	#ebp+8 : weight	(ptr)
	#ebp+12 : value (ptr)
	#ebp+16 : num_items
	#ebp+20 : capacity
	#ebp+24 : cur_value
	# %ECX will be i 
	# %EAX , EBX, EDX will be for temporary storage
	# %ESI will be weights 
	# %EDI will be values
	push %ebp				#prologue
	mov %esp, %ebp
#declare variables
	subl $8, %esp				#make room for i and best_value, i=-4(%ebp), best_value=-8(%bp)
	movl 24(%ebp), %eax			#move cur_value into a register
	movl %eax, -8(%ebp)			#move cur_value into best_value
	xorl %ecx, %ecx				#set i to 0
#for(i = 0; i < num_items; i++)
for_each_item:
	cmpl 16(%ebp), %ecx			#check if i < num_items
	jb if					#if i is less, go to the if statement
	jmp ret_best_value			#else jump to return line
#if (capacity - weights[i] >= 0 )
if:
	movl 20(%ebp), %ebx			#move capacity to EBX
	movl 8(%ebp), %esi			#move *weight into esi
	movl (%esi, %ecx, wordsize), %esi	#move weight[i] into esi
	movl (%edi, %ecx, wordsize), %edi	#move values[i] into edi
	subl %esi, %ebx				#subtract weights[i] from capacity
	cmpl $0, %ebx				#compare result and 0
	jge find_best_value			#jump to next line if result >=0
	incl %ecx				#else i++ and jump to for loop
	jmp for_each_item			#jump to for loop
# best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]));
find_best_value:
	call max
	movl %eax, -8(%ebp)			#store w/e returned from max into best_value
	incl %ecx				#i++
	jmp for_each_item			#jump to for loop

#return best_value
ret_best_value:
	movl -8(%ebp), %eax			#store best_value into eax and then return	
	ret

#return a > b ? a : b;
#ebx will be b
#edx will be a
max:
	movl 24(%ebp), %eax		#move cur_value into eax
	addl %edi, %eax			#addl cur_value and values[i], store in eax
	push %eax			#push new cur_value onto stack
	movl 20(%ebp), %eax		#move capacity into eax
	subl %esi, %eax			#subtract weights[i] from capacity
	push %eax			#push new capcity onto stack
	movl 16(%ebp), %eax		#move num_items into eax
	subl %ecx, %eax			#subtract i from num_items
	subl $1, %eax			#subtract 1 from num_items
	push %eax			#push new num_items onto stack
	movl (%edi, wordsize), %edi	#move values + 1 into *values
	movl (%edi, %ecx, wordsize)	#move values+1+i into *values
	push %edi			#push new *values onto the stack
	movl (%esi, wordsize), %esi	#move weights + 1 into *weights
	movl (%esi, %ecx, wordsize)	#move weights + 1 + 1 into *weights
	push %esi			#push new *weights onto stack
	call knapsack			#call knapsack after pushing new arguments onto stack, then we can find b
	movl %eax, %ebx			#move best value returned in eax, into ebx for b
	movl -8(ebp), %edx		#move best_value, into edx for a
	cmpl %ebx, %edx			#compare if a greater than b
	ja ret_a			#if a is greater than b, go to ret_a to return a
	movl %ebx, %eax			#else move b into eax and return
	ret
ret_a:
	movl %edx, %eax			#move a into eax and return
	ret
	
