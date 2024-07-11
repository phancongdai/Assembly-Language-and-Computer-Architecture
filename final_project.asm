.data
    input_str: .asciiz "Enter the prefix string: "
    output_str: .asciiz "The postfix string: "
    result_str: .asciiz "Value of string: "
    length_str: .space 100  
    infix: .word 100
    postfix: .word 100
.text
    main:
        # Nhập biểu thức trung tố từ người dùng
        li $v0, 4
        la $a0, input_str
        syscall
	
        li $v0, 8
        la $a0, length_str
        li $a1, 64
        syscall
        add $t0, $zero, $zero # point to symbol
        add $t9, $zero, $zero
        li $sp, 0x7FFFEFFC 
	add $fp, $sp, $zero
        
        # Gọi hàm để chuyển đổi biểu thức trung tố thành hậu tố
        jal undergo_infix

        # In ra biểu thức hậu tố
        li $v0, 4
        la $a0, output_str
        syscall

        li $v0, 4
        la $a0, length_str
        syscall
       
        # Gọi hàm để tính giá trị của biểu thức hậu tố
        jal evaluate_postfix

        # In ra giá trị của biểu thức
        li $v0, 4
        la $a0, result_str
        syscall

        li $v0, 1
        move $a0, $t0
        syscall

        # Kết thúc chương trình
        li $v0, 10
        syscall
        push_stack:
	#push $a2 in stack
		addi $sp, $sp, -4
		sw $a1, 0($sp)
		j continue_1st
	check_higher_operand:
		beq $sp, $fp, push_stack
		lb $t8, 0($sp)
		addi $t2, $zero, -8 #symbol (
		beq $t8, $t2, push_stack
		addi $t2, $zero, -3 #symbol -
		beq $t8, $t2, push_stack
		addi $t2, $zero, -5 #symbol +
		beq $t8, $t2, push_stack
		addi $t2, $zero, -6 #symbol *
		beq $a1, $t2, continue_2nd 
		addi $t2, $zero, -1 #symbol /
		beq $a1, $t2, continue_2nd
		j continue_1st
	check_lower_operand:
		beq $sp, $fp, push_stack
		lb $t8, 0($sp)
		addi $t2, $zero, -8 #symbol (
		beq $t8, $t2, push_stack
		addi $t2, $zero, -3 #symbol -
		beq $t8, $t2, push_stack
		addi $t2, $zero, -5 #symbol +
		beq $t8, $t2, push_stack
		j continue
	
		
		
		
		
		
    # Hàm chuyển đổi biểu thức trung tố thành hậu tố
    undergo_infix:
    	add $t1, $a0, $t0
    	lb $a1, 0($t1)
    	beq $a1, '\n', exit_infix
    	#addi $a1, $a1, -48
    	#check $a2 belongs to the range from "0" to "9"
	addi $t2, $zero, 0x30
	blt $a1, $t2, not_in_range #a1 less than 0
	addi $t2, $zero, 0x39
	bgt $a1, $t2, not_in_range #a1 greater than 9
	j in_range
	not_in_range:
	addi $t2, $zero, 0x40 #symbol (
	beq $a1, $t2, push_stack
	addi $t2, $zero, 0x41 #symbol )
	beq $a1, $t2, check_closed_parenthese
	addi $t2, $zero, 0x45 #symbol -
	beq $a1, $t2, check_lower_operand
	addi $t2, $zero, 0x43 #symbol +
	beq $a1, $t2, check_lower_operand
	addi $t2, $zero, 0x42 #symbol *
	beq $a1, $t2, check_higher_operand 
	addi $t2, $zero, 0x47 #symbol /
	beq $a1, $t2, check_higher_operand
	#j continue
	in_range:
		lb $a2, 1($t1)
		#addi $a2, $a2, -48
		addi $t2, $zero, 0x30
		blt $a2, $t2, push_postfix
		addi $t2, $zero, 0x39
		bgt $a2, $t3, push_postfix
		addi $t0, $t0, 1
		addi $s0, $zero, 10
		addi $
		mul $a1, $s0, $a1
		add $a1, $a1, $a2 
	push_postfix: #save in postfix
	sb $a1, 0($t9)
	continue_1st: 
	addi $t9, $t9, 1	
	addi $t0, $t0, 1
	j undergo_infix
	continue_2nd:
	sb $t8, 0($t9)
	addi $t9, $t9, 1
	addi $t0, $t0, 1
	
	j undergo_infix
	exit_infix:
        jr $ra

    # Hàm tính giá trị của biểu thức hậu tố
    evaluate_postfix:
        # Điều chỉnh thanh ghi $t0 và $t1 theo nhu cầu
        # ...

        jr $ra
