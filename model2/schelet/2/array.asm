%include "utils/printf32.asm"

extern printf

section .data
    num dd 55555123
    char_f db "%c", 0
    numf db "%u", 10, 0
    charfn db "%c", 10, 0
    newline db "", 10, 0
    arr db "asnsanasdjsdf"
    arr1 db 100, 11, 12, 13, 15
    arr1len dd 5
    arr2 dw 0, 0, 0, 0, 0
    arrlen dd 13
;;  TODO d: declare byte_array so that PRINT_HEX shows babadac
byte_array db 0, 0, 0, 0



section .text
global main

extern printf

; TODO b: implement array_reverse
array_reverse:
    push ebp
    mov ebp, esp

    mov edi, [esp + 8] ; arr
    mov ecx, [esp + 12] ; arr len

    ;mov ecx, [edi + 1] ; 2nd element

    mov edx, 0
swap:
    mov ebx, [edi + edx]
    mov eax, [edi + ecx - 1]



    mov [edi + edx], al
    mov [edi + ecx - 1], bl

    inc edx
    dec ecx
    cmp edx, ecx
    jng swap

    leave
    ret

; TODO c: implement pow_arraypowArray
pow_array:
    push ebp
    mov ebp, esp

    mov edx, [esp + 8] ; arr1
    mov edi, [esp + 12] ; arr2
    mov ecx, [esp + 16] ; len
    mov ebx, 0
whilep:
    xor eax, eax
    mov al, byte [edx + ebx]

    ; al * al
    pusha
    ; la inmultirea byte cu byte, rezultatul se gaseste in ax (NU AL + DL)
    mul al
    xor edx, edx

    mov [edi + ebx * 2], ax

    popa

    inc ebx
    cmp ebx, ecx
    jne whilep

    leave
    ret

main:
    push ebp
    mov ebp, esp

    ;TODO a: allocate on array of 20 byte elements and initializate it incrementally starting from 'A'
    sub esp, 20
    mov ebx, 0
    mov eax, 'A'
for:
    mov [esp + ebx], al
    inc eax
    inc ebx
    cmp ebx, 20
    jne for

    mov ebx, 0
for2:
    push word [esp + ebx]
    push char_f
    call printf
    add esp, 6
    inc ebx
    cmp ebx, 20
    jne for2

    push newline
    call printf
    add esp, 4

    ;TODO b: call array_reverse and print reversed array
    push dword [arrlen]
    push arr
    call array_reverse
    add esp, 8

    mov edx, 0
    mov ecx, [arrlen]
forp:
    mov eax, [edi + edx]

    pusha
    push eax
    push char_f
    call printf
    add esp, 8
    popa

    inc edx
    cmp edx, ecx
    jne forp

    push newline
    call printf
    add esp, 4

    ;TODO c: call pow_array and print the result array

    push dword [arr1len]
    push arr2
    push arr1
    call pow_array
    add esp, 12

    mov edi, arr2
    mov edx, 0
    mov ecx, [arr1len]
forpp:
    xor eax, eax
    mov ax, [edi + 2 * edx]

    pusha
    push eax
    push numf
    call printf
    add esp, 8
    popa

    inc edx
    cmp edx, ecx
    jne forpp



	;;  TODO d: this print of an uint32_t should print babadac
    mov eax, dword 0xbabadac
    ;PRINTF32 `%x\n\x0`, eax
    mov [byte_array], eax
	PRINTF32 `%x\n\x0`, byte_array

    add esp, 20

    xor eax, eax
    leave
    ret
