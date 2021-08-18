#original FASTBOOT.S - Decompiled from Caetla ROM
#Modified by Sickle July 2013 for RomProd cartridge boots.

initBIOS:
                addiu   $sp, $sp, -0x24
                sw      $ra, 0x20($sp)

                lw      $a0,0xA0($0)
                lui     $a1,0x3C08
                bne     $a0,$a1,Label1F003798
                sw      $0,0x90($0)
                sw      $a1,0x90($0)
							

Label1F003798:  lui     $t0,0xA001
                sw      $0,0xB9B0($t0)

                lui     $v0,0x1F80
                sw      $0,0x1D84($v0)
                sw      $0,0x1D80($v0)

                lw      $t0,0($s0)
                jalr    $ra,$t0
                nop

                lw      $t0,4($s0)
                jalr    $ra,$t0
                nop

                lw      $t0,8($s0)
                jalr    $ra,$t0
                nop

                addiu   $t2, $0, 0xC0
                jal     $t2                        # PatchA0Table
                addiu   $t1, $0, 0x1C

                addiu   $t2,$0,0xC0
                jal     $t2                        # InstallExceptionHandlers
                addiu   $t1,$0,0x7

                addiu   $t2,$0,0xB0
                jal     $t2                        # ResetEntryInt
                addiu   $t1,$0,0x18

                lui     $v0,0x1F80
                sw      $0,0x1D84($v0)
                sw      $0,0x1D80($v0)
                sw      $0,0x1074($v0)
                sw      $0,0x1070($v0)
                lui     $a0,0xA001
                lw      $a0,0xB9B0($a0)

                addiu   $t2,$0,0xC0
                jal     $t2
                addiu   $t1,$0,0x12               # InstallDevices

                lui     $v0,0x1F80
                sw      $0,0x1D84($v0)
                sw      $0,0x1D80($v0)

                li      $a0, 0xA000E000
                ori     $a1,$0,0x2000

                addiu   $t2,$0,0xC0
                jal     $t2
                addiu   $t1,$0,0x8                # SysInitMemory

                lw      $t0,0xC($s0)
                jalr    $ra,$t0
                addiu   $a0,$0,0x4

                addu    $a0,$0,$0

                addiu   $t2,$0,0xC0
                jal     $t2
                addiu   $t1,$0,0x1                # InitException

                addiu   $a0,$0,0x3

                addiu   $t2,$0,0xC0
                jal      $t2
                addiu   $t1,$0,0xC                # InitDefInt

                lw      $t0,0x10($s0)
                jalr    $ra,$t0
                addiu   $a0,$0,0x10

                lw      $t0,0x14($s0)
                addiu   $a0,$0,0x1
                jalr    $ra,$t0
                addiu   $a1,$0,0x4

                addiu   $a0,$0,0x1

                addiu   $t2,$0,0xC0
                jal      $t2
                addu    $t1,$0,$0              # InitRCnt

                lui     $v0,0x1F80
                sw      $0,0x1D84($v0)
                sw      $0,0x1D80($v0)
                
                addiu   $sp,$sp,0x24
                lw      $ra,-4($sp)
				
                jr      $ra
                nop

