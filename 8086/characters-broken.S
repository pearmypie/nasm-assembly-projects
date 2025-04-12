[org 0x7C00] ; BIOS loads this this bootloader at this address
bits 16      ; 16 bit real mode

_start:
    xor cx, cx   ; make sure CX is 0x00000000 
    mov cl, 0x20 ; first printable character
    call print
    ret

print:
    mov ah, 0x0E  ; teletype output of the BIOS
print_loop: 
    mov al, cl    ; loads the next character
    cmp al, 0xFE  ; checks for the last printable character
    jg print_done

    call hex_value ; transforms the number in memory into two ASCII characters

    int 0x10      ; prints the character found in AL
    inc cl        ; next character

    push cx
    mov cl, 0x20 ; space character
    int 0x10
    pop cx       

    jmp print_loop
        
print_done:
    mov al, 0x0D
    int 0x10

    mov al, 0x0A ; print new line (it's nice)
    int 0x10

    ret

hex_value:
    push cx ; original
    push cx ; needed later
    
    and cx, 0x0F
    shr cx, 4
    call compare_to_nine
    int 0x10 ; print first character

    pop cx   ; edit second character

    and cx, 0xF0
    shr cx, 4
    call compare_to_nine
    int 0x10     ; print second 
        
    mov cx, 0x3A ; semicolon character
    int 0x10

    pop cx   ; restore original
    ret

compare_to_nine:
    cmp cl, 0x09
    jle less
    add cl, 0x37
    ret
less:
    add cl, 0x30
    ret


; boot sector black magic
times 510 - ($ - $$) db 0
dw 0xAA55

