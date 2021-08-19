# RomProd
Converts a PlayStation PS-EXE to a bootable ROM image, which can be burnt to an EEPROM connected to the PlayStation's parallel port (ie. on an Xplorer cheat cartridge, or soldered directly to the mainboard).
The EXE will boot as soon as the console is powered up, skipping the PlayStation's intro sequence.

The PlayStation's parallel port has a hard limit of 64 KiB (unless you want to get messy), so the EXE is LZ77-compressed before it's included in the ROM.

Useful for projects like [sioload](https://github.com/danhans42/sioload), which allows you to upload EXEs to the PlayStation via a serial cable, now without the need of burning the utility to the CD and wearing out the aging PlayStation's CD-ROM drive.

Tested and working on [NO$PSX 2.0](https://problemkaputt.de/psx.htm), untested on a real console (yet).

## Prerequisites

This project uses ```mipsel-unknown-elf-as``` and ```mipsel-unknown-elf-ld```, both of which can be acquired by compiling the [GNU binutils](https://www.gnu.org/software/binutils/) for the mipsel-unknown-elf target:

```
wget http://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.gz
mkdir source build
tar -zxf binutils*gz -C source
cd build
../source/binutils*/configure --disable-nls --prefix=$(pwd)/../binutils --target=mipsel-unknown-elf --with-float=soft
make -j8
make install
cd ..
rm -rf source build binutils*gz
```

This will install the GNU binutils to a ```binutils``` directory in the repo's root. It will take a few minutes.

**If you have the open-source [PSXSDK](http://unhaut.epizy.com/psxsdk/) installed, then you can safely skip this step.** The correct binutils are already installed on your system.

The Makefile will automatically detect where your binutils are.

## Usage

```
./minify_exe.sh <PATH_TO_EXE>  # Compresses your EXE and copies it to the repo's root
make                           # Assembles everything
```

If everything goes well, the output will be in ```romprod.rom```. Make sure it's under 64 KiB, otherwise it will not work.

## Testing

### NO$PSX

To get it working on NO$PSX, you have to first load your legitimate backup of the PlayStation BIOS, wait until it starts playing the intro sequence and then load your ROM image.
Without it, NO$PSX will hang.

### Real console

TODO

## Credits

- [RomProd](http://www.psxdev.net/forum/viewtopic.php?t=393) – base project (provides romprod.s and fastboot.s)
- [lzss](https://www.romhacking.net/utilities/826/) – LZ77-compatible data compressor (provides lzss.c)
- [PSX-LZ77](https://github.com/ArthCarvalho/PSX-LZ77) – LZ77 data decompressor (provides lz77.s)
