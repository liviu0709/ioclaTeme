; Interpret as 64 bits code
[bits 64]

; nu uitati sa scrieti in feedback ca voiati
; assembly pe 64 de biti

section .text
global map
global reduce
; void map(int64_t *destination_array, int64_t *source_array, int64_t array_size, int64_t(*f)(int64_t));
; int64_t map_func1(int64_t curr_elem);
map:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp

    ; rdi -> dst arr
    ; rsi -> src arr
    ; rdx -> arr size
    ; rcx -> f

    ; sa-nceapa turneu'
    mov r8, 0
for:
    cmp r8, rdx
    jge end_for

    push rdi
    ; load current element
    mov rdi, [rsi + 8 * r8]
    call rcx
    ; solution is in rax
    pop rdi
    ; move sol to dst
    mov [rdi + 8 * r8], rax

    inc r8
    jmp for

end_for:
    ;popaq

    leave
    ret


; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp

    ; rdi -> dst arr ; -> useless ?
    ; rsi -> src arr
    ; rdx -> arr size
    ; rcx -> acc
    ; r8 -> f

    ; init index
    mov r9, 0
foor:
    cmp r9, rdx
    jge end_foor

    ; load current elem
    mov rax, [rsi + 8 * r9]
    ; some registers need to be saved
    ; bcz they are modified
    ; why? Irrelevant
    push rdx
    push rdi
    push rsi
    ; current elem
    mov rsi, rax
    ; acc
    mov rdi, rcx
    call r8
    ; save new acc
    mov rcx, rax
    pop rsi
    pop rdi
    pop rdx

    inc r9
    jmp foor

    ; sa-nceapa festivalu'
end_foor:
    ; return solution
    mov rax, rcx
    ;popaq

    leave
    ret

