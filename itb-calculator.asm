; catana ioan-alexandru
; bti final grade & credit points calculator
; 13/01/2023

SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

section .data
    ; data declaration

    ; input messages
    msg0: db "Please be realistic! Input single-digit numbers only!", 0xA
    msg0len: equ $ - msg0

    msg1: db "Test #1 grade: "
    msg1len: equ $ - msg1

    msg2: db "Test #2 grade: "
    msg2len: equ $ - msg2

    msg3: db "Exam grade: "
    msg3len: equ $ - msg3

    msg4: db 0xA, "Final grade: "
    msg4len: equ $ - msg4

    msg5: db 0xA, "Credit points obtained: "
    msg5len: equ $ - msg5

    msg6: db 0xA, 0xD
    msg6len: equ $ - msg6

    ; sum
    sum: dw 0

    ; useful rounding variable
    fifty: db 50

section .bss
    ; memory reservations
    res: resb 1

    ; grades obtained
    test1: resb 2
    test2: resb 2
    exam:  resb 2

    ; useful credit points variable
    twodigits: resb 2

section .text
    global _start

_start:
    ; code starts here

    ; display important message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg0
    mov edx, msg0len
    int 0x80

    ; read the obtained grades
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, msg1len
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, test1
    mov edx, 2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, msg2len
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, test2
    mov edx, 2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, msg3len
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, exam
    mov edx, 2
    int 0x80

    ; convert from ascii to decimal number
    mov al, [test1]
    sub al, '0'
    mov [test1], al

    mov al, [test2]
    sub al, '0'
    mov [test2], al
    
    mov al, [exam]
    sub al, '0'
    mov [exam], al

    ; computing the weighted sum
    mov al, [test1]
    mov bl, 15
    mul bl          ; result in AH AL

    mov bx, [sum]
    add bx, ax
    mov [sum], bx

    mov al, [test2]
    mov bl, 15
    mul bl
    
    mov bx, [sum]
    add bx, ax
    mov [sum], bx

    mov al, [exam]
    mov bl, 70
    mul bl

    mov bx, [sum]
    add bx, ax
    mov [sum], bx

    ; computing the final grade
    mov ax, [sum]
    mov bl, 100
    div bl          ; al is the result, ah contains the remainder

    add al, '0'
    mov [res], al

    ; round the grade
    mov bh, [fifty]
    cmp ah, bh
    jge roundup     ; if the remainder is >=50, the grade is rounded up
    jmp results

roundup:
    mov al, [res]
    add al, 1
    mov [res], al
    jmp results

results:
    ; display results
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg4
    mov edx, msg4len
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 1
    int 0x80

    ; compute credit
    mov al, [res]
    sub al, '0'
    mov [res], al

    mov al, [res]
    mov bl, 6
    mul bl              ; ax contains 16 bit result
    aam                 ; ax contains unpacked BCD result
    add ax, 3030h       ; ah first digit, al last digit
    
    mov [twodigits], ah
    mov [twodigits + 1], al

    ; displaying the credit points message
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg5
    mov edx, msg5len
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, twodigits
    mov edx, 2
    int 0x80

    ; prints new line
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, msg6
    mov edx, msg6len
    int 0x80

    ; end of program
    mov eax, SYS_EXIT
    int 0x80