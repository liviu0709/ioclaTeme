%include "printf32.asm"

section .data
    n1 dd 65535
    n2 dd 67174399
    arr1 dd 1, 22, 313, 5125, 818, 0
    len1 equ $-arr1
    arr2 dw 1, 0, -3, 5, 91, -7
    len2 equ $-arr2
    fmtXen db "I am Xen", 10, 0
    fmtNoXen db "I am no Xen", 10, 0
    fmt_int_newline db "%u", 10, 0
    fmt_sint_newline db "%hi", 10, 0
    fmt_int db "%hi ", 0

section .text
global main

extern printf

main:
    push ebp
    mov ebp, esp


    ; TODO a: Determine whether a 4 bytes number has the first 16 bits
    ; equal to the second 16 bits negated
    mov eax, [n1]
    and eax, 0xFFFF ; first half

    mov ebx, eax ; save first half

    mov eax, [n1]
    and eax, 0xFFFF0000 ; 2nd half
    not eax
    xor eax, 0xFFFF

    shr eax, 16 ; move 2nd half on first 2 bytes

    cmp eax, ebx
    jne noXen
    push fmtXen
    jmp skip
noXen:
    push fmtNoXen
skip:
    call printf
    add esp, 4

    mov eax, [n2]
    and eax, 0xFFFF ; first half

    mov ebx, eax ; save first half

    mov eax, [n2]
    and eax, 0xFFFF0000 ; 2nd half
    not eax
    xor eax, 0xFFFF

    shr eax, 16 ; move 2nd half on first 2 bytes

    cmp eax, ebx
    jne noXen1
    push fmtXen
    jmp skip1
noXen1:
    push fmtNoXen
skip1:
    call printf
    add esp, 4

    ; TODO b: Determine the sum of the last digit for the numbers saved
    ; in arr1
    mov ecx, 0 ; cnt while
    mov edi, 0 ; sum

while:

    mov eax, [arr1 + ecx]

    ; div ecx -> eax cat, edx rest
    mov ebx, 10
    div ebx

    add edi, edx

    add ecx, 4
    cmp ecx, len1
    jne while

    pusha
    push edi
    push fmt_int_newline
    call printf
    add esp, 8
    popa


    ; TODO c: Print all pairs from arr2 that have the first number on a 3k
    ; index, the second number on a 3k + 2 index and the second number
    ; equal to the first number negated - 1

    mov ecx, 0 ; k
while2:
    xor eax, eax
    xor ebx, ebx
    mov ax, [arr2 + ecx]
    mov bx, [arr2 + ecx + 4]

    not ax
    dec ax
    cmp eax, ebx
    jne notOk

    pusha
     mov ax, [arr2 + ecx]
    push ax
    push fmt_int
    call printf
    add esp, 6

    popa
    pusha

    push bx
    push fmt_sint_newline
    call printf
    add esp, 6
    popa
notOk:
    add ecx, 6
    mov edi, ecx
    add edi, 4
    cmp edi, len2
    jl while2

    ; Return 0.
    xor eax, eax
    leave
    ret
