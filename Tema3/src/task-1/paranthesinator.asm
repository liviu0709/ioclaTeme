; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .data
    format_str db "Formatul meu: %s WOW", 10, 0

section .text
; int check_parantheses(char *str)
global check_parantheses
extern printf
check_parantheses:
    push ebp
    mov ebp, esp
    mov ebx, [ebp]
    push ebx
    push format_str
    call printf
    pop eax
    pop eax
    ; sa-nceapa concursul
    mov eax, 10
    push eax
    leave
    ret
