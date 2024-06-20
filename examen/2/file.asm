section .data
	v dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
    lenv equ $-v
	fmt_nl db 10, 0
	fmt_s db "%s", 10, 0
    fmt_c db "%c ", 10, 0
	fmt_int db "%d", 0
    fmt_int_newline db "%d", 10, 0
	fmt_int_space db "%d ", 0
    fmt_newline db 10, 0
    string db "Ana are 3 MERE.", 0
    lens equ $-string

section .bss
    dest resd 100

section .text
global main
extern printf
extern scanf
extern tolower
extern memset ; void memset(char *str, int c, size_t s)
; TODO: a: Implement `void reset_arr(int *n, int *v)
reset_arr:
	push ebp
	mov ebp, esp
    pusha

    mov eax, [ebp + 8] ; &n
    mov ebx, [ebp + 12] ; &v

    pusha
    push eax
    push fmt_int
    call scanf
    add esp, 8
    popa

    pusha
    mov ecx, [eax]
    shl ecx, 2
    push ecx
    push dword 0
    push ebx
    call memset
    add esp, 12
    popa

    popa
	leave
	ret

; TODO: b: Implement `int dup_array(int n, int *src, int *dest)
dup_array:
	push ebp
	mov ebp, esp

    mov edx, [ebp + 8] ; n
    mov ebx, [ebp + 12] ; &src
    mov edi, [ebp + 16] ; &dest


    mov esi, 0 ; return value

    mov ecx, 0
while2:
    mov eax, [ebx + 4 * ecx]

    cmp eax, 0
    je nosave
    mov [edi + 4 * esi], eax
    inc esi
nosave:
    inc ecx
    cmp ecx, edx
    jne while2

    mov eax, esi ; counter dest

	leave
	ret

; TODO: c: Implement `to_lower(int n, char *c)`, that converts
; uppercase letters to lowercase.
to_lower:
	push ebp
	mov ebp, esp
    pusha

    mov edx, [ebp + 8] ; n
    mov ebx, [ebp + 12] ; &s

    mov ecx, 0
while4:
    mov eax, 0
    mov al, [ebx + ecx]

    push edx
    push ecx
    push ebx

    push eax
    call tolower
    add esp, 4


    pop ebx
    pop ecx
    pop edx
    mov [ebx + ecx], al


    inc ecx
    cmp ecx, edx
    jne while4



    popa
	leave
	ret

main:
    push ebp
    mov ebp, esp

; TODO: a: Call reset_arr
    sub esp, 4 ; aloc n
    ; mov dword [esp], 4
    mov eax, esp

    push v
    push eax
    call reset_arr
    add esp, 8


; TODO: a: Print array
    mov ecx, 0
while:
    mov eax, [v + ecx]

    pusha
    push eax
    push fmt_int_space
    call printf
    add esp, 8
    popa

    add ecx, 4
    cmp ecx, lenv
    jne while

    push fmt_newline
    call printf
    add esp, 4
; TODO: b: Call dup_array
    mov eax, lenv
    shr eax, 2

    push dest
    push v
    push eax
    call dup_array
    add esp, 12

; TODO: b: Print dest array
    mov ecx, 0
while3:
    pusha
    push dword [dest + 4 * ecx]
    push fmt_int_space
    call printf
    add esp, 8
    popa

    inc ecx
    cmp ecx, eax
    jne while3

    push fmt_newline
    call printf
    add esp, 4

; TODO c: Call to_lower and print the string

    push string
    push lens
    call to_lower
    add esp, 8

    push string
    push fmt_s
    call printf
    add esp, 8

	; Return 0.
	xor eax, eax
	leave
	ret
