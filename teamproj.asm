; ITB Group project
; ITB final grade & credit point calculator

; macro declaration
%macro sys_write 2
   ; impelemnts the sys_write kernel call
   ; param 1 : message
   ; param 2 : message length
   mov edx, %2
   mov ecx, %1
   mov ebx, 1
   mov eax, 4
   int 80h
   %endmacro

%macro sys_read 2
   ; implements the sys_read kernel call
   ; param 1 : destination variable
   ; param 2 : byte length
   mov edx, %2
   mov ecx, %1
   mov ebx, 0
   mov eax, 3
   int 80h
   %endmacro

section	.text
   global _start
	
_start:
   ; code section is here

   ; input the grades of the student
   ; do not input two-digit grades! that is impossible!
   sys_write   in1msg, in1len
   sys_read    tes1  , 2
   sys_write   tes1  , 2

   sys_write   in2msg, in2len
   sys_read    tes2  , 2
   sys_write   tes2  , 2

   sys_write   examsg, exalen
   sys_read    exam  , 2
   sys_write   exam  , 2

   ; temporary message test
   sys_write   welmsg, wellen
   sys_write   hapmsg, haplen
   sys_write   sadmsg, sadlen

   ; sys_exit
   mov	eax, 1
   int	0x80

section	.data
   ; data section is here

   ; note : on linux systems 0xA implies 0xD
   welmsg: db "ITB Final grade & credit point calculator", 0xA, 0xD
   wellen: equ $ - welmsg

   ; the happy message
   hapmsg: db "You have passed!", 0xA, 0xD
   haplen: equ $ - hapmsg

   ; the sad message
   sadmsg: db "You have failed! See you at restanta!", 0xA, 0xD
   sadlen: equ $ - sadmsg

   ; input messages
   in1msg: db "Test 1: ", 0x0
   in1len: equ $ - in1msg

   in2msg: db "Test 2: ", 0x0
   in2len: equ $ - in2msg

   examsg: db "Exam: ", 0x0
   exalen: equ $ - examsg

section .bss
   ; reservation section is here

   ; one byte is reserved for the sign, two bytes are reserved for (im)possible two digit grades
   tes1: resb 3
   tes2: resb 3
   exam: resb 3