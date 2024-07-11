.eqv HEADING 0xffff8010 # Integer: An angle between 0 and 359
 # 0 : North (up)
# 90: East (right)
# 180: South (down)
 # 270: West (left)
.eqv MOVING 0xffff8050 # Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # Boolean (0 or non-0):
 # whether or not to leave a track
.eqv WHEREX 0xffff8030 # Integer: Current x-location of MarsBot
.eqv WHEREY 0xffff8040 # Integer: Current y-location of MarsBot
.text
di_ra:
	addi $a0, $zero, 90 # Marsbot rotates 90* and start running
 	jal ROTATE
 	nop
 	jal GO
 	nop
	ngu0: addi $v0,$zero,32 # Keep running by sleeping in 1800 ms
 	li $a0, 5000
 	syscall
 	jal UNTRACK # keep old track
 	nop
di_xuong:
	addi $a0, $zero, 180 # Marsbot rotates 90* and start running
 	jal ROTATE
 	nop
 	jal GO
 	nop
	ngu1: addi $v0,$zero,32 # Keep running by sleeping in 1800 ms
 	li $a0, 5000
 	syscall
 	jal UNTRACK # keep old track
 	nop
net1: 
jal TRACK # draw track line
 nop
 addi $a0, $zero, 90 # Marsbot rotates 90* and start running
 jal ROTATE
 nop
 jal GO
 nop
 sleep0: addi $v0,$zero,32 # Keep running by sleeping in 2000 ms
 li $a0,2000
 syscall
 
 jal UNTRACK # keep old track
 nop
 jal TRACK # and draw new track line
 nop
 
  net2: addi $a0, $zero, 120 # Marsbot rotates 120*
 jal ROTATE
 nop

sleep2: addi $v0,$zero,32 # Keep running by sleeping in 300 ms
 li $a0,500
 syscall
 jal UNTRACK # keep old track
 nop
 jal TRACK # and draw new track line
 nop
 
net3: addi $a0, $zero, 180 # Marsbot rotates 180*
 jal ROTATE
 nop

sleep3: addi $v0,$zero,32 # Keep running by sleeping in 1800 ms
 li $a0, 3000
 syscall
 jal UNTRACK # keep old track
 nop
 jal TRACK # and draw new track line
 nop
 
net4: addi $a0, $zero, 210 # Marsbot rotates 210*
 jal ROTATE
 nop

sleep4: addi $v0,$zero,32 # Keep running by sleeping in 300 ms
 li $a0, 500
 syscall
 jal UNTRACK # keep old track
 nop
 jal TRACK # and draw new track line
 nop
net5: addi $a0, $zero, 270 # Marsbot rotates 270*
 jal ROTATE
 nop

sleep5: addi $v0,$zero,32 # Keep running by sleeping in 2000 ms
 li $a0,2200
 syscall
 jal UNTRACK # keep old track
 nop
 jal TRACK # and draw new track line
 nop

net6: addi $a0, $zero, 0 # Marsbot rotates 0*
 jal ROTATE
 nop

sleep6: addi $v0,$zero,32 # Keep running by sleeping in 2400 ms
 li $a0,3600
 syscall
 jal UNTRACK # keep old track
 nop

net7: addi $a0, $zero, 180 # Marsbot rotates 0*
 jal ROTATE
 nop

sleep7: addi $v0,$zero,32 # Keep running by sleeping in 2400 ms
 li $a0,1700
 syscall
 jal UNTRACK # keep old track
 nop 
 jal TRACK
 nop

net8: addi $a0, $zero, 270 # Marsbot rotates 0*
 jal ROTATE
 nop

sleep8: addi $v0,$zero,32 # Keep running by sleeping in 2400 ms
 li $a0,1000
 syscall
 jal UNTRACK # keep old track
 nop 
 jal TRACK
 nop
 
net9: addi $a0, $zero, 90 # Marsbot rotates 0*
 jal ROTATE
 nop

sleep9: addi $v0,$zero,32 # Keep running by sleeping in 2400 ms
 li $a0,2000
 syscall
 jal UNTRACK # keep old track
 nop 
  

end_main:

li $v0, 10
syscall

#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO: li $at, MOVING # change MOVING port
 addi $k0, $zero,1 # to logic 1,
 sb $k0, 0($at) # to start running
 nop
 jr $ra
 nop
#-----------------------------------------------------------
# STOP procedure, to stop running
# param[in] none
#-----------------------------------------------------------
STOP: li $at, MOVING # change MOVING port to 0
 sb $zero, 0($at) # to stop
 nop
 jr $ra
 nop
#-----------------------------------------------------------
# TRACK procedure, to start drawing line
# param[in] none
#-----------------------------------------------------------
TRACK: li $at, LEAVETRACK # change LEAVETRACK port
 addi $k0, $zero,1 # to logic 1,
 sb $k0, 0($at) # to start tracking
 nop
 jr $ra
 nop
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#-----------------------------------------------------------
UNTRACK:li $at, LEAVETRACK # change LEAVETRACK port to 0
 sb $zero, 0($at) # to stop drawing tail
 nop
 jr $ra
 nop
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a0, An angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE: li $at, HEADING # change HEADING port
 sw $a0, 0($at) # to rotate robot
 nop
 jr $ra
 nop