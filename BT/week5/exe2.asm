#Laboratory Exercise 5, Home Assignment 2
.data
	mes1:	.asciiz "The sum of "
	mes2:	.asciiz " and "
	mes3: 	.asciiz " is "
.text
	addi $s0, $zero, 2
	addi $s1, $zero, 3
	# print mes1
	li $v0, 4
	la $a0, mes1
	syscall
	# print num 1
	li $v0, 1
	add $a0, $zero, $s0
	syscall
	# print mes2
	li $v0, 4
	la $a0, mes2
	syscall
	# print num 2
	li $v0, 1
	add $a0, $zero, $s1
	syscall
	# print mes3
	li $v0, 4
	la $a0, mes3
	syscall
	# print result
	li $v0, 1
	add $a0, $s0, $s1
	syscall