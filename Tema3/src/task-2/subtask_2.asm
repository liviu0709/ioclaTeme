; subtask 2 - bsearch
section .data
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

    mov eax, [ebp + 8] ; start
    mov ebx, [ebp + 12] ; stop

    cmp eax, ebx
    jg end ; start > stop

    mov edi, eax ; middle = start
    add edi, ebx ; middle += stop
    shr edi, 1 ; middle /= 2

    cmp edx, [ecx + edi * 4] ; arr[mid] == needle
    jne unlucky
    mov eax, edi ; save the solution
    jmp end ; stop recursivity

unlucky:
    ; stop condition if no match found in start == end
    cmp eax, ebx
    je save_no_sol
    jmp skipp

save_no_sol:
    mov eax, -1
    jmp end

skipp:
    cmp edx, [ecx + edi * 4]
    jl left ; needle < arr[mid]
    ; right
    inc edi
    push ebx ; end
    push edi ; start
    call binary_search
    add esp, 8
    jmp end

left:
    push edi ; end
    push eax ; start
    call binary_search
    add esp, 8

    ;; restore the preserved registers
end:
    mov [solution], eax
    popa
    mov eax, [solution]



    leave
    ret
