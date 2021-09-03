#Laboratory Exercise 4, Home Assignment 3
# ble $s1, $s2, lable
.text
	li $s1, 0x1
	li $s2, 0x2

	slt $t1, $s2, $s1	# Check $s2 < $s1?
	beq $t1, $zero, SET	# If true ...
	j END
SET:
	li $s3, 0x3
END:


# not $s0, $s1
.text
	li $s0, -5
	xori $s1, $s0, 0xffffffff


# move $s0, $s1
.text
	li $s0, 5
	add $s1, $s0, $zero


# abs $s0, $s1
.text
	.text
	li $s1, -10			# $s1 = -10
	bgtz $s1, SET			# If $s1 > 0 then $s1 = $s0
	xori $t1, $s1, 0xffffffff	# If not, $t1 = ~$s1
	addi $s0, $t1, 0x1		# $s0 = $t1 + 1
	j END
SET:
	add $s0, $zero, $s1		# $s0 = $s1
END

