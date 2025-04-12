all:
	nasm -f bin bootloader.S -o bootloader.bin

qemu: all
	qemu-system-x86_64 -hda bootloader.bin

clean:
	rm *.bin