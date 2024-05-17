; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .data
    format_str db "Formatul meu: %s WOW", 10, 0
    format_chr db "Caracter: %c Final", 10, 0
    format_int db "Size stiva: %d", 10, 0

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
    ; cnt for stack size
    mov edi, 0
for:
    xor edx, edx
    mov dl, [ebx + ecx]
    ; if terminator found
    cmp edx, 0
    je finish


    ; verific (
    ; xor edx, edx
    mov dl, [ebx + ecx]
    ; (
    cmp dl, 40
    jne skip1

    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop edx
    ; pop ecx

    inc edi
    push edx
skip1:

    ; verific )
    cmp dl, 41
    jne skip2
    dec edi
    ; if () closed bad
    cmp edi, -1
    je fail
    xor edx, edx
    pop edx

    ; push ecx
    ; push edx
    ; push format_chr
    ; call printf
    ; pop eax
    ; pop edx
    ; pop ecx

    ; sper ca gasesc ( pe stiva
    cmp dl, 40
    jne fail
skip2:

    ; verific [
    ; xor edx, edx
    mov dl, [ebx + ecx]
    ; [
    cmp dl, '['
    jne skip3
    push edx
    inc edi

skip3:
    ; verific ]
    ; xor edx, edx
    mov dl, [ebx + ecx]
    ; ]
    cmp dl, ']'
    jne skip4
    dec edi
    cmp edi, -1
    je fail
    pop edx
    ; sper ca gasesc [ pe stiva
    cmp dl, '['
    jne fail

skip4:
    ; verific {
    ; xor edx, edx
    mov dl, [ebx + ecx]
    ; {
    cmp dl, '{'
    jne skip5
    inc edi
    push edx


skip5:
    ; verific }
    ; xor edx, edx
    mov dl, [ebx + ecx]
    ; }
    cmp dl, '}'
    jne skip6
    dec edi
    cmp edi, -1
    je fail
    pop edx
    ; sper ca gasesc { pe stiva
    cmp dl, '{'
    jne fail
skip6:

    inc ecx
    jmp for
finish:

    ; check if () closed succesfully
    cmp edi, 0
    jne fail
    ; index for

    jmp succes

    ; [
    ; cmp dl, 91

    ; verific {

    ; {
    ; cmp dl, 123

    ; sa-nceapa concursul
fail:

    cmp edi, 0
    jle fail_final
    dec edi
    pop eax
    jmp fail

fail_final:
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
