.data
	str:	.string	"My-Pizza"

.text

.global	main

main:
	mov	$4,	%eax
	mov	$1,	%ebx
	mov	$str	, %ecx
	mov $8, %edx

	int $0x80


