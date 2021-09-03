.data 
	A: .word 11 -12 0 7

.text
	addi $s0 $zero 4	# n = 4
	addi $s1 $zero 0	# i = 0
	la $s2, A		# store address of A[0]
	lw $s3 0($s2)		# initializeMax = A[0]
loop:	slt $t2, $s1, $s0	# $t2 = i < n ? 1 : 0
	beq $t2, $zero, endloop
	add $t1, $s1, $s1	# $t1 = 2 * $s1
	add $t1, $t1, $t1	# $t1 = 4 * $s1
	add $t1, $t1, $s2	# $t1 store the address of A[i]
	lw $t0, 0($t1)		# load value of A[i] in $t0
	bltz $t0, getabs	# if A[i] < 0 jump to absolute
	addi $s1 $s1 1		# i = i + 1
	bgt $s3 $t0 loop	# if max > A[i] jump to loop
	add $s3 $t0 $zero	# else max = A[i]
	j loop			# jump to loop
getabs:	addi $s1 $s1 1		# i = i + 1
	sub $t0 $zero $t0	# A[i] = -A[i]
	bgt $s3 $t0 loop	# if max > A[i] jump to loop
	add $s3 $t0 $zero	# else max = A[i]
	j loop			# goto loop
endloop:

