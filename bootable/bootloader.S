org 0
bits 16

_start:
    jmp short boot
    nop

times 33 db 0 ; bios parameter block

boot:
    jmp 0x07C0:setup ; ensures CS is 07C0

; self defined interrupts
handle_zero:
    mov ah, 0x0E
    mov al, 0x30 ; character '0'
    mov bx, 0x00
    int 0x10
    iret

handle_one:
    mov ah, 0x0E
    mov al, 0x31 ; character '1'
    mov bx, 0x00
    int 0x10
    iret

setup:
    cli            ; clear interrupts
    mov ax, 0x07C0
    mov ds, ax     ; setup data segment
    mov es, ax
    mov ax, 0x00
    mov ss, ax     ; setup stack segment
    mov sp, 0x7C00 ; setup stack pointer
    sti            ; enables interrupts

    ; vector interrupt talbe
    mov word[ss:0x0000], handle_zero ; ss is already 0000
    mov word[ss:0x0002], 0x07C0
    
    mov word[ss:0x0004], handle_one
    mov word[ss:0x0006], 0x07C0

    ; read sector from disk
    mov ah, 0x02 ; read sector command
    mov al, 0x01 ; sector count
    mov ch, 0x00 ; cylinder number
    mov cl, 0x02 ; sector number
    mov dh, 0x00 ; head number
    mov bx, buffer
    int 0x13
    jc error

    mov si, buffer
    call print

    int 0
    int 1

halt:
    jmp halt

error:
    mov si, error_msg
    call print
    jmp halt

print:
    mov bx, 0
._loop:
    lodsb ;  load character from si into al and increment si
    cmp al, 0
    je .done
    call putc
    jmp ._loop
.done: ; special label only accessible in print
    ret

putc:
    mov ah, 0x0E
    int 0x10
    ret

error_msg: db 'failed to load sector.', 0

times 510 - ($ - $$) db 0
dw 0xAA55

buffer:

