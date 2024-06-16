%include "printf32.asm"

section .data
    n dd 0x10
    arr dd 118, 2, 88, 16, 17, 13, 8, 15, 338, 78, 10, 4, 2, 3, 5, 16
    len equ $-arr
    res dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    a dd 1
    b dd 25
    printintn db "%d", 10, 0
    printint db "%d ", 0
    printPair db "%d %d", 10, 0

; TODO b: Define res, an array of integers

section .text
extern printf
global main

main:
    push ebp
    mov ebp, esp


    ; TODO a: nr pare in [a, b]
    mov eax, [a]
    mov ebx, [b]
    sub ebx, eax
    shr ebx, 1

    mov ecx, 0 ; incep cu imp

    and eax, 1
    cmp eax, 1 ; -> nu e par
    je nuPar
    inc ebx
    mov ecx, 1 ; incep cu par
nuPar:

    cmp ecx, 1
    je nuPar2

    mov eax, [b]
    and eax, 1
    cmp eax, 1
    je nuPar2
    inc ebx
nuPar2:
    push ebx
    push printintn
    call printf
    add esp, 8



    ; TODO b: Save in res and print all the numbers from arr with an even
    ; index and with the last digit 8
    mov ebx, 0 ; res cnt
    mov ecx, 1
    shl ecx, 2
while:
    shr ecx, 2
    mov eax, [arr + 4 * ecx]

    cmp eax, [a]
    jl noSave
    cmp eax, [b]
    jg noSave

    mov [res + 4 * ebx], eax
    inc ebx

noSave:
    add ecx, 2
    shl ecx, 2
    cmp ecx, len ; nu vrea cu len..
    jl while


    mov ecx, 0
while2:
    mov eax, [res + 4 * ecx]
    pusha
    push eax
    push printint
    call printf
    add esp, 8
    popa
    inc ecx
    cmp ecx, ebx
    jl while2
    ; TODO c: Print all the pairs of numbers on consecutive positions from arr
    ; with the same last bit
    mov ecx, 4
while3:
    mov eax, [arr + ecx - 4]
    mov ebx, [arr + ecx]
    xor eax, ebx
    and eax, 1
    cmp eax, 1
    jne noPrint
    mov eax, [arr + ecx - 4]
    pusha
    push ebx
    push eax
    push printPair
    call printf
    add esp, 12
    popa

noPrint:
    add ecx, 4
    cmp ecx, len
    jl while3
    ; Return 0.
    xor eax, eax
    leave
    ret
