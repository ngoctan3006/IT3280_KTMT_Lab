#Laboratory Exercise 5, Home Assignment 3
.data
	x: .space 32
	y: .asciiz "Hello World"
.text
strcpy:
	la $a0, x
	la $a1, y
	add $s0, $zero, $zero
loop:
	add $t1, $s0, $a1
	lb $t2, 0($t1)
	add $t3, $s0, $a0
	sb $t2, 0($t3)
	beq $t2, $zero, end
	nop
	addi $s0, $s0, 1
	j loop
	nop
end:

