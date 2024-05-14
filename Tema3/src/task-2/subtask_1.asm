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
    ; array
    mov eax, [ebp + 8]
    ; start
    mov ebx, [ebp + 12]
    ; end
    mov ecx, [ebp + 16]

    ; condition to stop
    cmp ebx, ecx
    ; (one element cant be sorted)
    jge stop

    ; save end
    push ecx
    ; save start
    push ebx
    ; index
    mov edx, ebx

for:
    ; condition to swap
    ; arr[edx]
    mov edi, [eax + 4 * edx]
    ; arr[ecx]
    cmp edi, [eax + 4 * ecx]
    jge no_swap

    ; swapping arr[edx] with arr[ebx]
    push edi
    ; arr[ebx]
    mov edi, [eax + 4 * ebx]
    ; arr[edx]
    mov [eax + 4 * edx], edi
    pop edi
    ; arr[ebx]
    mov [eax + 4 * ebx], edi
    inc ebx
no_swap:
    inc edx
    cmp edx, ecx
    jne for


; swap pivot with arr[ebx]
    ; arr[ebx]
    mov edi, [eax + 4 * ebx]
    push edi
    ; arr[ecx]
    mov edi, [eax + 4 * ecx]
    ; arr[ebx]
    mov [eax + 4 * ebx], edi
    pop edi
    ; arr[ecx]
    mov [eax + 4 * ecx], edi

; split array
    ; pivot
    mov edx, ebx
    ; start first call
    pop ebx
    ; stop last call
    pop ecx
; check if array has more than 2 elems otherwise we finish
    ; dont include pivot
    dec edx

    ; if we called the func with the same data we send to recursivity
    cmp edx, ecx
    ; just stop
    je stop

    ; stop
    push edx
    ; start
    push ebx
    ; array
    push eax
    call quick_sort
    ; clear stack
    add esp, 12

    inc edx
    ; dont include pivot
    inc edx

    ; stop
    push ecx
    ; start
    push edx
    ; array
    push eax
    call quick_sort
    ; clear stack
    add esp, 12

stop:
    ;; restore the preserved registers
    popa
    leave
    ret
