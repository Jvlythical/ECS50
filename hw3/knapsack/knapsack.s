.global knapsack
.equ wordsize, 4

.text

	

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
	subl $12, %esp				#make room for i and best_value, i=-4(%ebp), best_value=-8(%bp), -12(%ebp) = b
	movl 24(%ebp), %edx			#move cur_value into a register
	movl %edx, -8(%ebp)			#move cur_value into best_value
	xorl %ecx, %ecx				#set i to 0
	movl %ecx, -4(%ebp)		#store ecx in i
#for(i = 0; i < num_items; i++)
for_each_item:
	movl -4(%ebp), %ecx
	cmpl 16(%ebp), %ecx			#check if i < num_items
	jb if					#if i is less, go to the if statement
	jmp ret_best_value			#else jump to return line
#if (capacity - weights[i] >= 0 )
if:
	movl 20(%ebp), %ebx			#move capacity to EBX
	movl 8(%ebp), %esi			#move *weight into esi
	movl 12(%ebp), %edi			#move *value into edi
	movl -4(%ebp), %ecx			#retrive i and put into ecx
	leal (%esi, %ecx, wordsize), %esi	#move weight[i] into esi
	leal (%edi, %ecx, wordsize), %edi	#move values[i] into edi
	subl (%esi), %ebx				#subtract weights[i] from capacity
	cmpl $0, %ebx				#compare result and 0
	jge find_best_value			#jump to next line if result >=0
	incl %ecx				#else i++ and jump to for loop
	movl %ecx, -4(%ebp) 		#move ecx into i
	jmp for_each_item			#jump to for loop
# best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]));
find_best_value:
	#call max
	#movl %eax, -8(%ebp)			#store w/e returned from max into best_value
	#incl %ecx				#i++
	#movl %ecx, -4(%ebp)		#store ecx in i
	#jmp for_each_item			#jump to for loop
	movl 24(%ebp), %eax			#move cur_value into eax
	addl (%edi), %eax				#addl cur_value and values[i], store in eax
	push %eax								#push new cur value onto stack
	movl 20(%ebp),%eax			#move capacity into eax
	subl (%esi), %eax				#subtract seights[i] from capacity
	push %eax								#push new capacity onto stack
	movl 16(%ebp), %eax			#move num_items into eax
	movl -4(%ebp), %ecx	
	subl %ecx, %eax					#subtract i from num_items
	subl $1, %eax						#subtract 1 from num_items
	push %eax								#push new num_items onto stack
	movl $1, %ebx
	movl -4(%ebp), %ecx			#get i adn put into ecx
	leal (%edi,%ebx,wordsize), %edi			#move calues+1+i into *values
	leal (%edi, %ecx, wordsize), %edi
	push %edi
	leal (%esi, %ebx, wordsize), %esi		#same for *weights
	leal (%esi, %ecx, wordsize), %esi
	push %esi
	call knapsack
	movl %eax, -12(%ebp)					#store returned value from knapsack, into stack, or b

	push %eax										##testing, push b onto stack
	movl -8(%ebp), %eax					##move a, or best_value, into eax,then push
	push %eax										#push a onto stack for max

	call max
	movl %eax, -8(%ebp)						#move return value from max, into best_value
	incl %ecx		
	movl %ecx, -4(%ebp)					
	jmp for_each_item							#after storing result in best_value, increment i and repeat loop

#return best_value
ret_best_value:
	movl -8(%ebp), %eax			#store best_value into eax and then return	
	leave
	ret

#return a > b ? a : b;
#ebx will be b
#edx will be a
max:
	push %ebp
	movl %esp, %ebp

	movl 12(%ebp), %ebx			#move returned value from knapsack, into ebx forba
	movl 8(%ebp), %edx		#move best_value, into eax for a
	cmpl %ebx, %edx			#compare if a greater than b
	ja ret_a			#if a is greater than b, go to ret_a to return a
	movl %ebx, %eax			#else move b into eax and return
	leave
	ret
ret_a:
	movl %edx, %eax			#move a into eax and return
	leave
	ret
