.eqv MONITOR_SCREEN 0x10010000
.eqv RED 0x00FF0000
.eqv GREEN 0x0000FF00
.eqv BLUE 0x000000FF
.eqv WHITE 0x00FFFFFF
.eqv BLACK 0x00000000
.text
	li $k0, MONITOR_SCREEN
	sub $k0, $k0, 4
	addi $k1, $k0, 256
loop:
	beq $k1, $k0, end
	# Prepare for Loop1
	addi $t1, $0, 0
	addi $t2, $0, 32
loop1:
	beq $t1, $t2, endLoop1
	li $t0, WHITE
	addi $k0, $k0, 4
	sw  $t0, ($k0)

	li $t0, BLACK
	addi $k0, $k0, 4
	sw  $t0, ($k0)
	addi $t1, $t1, 8
   
	j loop1

endLoop1:
	# Prepare for Loop2
	addi $t1, $0, 0
	addi $t2, $0, 32
loop2:
	beq $t1, $t2, endLoop2
	li $t0, BLACK
	addi $k0, $k0, 4
	sw  $t0, ($k0)
   
	li $t0, WHITE
	addi $k0, $k0, 4
	sw  $t0, ($k0)
	addi $t1, $t1, 8

	j loop2

endLoop2:
   j loop
   
end: