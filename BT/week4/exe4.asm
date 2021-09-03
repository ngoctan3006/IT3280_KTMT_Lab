#Laboratory Exercise 4, Home Assignment 4
.text
start:	li $t0, 0		#No Overflow is default status
	li $s1, 0xffffffff	# $s1 = 0xffffffff
	li $s2, 0xbfffffff	# $s2 = 0xbfffffff
	addu $s3, $s1, $s2	# s3 = s1 + s2
	xor $t1, $s1, $s2	# Test if $s1 and $s2 have the same sign
	bltz $t1, EXIT		# If not, exit
	
	xor $t2, $s1, $s3	# Test if $s1 and $s3 have the same sign
	bgtz $t2, EXIT		# If same, exit
OVERFLOW:
	li $t0, 1		# the result is overflow
EXIT:

