#Laboratory Exercise 4, Home Assignment 2
.text
    li $s0, 0x12345678		# $s0 = 0x12345678
    andi $t1, $s0, 0xff000000	# $t1 = $s0 AND 0xff000000 -> Extract MSB of $s0
    andi $t2, $s0, 0xffffff00	# $t2 = $s0 AND 0xffffff00 -> Clear LSB of $s0
    ori $s0, $s0, 0x000000ff	# Set LSB of $s0
    and $s0, 0			# Clear $s0

