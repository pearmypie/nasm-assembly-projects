all:
	nasm -f bin bootloader.S -o bootloader.bin
	dd if=splash.txt >> bootloader.bin
	dd if=/dev/zero bs=512 count=1 >> bootloader.bin

qemu: all
	qemu-system-x86_64 -hda bootloader.bin

clean:
	rm *.bin