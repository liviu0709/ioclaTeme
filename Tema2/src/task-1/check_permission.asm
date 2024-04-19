%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result
    ;; DO NOT MODIFY

    ;; Your code starts here
    xor eax, eax ; clear
    mov al, [ebp + 8 + 3] ; copy most significant 8 bits to get id
    mov ecx, [ant_permissions + eax * 4] ;; * 4 because unsigned int is 4 bytes

    mov eax, [ebp + 8] ; copy permission + id
    shl eax, 8 ; shift 8 bits to the left to get permission
    shl ecx, 8 ; to compare registers bit with bit
    ; eax has requested rooms
    ; ebx has allowed rooms
    ; if eax has bits that are not in ebx, then it is not allowed
    mov edx, eax ; copy eax for later use
    and eax, ecx ; if eax has bits that are not in ebx, then it is not allowed
    cmp eax, edx
    jne not_allowed
    ; if eax is equal to ecx, then it is allowed
    mov eax, 1 ; return 1

    jmp done ; skip not_allowed

not_allowed:
    mov eax, 0 ; return 0

done:
    mov [ebx], eax ; save solution
    ;; Your code ends here

    ;; DO NOT MODIFY

    popa
    leave
    ret

    ;; DO NOT MODIFY
