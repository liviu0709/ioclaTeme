%include "printf32.asm"

section .data
    a1 dd 0x40000000
    b1 dd 0x40000001
    a2 dd 0x0
    b2 dd 0x10
    n dw 0xA01
    fmtOverflow db "Go on a diet, Pisi", 10, 0
    fmtNoOvr db "You can eat more bacalhau", 10, 0
    fmt_int_newline db "%d", 10, 0
    fmt_chars db "%s", 10, 0
    arr dw 0x3448, 0x3434, 0x6B63, 0x6E69, 0x2067, 0x6874, 0x2065, 0x6F77, 0x6C72, 0x2E64
    len equ $-arr

section .text
extern printf
global main

main:
    push ebp
    mov ebp, esp


    ; TODO a: Determine whether the sum of 2 ints results in overflow
    mov eax, [a2]
    mov ebx, [b2]
    add eax, ebx
    jno good
    push fmtOverflow
    jmp skip
good:
    push fmtNoOvr
skip:
    call printf
    add esp, 4

    ; TODO b: Determine the position of the first set bit starting from the
    ; left for the little endian representation of a 16 bit number
    mov eax, 0
    mov ax, [n]
    mov ecx, 0 ; cnt
    mov edx, 0 ; SOL
while:
    mov ebx, 0
    mov bx, ax
    and bx, 1
    cmp ebx, 1
    jne no
    mov edx, ecx
no:
    inc ecx
    shr eax, 1
    cmp ecx, 16
    jne while

    push edx
    push fmt_int_newline
    call printf
    add esp, 8

    ; TODO c: For every short saved in arr, replace the first byte starting
    ; from the right for the little endian representation of the number that
    ; is equal to 0x34 with 0x61.
    mov ecx, 0 ; cnt
while2:
    mov eax, 0
    mov al, [arr + ecx]
    cmp al, 0x34
    jne ripp
    mov [arr + ecx], byte 0x61
ripp:
    add ecx, 2
    cmp ecx, len
    jne while2

    push arr
    push fmt_chars
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
