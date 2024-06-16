section .data

prompt db 'Input string:', 0
ok_str db 'c) Perfect. Go on!', 10, 0
notok_str db 'c) Wrong answer. Try again!', 10, 0

section .text

global compute
global check_array
global read_string

extern printf
extern gets
extern exit

; TODO a: compute(int a, int b, int c)
compute:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    shl edx, 1
    add eax, edx

    mov edx, [ebp + 16]
    shr edx, 2
    add eax, edx

    sub eax, 5

    leave
    ret

; TODO b, check_array(int *vec, int n)
check_array:
    push ebp
    mov ebp, esp

    ; preserve ebx forced by C calling convention
    push ebx

    mov eax, [ebp + 8]   ; vec
    mov ebx, [ebp + 12]  ; n

    cmp ebx, 3
    jl invalid_size
    cmp ebx, 10
    jg invalid_size

    ; Initialize index to 0
    xor ecx, ecx

check_loop:
    cmp ecx, ebx
    jge valid

    mov edx, [eax + ecx*4]

    test edx, 1
    jz invalid

    inc ecx
    jmp check_loop

invalid_size:
    mov eax, -1
    jmp end

invalid:
    mov eax, -1
    jmp end

valid:
    mov eax, 0

end:
    ; restore ebx
    pop ebx

    leave

    ret

; TODO c) void read_string(void)
read_string:
    push ebp
    mov ebp, esp

    sub esp, 128       ; Allocate 128 bytes on the stack for the buffer

    lea eax, [ebp - 128]
    push eax
    call gets
    add esp, 4

    mov ebx, [ebp - 4]
    cmp ebx, 0x50515253
    jnz not_ok

    mov edx, [ebp - 128]
    cmp ebx, edx
    jz go_out

not_ok:
    push notok_str
    call printf
    add esp, 4

    push 0
    call exit
    add esp, 4

go_out:
    leave
    ret

secret_function:
    push ebp
    mov ebp, esp

    push ok_str
    call printf
    add esp, 4

    leave
    ret
