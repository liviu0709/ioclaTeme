; subtask 1 - qsort

section .text
    global quick_sort
    ;; no extern functions allowed
quick_sort:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    pusha
    ;; recursive qsort implementation goes here
    mov eax, [ebp + 8] ; array
    mov ebx, [ebp + 12] ; start
    mov ecx, [ebp + 16] ; end

    cmp ebx, ecx ; condition to stop
    ; (one element cant be sorted)
    jge stop

    push ecx ; save end
    push ebx ; save start
    mov edx, ebx ; index

for:
    ; condition to swap
    mov edi, [eax + 4 * edx]
    cmp edi, [eax + 4 * ecx]
    jge no_swap

    ; swapping arr[edx] with arr[ebx]
    push edi
    mov edi, [eax + 4 * ebx]
    mov [eax + 4 * edx], edi
    pop edi
    mov [eax + 4 * ebx], edi
    inc ebx
no_swap:
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
    mov edx, ebx ; pivot
    pop ebx ; start first call
    pop ecx ; stop last call
; check if array has more than 2 elems otherwise we finish
    dec edx ; dont include pivot

    cmp edx, ecx ; if we called the func with the same data we send to recursivity
    ; just stop
    je stop

    push edx ; stop
    push ebx ; start
    push eax ; array
    call quick_sort
    add esp, 12

    inc edx
    inc edx ; dont include pivot

    push ecx ; stop
    push edx ; start
    push eax ; array
    call quick_sort
    add esp, 12

stop:
    ;; restore the preserved registers
    popa
    leave
    ret
