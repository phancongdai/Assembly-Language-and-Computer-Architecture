.data
 string: .space 30
 message1: .asciiz "Input the string: "
 message2: .asciiz "The result: "
 res: .space 30
.text
li $v0, 4 
la $a0, message1
syscall
li $v0, 8
la $a0, string
li $a1, 21
syscall
get_length:   la   $a0,string   
              add  $t0,$zero,$zero       
check_char:   
add  $t1,$a0,$t0                                         
lb   $t2, 0($t1)  
beq  $t2, $zero, end_of_str    
addi $t0, $t0, 1           
j    check_char 
end_of_str:                          
excution: 
add $s0, $zero, $zero
loop:
la $a0, string
addi $t0, $t0, -1
add $t1, $t0, $a0
lb $t2, 0($t1)
la $a1, res
add $t3, $a1, $s0
sb $t2, 0($t3)
beq $t2,$zero,end_execution
nop
addi $s0,$s0,1
j loop
nop
end_execution:
print_result:
li $v0, 4
la $a0, message2
syscall
li $v0, 4
la $a0, res
syscall










