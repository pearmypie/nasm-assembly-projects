org 0x7C00
bits 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
_start:
    jmp short boot
    nop

times 33 db 0 ; bios parameter block

boot:
    jmp 0x00:setup ; ensures CS is 07C0

setup:
    cli            ; clear interrupts
    mov ax, 0x00
    mov ds, ax     ; setup data segment
    mov es, ax
    ; mov ax, 0x00
    mov ss, ax     ; setup stack segment
    mov sp, 0x7C00 ; setup stack pointer
    sti            ; enables interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; Global Descriptor Table
gdt_start:
gdt_null:
    dd 0
    dd 0 ; 64 zero bits

; offset 0x08
gdt_code:     ; CS point here!
    dw 0xFFFF ; segment limit for first 0-15 bits
    dw 0      ; base first 0-15 bits
    db 0      ; base 16-23 bits
    db 0x9A   ; access byte
    db 11001111b ; the high 4 bit flags and the 4 low bit flags
    db 0         ; base 24-31 bits

; offset 0x10
gdt_data:     ; DS, SS, ES, FS, GS
    dw 0xFFFF ; segment limit for first 0-15 bits
    dw 0      ; base first 0-15 bits
    db 0      ; base 16-23 bits
    db 0x92   ; access byte (only change from above)
    db 11001111b ; the high 4 bit flags and the 4 low bit flags
    db 0         ; base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size
    dd gdt_start               ; offset

bits 32
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
