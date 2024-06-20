section .data

prompt db 'Input string:', 0
ok_str db 'c) Perfect. Go on!', 10, 0
notok_str db 'c) Wrong answer. Try again!', 10, 0

fmt db "%x", 10, 0

section .text

global compute
global check_arrays
global read_string

extern printf
extern gets
extern exit

; TODO a: compute(int a, b)

compute:
    push ebp
    mov ebp, esp

    ; preserve `ebx` as per calling convention
    push ebx
    push edi
    push esi

    mov eax, [ebp + 8]
    mov edx, [ebp + 12]

    mov edi, 0x00ff00ff

    cmp eax, 0x0f000000
    jl not_ok

    mov ebx, eax
    and ebx, edi

    cmp ebx, edi
    jne not_ok

    mov ebx, eax
    shr ebx, 1
    xor ebx, edx

    cmp ebx, 0
    jne not_ok

    mov eax, 0
    jmp done

not_ok:
    mov eax, 1

done:
   ; Restore preserved register
    pop esi
    pop edi
    pop ebx

    leave
    ret

; TODO b, check_arrays(int *a, int n, int *b, int m)
check_arrays:
    push ebp
    mov ebp, esp

  ; Preserve registers as per calling convention
    push ebx
    push esi
    push edi

    mov eax, [ebp+12]
    cmp eax, [ebp+20]
    jne arrays_not_ok

    mov edx, [ebp+20]

    cmp edx, 6
    jle arrays_not_ok

    xor ecx, ecx
    mov esi, [ebp+8]
    mov edi, [ebp+16]

check_elements_loop:
    mov eax, [esi + ecx * 4]
    mov ebx, [edi + ecx * 4]

    cmp eax, 100
    jl arrays_not_ok

    shl eax, 2
    cmp eax, ebx
    jne arrays_not_ok

    ; Increment loop counter
    inc ecx
    cmp ecx, [ebp + 12]               ; Compare with array size
    jl check_elements_loop      ; Loop if not end of array

    ; All checks passed
    xor eax, eax                ; Return 0
    jmp end_check_arrays

arrays_not_ok:
    mov eax, 1

end_check_arrays:
    ; Restore preserved registers
    pop edi
    pop esi
    pop ebx

    leave
    ret

; TODO c, void read_string(void)
read_string:
    push ebp
    mov ebp, esp
    sub esp, 4         ; allocate 4 bytes on stack for local var
    sub esp, 256       ; allocate 256 bytes on the stack for the buffer

    lea ebx, [ebp-4]

    lea eax, [ebp-260]
    push eax
    call gets
    add esp, 4

    mov edx, [ebx]
    cmp edx, dword [ebp-260]
    jne not_ok_str

    cmp edx, dword [ebp - 252]
    jne not_ok_str

    xor edx, 0xdeadbeef
    jz go_out

not_ok_str:
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

    push 0
    call exit
    add esp, 4

    leave
    ret
