.eqv MONITOR_SCREEN 0x10010000   #Dia chi bat dau cua bo nho man hinh 
.eqv RED            0x00FF0000   #Cac gia tri mau thuong su dung 
.eqv GREEN          0x0000FF00 
.eqv BLUE           0x000000FF 
.eqv WHITE          0x00FFFFFF 
.eqv YELLOW         0x00FFFF00 
.text 
li $k0, MONITOR_SCREEN        
li $t0, WHITE 
sw  $t0, 4($k0) 
nop 
sw  $t0, 8($k0)        
nop  
sw  $t0, 12($k0)    
nop  
sw  $t0, 16($k0) 
nop  
sw  $t0, 36($k0) 
nop
sw  $t0, 68($k0) 
nop
sw  $t0, 100($k0) 
nop
sw  $t0, 132($k0) 
nop       
sw  $t0, 164($k0) 
nop 
sw  $t0, 196($k0) 
nop 
sw  $t0, 52($k0) 
nop 
sw  $t0, 84($k0) 
nop 
sw  $t0, 116($k0) 
nop 
sw  $t0, 148($k0) 
nop 
sw  $t0, 180($k0) 
nop 
sw  $t0, 200($k0) 
nop 
sw  $t0, 204($k0) 
nop 
sw  $t0, 208($k0) 
nop 
sw  $t0, 96($k0) 
nop     
sw $t0, 104($k0) 
nop