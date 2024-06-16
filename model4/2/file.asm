extern printf
extern scanf

section .data
    fmt_int db "%d", 0
    fmt_int_newline db "%d", 10, 0
    fmt_int_space db "%d ", 0
    newline db 10, 0
    N dd 13321
    arr times 100 dd 0
    res times 100 dd 0
    readint dd 0

section .text
global main

; TODO a: Implement `void pow4(int n)` which modifies the
; integer pointed by n by calculating 4 to the power of n
; In other words, *n = 4 ^ (*n)

palindrom:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8] ; n
    cmp eax, 10
    jl exit1

    mov ebx, 0
for:
    mov edx, 0
    mov ecx, 10
    div ecx ; eax cat, edx rest

    inc ebx
    push edx ; save on stack digits

    cmp eax, 0
    ; cmp ebx, 5
    je finish
    jmp for
finish:

    ; ebx -> number of digits

    mov eax, [ebp + 8]
for2:
    mov edx, 0
    mov ecx, 10
    div ecx ; -> eax cat ; edx rest

    pop ecx
    cmp ecx, edx
    jne exit0

    dec ebx
    cmp ebx, 0
    jnz for2

    jmp exit1

exit0:
    mov eax, 0
    jmp ripp
exit1:
    mov eax, 1
ripp:
    leave
    ret

; TODO b: Implement `void read_array(int *n, int *v)` which reads
; an integer, stores it at the address pointed by n, and then proceeds
; to read an array of n integers

read_array:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8] ; &n
    ; mov eax, [eax] ; n
    mov ebx, [ebp + 12] ; &v

    pusha
    push readint
    push fmt_int
    call scanf
    add esp, 8
    popa

    mov edi, [readint]

    mov [eax], edi

    mov eax, [eax]

    mov edx, 0
repeatt:
    pusha
    push readint
    push fmt_int
    call scanf
    add esp, 8
    popa

    mov edi, [readint]
    mov [ebx + 4 * edx], edi

    inc edx
    cmp edx, eax
    jne repeatt

    ; push newline
    ; call printf
    ; add esp, 4

    leave
    ret

; TODO c: Implement `void print_array(int n, int *v)` that prints
; the elements of the array stored in v of n integers.

print_array:
    push ebp
    mov ebp, esp

mov eax, [ebp + 8] ; n
    mov ebx, [ebp + 12] ; v

    mov edx, 0
anotherfor:
    pusha
    push dword [ebx + 4 * edx]
    push fmt_int_space
    call printf
    add esp, 8
    popa

    inc edx
    cmp edx, eax
    jne anotherfor

    push newline
    call printf
    add esp, 4


    leave
    ret

; TODO d: Implement `void map_array(int n, int *v, void (*f)(int *))`
; which updates every element of the array by applying the function
; sent as the third parameter

map_array:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8] ; n
    mov ebx, [ebp + 12] ; v
    mov ecx, [ebp + 16] ; palindrom
    mov esi, 0
    mov edx, 0
forEach:
    mov edi, [ebx + 4 * edx]
    pusha

    push edi
    call ecx
    add esp, 4

    cmp eax, 1
    jne noSavee
    mov [res + 4 * esi], edi
    popa
    inc esi
    jmp nopopa
noSavee:

    popa
nopopa:
    inc edx
    cmp edx, eax
    jne forEach

    leave
    ret

main:
    push ebp
    mov ebp, esp

    ; TODO a: Call `pow4` with the value N, stored in .data
    ; NOTE: You must print the modified value of N afterwards
    push dword [N]
    call palindrom
    add esp, 4

    push eax
    push fmt_int_newline
    call printf
    add esp, 8

    ; TODO b: Call `read_array` with the address of a variable saved
    ; on stack as the length of the array and the array saved in a
    ; section of your choice
    ; NOTE: You must print the array afterwards by using the function
    ; implemented at TODO c

    sub esp, 4
    mov dword [esp], 4
    mov eax, esp ; save address
    pusha
    push arr
    push eax ; push address
    call read_array
    add esp, 8
    popa

    pusha
    push arr
    push dword [eax]
    call print_array
    add esp, 8
    popa

    ; TODO d: Call `map_array` with the length and array read at the
    ; first task and `pow4` as the third argument
    ; NOTE: You must print the array afterwards by using the function
    ; implemented at TODO c

    pusha
    push palindrom
    push arr
    push dword [eax]
    call map_array
    add esp, 12
    popa

    push res
    push dword [eax]
    call print_array
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
