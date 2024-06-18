extern printf
extern atoi

section .data
    fmt_int db "%d ", 0
    fmt_int_newline db "%d", 10, 0
    fmt_int_space db "%d ", 0
    fmt_str db "%s", 10, 0
    fmt_char db "%c", 10, 0
    newline db 10, 0

section .text
global main

; TODO c: Implement `int to_int(int n, int *v)` that concatenates
; all n numbers from v into a new one
; It is guaranteed that the result will fit into an int value

to_int:
    push ebp
    mov ebp, esp

    mov ecx, [ebp + 8] ; n
    mov ebx, [ebp + 12] ; &v

    mov esi, 0 ; sol
    mov edx, 0
for:
    mov eax, [ebx + 4 * edx]
    push ecx
    push eax
    push edx
    ; inmultire cu 10 de edx ori

    mov edi, 0
    sub ecx, edx
    dec ecx
    mov edx, ecx
    cmp edi, ecx
    je noInc
for2:
    mov ecx, 10
    push edx
    mul ecx
    pop edx
    inc edi
    cmp edi, edx
    jne for2
noInc:
    add esi, eax

    pop edx
    pop eax
    pop ecx

    inc edx
    cmp edx, ecx
    jne for

    mov eax, esi

    leave
    ret

main:
    push ebp
    mov ebp, esp

    ; TODO a: Traverse all command-line arguments and compute
    ; how many of them represent a natural number
    ; The result value must be placed on stack
    ; NOTE: You must print the result afterwards
    ; HINT: man atoi (https://man7.org/linux/man-pages/man3/atoi.3.html)


    mov edx, [ebp + 8] ; argc
    mov ecx, [ebp + 12] ; **argv

    sub esp, 4
    mov dword [esp], 0 ; save n on stack

    mov edi, 1
    cmp edi, edx
    je nono
while:
    mov eax, [ecx + 4 * edi] ; *argv -> arg str

    push ebx
    push ecx
    push edx
    push edi
    push eax
    call atoi
    add esp, 4
    pop edi
    pop edx
    pop ecx
    pop ebx

    cmp eax, 0
    jle noSave
    mov ebx, [esp]
    inc ebx
    mov [esp], ebx

noSave:
    inc edi
    cmp edi, edx
    jne while
nono:
    mov eax, esp
    pusha
    push dword [eax]
    push fmt_int_newline
    call printf
    add esp, 8
    popa

    ; TODO b: Convert all command-line arguments that represent a
    ; number to int and save them in an array placed on stack
    ; NOTE: You must print the array afterwards; you may use the
    ; value computed at task a in doing so
    ; HINT: man atoi (https://man7.org/linux/man-pages/man3/atoi.3.html)

    mov eax, esp ; &n
    mov esi, [eax] ; n

    sub esp, esi
    sub esp, esi
    sub esp, esi
    sub esp, esi ; alloc int array

    ; mov edx, [ebp + 8] ; argc
    ; mov ecx, [ebp + 12] ; **argv
    mov ebx, 0 ; data on stack
    mov edi, 1
    cmp edi, edx
    je nonono
while2:
    push ebx
    mov ebx, [ecx + 4 * edi] ; *argv -> arg str

    push ecx
    push edx
    push edi
    push ebx
    call atoi
    add esp, 4
    pop edi
    pop edx
    pop ecx
    pop ebx

    cmp eax, 0
    jle noSave2
    mov [esp + 4 * ebx], eax
    inc ebx

noSave2:
    inc edi
    cmp edi, edx
    jne while2
nonono:

    mov ecx, 0
while3:
    mov eax, [esp + 4 * ecx]

    pusha
    push eax
    push fmt_int
    call printf
    add esp, 8
    popa

    inc ecx
    cmp ecx, esi
    jne while3

    pusha
    push newline
    call printf
    add esp, 4
    popa
    ; TODO c: Call `to_int` with the value computed at task a and
    ; the array got at task b

    push esp
    push esi
    call to_int
    add esp, 8

    push eax
    push fmt_int_newline
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
