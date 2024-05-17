; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses

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

    ; check (
    mov dl, [ebx + ecx]
    cmp dl, '('
    jne skip1
    inc edi
    push edx

skip1:
    ; check )
    cmp dl, ')'
    jne skip2
    dec edi
    ; if () closed bad
    cmp edi, -1
    je fail
    pop edx
    ; i want ( on stack
    cmp dl, '('
    jne fail

skip2:
    ; check [
    mov dl, [ebx + ecx]
    cmp dl, '['
    jne skip3
    push edx
    inc edi

skip3:
    ; check ]
    mov dl, [ebx + ecx]
    cmp dl, ']'
    jne skip4
    dec edi
    ; if [] closed bad
    cmp edi, -1
    je fail
    pop edx
    ; i want [ on stack
    cmp dl, '['
    jne fail

skip4:
    ; check {
    mov dl, [ebx + ecx]
    cmp dl, '{'
    jne skip5
    inc edi
    push edx

skip5:
    ; check }
    mov dl, [ebx + ecx]
    cmp dl, '}'
    jne skip6
    dec edi
    ; if {} closed bad
    cmp edi, -1
    je fail
    pop edx
    ; i want { on stack
    cmp dl, '{'
    jne fail

skip6:
    inc ecx
    jmp for

finish:
    ; check if all paranthesis closed succesfully
    cmp edi, 0
    jne fail
    jmp succes

fail:
    ; check if stack empty
    cmp edi, 0
    ; if its not empty, clear it
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
