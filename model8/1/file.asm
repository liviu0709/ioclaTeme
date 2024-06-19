%include "./utils/printf32.asm"
extern printf

section .data

limit dd  120
len equ   10
fmt_int_newline db "%d", 10, 0
fmt_int db "%d ", 0
fmt_newline db 10, 0

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
    mov eax, ecx
    mov edx, 17
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
    mov edi, 0 ; cnt
    mov ecx, 0
while3:
    mov eax, [int_arr + 4 * ecx]
    cmp eax, [limit]
    jge noInc
    inc edi
noInc:
    inc ecx
    cmp ecx, len
    jne while3

    push edi
    push fmt_int_newline
    call printf
    add esp, 8
    ; TODO c: Find and print the smallest number strictly greater than number pointed by `limit`

    mov edi, 0x7FFFFFFF
    mov ecx, 0
while4:
    mov eax, [int_arr + 4 * ecx]
    cmp eax, [limit]
    jle ripp
    cmp eax, edi
    jge ripp
    mov edi, eax

ripp:
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
