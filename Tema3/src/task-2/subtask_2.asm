; subtask 2 - bsearch
section .data
    ; no solution found
    solution dd -1

section .text
    global binary_search
    ;; no extern functions allowed
binary_search:
    ;; create the new stack frame
    enter 0, 0
; binary_search(int32_t *buff, uint32_t needle, uint32_t start, uint32_t end);
    ;; save the preserved registers

    pusha
    ;; recursive bsearch implementation goes here

    ; fastcall -> first 2 arguments in ecx and edx
    ; ecx -> arr
    ; edx -> needle

    ; start
    mov eax, [ebp + 8]
    ; stop
    mov ebx, [ebp + 12]

    cmp eax, ebx
    ; start > stop
    jg end

    ; middle = start
    mov edi, eax
    ; middle += stop
    add edi, ebx
    ; middle /= 2
    shr edi, 1

    ; arr[mid] == needle
    cmp edx, [ecx + edi * 4]
    jne unlucky
    ; save the solution
    mov eax, edi
    ; stop recursivity
    jmp end

unlucky:
    ; stop condition if no match found in start == end
    cmp eax, ebx
    je save_no_sol
    jmp skipp

save_no_sol:
    ; no solution found
    mov eax, -1
    jmp end

skipp:
    ; needle < arr[mid]
    cmp edx, [ecx + edi * 4]
    jl left
    ; right
    inc edi
    ; end
    push ebx
    ; start
    push edi
    call binary_search
    ; clear stack
    add esp, 8
    jmp end

left:
    ; end
    push edi
    ; start
    push eax
    call binary_search
    ; clear stack
    add esp, 8

    ;; restore the preserved registers
end:
    mov [solution], eax
    popa
    mov eax, [solution]



    leave
    ret
