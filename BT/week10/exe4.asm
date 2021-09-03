.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C # ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 # =1 if the display has already to do
# Auto clear after sw
.eqv e 0x65
.eqv x 0x78
.eqv i 0x69
.eqv t 0x74
.text
	li $k0, KEY_CODE
	li $k1, KEY_READY
	li $s0, DISPLAY_CODE
	li $s1, DISPLAY_READY
loop: 	nop
WaitForKey:
	lw $t1, 0($k1)			# $t1 = [$k1] = KEY_READY
	beq $t1, $zero, WaitForKey	# if $t1 == 0 then Polling
ReadKey:
	lw $t0, 0($k0)			# $t0 = [$k0] = KEY_CODE
	j check_e
WaitForDis:
	lw $t2, 0($s1)			# $t2 = [$s1] = DISPLAY_READY
	beq $t2, $zero, WaitForDis	# if $t2 == 0 then Polling
ShowKey:
	sw $t0, 0($s0)			# show key
	nop
	j loop
check_e:
	beq $t3, e, check_x		# if character e exist then check x
	bne $t0, e, WaitForDis		# if character != e then continue
	add $t3, $t0, $0		# else $t3 = 'e'
	j WaitForDis
check_x:
	beq $t4, x, check_i		# if character x exist then check i
	bne $t0, x, reset		# if character != i then continue
	add $t4, $t0, $0		# else $t4 = 'x'
	j WaitForDis
check_i:
	beq $t5, i, check_t		# if character i exist then check t
	bne $t0, i, reset		# if character != t then continue
	add $t5, $t0, $0		# else $t5 = 't'
	j WaitForDis
check_t:
	beq $t0, t, exit		# if character t exist then exit
	j reset				# if character != t then continue
reset:	li $t3, 0			# reset 'e' to 0
	li $t4, 0			# reset 'x' to 0
	li $t5, 0			# reset 'i' to 0
	j WaitForDis
exit:	li $v0, 10
	syscall

