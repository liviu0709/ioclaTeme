%include "../include/io.mac"

; declare your structs here

section .data
    format_admin db "Admin: %d", 10, 0
    format_prio db "Priority: %d", 10, 0
    format_user db "Username: %s", 10, 0
    format_passkey db "Passkey: %hu", 10, 0
    format_int db "Edx: %d", 10, 0
    format_int_ecx db "Ecx: %d", 10, 0
    struc creds
        .passkey:    resw 1
        .username:   resb 51
    endstruc

    struc request
        .admin: resb 1
        .prio: resb 1
        .login: resb creds_size
    endstruc

section .text
    global check_passkeys
    extern printf

check_passkeys:
    ;; DO NOT MODIFY
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ;
    ;; DO NOT MODIFY

    ;; Your code starts here
    xor edx, edx
for:
    ; load elem curent
    push eax
    xor eax, eax
    xor esi, esi
    imul esi, edx, request_size
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 1 ; verific daca primul bit este 1
    cmp ax, 1
    jne no_hacker
    ; verific daca ultimul bit este 1
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 0x8000 ; 1000 0000 0000 0000
    cmp ax, 0x8000
    jne no_hacker
    ; verificam cei 7 biti din byteul nesemnificativ
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 0xFE ; 1111 1110
    ; salvam valorile pt ca seg fault
    push ecx
    push ebx

    xor ecx, ecx ; contor loop
    xor ebx, ebx ; contor biti 1
loop_1:
    test ax, 1
    jz ripp
    inc ebx
ripp:
    shr ax, 1
    inc ecx
    cmp ecx, 8 ; cond iesire
    jne loop_1

    test ebx, 1 ; verific daca e par
    pop ebx
    pop ecx
    jnz no_hacker

; verificam cei 7 biti din cel mai semnificativ byte pentru 1
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 0x7F00 ; 0111 1111 0000 0000
    shr ax, 8 ; make 0111 1111 0000 0000 -> 0000 0000 0111 1111

    push ecx
    push ebx

    xor ecx, ecx ; cnt iter
    xor ebx, ebx ; cnt 1
loop_2:
    test ax, 1
    jz ripp_2
    inc ebx
ripp_2:
    inc ecx
    shr ax, 1
    cmp ecx, 8 ; cond iesire
    jne loop_2

    test ebx, 1 ; verificare paritate
    pop ebx
    pop ecx
    jz no_hacker ; daca nu e impar, nu e hacker

    ; salvam rez hacker
    pop eax
    mov [eax + edx], byte 1
    jmp skip_pop

no_hacker:
    pop eax
    mov [eax + edx], byte 0 ; salvam rez non hacker
skip_pop:
    inc edx ; conditii de iesire
    cmp edx, ecx
    jl for
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY