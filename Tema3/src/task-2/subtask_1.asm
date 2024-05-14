; subtask 1 - qsort
section .data
    format_int db "Start: %u Stop: %u", 10, 0
    format_int1 db "Apel1: %u Stop: %u", 10, 0
    format_int2 db "Final?: %u Stop: %u", 10, 0

section .text
    global quick_sort
    ;; no extern functions allowed
extern printf
quick_sort:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    pusha
    ;; recursive qsort implementation goes here
    mov eax, [ebp + 8] ; array
    mov ebx, [ebp + 12] ; start
    mov ecx, [ebp + 16] ; end

    cmp ebx, ecx

    jge stop
    push ecx
    push ebx
    mov edx, ebx

    pusha
    push ecx
    push ebx
    push format_int
    call printf
    add esp, 12
    popa
for:
    mov edi, [eax + 4 * edx]
    cmp edi, [eax + 4 * ecx]
    jge no_swap


    push edi
    mov edi, [eax + 4 * ebx]
    mov [eax + 4 * edx], edi
    pop edi
    mov [eax + 4 * ebx], edi
    inc ebx
    jmp skip
no_swap:
skip:
    inc edx
    cmp edx, ecx
    jne for


; swap pivot with arr[ebx]
    mov edi, [eax + 4 * ebx]
    push edi
    mov edi, [eax + 4 * ecx]
    mov [eax + 4 * ebx], edi
    pop edi
    mov [eax + 4 * ecx], edi

; split array
    mov edx, ebx
    pop ebx
    pop ecx
; check if array has more than 2 elems otherwise we finish
    dec edx ; dont include pivot

    cmp edx, ecx ; if we called the func with the same data we send to recursivity
    ; just stop
    je stop




    pusha
    push edx
    push ebx
    push format_int
    call printf
    add esp, 12
    popa

    push edx ; stop
    push ebx ; start
    push eax ; array
    call quick_sort
    add esp, 12

    inc edx
    inc edx ; dont include pivot

    pusha
    push ecx
    push edx
    push format_int
    call printf
    add esp, 12
    popa

    push ecx ; stop
    push edx ; start
    push eax
    call quick_sort
    add esp, 12

stop:
    ;; restore the preserved registers
    popa
    leave
    ret
