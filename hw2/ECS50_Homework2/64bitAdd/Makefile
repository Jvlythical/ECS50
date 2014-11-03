64bitAdd.out: 64bitAdd.o
	ld -o 64bitAdd.out 64bitAdd.o
64bitAdd.o: 64bitAdd.s
	as --gstabs -o 64bitAdd.o 64bitAdd.s
	
clean:
	rm -fr 64bitAdd.out 64bitAdd.o
