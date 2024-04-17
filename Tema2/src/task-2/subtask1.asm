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
    mov esi, ecx


outer_loop:
    dec esi
    jz done ; cond oprire
    mov edi, ebx ; element curent
    mov edx, esi ; counter loop inner

inner_loop:
    xor eax, eax
    ; compar adminii
    mov al, [edi]
    cmp al, [edi + request_size]
    jl swap ; daca ordinea nu e buna, fac swap

    cmp al, [edi + request_size] ; daca unul e admin si altul nu, trec mai departe
    jne next

    ; compar prioritatile daca adminii sunt egali
    mov al, [edi + request.prio]
    cmp al, [edi + request.prio + request_size]
    jg swap ; daca prioritatea e mai mare, fac swap

    cmp al, [edi + request.prio + request_size] ; daca nu au prioritatea egala, trec mai departe
    jne next

    ; avand prioritate si grad de admin egal, compar user ;/
    push ecx    ; salvam registrii ca sa nu dea segfault
    push ebx
    push esi
    mov ecx, 51
    lea esi, [edi + request.login + 2] ; adresa user curent
    lea ebx, [edi + request.login + 2 + request_size] ; adresa user urmator
compare_char:
    xor eax, eax
    mov al, [esi] ; caracter curent user curent
    cmp al, [ebx] ; caracter curent user urmator
    jne not_equal ; daca nu sunt egale, pot afla ordinea lor!
    inc esi ; trec la urmatorul caracter
    inc ebx ; trec la urmatorul caracter
    dec ecx ; decrementez contorul
    jnz compare_char ; daca nu am terminat, repet

    pop esi ; da segfault daca nu salvam valorile
    pop ebx
    pop ecx

    jmp next ; dam skip la swap

not_equal:
    pop esi ; da segfault daca nu salvam valorile
    pop ebx
    pop ecx
    ; daca nu sunt ordonate alfabetic, fac swap
    jg swap
    ; altfel trec mai departe
    jmp next



swap:
    ; salvez ebx
    push ebx
    mov ebx, request_size
swap_loop:
    mov al, [edi]
    xchg al, [edi + request_size]
    mov [edi], al
    inc edi
    dec ebx
    jnz swap_loop
    sub edi, request_size
    
    pop ebx

next:
    add edi, request_size
    dec edx
    jnz inner_loop
    jmp outer_loop

done:

    mov edx, 0
    ;mov ecx, 0

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
    jne for

    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY