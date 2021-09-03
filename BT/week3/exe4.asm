# i + j >= m + n
.text
	addi  $s1, $zero, 4 	# i = $s1 = 4
	addi  $s2, $zero, 5 	# j = $s2 = 5
	addi $s4, $zero, 2	# m = $s4 = 2
	addi $s5, $zero, 6	# n = $s5 = 6
	addi  $t1, $zero, 4 	# x = $t1 = 4
	addi  $t2, $zero, 5 	# y = $t2 = 5
	addi  $t3, $zero, 0	# z = $t3 = 0
	add  $s3, $s1, $s2	# sum_1 = i+j
	add $s6, $s4, $s5	# sum_2 = m+n
start:	slt  $t0, $s6, $s3	# m+n < i+j
	bne  $t0, $zero, else 	# branch to else if m+n not less than i+j
	addi  $t1, $t1, 1	# then part: x=x+1
	addi  $t3, $zero, 1 	# z=1
	j endif			# skip “else” part
else:	addi  $t2, $t2, -1	# begin else part: y=y-1
	add  $t3, $t3, $t3	# z=2*z
endif:


# i + j <= 0
.text
	addi $s1, $zero, 4 	# i = $s1 = 4
	addi $s2, $zero, 5 	# j = $s2 = 5
	addi  $t1, $zero, 4 	# x = $t1 = 4
	addi  $t2, $zero, 5 	# y = $t2 = 5
	addi  $t3, $zero, 0	# z = $t3 = 0
	add  $s4, $s2, $s1	# sum = $s4 = i+j
start:	slt  $t0, $zero, $s4	# 0 < i+j
	bne  $t0, $zero, else 	# branch to else if 0 < sum of i and j
	addi  $t1, $t1, 1	# then part: x=x+1
	addi  $t3, $zero, 1	# z=1
	j endif			# skip “else” part
else:	addi  $t2, $t2, -1	# begin else part: y=y-1
	add   $t3, $t3, $t3	# z=2*z
endif:


# i >= j
.text
	addi  $s1, $zero, 4	# init i=4
	addi $s2, $zero, 5	# init j=5
	addi $t1, $zero, 4	# init x=4
	addi $t2, $zero, 5	# init y=5
	addi $t3, $zero, 3	# init z=3
start:	slt $t0, $s1, $s2	# i < j
	bne $t0, $zero, else	# branch to else if i < j
	addi $t1, $t1, 1	# part x=x+1
	addi $t3, $zero, 1	# init z=1
	j endif			# skip the else part
else:   addi 	$t2, $t2, -1	# part y=y-1
	add	$t3, $t3, $t3	# part z=2*z
endif:


# i < j
.text 
	addi $s1, $zero, 4	# i=4
	addi $s2, $zero, 5	# j=5
	addi $t1, $zero, 4	# x=4
	addi $t2, $zero, 5	# y=5
	addi $t3, $zero, 3	# z=3
start:
	slt $t0, $s1, $s2	# i < j
	beq $t0, $zero, else	# branch to else if i not less than j
	addi $t1, $t1, 1	# part x=x+1
	addi  $t3, $zero, 1	# init z=1 
	j endif			# skip the else part
else:   addi $t2, $t2, -1	# part y=y-1
	add $t3, $t3, $t3	# part z=2*z
endif:

