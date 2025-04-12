[org 0x7C00] ; BIOS loads this this bootloader at this address
bits 16      ; 16 bit real mode

_start:
    xor cx, cx   ; make sure CX is 0x00000000 
    mov cl, 0x20 ; first printable character

print_loop:
    cmp cx, 0xFF ; checks for the last printable character
    jg end_program

    push cx      ; save cx on stack
    call print_hex
    pop cx       ; restore CX

    mov ah, 0x0E 
    mov al, cl   ; print character
    int 0x10

    mov al, 0x20 ; print a space
    int 0x10

    inc cx
    jmp print_loop

end_program:
    ret ; return to DOS

print_hex:
    push ax ; backup registers
    push dx

    mov dl, cl ; save cl value in dl
    
    ; transforms the number 
    ; in memory into two ASCII characters
    ; using bitshifts, masks and additions
    mov al, dl
    and al, 0xF0
    shr al, 4
    call nibble_to_ascii
    mov ah, 0x0E
    int 0x10 ; print first character

    mov al, dl
    and al, 0x0F
    call nibble_to_ascii
    mov ah, 0x0E
    int 0x10 ; print second 

    mov al, 0x3A ; semicolon character
    int 0x10

    pop dx ; restore saved registers
    pop ax
    ret

nibble_to_ascii:
    cmp al, 9
    jle digit
    add al, 0x37
    ret
digit:
    add al, 0x30
    ret

; boot sector black magic
times 510 - ($ - $$) db 0
dw 0xAA55
