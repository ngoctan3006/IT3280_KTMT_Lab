#Laboratory Exercise 7, Assignment 5
.data
MesOfMax:	.asciiz "The largest value is "
MesOfMin: 	.asciiz "The smallest value is "
MesMaxIndex:	.asciiz "The largest element is stored in $s"
MesMinIndex:	.asciiz "The smallest element is stored in $s"
.text
main: 	li $s0, -1
	li $s1, 0
	li $s2, 1
	li $s3, 2
	li $s4, 3
	li $s5, 4
	li $s6, 5
	li $s7, 6
	jal init 		# call max procedure
	nop
	li $v0, 56		
	la $a0, MesMaxIndex	# print index of max element
	add $a1,$t8,$zero
	syscall
	la $a0, MesOfMax	# print max value
	add $a1,$t0,$zero
	syscall	
	la $a0, MesMinIndex	# print index of min value
	add $a1,$t9,$zero
	syscall
	la $a0, MesOfMin	# print min value
	add $a1,$t1,$zero
	syscall
	li $v0, 10		# exit program
	syscall
endmain:
swapMax:add $t0,$t3,$zero	# set Max = $t3
	add $t8,$t2,$zero	# set index of Max = $t2
	jr $ra
swapMin:add $t1,$t3,$zero	# set Min = $t3
	add $t9,$t2,$zero	# set index of Min = #$t2
	jr $ra
init:	add $fp,$sp,$zero	# save address of origin sp
	addi $sp,$sp, -32	# create space for stack
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	sw $s3, 8($sp)
	sw $s4, 12($sp)
	sw $s5, 16($sp)
	sw $s6, 20($sp)
	sw $s7, 24($sp)
	sw $ra, 28($sp)		# save $ra for main
	add $t0,$s0,$zero	# set Max = $s0
	add $t1,$s0,$zero	# set Min = $s0
	li $t8, 0		# set index of Max to 0
	li $t9, 0		# set index of Min to 0
	li $t2, 0		# set current index to 0
max_min:addi $sp,$sp,4
	lw $t3,-4($sp)
	sub $t4, $sp, $fp	# check if meet $ra
	beq $t4,$zero, done	# if true, done
	addi $t2,$t2,1		# increase index
	sub $t4,$t0,$t3		# cal Max - $t3
	bltzal $t4, swapMax	# if Max < $t3, swap Max
	sub $t4,$t3,$t1		# cal $t3 - Min
	bltzal $t4, swapMin	# if $t3 < Min, swap Min
	j max_min		# repeat
done:	lw $ra, -4($sp)		# load #$ra
	jr $ra 			# return to calling program

