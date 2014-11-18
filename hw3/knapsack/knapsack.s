.global knapsack
.equ wordsize, 4
.equ cur_value, 24
.equ capacity,  20
.equ num_items, 16
.equ values, 12
.equ weights, 8
.equ i, -4
.equ best_value, -8
.equ b, -12
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
	movl cur_value(%ebp), %edx			#move cur_value into a register
	movl %edx, best_value(%ebp)			#cur_value =  best_value
	xorl %ecx, %ecx				#set i to 0
	movl %ecx, i(%ebp)		#store ecx in i
#for(i = 0; i < num_items; i++)
for_each_item:
	movl i(%ebp), %ecx
	cmpl num_items(%ebp), %ecx			#check if i < num_items
	jb if					#if i is less, go to the if statement
	jmp ret_best_value			#else jump to return line
#if (capacity - weights[i] >= 0 )
if:
	movl capacity(%ebp), %ebx			#move capacity to EBX
	movl weights(%ebp), %esi			#move *weight into esi
	movl values(%ebp), %edi			#move *value into edi
	movl i(%ebp), %ecx			#retrive i and put into ecx
	leal (%esi, %ecx, wordsize), %esi	#move weight[i] into esi
	leal (%edi, %ecx, wordsize), %edi	#move values[i] into edi
	subl (%esi), %ebx				#subtract weights[i] from capacity
	cmpl $0, %ebx				#compare result and 0
	jge find_best_value			#jump to next line if result >=0
	incl %ecx				#else i++ and jump to for loop
	movl %ecx, i(%ebp) 		#move ecx into i
	jmp for_each_item			#jump to for loop
	
# best_value = max(best_value, knapsack(weights + i + 1, values + i + 1, num_items - i - 1, capacity - weights[i], cur_value + values[i]));
find_best_value:
	movl cur_value(%ebp), %eax			#move cur_value into eax
	addl (%edi), %eax				#addl cur_value and values[i], store in eax
	push %eax								#push new cur value onto stack
	movl capacity(%ebp),%eax			#move capacity into eax
	subl (%esi), %eax				#subtract weights[i] from capacity
	push %eax								#push new capacity onto stack
	movl num_items(%ebp), %eax			#move num_items into eax
	movl i(%ebp), %ecx	
	subl %ecx, %eax					#subtract i from num_items
	subl $1, %eax						#subtract 1 from num_items
	push %eax								#push new num_items onto stack
	movl $1, %ebx
	movl i(%ebp), %ecx			#get i adn put into ecx
	leal (%edi,%ebx,wordsize), %edi			#move calues+1+i into *values
	leal (%edi, %ecx, wordsize), %edi
	push %edi
	leal (%esi, %ebx, wordsize), %esi		#same for *weights
	leal (%esi, %ecx, wordsize), %esi
	push %esi
	call knapsack
	movl %eax, b(%ebp)					#store returned value from knapsack, into stack, or b

	push %eax										#testing, push b onto stack
	movl best_value(%ebp), %eax					#move a, or best_value, into eax,then push
	push %eax										#push a onto stack for max
	call max
	movl %eax, best_value(%ebp)						#move return value from max, into best_value
	incl %ecx		
	movl %ecx, i(%ebp)					
	jmp for_each_item							#after storing result in best_value, increment i and repeat loop

#return best_value
ret_best_value:
	movl best_value(%ebp), %eax			#store best_value into eax and then return	
	leave

	ret $36

#return a > b ? a : b;
#ebx will be b
#edx will be a
max:
	push %ebp
	movl %esp, %ebp

	movl values(%ebp), %ebx			#move returned value from knapsack, into ebx forba
	movl weights(%ebp), %edx		#move best_value, into eax for a
	cmpl %ebx, %edx			#compare if a greater than b
	ja ret_a			#if a is greater than b, go to ret_a to return a
	movl %ebx, %eax			#else move b into eax and return
	leave
	ret $12
ret_a:
	movl %edx, %eax			#move a into eax and return
	leave

	ret $12

