%include "utils/printf32.asm"

section .data
    num dd 55555123
    num_a1 db "a. %d", 0
    num_a2 db "%d", 10, 0
    num_b db "b. %d", 10, 0
    num_c db "c. %d", 10, 0

section .text
global main

extern printf

main:
    push ebp
    mov ebp, esp

    ;TODO a: print least significant 2 bits of the second most significant byte of num
    mov eax, [num + 2]
    and eax, 0x2

    cmp eax, 2
    shr eax, 1
    push eax
    push num_a1
    call printf
    add esp, 8


    mov eax, [num + 2]
    and eax, 0x1
    cmp eax, 1
    push eax
    push num_a2
    call printf
    add esp, 8

    ;TODO b: print number of bits set on odd positions

    mov ebx, 0

    mov eax, [num]
    mov ecx, 0
while:
    test ecx, 1
    jnz noInc
    test eax, 1
    jz noInc
    inc ebx

noInc:
    shr eax, 1
    inc ecx
    cmp ecx, 32
    je out
    jmp while
out:

    push ebx
    push num_b
    call printf
    add esp, 8

    ;TODO c: print number of groups of 3 consecutive bits set
    mov eax, [num]
    mov ecx, 0
    mov ebx, 0
while2:
    mov edx, eax ; copy eax
    and edx, 7 ; get first 3 bits
    cmp edx, 7 ; apply mask
    jne noIncnoRot
    inc ebx
noIncnoRot:
    shr eax, 1
    inc ecx
    cmp ecx, 32
    jne while2

    push ebx
    push num_c
    call printf
    add esp, 8

    xor eax, eax
    leave
    ret
