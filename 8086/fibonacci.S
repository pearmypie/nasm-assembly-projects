[org 0x7C00] ; BIOS loads this this bootloader at this address
bits 16      ; 16 bit real mode

_start:
    push 0x01
    push 0x01

    mov cx, 0x18
fibonacci:
    pop ax
    pop bx
    add ax, bx
    push bx
    push ax
    loop fibonacci

; boot sector black magic
times 510 - ($ - $$) db 0
dw 0xAA55

