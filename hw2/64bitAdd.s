.data
num1:
        .long 10
        .long 256
num2:
        .long 30
        .long 40

.text
.global main

main:
#upper 32 bits will be in EDX
#lower 32 bits will be in EAX
#current element will be in ecx
        movl num1, %edx #move first half of num1 into edx
        movl num1+4, %eax  #move 2nd half of num1 into eax
        addl num2+4, %eax   #add 2nd half of num2 into eax
        jnc nocarry
        addl num2, %edx
        addl $1, %edx   #since there's carry, add 1
        jmp done

nocarry:
        addl num2, %edx
done:
        movl %eax, %eax
