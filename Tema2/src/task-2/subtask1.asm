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
    mov esi, ecx ; init contor nrElem
    ; sortam vectorul folosind cea mai simpla metoda de sortare
    ; posibila (bubble sort)

first_for: ; primul for
    dec esi ; decrementam contor
    jz done ; cond oprire
    mov edi, ebx ; element curent
    mov edx, esi ; counter loop inner

second_for:
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
    ja swap ; daca prioritatea e mai mare, fac swap

    cmp al, [edi + request.prio + request_size] ; daca nu au prioritatea egala, trec mai departe
    jne next

    ; avand prioritate si grad de admin egal, compar user :/
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
    mov ebx, request_size ; contor loop
swap_loop:
    mov al, [edi] ; bit din primul elem
    xchg al, [edi + request_size] ; schimb bitul din primul elem cu cel din al doilea
    mov [edi], al ; pun bitul din al doilea elem in primul
    inc edi ; trec la urmatorul bit
    dec ebx ; decrementez contorul
    jnz swap_loop
    sub edi, request_size ; revin la primul elem

    pop ebx

next:
    add edi, request_size ; trec la urmatorul elem
    dec edx ; decrementez contorul
    jnz second_for
    jmp first_for

done:


    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY