.data
	A: .word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
	Aend: .word
.text
main:
	la $a0,A
	la $a1,Aend
	addi $a1,$a1,-4
	j sort
after_sort:
	li $v0, 10
	syscall
end_main:
sort: 
	beq $a0, $a1, done
	j max
after_loop: 	
	addi $a1,$a1,-4
	j sort
done:
	j after_sort
max:
	addi $t0, $a0, 0
loop:
	beq $t0,$a1,after_loop
	addi $t1,$t0,0
	addi $t0,$t0,4
	lw $t3,0($t1)
	lw $t4,0($t0)
	slt $t5,$t4,$t3
	bne $t5,$zero,swap
	j loop
swap:
	sw $t3,0($t0)
	sw $t4,0($t1)
	j loop

