#!/bin/sh

mipsel-unknown-elf-as -o romprod.o romprod.s
#mipsel-unknown-elf-ld -T rom.ld -Ttext 0x1F000000 --oformat binary -o romprod.tmp romprod.o
mipsel-unknown-elf-ld -T rom.ld -Ttext 0x1F000000 --oformat binary -o romprod.rom romprod.o

#dd if=romprod.tmp of=romprod.rom bs=4096 count=1
