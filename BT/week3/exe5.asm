.data
	A:  	.word 1,2,0,5

.text
	addi $s5, $zero, 0		# sum = 0
	addi $s1, $zero, 0		# i = 0
	addi $s4, $zero, 1		# step = 1
	addi $s3, $zero, 4		# n = 4
	la   $s2, A
loop:	lw $t0, 0($t1)			# load value of A[i] into $t0
	beq $t0, $zero, endloop		# goto endloop if A[i] == 0
	add $t1, $s1, $s1		# $t1=2*$s1
	add $t1, $t1, $t1		# $t1=4*$s1
	add $t1, $t1, $s2		# $t1 store the address of A[i]
	lw $t0, 0($t1)			# load value of A[i] in $t0
	add $s5, $s5, $t0		# sum=sum+A[i]
	add $s1, $s1, $s4		# i=i+step
	j loop				# goto loop
endloop:


# sum >= 0
.data
A:  	.word -1,-4,6,2

.text
	addi $s5, $zero, 0		# sum = 0
	addi $s1, $zero, 0		# i = 0
	addi $s4, $zero, 1		# step = 1
	addi $s3, $zero, 4		# n = 4
	la   $s2, A
loop:	slt $t2, $s5, $zero		# $t2 = sum < 0? 1 : 0
	bne $t2, $zero, endloop		# goto endloop if sum < 0
	add $t1, $s1, $s1		# $t1=2*$s1
	add $t1, $t1, $t1		# $t1=4*$s1
	add $t1, $t1, $s2		# $t1 store the address of A[i]
	lw $t0, 0($t1)			# load value of A[i] in $t0
	add $s5, $s5, $t0		# sum=sum+A[i]
	add $s1, $s1, $s4		# i=i+step
	j loop				#goto loop
endloop:


# i <= n
.data
	A: .word 1,2,3,4

.text
	addi $s5, $zero, 0		# sum = 0
	addi $s1, $zero, 0		# i = 0
	addi $s4, $zero, 1		# step = 1
	addi $s3, $zero, 4		# n = 4
	la   $s2, A
loop:	slt $t2, $s3, $s1		# $t2 = n < i? 1 : 0
	beq $t2, $zero, endloop		# goto endloop if n<i
	add $t1, $s1, $s1		# $t1=2*$s1
	add $t1, $t1, $t1		# $t1=4*$s1
	add $t1, $t1, $s2		# $t1 store the address of A[i]
	lw $t0, 0($t1)			# load value of A[i] in $t0
	add $s5, $s5, $t0		# sum=sum+A[i]
	add $s1, $s1, $s4		# i=i+step
	j loop				# goto loop
endloop:


# i < n
.data
	A: .word 1,2,3,4

.text
	addi $s5, $zero, 0		# sum = 0
	addi $s1, $zero, 0		# i = 0
	addi $s4, $zero, 1		# step = 1
	addi $s3, $zero, 4		# n = 4
	la   $s2, A
loop:	slt $t2, $s1, $s3		# $t2 = i < n? 1 : 0
	bne $t2, $zero, endloop		# goto endloop if i not less than n
	add $t1, $s1, $s1       	# $t1=2*$s1
	add $t1, $t1, $t1        	# $t1=4*$s1
	add $t1, $t1, $s2       	# $t1 store the address of A[i]
	lw $t0, 0($t1)            	# load value of A[i] in $t0
	add $s5, $s5, $t0       	# sum = sum+A[i]
	add $s1, $s1, $s4		# i = i+step
	j loop                        	# goto loop
endloop:

