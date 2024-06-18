extern printf
extern scanf

section .data
    fmt_int db "%d", 0
    fmt_int_newline db "%d", 10, 0
    fmt_int_hexa db "%x", 0
    fmt_int_hexa_space db "0x%x ", 0
    fmt_ip db "%d.%d.%d.%d", 10, 0
    newline db 10, 0
    data dd 0
    n dd 5
    arr times 100 dd 0

section .text
global main

; TODO a: Implement `void read_array(int *n, int *v)` which reads
; an integer, stores it at the address pointed by n, and then proceeds
; to read an array of n integers in hex format

read_array:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8] ; &n
    mov edx, [ebp + 12] ; &v

    pusha
    push data
    push fmt_int
    call scanf
    add esp, 8
    popa

    mov ebx, [data]
    mov [eax], ebx

    mov ecx, 0
while:
    pusha
    push data
    push fmt_int_hexa
    call scanf
    add esp, 8
    popa

    mov ebx, [data]
    mov [edx + 4 * ecx], ebx

    inc ecx
    cmp ecx, [eax]
    jne while

    popa
    leave
    ret


; TODO b: Implement `void print_ip(int n)` that prints the ip format
; of n

print_ip:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]

    mov ebx, eax
    and ebx, 0xFF ; first byte

    mov ecx, eax
    and ecx, 0xFF00 ; 2nd byte
    shr ecx, 8

    mov edx, eax
    and edx, 0xFF0000 ; 3rd byte
    shr edx, 16

    mov edi, eax
    and edi, 0xFF000000 ; 4th byte
    shr edi, 24

    push ebx
    push ecx
    push edx
    push edi
    push fmt_ip
    call printf
    add esp, 20

    popa
    leave
    ret

; TODO c: Implement `int fibo(int n)` that recursively determines
; the nth Fibonacci sequence element

fibo:
    push ebp
    mov ebp, esp


    mov ebx, [ebp + 8]

    cmp ebx, 0
    je zero
    cmp ebx, 1
    je unu

    dec ebx
    push ebx
    push ecx
    push ebx
    call fibo
    add esp, 4
    pop ecx
    pop ebx

    mov ecx, eax


    dec ebx
    push ecx
    push ebx
    push ebx
    call fibo
    add esp, 4
    pop ebx
    pop ecx

    add ecx, eax

    mov eax, ecx
    jmp end

unu:
    mov eax, 1
    jmp end
zero:
    mov eax, 0
    jmp end
end:
    leave
    ret

main:
    push ebp
    mov ebp, esp


    ; TODO a: Call `read_array` with the address of a variable saved
    ; wherever as the length of the array and the array saved in a
    ; section of your choice
    ; NOTE: You must print the array afterwards in hex format

    push arr
    push n
    call read_array
    add esp, 8

    mov ecx, 0
while2:
    mov eax, [arr + 4 * ecx]
    pusha
    push eax
    push fmt_int_hexa_space
    call printf
    add esp, 8
    popa

    inc ecx
    cmp ecx, [n]
    jne while2

    push newline
    call printf
    add esp, 4

    ; TODO b: Call `print_ip` with the first element stored
    ; in the array read at task a

    mov eax, [arr]
    push eax
    call print_ip
    add esp, 4


    ; TODO c: Call `fibo` with a value for n of your choice
    ; NOTE: You must print the result afterwards

    push dword [n]
    call fibo
    add esp, 4

    push eax
    push fmt_int_newline
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
