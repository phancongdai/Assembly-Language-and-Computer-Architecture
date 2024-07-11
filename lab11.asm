.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012 
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014 
.data
.text
main:            
li $t1, IN_ADDRESS_HEXA_KEYBOARD 
li $t2, OUT_ADDRESS_HEXA_KEYBOARD 
li $t3, 0x08    
# check row 4 with key C, D, E, F  
polling:         
sb $t3, 0($t1)   # must reassign expected row 
lb $a0, 0($t2)   # read scan code of key button 
print:       
li $v0, 34       # print integer (hexa) 
syscall 
sleep:       
li $a0, 100      # sleep 100ms 
li $v0, 32 
syscall        
back_to_polling: 
#j polling        # continue polling 
exit:
li $v0, 10
syscall






#number0: .word 0x11
#number1: .word 0x21
#number2: .word 0x41
#number3: .word 0x81
#number4: .word 0x12
#number5: .word 0x22
#number6: .word 0x42
#number7: .word 0x82
#number8: .word 0x14
#number9: .word 0x24
#numberA: .word 0x44
#numberB: .word 0x84
#numberC: .word 0x18
#numberD: .word 0x28
#numberE: .word 0x48
#numberF: .word 0x88
