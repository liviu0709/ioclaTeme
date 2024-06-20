%include "printf32.asm"

section .data
    n dd 4261543935
    arr1 dd 4294574079, 1073741823, 0, 1, 2, 3
    len1 equ $-arr1
    arr2 db 1, 0, 1, 1, 1, 0
    len2 equ $-arr2
    fmt_int_newline db "%d", 10, 0


section .text
extern printf
global main

main:
    push ebp
    mov ebp, esp


    ; TODO a: Determine how many bits are not set for n
    ; HINT: Use not and popcnt

    mov eax, [n]
    not eax
    mov edx, 0 ; cnt 0
    mov ecx, 0 ; cnt while
while:
    mov ebx, eax
    and ebx, 1
    cmp ebx, 1
    jne skipinc
    inc edx
skipinc:
    shr eax, 1
    inc ecx
    cmp ecx, 32
    jne while

    push edx
    push fmt_int_newline
    call printf
    add esp, 8

    ; TODO b: Determine how many values from arr1 don't have 2 bits not set
    mov edi, 0 ; cnt fin
    mov ecx, 0
while2:
    mov eax, [arr1 + ecx]

    push ecx

    ; a) copy paste

    not eax
    mov edx, 0 ; cnt 0
    mov ecx, 0 ; cnt while

whilein:
    mov ebx, eax
    and ebx, 1
    cmp ebx, 1
    jne skipincin
    inc edx
skipincin:
    shr eax, 1
    inc ecx
    cmp ecx, 32
    jne whilein

    pop ecx

    cmp edx, 2
    je skipcnt
    inc edi
skipcnt:

    add ecx, 4
    cmp ecx, len1
    jne while2

    push edi
    push fmt_int_newline
    call printf
    add esp, 8

    ; TODO c: Calculate the decimal value of a number whose bits
    ; are stored in big endian order inside arr2
    mov ebx, 0 ; sol
    mov ecx, len2
    dec ecx
while3:
    mov eax, 0
    mov al, [arr2 + ecx]

    push ecx
    mov esi, len2
    sub esi, ecx
    mov ecx, esi
    dec ecx

    shl eax, cl
    pop ecx
    add ebx, eax

    dec ecx
    cmp ecx, -1
    jne while3

    push ebx
    push fmt_int_newline
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
