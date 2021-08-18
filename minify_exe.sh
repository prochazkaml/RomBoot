#/bin/sh

make lzss

# Destination address
dd if="$1" bs=1 count=4 skip=24 > main.exe

# PC
dd if="$1" bs=1 count=4 skip=16 >> main.exe

# SP
dd if="$1" bs=1 count=4 skip=48 >> main.exe

# GP
dd if="$1" bs=1 count=4 skip=60 >> main.exe

# Executable
dd if="$1" bs=2048 skip=1 > main.tmp

./lzss -ewo main.tmp
dd if=main.tmp >> main.exe
rm main.tmp
