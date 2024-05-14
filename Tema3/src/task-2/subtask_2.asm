; subtask 2 - bsearch
section .data
    format_int db "Start: %u Stop: %u", 10, 0
    format_data db "Cui: %u, start: %u, stop: %u", 10, 0
    format_cui db "Cui: %u", 10, 0
    format1 db "Ceva: %u", 10, 0
    solution dd -1

section .text
    global binary_search
    ;; no extern functions allowed
extern printf
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

    pusha
    push edx
    push format1
    call printf
    add esp, 8
    popa

    mov edi, eax ; middle = start
    add edi, ebx ; middle += stop
    shr edi, 1 ; middle /= 2

    cmp edx, [ecx + edi * 4] ; arr[mid] == needle
    jne unlucky
    mov [solution], edi ; save the solution
    jmp end ; stop recursivity
unlucky:

    ; stop condition if no match found in start == end
    cmp eax, ebx
    je end

    cmp edx, [ecx + edi * 4]
    jl left ; needle < arr[mid]
    ; right
    inc edi

    push eax
    push ebx ; end
    push edi ; start
    call binary_search
    add esp, 8
    cmp eax, -1
    je no_solution
    mov [solution], eax
no_solution:
    pop eax



    jmp end
left:
    cmp edi, 0
;     jz skip_dec
;     dec edi
; skip_dec:
    pusha
    push edi
    push eax ; start
    push format_int
    call printf
    add esp, 12
    popa

    push eax
    push edi ; end
    push eax ; start
    call binary_search
    add esp, 8
    cmp eax, -1
    je no_solution2
    mov [solution], eax
no_solution2:
    pop eax




    ;; restore the preserved registers
end:
    popa
    mov eax, [solution]

    pusha
    push eax ; solution
    push format_cui
    call printf
    add esp, 8
    popa

    leave
    ret
