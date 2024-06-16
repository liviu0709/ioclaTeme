%include "printf32.asm"

section .data
    n dd 0x10
    arr dd 118, 2, 88, 16, 17, 13, 8, 15, 338, 78
    len equ $-arr
    intn db "%d", 10, 0
    intnoline dd "%d ", 0
    newline dd "", 10, 0
    pair db "%d %d", 10, 0
    odd db "odd", 10, 0
    even db "even", 10, 0
    ; TODO b: Define res, an array of integers
    res dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 69
section .text
extern printf
global main

main:
    push ebp
    mov ebp, esp


    ; TODO a: Determine, without using div, whether a number is odd or even

    mov ebx, [n]
    and ebx, 1
    cmp ebx, 0
    je evenn
    push odd
    jmp no_even
evenn:
    push even
no_even:

    call printf
    add esp, 4

    ; TODO b: Save in res and print all the numbers from arr with an even
    ; index and with the last digit 8
    mov ecx, 0
    mov edi, 0 ; cnt res
while:
    mov eax, [arr + ecx]
    cmp eax, 10 ;
    jl nodemo
demolish:
    sub eax, 10
    cmp eax, 10
    jge demolish
nodemo:
    and eax, 8
    cmp eax, 0
    je no_8
    mov eax, [arr + ecx]
    mov [res + edi * 4], eax
    inc edi

no_8:
    add ecx, 8
    cmp ecx, len ; len is 40 sooo
    jl while

    mov ecx, 0
while2:
    mov eax, [res + ecx * 4]
    pusha
    push eax
    push intnoline
    call printf
    add esp, 8
    popa
    inc ecx
    cmp ecx, edi
    jne while2

    push newline
    call printf
    add esp, 4

    ; TODO c: Print all the pairs of numbers on consecutive positions from arr
    ; with the same last bit
    mov ecx, 4
for:
    mov eax, [arr + ecx - 4]
    mov ebx, [arr + ecx]
    xor eax, ebx ; and gives 0 with 0 and 0 so not good
    and eax, 1
    cmp eax, 1
    je no_pair
    mov eax, [arr + ecx - 4]
    mov ebx, [arr + ecx]
    pusha
    push ebx
    push eax
    push pair
    call printf
    add esp, 12
    popa
no_pair:
    add ecx, 4
    cmp ecx, len
    jne for

    ; Return 0.
    xor eax, eax
    leave
    ret
