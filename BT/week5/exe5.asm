#Laboratory Exercise 5, Home Assignment 5
.data
	mes: .asciiz "Enter a character (press Enter to end): "
	str: .space 20
.text
init:
	add $s0, $zero, $zero
	la $s1, str
read:
	li $v0, 12			# input character
	la $a0, mes
	syscall
	nop
check:
	beq $v0, 10, print		# if input is enter jump to print
	add $t1, $s0, $s1		# load string[i] -> t1
	sb $v0, 0($t1)			# load $v0 -> $t1
	addi $s0, $s0, 1		# $s0 ++
	slti $t0, $s0, 20
	beq $t0, $zero, print		# if $s0 == 20: jump to print
	j read
print:
	slt $t0, $s0, $zero		# for $s0 -> 0
	bne $t0, $zero, exit
	add $t1, $s0, $s1		# $t1 = address of string[$s0]
	lb $t2, 0($t1)			# $t2 = string[$s0]
	li $v0, 11
	add $a0, $zero, $t2		# print $t2
	syscall
	addi $s0, $s0, -1		# i-= 1
	j print
exit: