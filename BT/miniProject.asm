.data
	input1: .asciiz "Nhap vao so luong phan tu cua mang: "
	input2: .asciiz "Nhap vao cac phan tu cua mang: "
	input3: .asciiz "Nhap m: "
	input4: .asciiz "Nhap M: "
	max_is: .asciiz "Phan tu lon nhat la: "
	in_range: .asciiz "Cac phan tu trong khoang (m, M) la: "
	space: .asciiz "\t"
	newline: .asciiz "\n"
	array: .word 0:100
.text
main:	# nhap so luong phan tu cua mang
	la $a0,input1
	li $v0,4
	syscall

	li $v0,5
	syscall
	move $t0,$v0		# luu so luong phan tu cua mang vao thanh ghi $t0

	# nhap cac phan tu cua mang
	li $v0,4
	la $a0,input2
	syscall
	xor $t1,$t1,$t1
	la $t2,array

loop:	li $v0,5
	syscall

	sw $v0,($t2)
	addi $t1,$t1,1
	addi $t2,$t2,4
	blt $t1,$t0,loop

	# gan max = array[0]
	xor $t1,$t1,$t1
	la $t2,array
	lw $t3,($t2)
	move $t4,$t3

max:	lw $t3,($t2)
	blt $t3,$t4,next
	move $t4,$t3

next:	addi $t1,$t1,1
	addi $t2,$t2,4
	blt $t1,$t0,max
	la $a0,max_is
	li $v0,4
	syscall

	li $v0,1
	move $a0,$t4
	syscall

	li $v0,4
	la $a0, newline
	syscall

	# nhap m
	li $v0,4
	la $a0,input3
	syscall
	li $v0,5
	syscall
	move $t5,$v0		# $t5 luu gia tri m

	# nhap M
	li $v0,4
	la $a0,input4
	syscall
	li $v0,5
	syscall
	move $t6,$v0		# $t6 luu gia tri M

	li $v0,4
	la $a0,in_range
	syscall

	# kiem tra dieu kien
	li $t1,0
	la $t2,array
check:	lw $t7,($t2)
	ble $t7,$t5,continue	# kiem tra dieu kien lon hon m
	bge $t7,$t6,continue	# kiem tra dieu kien nho hon M

	# in phan tu thoa man ra man hinh
	li $v0,1
	move $a0,$t7
	syscall

	# in khoang trang
	li $v0,4
	la $a0,space
	syscall

continue:
	addi $t1,$t1,1
	addi $t2,$t2,4
	blt $t1,$t0,check

	# end
	li $v0,10
	syscall

