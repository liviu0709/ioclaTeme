%include "printf32.asm"
extern printf

section .data

limit dd  120
len equ   10
    fmt_int db "%d ", 0
    fmt_newline db 10, 0
    fmt_int_newline db "%d", 10, 0

section .bss
    ; TODO a: Reserve space for an array of `len` integers. The array name is `int_arr`
    int_arr resd len

section .text
global main

main:
    push ebp
    mov ebp, esp

    ;TODO a: Generate first `len` elements of `int_arr` defined as follows:
    ; int_arr[i] = 17 * i + 3
    mov ecx, 0
while:
    mov edx, 17
    mov eax, ecx
    mul edx
    add eax, 3
    mov [int_arr + 4 * ecx], eax

    inc ecx
    cmp ecx, len
    jne while

    mov ecx, 0
while2:
    pusha
    push dword [int_arr + 4 * ecx]
    push fmt_int
    call printf
    add esp, 8
    popa

    inc ecx
    cmp ecx, len
    jne while2

    push fmt_newline
    call printf
    add esp, 4

    ; TODO b: Count the number of elements strictly smaller than number pointed by `limit`
    mov ecx, 0
    mov edi, 0 ; counter
while3:
    mov eax, [int_arr + 4 * ecx]
    cmp eax, [limit]
    jge nocount
    inc edi
nocount:
    inc ecx
    cmp ecx, len
    jne while3

    push edi
    push fmt_int_newline
    call printf
    add esp, 8

    ; TODO c: Find and print the smallest number strictly greater than number pointed by `limit`
    mov ecx, 0
    mov edi, 0 ; max
while5:
    mov eax, [int_arr + 4 * ecx]
    cmp eax, edi
    jle skip
    mov edi, eax

skip:
    inc ecx
    cmp ecx, len
    jne while5


    mov ecx, 0
    ; get in edi biggest num possible
while4:
    mov eax, [int_arr + 4 * ecx]
    cmp eax, [limit]
    jle nocheck
    cmp eax, edi
    jge nocheck
    mov edi, eax

nocheck:
    inc ecx
    cmp ecx, len
    jne while4

    push edi
    push fmt_int_newline
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
