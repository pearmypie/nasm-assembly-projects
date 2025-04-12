#!/usr/bin/env bash

echo $1
newname="$(echo "$1" | sed 's/\.S$/.bin/')"
destination="bin/$newname"

nasm -f bin -o $destination $1
qemu-system-i386 -drive file=$destination,if=floppy,format=raw,media=disk

