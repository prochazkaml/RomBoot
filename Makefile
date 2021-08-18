.DEFAULT_GOAL := romprod.rom

lzss: lzss.c
	cc $< -o $@

romprod.rom: romprod.s lz77.s fastboot.s main.exe
	mipsel-unknown-elf-as -o romprod.o romprod.s
	mipsel-unknown-elf-ld -T rom.ld -Ttext 0x1F000000 --oformat binary -o romprod.rom romprod.o

clean:
	-rm *.o
	-rm *.exe
	-rm *.rom
	-rm lzss
