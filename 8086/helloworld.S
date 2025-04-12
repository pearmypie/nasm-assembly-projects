[org 0x7C00] ; BIOS loads this this bootloader at this address
bits 16      ; 16 bit real mode

_start:
        mov si, message
        call print
        ret

print:
        mov ah, 0x0E ; teletype output of the BIOS
print_loop:
        mov al, [si] ; loads the next character
        cmp al, 0x00 ; checks for the null string terminator
        je print_done

        int 0x10     ; prints the character found in AL
        inc si       ; next character
        jmp print_loop
        
print_done:
        ret

; data
message: db "Hello, world!", 0x0D, 0x0A, 0x00 ; null terminated string

; boot sector black magic
times 510 - ($ - $$) db 0
dw 0xAA55

