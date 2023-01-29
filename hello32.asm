; CATANA IOAN - ALEXNADRU
; 32 - Bit NASM Hello World Example

section.data
str : db "hello world!", 0  ; declare byte, address stored in str
len : equ $ - str           ; length in bytes of the string
                            ; $ = current address in memory
                            ; str points to "H"
section.bss
    ; nothing here

global _start               ; not necesarry, global label start will be known outside of text
section.text
_start :
mov EAX, 4                  ; calls sys_write
mov EBX, 1                  ; standard io
mov ECX, str                ; pointer to our string
mov EDX, len                ; length
int 0x80                    ; kernel call

mov eax, 1                  ; calls sys_exit
int 0x80                    ; kernel call
