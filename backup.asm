.data
    input_str: .asciiz "\nEnter the infix string: "
    output_str: .asciiz "The postfix string: "
    result_str: .asciiz "\nValue of string: "  
    infix: .space 100
    postfix: .space 100
    arrange: .space 100
    array: .byte
    order: .asciiz "\nInput order:"
    order1: .asciiz "\n1. Execute this program"
    order2: .asciiz "\n2. Quit this program"
    exception: .asciiz "\nPlease choose order 1 or 2"
.text
start:
	li $v0, 4
	la $a0, order1
	syscall
	li $v0, 4
	la $a0, order2
	syscall
input:
	li $v0, 51
	la $a0, order
	syscall
	beq $a0, 1, ord1
	beq $a0, 2, quit
	bne $a0, 1, except
except:
	li  $v0, 4 
	la  $a0, exception
	syscall
	j input
quit:
	li $v0, 10 #terminate
	syscall
ord1:
	# Nhập biểu thức trung tố từ người dùng
	li $v0, 4
	la $a0, input_str
	syscall
	
	li $v0, 8
	la $a0, infix
	li $a1, 100
	syscall
	
	initialize:
		la $a0, infix
		la $t7, postfix
		add $t0, $zero, $zero # point to current element of infix
		add $t9, $zero, $zero #point to the last element of postfix
		li $sp, 0x7FFFEFFC 
		add $fp, $sp, $zero
	main:	
		#jal compute
		jal undergo_infix
		push_remaining_in_stack:
			beq $sp, $fp, exit
			lb $t8, 0($sp)
			#addi $sp, $sp, 4
			add $a3, $t7, $t9
			sb $t8, 0($a3)
			addi $t9, $t9, 1
			addi $sp, $sp, 4
			j push_remaining_in_stack
		exit:
		li $v0, 4
		la $a0, output_str
		syscall
		#print the postfix
		li $v0, 4
		la $a0, postfix
		syscall
		li $v0, 4
		la $a0, result_str
		syscall
		jal compute_task
		li $v0, 1          	 
		add $a0, $zero, $t0        
		syscall
		j start
	push_stack:
		addi $sp, $sp, -4
		sb $a1, 0($sp)
		j continue
	check_operand:
		beq $sp, $fp, push_stack
		lb $t8, 0($sp)
		addi $t2, $zero, 0x28
		beq $t8, $t2, push_stack
		beq $a1, 0x2b, check_plusminus
		beq $a1, 0x2d, check_plusminus
		beq $a1, 0x2a, check_plusminus
		beq $a1, 0x2f, check_plusminus
		beq $a1, 0x7c, push_stack
		check_plusminus: #a1 is + or a1 is -
		addi $t2, $zero, 0x2b #+ 
		beq $t8, 0x7c, push_stack
		beq $a1, $t2, push_and_pop
		addi $t2, $zero, 0x2d #-
		beq $a1, $t2, push_and_pop
		check_muldiv: #a1 is * or a1 is /
		addi $t2, $zero, 0x2b
		beq $t8, $t2, push_stack
		addi $t2, $zero, 0x2d
		beq $t8, $t2, push_stack
		j push_and_pop
	check_closed_parenthese:
		lb $t8 ,0($sp)
		addi $t2, $zero, 0x28 #(
		beq $t8, $t2, erase_top_stack
		push_queue:
			add $a3, $t7, $t9 
			sb $t8, 0($a3)
			addi $t9, $t9, 1
			add $t2, $zero, $zero
			sb $t2, 0($sp)
			addi $sp, $sp, 4
			j check_closed_parenthese
	erase_top_stack:
		add $t2, $zero, $zero
		sb $t2, 0($sp)
		addi $sp, $sp, 4
		j continue
	undergo_infix:
		add $t1, $a0, $t0
		lb $a1, 0($t1)
		add $a3, $t7, $t9 
		addi $t2, $zero, 0x0a
		beq $a1, $t2, exit_infix
		addi $t2, $zero, 0x30
		blt $a1, $t2, not_in_range #a1 less than 0
		addi $t2, $zero, 0x39
		bgt $a1, $t2, not_in_range #a1 greater than 9
		j push_postfix
		not_in_range:
			addi $t2, $zero, 0x28 #symbol (
			beq $a1, $t2, push_stack
			addi $t2, $zero, 0x29 #symbol )
			beq $a1, $t2, check_closed_parenthese
			addi $t2, $zero, 0x2d #symbol -
			beq $a1, $t2, check_operand
			addi $t2, $zero, 0x2b #symbol +
			beq $a1, $t2, check_operand
			addi $t2, $zero, 0x2a #symbol *
			beq $a1, $t2, check_operand 
			addi $t2, $zero, 0x2f #symbol /
			beq $a1, $t2, check_operand
			beq $a1, 0x7c, check_operand
		push_postfix:
			sb $a1, 0($a3)
			addi $t9, $t9, 1
		continue:
			addi $t0, $t0, 1
		j undergo_infix
		push_and_pop:
			add $a3, $t7, $t9 
			sb $t8, 0($a3)
			addi $t9, $t9, 1
			add $t2, $zero, $zero
			sb $t2, 0($sp)
			addi $sp, $sp, 4
			j check_operand
		exit_infix:
		jr $ra
		new_push_stack:
		addi $sp, $sp, -4
		sb $a1, 0($sp)
		j new_continue
	new_check_operand:
		beq $sp, $fp, new_push_stack
		lb $t8, 0($sp)
		beq $t8, 0x28, new_push_stack
		beq $a1, 0x2b, new_check_plusminus
		beq $a1, 0x2d, new_check_plusminus
		beq $a1, 0x2a, new_check_plusminus
		beq $a1, 0x2f, new_check_plusminus
		beq $a1, 0x7c, new_push_stack
		new_check_plusminus:
		beq $t8, 0x7c, new_push_stack
		beq $a1, 0x2b, new_push_and_pop
		beq $a1, 0x2d, new_push_and_pop
		new_check_muldiv: #a1 is * or a1 is /
		beq $t8, 0x2b, new_push_stack
		beq $t8, 0x2d, new_push_stack
		j new_push_and_pop
	new_check_closed_parenthese:
		lb $t8 ,0($sp)
		addi $t2, $zero, 0x28 #(
		beq $t8, $t2, new_erase_top_stack
		new_push_queue:
			add $t6, $t7, $t9 
			sb $t8, 0($a3)
			addi $t9, $t9, 1
			add $t2, $zero, $zero
			sb $t2, 0($sp)
			addi $sp, $sp, 4
			j new_check_closed_parenthese
	new_erase_top_stack:
		add $t2, $zero, $zero
		sb $t2, 0($sp)
		addi $sp, $sp, 4
		j new_continue
	compute_task:
	new_initialize:
		la $a0, infix
		add $t0, $zero, $zero
		la $t7, array
		add $t9, $zero, $zero
		li $sp, 0x7FFFEFFC 
		add $fp, $sp, $zero
		begin: 
		add $t1, $a0, $t0
		lb $a1, 0($t1)
		add $t6, $t7, $t9
		beq $a1, 0x0a, exit_begin
		blt $a1, 0x30, out_range
		bgt $a1, 0x39, out_range
		j in_range
		out_range:
			#symbol (
			beq $a1, 0x28, new_push_stack
			#symbol )
			beq $a1, 0x29, new_check_closed_parenthese
			#symbol -
			beq $a1, 0x2d, new_check_operand
			#symbol +
			beq $a1, 0x2b, new_check_operand
			#symbol *
			beq $a1, 0x2a, new_check_operand 
			#symbol /
			beq $a1, 0x2f, new_check_operand
			beq $a1, 0x7c, new_check_operand
		in_range:
			lb $a2, 1($t1)
			addi $a1, $a1, -48
			#addi $a2, $a2, -48
			blt $a2, 0x30, push_array
			bgt $a2, 0x39, push_array
			addi $a2, $a2, -48
			mul $a1, $a1, 10
			add $a1, $a1, $a2
			addi $t0, $t0, 1
		push_array:
			sb $a1, 0($t6)
			addi $t9, $t9, 1
		new_continue:
			addi $t0, $t0, 1
		j begin
		new_push_and_pop:
			add $t6, $t7, $t9 
			sb $t8, 0($t6)
			addi $t9, $t9, 1
			add $t2, $zero, $zero
			sb $t2, 0($sp)
			addi $sp, $sp, 4
			j new_check_operand
		exit_begin:
		new_push_remaining_in_stack:
			beq $sp, $fp, new_exit
			lb $t8, 0($sp)
			#addi $sp, $sp, 4
			add $t6, $t7, $t9
			sb $t8, 0($t6)
			addi $t9, $t9, 1
			addi $sp, $sp, 4
			j new_push_remaining_in_stack
		new_exit:
		compute:
			addi $v0, $t9, 0 
			li $sp, 0x7FFFEFFC 
			add $fp, $sp, $zero
			la $t7, array
			add $t9, $zero, $zero
			loop:
			add $t6, $t7, $t9
			lb $a1, 0($t6)
			beq $v0, $t9, exit_loop
			beq $a1, 0x2b, plus
			beq $a1, 0x2d, minus
			beq $a1, 0x2a, multi
			beq $a1, 0x2f, divide
			beq $a1, 0x7c, or_exp
			is_operand:
			addi $sp, $sp, -4
			sb $a1, 0($sp)
			j next
			plus:
			lb $t2, 0($sp)
			lb $t1, 4($sp)
			addi $sp, $sp, 4
			add $t1, $t2, $t1
			sb $t1, 0($sp)
			j next
			minus:
			lb $t2, 0($sp)
			lb $t1, 4($sp)
			addi $sp, $sp, 4
			sub $t1, $t1, $t2
			sb $t1, 0($sp)
			j next
			multi:
			lb $t2, 0($sp)
			lb $t1, 4($sp)
			addi $sp, $sp, 4
			mul $t3, $t2, $t1
			sb $t3, 0($sp)
			j next
			divide:
			lb $t2, 0($sp)
			lb $t1, 4($sp)
			addi $sp, $sp, 4
			div $t3, $t1, $t2
			sb $t3, 0($sp)
			j next
			or_exp:
			lb $t2, 0($sp)
			lb $t1, 4($sp)
			addi $sp, $sp, 4
			or $t3, $t1, $t2
			sb $t3, 0($sp)
			next:
			addi $t9, $t9, 1
			j loop
			exit_loop:
			lb $t0, 0($sp)
			jr $ra
		
		
		
		
	
		
		
		
		
		

			
			
			
					

		
		
		
