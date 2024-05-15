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
    ; load srt
    mov ebx, [ebp + 8]
    ; index for
    mov ecx, 0
    ; cnt parant
    mov edi, 0
for:
    xor edx, edx
    mov dl, [ebx + ecx]
    ; if terminator found
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
    ; (
    cmp dl, 40
    jne skip1
    inc edi
skip1:

    ; verific )
    cmp dl, 41
    jne skip2
    dec edi
    ; if () closed bad
    cmp edi, -1
    je fail
skip2:


    inc ecx
    jmp for
finish:

    ; check if () closed succesfully
    cmp edi, 0
    jne fail
    ; index for
    mov ecx, 0
    ; cnt parant
    mov edi, 0

for2:
    xor edx, edx
    mov dl, [ebx + ecx]
    ; if terminator found
    cmp edx, 0
    je finish2
    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop eax
    ; pop ecx

    ; verific [
    xor edx, edx
    mov dl, [ebx + ecx]
    ; [
    cmp dl, 91
    jne skip3
    inc edi
skip3:

    ; verific ]
    cmp dl, 93
    jne skip4
    dec edi
    ; if [] closed bad
    cmp edi, -1
    je fail
skip4:


    inc ecx
    jmp for2

finish2:

    ; check if [] closed succesfully
    cmp edi, 0
    jne fail
    ; cnt parant
    mov edi, 0
    ; index for
    mov ecx, 0
for3:
    xor edx, edx
    mov dl, [ebx + ecx]
    ; if terminator found
    cmp edx, 0
    je finish3
    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop eax
    ; pop ecx

    ; verific {
    xor edx, edx
    mov dl, [ebx + ecx]
    ; {
    cmp dl, 123
    jne skip5
    inc edi
skip5:

    ; verific }
    cmp dl, 125
    jne skip6
    dec edi
    ; if {} closed bad
    cmp edi, -1
    je fail
skip6:


    inc ecx
    jmp for3

finish3:

    ; check if {} closed succesfully
    cmp edi, 0
    je succes

    ; sa-nceapa concursul
fail:
    popa
    ; return fail
    mov eax, 1
    jmp skip_suc
succes:
    popa
    ; return succes
    mov eax, 0
skip_suc:
    leave

    ret
