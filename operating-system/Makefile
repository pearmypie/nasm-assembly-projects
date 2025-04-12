all:
	nasm -f bin src/boot/bootloader.S -o bin/bootloader.bin

qemu: all
	qemu-system-x86_64 -hda bin/bootloader.bin

clean:
	rm -rf boot/*.bin
	rm -rf build/*.o build/*.so build/*.a