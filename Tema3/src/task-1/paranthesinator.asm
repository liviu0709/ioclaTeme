; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .data
    format_str db "Formatul meu: %s WOW", 10, 0
    format_chr db "Caracter: %c Final", 10, 0

section .text
; int check_parantheses(char *str)
global check_parantheses
extern printf
check_parantheses:
    push ebp
    mov ebp, esp
    pusha
    mov ebx, [ebp + 8]
    mov ecx, 0
    mov edi, 0 ; cnt inchidere parant
for:
    xor edx, edx
    mov dl, [ebx + ecx]
    cmp edx, 0
    je finish
    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop eax
    ; pop ecx

    ; verific (
    xor edx, edx
    mov dl, [ebx + ecx]
    cmp dl, 40
    jne skip1
    inc edi
skip1:

    ; verific )
    cmp dl, 41
    jne skip2
    dec edi
    cmp edi, -1
    je fail
skip2:


    inc ecx
    jmp for
finish:

    cmp edi, 0
    jne fail

    mov edi, 0

for2:
    xor edx, edx
    mov dl, [ebx + ecx]
    cmp edx, 0
    je finish2
    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop eax
    ; pop ecx

    ; verific (
    xor edx, edx
    mov dl, [ebx + ecx]
    cmp dl, 91
    jne skip3
    inc edi
skip3:

    ; verific )
    cmp dl, 93
    jne skip4
    dec edi
    cmp edi, -1
    je fail
skip4:


    inc ecx
    jmp for2

finish2:

    cmp edi, 0
    jne fail
    mov edi, 0
for3:
    xor edx, edx
    mov dl, [ebx + ecx]
    cmp edx, 0
    je finish3
    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop eax
    ; pop ecx

    ; verific (
    xor edx, edx
    mov dl, [ebx + ecx]
    cmp dl, 123
    jne skip5
    inc edi
skip5:

    ; verific )
    cmp dl, 125
    jne skip6
    dec edi
    cmp edi, -1
    je fail
skip6:


    inc ecx
    jmp for3

finish3:

    cmp edi, 0
    je succes

    ; sa-nceapa concursul
fail:
    popa
    mov eax, 1
    jmp skip_suc
succes:
    popa
    mov eax, 0
skip_suc:
    leave

    ret
