%include "utils/printf32.asm"


section .data
    arr1 db 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x99, 0x88
    len1 equ $-arr1
    arr2 db 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef
    len2 equ $-arr2
    val1 dd 0xabcdef01
    val2 dd 0x62719012

    formatSign db "Sign bit", 10, 0
    formatNoSign db "No sign bit", 10, 0
    formatInt db "Number of bits for integer value: %d", 10, 0

section .text
global main

extern printf

main:
    push ebp
    mov ebp, esp


    ; TODO a: Print if sign bit is present or not.
    mov ebx, [val1]
    and ebx, 0x80000000

    cmp ebx, 0
    je noSign

    mov eax, formatSign
    push eax
    call printf
    add esp, 4
    jmp skipNo

noSign:
    mov eax, formatNoSign
    push eax
    call printf
    add esp, 4

skipNo:
    mov ebx, [val2]
    and ebx, 0x80000000

    cmp ebx, 0
    je noSign2

    mov eax, formatSign
    push eax
    call printf
    add esp, 4
    jmp b

noSign2:
    mov eax, formatNoSign
    push eax
    call printf
    add esp, 4

b:
    ; TODO b: Prin number of bits for integer value.
    mov ebx, [val1]

    mov eax, 0 ; Counter for number of bits 1.
    mov ecx, 0 ; Counter for number of bits.

while:
    test ebx, 1
    jz rip
    inc eax
rip:
    shr ebx, 1
    inc ecx
    cmp ecx, 32
    je end
    jmp while
end:

    mov ecx, formatInt
    push eax
    push ecx
    call printf
    add esp, 8

mov ebx, [val2]

    mov eax, 0 ; Counter for number of bits 1.
    mov ecx, 0 ; Counter for number of bits.

while2:
    test ebx, 1
    jz rip2
    inc eax
rip2:
    shr ebx, 1
    inc ecx
    cmp ecx, 32
    je end2
    jmp while2
end2:

    mov ecx, formatInt
    push eax
    push ecx
    call printf
    add esp, 8

    ; TODO c: Prin number of bits for array.
    mov eax, 0 ; Counter for array num.
    mov edx, 0 ; Counter for number of bits 1.
outer_while:
    xor ebx, ebx
    mov bl, [arr1 + eax]

    mov ecx, 0 ; Counter for number of bits.

while3:
    test ebx, 1
    jz rip3
    inc edx
rip3:
    shr ebx, 1
    inc ecx
    cmp ecx, 32
    je end3
    jmp while3
end3:

    inc eax
    cmp eax, len1
    je end_outer
    jmp outer_while
end_outer:



    mov ecx, formatInt
    push edx
    push ecx
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
