.DEFAULT_GOAL := romprod.rom

PREFIX := $(if $(shell which mipsel-unknown-elf-as),,./binutils/bin/)

lzss: lzss.c
	cc $< -o $@

romprod.rom: romprod.s lz77.s fastboot.s main.exe
	$(PREFIX)mipsel-unknown-elf-as -o romprod.o romprod.s
	$(PREFIX)mipsel-unknown-elf-ld -T rom.ld -Ttext 0x1F000000 --oformat binary -o romprod.rom romprod.o

clean:
	-rm *.o
	-rm *.exe
	-rm *.rom
	-rm lzss
