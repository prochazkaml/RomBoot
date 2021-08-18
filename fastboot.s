#original FASTBOOT.S - Decompiled from Caetla ROM
#Modified by Sickle July 2013 for RomProd cartridge boots.

Exec:
                addiu   $t2,$0,0xA0
                jr      $t2
                addiu   $t1,$0,0x43

ResetEntryInt:
                addiu   $t2,$0,0xB0
                jr      $t2                        # ResetEntryInt
                addiu   $t1,$0,0x18

InitRCnt:
                addiu   $t2,$0,0xC0
                jr      $t2
                addu    $t1,$0,$0              # InitRCnt

InitException:
                addiu   $t2,$0,0xC0
                jr      $t2
                addiu   $t1,$0,0x1                # InitException

InstallExceptionHandlers:
                addiu   $t2,$0,0xC0
                jr      $t2                        # InstallExceptionHandlers
                addiu   $t1,$0,0x7

SysInitMemory:
                addiu   $t2,$0,0xC0
                jr      $t2
                addiu   $t1,$0,0x8                # SysInitMemory


InitDefInt:
                addiu   $t2,$0,0xC0
                jr      $t2
                addiu   $t1,$0,0xC                # InitDefInt

InstallDevices:
                addiu   $t2,$0,0xC0
                jr      $t2
                addiu   $t1,$0,0x12               # InstallDevices

PatchA0Table:
                addiu   $t2, $0, 0xC0
                jr      $t2                        # PatchA0Table
                addiu   $t1, $0, 0x1C

initBIOS:



                addiu   $sp, $sp, -8
                sw      $ra, 0($sp)
                sw      $s0, 4($sp)
                nop

                #jal     biosRoutineA
				#nop
				
				#MOD - biosRoutineA was just a bit crashy.
				la $a0,biosJumpTable
				addiu   $a0,$a0,0x30	
				or      $v0,$0,$a0			
				
                #addiu   sp, sp, $FFE0   				#Let's not address things like that...
				addiu $sp,$sp,-0x20
								
				

                beq     $v0, $0, initBiosExitZero   	# Branch if return value == 0 #MOD
                or      $s0, $0, $v0

                mfc0    $v0, $12                   	# Fetch SR (requires 'status' - sickle)			
                nop
				
                andi    $v0, $v0,0xFBFE              		# Enable interrupts & use normal endianness?
                mtc0    $v0, $12						#MOD
                nop
							

                lw      $a0,0xA0($0)
                lui     $a1,0x3C08
                bne     $a0,$a1,Label1F003798
                sw      $0,0x90($0)
                sw      $a1,0x90($0)
				
								

Label1F003798:  lui     $t0,0xA001
                sw      $0,0xB9B0($t0)

                lui     $v0,0x1F80
                sh      $0,0x1D86($v0)
                sh      $0,0x1D84($v0)
                sh      $0,0x1D82($v0)
                sh      $0,0x1D80($v0)

                lw      $t0,0($s0)
                nop
                jalr    $ra,$t0
                nop

                lw      $t0,4($s0)
                nop
                jalr    $ra,$t0
                nop

                lw      $t0,8($s0)
                nop
                jalr    $ra,$t0
                nop

                jal     PatchA0Table
                nop

                jal     InstallExceptionHandlers
                nop

                jal     ResetEntryInt
                nop

                lui     $v0,0x1F80
                sh      $0,0x1D86($v0)
                sh      $0,0x1D84($v0)
                sh      $0,0x1D82($v0)
                sh      $0,0x1D80($v0)
                lui     $v0,0x1F80
                sw      $0,0x1074($v0)
                sw      $0,0x1070($v0)
                lui     $a0,0xA001
                lw      $a0,0xB9B0($a0)

                jal     InstallDevices
                nop

                lui     $v0,0x1F80
                sh      $0,0x1D86($v0)
                sh      $0,0x1D84($v0)
                sh      $0,0x1D82($v0)
                sh      $0,0x1D80($v0)

                li      $a0, 0xA000E000
                ori     $a1,$0,0x2000

                jal     SysInitMemory
                nop

                lw      $t0,0xC($s0)
                nop
                jalr    $ra,$t0
                addiu   $a0,$0,0x4

                jal     InitException
                addu    $a0,$0,$0

                jal     InitDefInt
                addiu   $a0,$0,0x3

                lw      $t0,0x10($s0)
                nop
                jalr    $ra,$t0
                addiu   $a0,$0,0x10

                lw      $t0,0x14($s0)
                addiu   $a0,$0,0x1
                jalr    $ra,$t0
                addiu   $a1,$0,0x4

                jal     InitRCnt
                addiu   $a0,$0,0x1

                lui     $v0,0x1F80
                sh      $0,0x1D86($v0)
                sh      $0,0x1D84($v0)
                sh      $0,0x1D82($v0)
                sh      $0,0x1D80($v0)
                beq     $0,$0,initBiosExit
                or      $v0, $0, $0            # Return 0

initBiosExitZero:  addiu   $v0, $0, -1              # Return -1

initBiosExit:   addiu   $sp,$sp,0x20
                lw      $ra,0($sp)
                lw      $s0,4($sp)
				
				addiu   $sp,$sp,8
                jr      $ra
                nop


# This routine does some check on the BIOS but I dunno what exactly.  It returns either the
# address of the biosJumpTable or 0, depending on events that I don't fully understand.
# Left it for the time being - sickle

#biosRoutineA:   ori     t0,$0,$400              # t0 = $400
#                #lui     t1,$BFC0                  # t1 = $BFC00000
#				 li		t1,$BFC00000					#BIOS start #MOD
#                or      v0,$0,zero              # v0 and v1 = $0
#                or      v1,$0,zero
#
#
#
#routineA_loop:  lw      t2,$6000(t1)              # Fetch a word from BIOS
#                addi    t1,t1,$4                  # Increment pointer
#                addiu   t0,t0,-$1               # Decrement counter
#                addu    v0,v0,t2                  # v0 += t2
#                bne     t0,$0,routineA_loop     # Loop while counter > 0
#                xor     v1,v1,t2                  # v1 ^= t2
#
#                la      a0, biosJumpTable
#                li      t0, $28550249
#                bne     v0,t0,Label1F003B20
#                lui     t0,$93D5
#                ori     t0,t0,$601D				
#				
#                beq     v1,t0,routineA_0
#Label1F003B20:  lui     t0,$B8A
#                ori     t0,t0,$F1C9
#                bne     v0,t0,routineA_Val
#                lui     t0,$51A
#                ori     t0,t0,$D5FF
#                bne     v1,t0,routineA_Val
#                addiu   a0,a0,$30
#routineA_0:	  	jr      ra
#                or      v0,$0,a0
#routineA_Val:	jr      ra
#                or      v0,$0,zero

#===== Routine A End

biosJumpTable:
                .long 0xBFC00410                      # 1F003B4C
                .long 0xBFC042C0                      # 1F003B50
                .long 0xBFC04290                      # 1F003B54
                .long 0xBFC045F0                      # 1F003B58
                .long 0xBFC04658                      # 1F003B5C
                .long 0xBFC0470C                      # 1F003B60
                .long 0xBFC072A0                      # 1F003B64
                .long 0xBFC07028                      # 1F003B68
                .long 0xBFC00890                      # 1F003B6C
                .long 0xBFC06EA4                      # 1F003B70
                .long Exec                           # 1F003B74
                .long 0xBFC0DCEC                      # 1F003B78
                .long 0xBFC00420                      # 1F003B7C
                .long 0xBFC042D0                      # 1F003B80
                .long 0xBFC042A0                      # 1F003B84
                .long 0xBFC04610                      # 1F003B88
                .long 0xBFC04678                      # 1F003B8C
                .long 0xBFC0472C                      # 1F003B90
                .long 0xBFC07330                      # 1F003B94
                .long 0xBFC070AC                      # 1F003B98
                .long 0xBFC008A0                      # 1F003B9C
                .long 0xBFC06F28                      # 1F003BA0
                .long Exec                           # 1F003BA4
                .long 0xBFC0E14C                      # 1F003BA8

