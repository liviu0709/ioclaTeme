extern scanf
extern printf


section .data
    uint_format    db "%zu", 0
    uint_format_newline    db "%zu", 10, 0
    pos1_str    db "Introduceti prima pozitie: ", 0
    pos2_str   db "Introduceti a doua pozitie: ", 0
    sum_str db "Suma este: %zu", 10, 0
    sum_interval_str db "Suma de la pozitia %zu la pozitia %zu este %zu", 10, 0
    arr     dd 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400
    start dd 0
    stop dd 100


section .text
global main


sum:
    push ebp
    mov ebp, esp


    ; TODO b: Implement sum() to compute sum for array.
    mov ecx, [ebp + 8] ; arr
    mov ebx, [ebp + 12] ; len

    mov eax, 0 ; sum
    mov edx, 0 ; cnt
while:
    add eax, [ecx + 4 * edx]

    inc edx
    cmp edx, ebx
    je end
    jmp while

end:
    leave
    ret


sum_interval:
    push ebp
    mov ebp, esp

    ; TODO b: Implement sum_interval() to compute sum for array between two positions.
    mov eax, 0 ; sum
    mov ebx, [ebp + 8] ; arr
    mov ecx, [ebp + 12] ; start
    mov edx, [ebp + 16] ; end

for:
    add eax, [ebx + 4 * ecx]

    inc ecx
    cmp ecx, edx
    jl for

    leave
    ret


main:
    push ebp
    mov ebp, esp


    push dword 14
    push arr
    call sum
    add esp, 8

    push eax
    push sum_str
    call printf
    add esp, 8


    ; TODO b: Call sum_interval() and print result.
    push dword 9
    push dword 5
    push arr
    call sum_interval
    add esp, 12

    push eax
    push dword 9
    push dword 5
    push sum_interval_str
    call printf
    add esp, 16

    ; TODO c: Use scanf() to read positions from standard input.


    push pos1_str
    call printf
    add esp, 4


    push start
    push uint_format
    call scanf
    add esp, 8


    push pos2_str
    call printf
    add esp, 4

    push stop
    push uint_format
    call scanf
    add esp, 8

    mov eax, [stop]


    push dword [stop]
    push dword [start]
    push arr
    call sum_interval
    add esp, 12

    push eax
    push dword [stop]
    push dword [start]
    push sum_interval_str
    call printf
    add esp, 16

    ; Return 0.
    xor eax, eax
    leave
    ret
