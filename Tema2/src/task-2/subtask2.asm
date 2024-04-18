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
    and ax, 1 ; check if first bite is 1
    cmp ax, 1
    jne no_hacker
    ; check if last bite is 1
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 0x8000 ; 1000 0000 0000 0000
    cmp ax, 0x8000
    jne no_hacker
    ; check least significant byte for even numbers of 1
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 0xFE ; 1111 1110
    ; loop for counting 1
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
    cmp ecx, 8 ; condition for exit
    jne loop_1

    test ebx, 1 ; check if even
    pop ebx
    pop ecx
    jnz no_hacker

; check most significant byte for odd numbers of 1
    mov ax, [ebx + esi + request.login] ; passkey
    and ax, 0x7F00 ; 0111 1111 0000 0000
    shr ax, 8 ; make 0111 1111 0000 0000 -> 0000 0000 0111 1111

    push ecx
    push ebx

    ; loop for counting 1
    xor ecx, ecx ; counter for iter
    xor ebx, ebx ; counter for 1s
loop_2:
    test ax, 1
    jz ripp_2
    inc ebx
ripp_2:
    inc ecx
    shr ax, 1
    cmp ecx, 8 ; condition for exit
    jne loop_2

    test ebx, 1 ; check if odd
    pop ebx
    pop ecx
    jz no_hacker ; if no odd, he legit

    ; set the byte to 1 in sol vector
    pop eax
    mov [eax + edx], byte 1
    jmp skip_pop

no_hacker:
    pop eax
    mov [eax + edx], byte 0 ; set the byte to 0 in sol vector
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