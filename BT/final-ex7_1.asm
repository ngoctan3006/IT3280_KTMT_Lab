.data
	OpcodeMsg: .asciiz "Opcode: "
	ThanhGhiMsg: .asciiz "Thanh ghi: "
	HangSoMsg: .asciiz "Hang so: "
	IdentMsg: .asciiz "Ident: "
	InputMsg: .asciiz "Nhap vao mot lenh hop ngu can kiem tra: "
	ContinueMsg: .asciiz "Ban muon tiep tuc chuong trinh khong?(0.No/1.Yes): "
	ErrorMsg: .asciiz "Lenh hop ngu khong hop le. Loi cu phap!\n"
	NotFoundMsg: .asciiz "Khong tim duoc khuon dang lenh nay!\n"
	EndMess: .asciiz "\nHoan thanh! Lenh vua nhap vao phu hop voi cu phap!\n"
	HopLeMsg: .asciiz "hop le.\n"
	ChuKyMess: .asciiz "So chu ky cua lenh la: "
	command: .space 100
	opcode: .space 10
	token: .space 20
	number: .space 15
	ident: .space 30
	# Quy luat cua library: opcode co do dai = 5 byte cac byte ko duoc su dung thay bang dau *
	# Moi lenh co 3 toan hang va chi co 4 loai la: thanh ghi = 1, hang so nguyen = 2, dinh danh = 3 hoac khong co = 0.
	# So thu 4 se la chu ky cua lenh
	library: .asciiz "or***1111;xor**1111;lui**1201;jr***1001;jal**3002;addi*1121;add**1111;sub**1111;ori**1121;and**1111;beq**1132;bne**1132;j****3002;nop**0001;"
	charGroup: .asciiz "qwertyuiopasdfghjklmnbvcxzQWERTYUIOPASDFGHJKLZXCVBNM_"
	tokenRegisters: .asciiz "$zero $at   $v0   $v1   $a0   $a1   $a2   $a3   $t0   $t1   $t2   $t3   $t4   $t5   $t6   $t7   $s0   $s1   $s2   $s3   $s4   $s5   $s6   $s7   $t8   $t9   $k0   $k1   $gp   $sp   $fp   $ra   $0    $1    $2    $3    $4    $5    $7    $8    $9    $10   $11   $12   $13   $14   $15   $16   $17   $18   $19   $20   $21   $22   $21   $22   $23   $24   $25   $26   $27   $28   $29   $30   $31   "

.text
readData: # Doc lenh nhap vao tu ban phim
	li $v0, 4
	la $a0, InputMsg
	syscall
	li $v0, 8
	la $a0, command # Chua dia chi cua lenh nhap vao
	li $a1, 100
	syscall
main:
	li $t2, 0 # i
readOpcode:
	la $a1, opcode # Luu cac ki tu doc duoc vao opcode
	add $t3, $a0, $t2 # Dich bit
	add $t4, $a1, $t2
	lb $t1, 0($t3) # Doc tung ki tu cua command
	sb $t1, 0($t4)
	beq $t1, 32, done # Gap ki tu ' ' -> luu ki tu nay vao opcode de xu ly
	beq $t1, 0, done # Ket thuc chuoi command
	addi $t2, $t2, 1
	j readOpcode
	
# Xu ly opcode
done:
	li $t7,-10
	la $a2, library
xuLyOpcode:
	li $t1, 0 # i
	li $t2, 0 # j
	addi $t7,$t7,10 # Buoc nhay = 10 de den vi tri opcode trong library
	add $t1,$t1,$t7 # Cong buoc nhay
	
compare:
	add $t3, $a2, $t1 # $t3 tro thanh con tro cua library
	lb $s0, 0($t3)
	beq $s0, 0, notFound # Khong tim thay opcode nao trong library
	beq $s0, 42, check # Gap ki tu '*' -> check xem opcode co giong nhau tiep ko?.
	add $t4, $a1, $t2
	lb $s1, 0($t4)
	bne $s0,$s1,xuLyOpcode # So sanh 2 ki tu. dung thi so sanh tiep, sai thi nhay den phan tu chua khuon danh lenh tiep theo.
	addi $t1,$t1,1 # i += 1
	addi $t2,$t2,1 # j += 1
	j compare
	
check:
	add $t4, $a1, $t2
	lb $s1, 0($t4)
	bne $s1, 32, check2 # Neu ki tu tiep theo khong phai ' ' => lenh khong hop le. chi co doan dau giong.
	checkContinue:
	add $t9,$t9,$t2 # $t9 = luu vi tri de xu ly token trong command
	li $v0, 4
	la $a0, OpcodeMsg # Opcode hop le
	syscall
	li $v0, 4
	la $a0, opcode
	syscall
	li $v0, 4
	la $a0, HopLeMsg
	syscall
	j readToanHang1
	
	check2: # Neu ki tu tiep theo khong phai '\n' => lenh khong hop le. chi co doan dau giong.
	bne $s1, 10, notFound
	j checkContinue
	
# Ket thuc xu ly opcode

# Xu li toan hang
readToanHang1:
	# Xac dinh kieu toan hang trong library
	# $t7 dang chua vi tri khuon dang lenh trong library
	li $t1, 0
	addi $t7, $t7, 5 # Chuyen den vi tri toan hang 1 trong library
	add $t1, $a2, $t7 # $a2 chua dia chi library
	lb $s0, 0($t1)
	addi $s0,$s0,-48 # Chuyen tu char -> int
	li $t8, 1 # Thanh ghi = 1
	beq $s0, $t8, checkTokenReg
	li $t8, 2 # Hang so nguyen = 2
	beq $s0, $t8, checkHSN
	li $t8, 3 # Dinh danh = 3
	beq $s0, $t8, checkIdent
	li $t8, 0 # Khong co toan hang = 0
	beq $s0, $t8, checkNT
	j end
	
# Check Token Register
checkTokenReg:
	la $a0, command
	la $a1, token # Luu ten thanh ghi vao token de so sanh
	li $t1, 0
	li $t2, -1
	addi $t1, $t9, 0
	readToken:
		addi $t1, $t1, 1 # i
		addi $t2, $t2, 1 # j
		add $t3, $a0, $t1
		add $t4, $a1, $t2
		lb $s0, 0($t3)
		add $t9, $zero, $t1 # Vi tri toan hang tiep theo trong command
		beq $s0, 44, readTokenDone # Gap dau ','
		beq $s0, 0, readTokenDone # Gap ki tu ket thuc
		sb $s0, 0($t4)
		j readToken
	
	readTokenDone:
		sb $s0, 0($t4) # Luu them ',' vao de compare
		li $t1, -1 # i
		li $t2, -1 # j
		li $t4, 0
		li $t5, 0
		add $t2, $t2, $k1
		la $a1, token
		la $a2, tokenRegisters
		j compareToken

compareToken:
	addi $t1,$t1,1
	addi $t2,$t2,1
	add $t4, $a1, $t1
	lb $s0, 0($t4)
	beq $s0, 0, end # Gap ki tu ket thuc -> end
	add $t5, $a2, $t2
	lb $s1, 0($t5)
	beq $s1, 0, notFound
	beq $s1, 32, checkLengthToken
	bne $s0,$s1, jump
	j compareToken
	
	checkLengthToken:
		beq $s0, 44, compareE
		beq $s0, 10, compareE
		j compareNE
	jump:
		addi $k1,$k1,6
		j readTokenDone
	compareE:
		la $a0, ThanhGhiMsg # Thanh ghi
		syscall
		li $v0, 4
		la $a0, token
		syscall
		li $v0, 4
		la $a0, HopLeMsg
		syscall
		addi $v1, $v1, 1 # Dem so toan hang da doc.
		li $k1, 0 # Reset buoc nhay
		beq $v1, 1, readToanHang2
		beq $v1, 2, readToanHang3
		beq $v1, 3, readChuKy
		j end
	compareNE:
		j notFound
# Ket thuc check Token Register

# Check toan hang la hang so nguyen
checkHSN: # Kiem tra co phai hang so nguyen hay ko
	la $a0, command
	la $a1, number # Luu day chu so vao number de so sanh tung chu so co thuoc vao numberGroup hay khong.
	li $t1, 0
	li $t2, -1
	addi $t1, $t9, 0
	readNumber:
		addi $t1, $t1, 1 # i
		addi $t2, $t2, 1 # j
		add $t3, $a0, $t1
		add $t4, $a1, $t2
		lb $s0, 0($t3)
		add $t9, $zero, $t1 # Vi tri toan hang tiep theo trong command
		beq $s0, 44, readNumberDone # Gap dau ','
		beq $s0, 0, readNumberDone # Gap ki tu ket thuc
		sb $s0, 0($t4)
		j readNumber
	readNumberDone:
		sb $s0, 0($t4) # Luu them ',' vao de compare
		li $t1, -1 # i
		li $t4, 0
		la $a1, number
		j compareNumber
compareNumber:
	addi $t1, $t1, 1
	add $t4, $a1, $t1
	lb $s0, 0($t4)
	beq $s0, 0, end
	beq $s0, 45, compareNumber # Bo dau '-'
	beq $s0, 10, compareNumE
	beq $s0, 44, compareNumE
	li $t2, 48
	li $t3, 57
	slt $t5, $s0, $t2
	bne $t5, $zero, compareNumNE
	slt $t5, $t3, $s0
	bne $t5, $zero, compareNumNE
	j compareNumber

	compareNumE:
		la $a0, HangSoMsg # Hang so
		syscall
		li $v0, 4
		la $a0, number
		syscall
		li $v0, 4
		la $a0, HopLeMsg
		syscall
		addi $v1, $v1, 1 # Dem so toan hang da doc.
		li $k1, 0 # Reset buoc nhay
		beq $v1, 1, readToanHang2
		beq $v1, 2, readToanHang3
		beq $v1, 3, readChuKy
		j end
	compareNumNE:
		j notFound
# Ket thuc check toan hang la hang so nguyen
# Check Indent
checkIdent:
	la $a0, command
	la $a1, ident # Luu ten thanh ghi vao indent de so sanh
	li $t1, 0
	li $t2, -1
	addi $t1, $t9, 0
	readIndent:
		addi $t1, $t1, 1 # i
		addi $t2, $t2, 1 # j
		add $t3, $a0, $t1
		add $t4, $a1, $t2
		lb $s0, 0($t3)
		add $t9, $zero, $t1 # Vi tri toan hang tiep theo trong command
		beq $s0, 44, readIdentDone # Gap dau ','
		beq $s0, 0, readIdentDone # Gap ki tu ket thuc
		sb $s0, 0($t4)
		j readIndent
	readIdentDone:
		sb $s0, 0($t4) # Luu them ',' vao de compare
		loopj:
		li $t1, -1 # i
		li $t2, -1 # j
		li $t4, 0
		li $t5, 0
		add $t1, $t1, $k1
		la $a1, ident
		la $a2, charGroup
		j compareIdent
compareIdent:
	addi $t1,$t1,1
	add $t4, $a1, $t1
	lb $s0, 0($t4)
	beq $s0, 0, end
	beq $s0, 10, compareIdentE
	beq $s0, 44, compareIdentE
	loop:
	addi $t2,$t2,1
	add $t5, $a2, $t2
	lb $s1, 0($t5)
	beq $s1, 0, compareIdentNE
	beq $s0, $s1, jumpIdent # So sanh ki tu tiep theo trong ident
	j loop # Tiep tuc so sanh ki tu tiep theo trong charGroup
	
	jumpIdent:
		addi $k1,$k1,1
		j loopj
		
	compareIdentE:
		la $a0, IdentMsg # Ident hop le
		syscall
		li $v0, 4
		la $a0, ident
		syscall
		li $v0, 4
		la $a0, HopLeMsg
		syscall
		addi $v1, $v1, 1 # Dem so toan hang da doc.
		li $k1, 0 # Reset buoc nhay
		beq $v1, 1, readToanHang2
		beq $v1, 2, readToanHang3
		beq $v1, 3, readChuKy
		j end
	compareIdentNE:
		j notFound
# Ket thuc check Indent

# Kiem tra khong co toan hang
checkNT:
	la $a0, command
	li $t1, 0
	li $t2, 0
	addi $t1, $t9, 0
	add $t2, $a0, $t1
	lb $s0, 0($t2)
	addi $v1, $v1, 1 # Dem so toan hang da doc
	li $k1, 0 # Reset buoc nhay
	beq $v1, 1, readToanHang2
	beq $v1, 2, readToanHang3
	beq $v1, 3, readChuKy
# Ket thuc kiem tra khong co toan hang

# Check Token Register 2
readToanHang2:
	# Xac dinh kieu toan hang trong library
	# $t7 dang chua vi tri khuon dang lenh trong library
	li $t1, 0
	la $a2, library
	addi $t7, $t7, 1 # Chuyen den vi tri toan hang 2 trong library
	add $t1, $a2, $t7 # $a2 chua dia chi library
	lb $s0, 0($t1)
	addi $s0,$s0,-48 # Chuyen tu char -> int
	li $t8, 1 # Thanh ghi = 1
	beq $s0, $t8, checkTokenReg
	li $t8, 2 # Hang so nguyen = 2
	beq $s0, $t8, checkHSN
	li $t8, 3 # Dinh danh = 3
	beq $s0, $t8, checkIdent
	li $t8, 0 # Khong co toan hang = 0
	beq $s0, $t8, checkNT
	j end
# Ket thuc check Token Register 2-->

# Check Token Register 3-->
readToanHang3:
	# Xac dinh kieu toan hang trong library
	# $t7 dang chua vi tri khuon dang lenh trong library
	li $t1, 0
	la $a2, library
	addi $t7, $t7, 1 # Chuyen den vi tri toan hang 3 trong library
	add $t1, $a2, $t7 # $a2 chua dia chi library
	lb $s0, 0($t1)
	addi $s0,$s0,-48 # Chuyen tu char -> int
	li $t8, 1 # Thanh ghi = 1
	beq $s0, $t8, checkTokenReg
	li $t8, 2 # Hang so nguyen = 2
	beq $s0, $t8, checkHSN
	li $t8, 3 # Dinh danh = 3
	beq $s0, $t8, checkIdent
	li $t8, 0 # Khong co toan hang = 0
	beq $s0, $t8, checkNT
	j end
# Ket thuc check Token Register 3
# Check Token Register 3
readChuKy:
	# Xac dinh kieu toan hang trong library
	# $t7 dang chua vi tri khuon dang lenh trong library
	li $t1, 0
	la $a2, library
	addi $t7, $t7, 1 # Chuyen den vi tri toan hang 4 trong library
	add $t1, $a2, $t7 # $a2 chua dia chi library
	lb $s0, 0($t1)
	addi $s0,$s0,-48 # Chuyen tu char -> int
	li $v0, 4
	la $a0, ChuKyMess
	syscall
	li $v0,1
	li $a0,0
	add $a0,$s0,$zero
	syscall
	j end
# Ket thuc check Token Register 3
# Ket thuc xu li toan hang

continue: # Lap lai chuong trinh
	li $v0, 4
	la $a0, ContinueMsg
	syscall
	li $v0, 5
	syscall
	add $t0, $v0, $zero
	bne $t0, $zero, resetAll
	j TheEnd
resetAll:
	li $v0, 0 
	li $v1, 0
	li $a0, 0 
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	li $k0, 0
	li $k1, 0
	j readData
notFound:
	li $v0, 4
	la $a0, NotFoundMsg
	syscall
	j TheEnd
error:
	li $v0, 4
	la $a0, ErrorMsg
	syscall
	j TheEnd
end:
	li $v0, 4
	la $a0, EndMess
	syscall
	j continue
TheEnd:
