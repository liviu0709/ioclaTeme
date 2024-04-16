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
    global sort_requests
    extern printf

sort_requests:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    mov edx, 0
    push edx
    push ecx
    push edx
    push format_int
    call printf
    pop eax
    pop eax
    pop ecx
    pop edx
for:
    ; check if admin
    xor eax, eax
    imul edi, edx, 55 ; 55 = sizeof(request)
    mov al, [ebx + edi] ; al is 1 byte = sizeof(char) = sizeof(request.admin)
    push edx
    push ecx
    push eax
    push format_admin
    call printf
    pop eax
    pop eax
    pop ecx
    pop edx

    ; get priority
    xor eax, eax
    mov al, [ebx + 1 + edi]
    push edx
    push ecx
    push eax
    push format_prio
    call printf
    pop eax
    pop eax
    pop ecx
    pop edx

    ; get passkey
    mov eax, [ebx + 2 + edi] ; eax = &request.login.passkey
    push edx
    push ecx
    push eax
    push format_passkey
    call printf
    pop eax
    pop eax
    pop ecx
    pop edx
    ; get username
    ; lea not mov bcz we need to copy address of username
    lea eax, [ebx + 4 + edi] ; eax = &request.login.username
    push edx
    push ecx
    push eax
    push format_user
    call printf
    pop eax
    pop eax
    pop ecx
    pop edx


    

    inc edx
    cmp edx, ecx
    jng for
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY