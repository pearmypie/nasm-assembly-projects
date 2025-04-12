FILES = build/kernel.o

all: bin/bootloader.bin $(FILES)
	rm -rf bin/os.bin
	dd if=bin/bootloader.bin >> bin/os.bin

bin/bootloader.bin: src/boot/bootloader.S
	nasm -f bin src/boot/bootloader.S -o bin/bootloader.bin

build/kernel.o: src/kernel/kernel.S
	nasm -f elf -g src/kernel/kernel.S -o build/kernel.o

qemu: all
	qemu-system-x86_64 -hda bin/bootloader.bin

clean:
	rm -rf bin/*
	rm -rf boot/*.bin
	rm -rf build/*.o build/*.so build/*.a