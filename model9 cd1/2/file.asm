extern puts
extern printf

section .rodata
    format db "%u ", 0
    fmt_int_newline db "%d", 10, 0
    puts_format db "", 0
    newline db 10, 0

section .data
    arr1 dd 10, 20, 30, 40, 50, 60, 70, 80, 11, 22, 33, 44, 55, 66, 77, 88, 99
    ; b) c) Test with k = 1, 7, 0, 17, 18
    len1 equ 17
    k equ 18

section .bss
    dest resd 100

section .text
global main

elem_adj:
    push ebp
    mov ebp, esp
    pusha
    ; TODO b: Implement adjacent computing function:
    ; elem_adj(unsigned int len, int k, unsigned int *v, unsigned int *w)

    mov ecx, [ebp + 8] ; n
    mov edx, [ebp + 12] ; k
    mov ebx, [ebp + 16] ; &v
    mov edi, [ebp + 20] ; &w

    cmp edx, ecx
    jle oki
    mov edx, ecx
oki:

    cmp edx, 1
    jl nomul
    mov esi, 0
    dec edx
while2:
    push edx
    mov eax, [ebx + 4 * esi]
    mov edx, [ebx + 4 * esi + 4]
    mul edx
    mov [edi + 4 * esi], eax
    pop edx

    inc esi
    cmp esi, edx
    jl while2

    inc edx

    cmp edx, 0
    je nomul
    mov eax, [ebx + 4 * edx - 4]
    push edx
    cmp edx, ecx
    jne notfirst
    mov edx, [ebx]
    jmp nononoskip
notfirst:
    mov edx, [ebx + 4 * edx]
nononoskip:
    mul edx
    pop edx
    mov [edi + 4 * edx - 4], eax
nomul:

    cmp edx, ecx
    je noadd
    mov esi, edx
    dec ecx
while3:
    mov eax, [ebx + 4 * esi]
    push edx
    mov edx, [ebx + 4 * esi + 4]
    add eax, edx
    pop edx
    mov [edi + 4 * esi], eax
    inc esi
    cmp esi, ecx
    jne while3
    inc ecx
    ; last elem tba
    mov eax, [ebx + 4 * ecx - 4]
    push edx
    mov edx, [ebx]
    add eax, edx
    pop edx
    mov [edi + 4 * ecx - 4], eax

noadd:
    popa
    leave
    ret

elem_inplace:
    push ebp
    mov ebp, esp

    ; TODO c: Implement inplace computing function:
    ; elem_inplace(unsigned int len, int k, unsigned int *v)

    mov ecx, [ebp + 8] ; n
    mov edx, [ebp + 12] ; k
    mov ebx, [ebp + 16] ; &v

    mov edi, [ebx]
    push edi

    cmp edx, ecx
    jle verygood
    mov edx, ecx
verygood:
    mov esi, 0
while4:
    dec ecx
    cmp esi, edx
    jge addadd

    mov eax, [ebx + 4 * esi]
    push edx
    cmp esi, ecx
    jne nice
    pop edx
    pop edi
    push edx
    mov edx, edi ; saved first elem(nu e nev sa il pun pe stiva, dar...)
    jmp defnoskip
nice:
    mov edx, [ebx + 4 * esi + 4]
defnoskip:
    mul edx
    pop edx
    mov [ebx + 4 * esi], eax
    jmp noaddskip
addadd:
    mov eax, [ebx + 4 * esi]
    push edx
    cmp esi, ecx
    jne nicenice
    pop edx
    pop edi
    push edx

    mov edx, edi
    jmp skiphellna
nicenice:
    mov edx, [ebx + 4 * esi + 4]
skiphellna:
    add eax, edx
    pop edx
    mov [ebx + 4 * esi], eax
noaddskip:
    inc ecx
    inc esi
    cmp esi, ecx
    jne while4

    leave
    ret

print_v:
    push ebp
    mov ebp, esp
    pusha
    ; TODO a: Implement array printing function:
    ; print_v(unsigned int len, unsigned int *v);

    mov ecx, [ebp + 8] ; n
    mov ebx, [ebp + 12] ; &v

    mov edx, 0
while:
    pusha
    push dword [ebx + 4 * edx]
    push format
    call printf
    add esp, 8
    popa

    inc edx
    cmp edx, ecx
    jne while

    push newline
    call printf
    add esp, 4

    popa
    leave
    ret


main:
    push ebp
    mov ebp, esp


    ; Print arr1 using print_arr.
    push arr1
    push len1
    call print_v
    add esp, 8

    ; Compute elems in dest using elem_adj.
    ; elem_adj(unsigned int len, int k, unsigned int *v, unsigned int *w)
    push dest
    push arr1
    push k
    push len1
    call elem_adj
    add esp, 16
    ; Print dest using print_arr.

    push dest
    push len1
    call print_v
    add esp, 8
    ; Compute elem_inplace in arr1.
    ; elem_inplace(unsigned int len, int k, unsigned int *v)
    push arr1
    push k
    push len1
    call elem_inplace
    add esp, 8
    ; Print arr1 using print_arr.
    push arr1
    push len1
    call print_v
    add esp, 8
    ; Return 0.
    xor eax, eax
    leave
    ret
