.eqv KEY_CODE   0xFFFF0004       # ASCII code from keyboard, 1 byte 
.eqv KEY_READY  0xFFFF0000       # =1 if has a new keycode ? 
# Auto clear after lw 
.eqv DISPLAY_CODE   0xFFFF000C   # ASCII code to show, 1 byte 
.eqv DISPLAY_READY  0xFFFF0008   # =1 if the display has already to do 
# Auto clear after sw 
.text 
li   $k0,  KEY_CODE 
li   $k1,  KEY_READY 
li   $s0, DISPLAY_CODE 
li   $s1, DISPLAY_READY 
loop:        
nop 
WaitForKey:  
lw   $t1, 0($k1)            # $t1 = [$k1] = KEY_READY 
nop 
beq  $t1, $zero, WaitForKey # if $t1 == 0 then Polling 
nop 
#----------------------------------------------------- 
ReadKey:     
lw   $t0, 0($k0)            # $t0 = [$k0] = KEY_CODE 
nop 
#----------------------------------------------------- 
WaitForDis:  
lw   $t2, 0($s1)            # $t2 = [$s1] = DISPLAY_READY 
nop
beq  $t2, $zero, WaitForDis # if $t2 == 0 then Polling              
nop              
#----------------------------------------------------- 
Encrypt:     
addi $t0, $t0, 1            # change input key 
#----------------------------------------------------- 
ShowKey:     
sw $t0, 0($s0)              # show key 
nop                
#-----------------------------------------------------             
j loop 
nop 
Process:
	seq $t3,$t0,'e'
	seq $t4,$s2,0
	and $t3,$t3,$t4
	bnez $t3,detect
	seq $t3,$t0,'x'
	seq $t4,$s2,1
	and $t3,$t3,$t4
	bnez $t3,detect
	seq $t3,$t0,'i'
	seq $t4,$s2,2
	and $t3,$t3,$t4
	bnez $t3,detect
	seq $t3,$t0,'t'
	seq $t4,$s2,3
	and $t3,$t3,$t4
	bnez $t3,detect
	li $s2,0
	detect:
		addi $s2,$s2,1
		nop
	beq $s2,4,End_program
 	j loop
 	nop 	
End_program:
	li $v0,10
	syscall