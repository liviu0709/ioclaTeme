extern strlen
extern printf


section .rodata
    test_str db "hell, it's about time", 0
    format db "length = %d", 10, 0

section .text
global main

strLEN:
    push ebp
    mov ebp, esp

    mov ebx, [ebp + 8] ; char*

    mov dl, [ebx]
    cmp  dl, 0
    je done

    inc eax
    inc ebx
    push ebx
    call strLEN
    add esp, 4

done:
    leave
    ret

main:
    push ebp
    mov ebp, esp



    push test_str
    call strlen
    add esp, 4


    push eax
    push format
    call printf
    add esp, 8


    ; TODO a: Implement strlen-like functionality using a RECURSIVE implementation.

    mov eax, 0

    push test_str
    call strLEN
    add esp, 4

    push eax
    push format
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
