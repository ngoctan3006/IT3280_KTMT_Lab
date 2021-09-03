.data
	A: .word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
.text
main:
sort_prep:
	la $t0, A		# load array to $t0
	addi $t1, $zero,13	# load array size to $t1
	li $t2, 1		# loop runner, starting from 1
loop1:
	la $t0, A		# load array to $t0
	bge $t2, $t1, exit	# while (t2 < $t1)
	move $t3, $t2		# copy $t2 to $t3
loop2:
	la $t0, A		# load array to $t0
	mul $t5, $t3, 4		# multiply $t3 with 4, and store in $t5
	add $t0, $t0, $t5	# add the array address with $t5,which is the index multiplied with 4
	ble $t3,$0,loop2_end	# while (t3 > 0)
	lw $t7, 0($t0)		# load array[$t3] to $t7
	lw $t6, -4($t0)		# load array[$t3 - 1] to $t6
	bge $t7, $t6, loop2_end	# while (array[$t3] < array[$t3 - 1])
	lw $t4, 0($t0)		#
	sw $t6, 0($t0)
	sw $t4, -4($t0)
	subi $t3, $t3, 1	#$t3=$t3-1
	j loop2			# jump back to the beginning of the loop2
loop2_end:
	addi $t2, $t2, 1	# increment loop runner by 1
	j loop1			# jump back to the beginning of the loop1
exit:
	li $v0, 10		# 10 = exit syscall
	syscall			# issue a system call

