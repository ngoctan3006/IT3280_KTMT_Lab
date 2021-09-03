#Laboratory Exercise 5, Home Assignment 4
.data
	x: .space 100
	mes: .asciiz "Enter string: "
	str: .space 100
	mes1: .asciiz "String isn't valid!"
	mes2: .asciiz "Result of strcpy: "
	mes3: .asciiz "Length of string: "
.text
	li $v0, 54
	la $a0, mes
	la $a1, str
	la $a2, 100
	syscall
	beq $a1, $0, strcpy
	li $v0, 59
	la $a0, mes1
	syscall
	j exit
strcpy:
	la $a1, str
	la $a0, x
	add $s0, $0, $0
loop:
	add $t1, $s0, $a1
	lb $t2, 0($t1)
	add $t3, $s0, $a0
	sb $t2, 0($t3)
	beq $t2, $0, end	# if y[i] == 0 -> exit
	nop
	addi $s0, $s0, 1
	j loop
	nop
end:

	li $v0, 59
	add $a1, $a0, $0	# copy from $a0 to $a1
	la $a0, mes2		# load mes2
	syscall
	
	li $v0, 56
	la $a0, mes3
	subi $a1, $s0, 1	# length of input
	syscall
exit: