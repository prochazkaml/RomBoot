#Rom Prod 0.2 - X-Plorer ROM by Sicklebrick - July 2013
#compile with ASMPSX /b sourcefile.s,outFile.rom and upload with X-Killer
#copy /B outFile.rom + yourEXE.exe my_combined_rom.rom  to add the .EXE

#Load embedded .exe:  			Turn PSX on with XP already ON
#Load embedded .exe:			Turn PSX on with XP OFF, then hit the switch during loading
#Load nothing:					Turn PSX on with XP OFF, then just leave it off.

#As of 0.2 (thanks shadow) it should load fine without the switch toggle.
#Yay.

#Uses portions from
#MultiROM	-	Herben
#MyAR		-	Foo Chen Hon
#RunRom		-	Barog (Napalm)
#Greentro	-	Silpheed (Hitmen) & Cat (Feline?)
#Caetla		-	Lol
#Much love to inc^lightforce, shadow and Type 79 for being helpful little rabbits.


            .section .text

            .global __start

            .set noreorder

__start:
		.org	0x00000000		#header, points to EP2

biosJumpTable:
                .long 0xBFC00420                      # 1F003B7C
                .long 0xBFC042D0                      # 1F003B80
                .long 0xBFC042A0                      # 1F003B84
                .long 0xBFC04610                      # 1F003B88
                .long 0xBFC04678                      # 1F003B8C
                .long 0xBFC0472C                      # 1F003B90

# This area (post-boot) is not used by us, so put it to some good use:

#===== Entry Point 1
#Runs immediately as system boots
#returns control to bios if XPlorer switch is off.

entryPoint1:
		# Prepare for initBIOS

		mfc0    $v0, $12                   	# Fetch SR (requires 'status' - sickle)	

		addiu   $sp, $sp, -0x4						#Hide the sausage
		sw      $ra, 0($sp)

		andi    $v0, $v0,0xFBFE              		# Enable interrupts & use normal endianness?
		mtc0    $v0, $12						#MOD

		jal initBIOS						#Init bios properly.
		lui     $s0, 0x1F00		# biosJumpTable - it's in a fixed position (0x1F000000)

#===== Copy exe from end of rom into main memory. Hooray.	
#Rebuilt from RunRom decompilation. Pretty functional by the look of things.
#Reads in the location of the .EXE relative to the rom , then adds 0x800 
#for the first chunk of executable code. This is written to 0x80010000 in
#most cases.
#I.e.  $1f000000 + 1000 (rom size) + 800 (exe header) writes out to 0x80010000

copyExe:

		#Will add some equates for these later. Will I?
		la $t0,data
		
		lw $a1,0x0($t0)				#Where we'll write to

		jal asm_lzdecompress
		addiu $a0,$t0,0x14			#PSX EXE actual code offset (reading from) - delay slot

		la $t0,data

		lw $t1,0x4($t0)				#where we're about to jump to	
		lw $sp,0x8($t0)				#The stack pointer. (was $2c, not iportant, but wrong)
		lw $gp,0xC($t0)				#0x00000000 in every exe I've seen.
		
		#For example
		#li t1,$80010000
		#li sp,$801ffff0
		#li gp,$0000000
						
		jr $t1		#Jumpity jump jump
		nop

		.org	0x00000080		#0x80 points to EP1
		.long	entryPoint1
		.string	"Licensed by Sony Computer Entertainment Inc."
	
		.align 2

		.include "fastboot.s"
		.include "lz77.s"

##===== Includes n Stuff.

data:
	.incbin "main.exe"
