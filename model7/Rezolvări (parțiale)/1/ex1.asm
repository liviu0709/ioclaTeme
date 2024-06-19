%include "printf32.asm"
extern printf

section .bss
	product_answer resw 1
	answer resb 24

section .data
	playlist db 0x42, 0x75, 0x76, 0x45, 0x25, 0x79, 0x54, 0x62, 0x94, 0x35, 0x6D, 0x6E, 0x45, 0x4D, 0x7A, 0x14, 0x25, 0x57, 0x94, 0x4C, 0x55, 0x42, 0x78, 0x4B
	playlist_len equ 24
    fmt_c db "%c ", 0
    fmt_int db "%d ", 0
	answer_len equ 12
    fmt_newline db 10, 0

section .text
global main

main:
    push ebp
    mov ebp, esp


    ; TODO a:
	; Faceti produsul dintre numarul de caractere din vector mai mici decat 'K'
	; si cel al caracterelor mai mari sau egale decat 'K'.
	; Puneti in product_answer rezultatul. (ATENTIE! product_answer asteapta
	; un word (short).
    mov edi, 0 ; cnt
    mov ecx, 0
while:
    mov al, [playlist + ecx]
    cmp al, 'K'
    jae skip
    inc edi
skip:
    inc ecx
    cmp ecx, playlist_len
    jne while

    mov eax, edi

    mov bl, playlist_len
    sub bl, al
    mul bl

    mov [product_answer], ax

	; Instructiune de afisare! NU MODIFICATI!
	a_print:
	PRINTF32 `%d\n\x0`, [product_answer]


    ; TODO b:
	; Pentru fiecare element din playlist, puneti in vectorul answer restul
	; impartirii lui la 41.
    mov ecx, 0
while2:
    mov eax, 0
    mov al, [playlist + ecx]
    mov bl, 41
    div bl
    mov [answer + ecx], ah

    shr eax, 8

    pusha
    push eax
    push fmt_int
    call printf
    add esp, 8
    popa


    inc ecx
    cmp ecx, playlist_len
    jne while2

    push fmt_newline
    call printf
    add esp, 8

    ; TODO c:
	; Pentru elementele de pe indici multiplii de 3 sau de 4, inversati
	; nibbles. Fiecare rezultat va fi pus in vectorul answer.
    mov eax, 0
    mov esi, 0
while3:
    push eax
    mov ebx, 3
    mov edx, 0
    div ebx

    pop eax
    cmp edx, 0
    je inverse

    mov ebx, eax
    and ebx, 3
    cmp ebx, 0
    je inverse

    jmp finish

inverse:

    pusha

    mov bl, [playlist + eax]
    and bl, 0xF
    shl bl, 4
    mov cl, [playlist + eax]
    and cl, 0xF0
    shr cl, 4
    add bl, cl
    mov [answer + esi], bl


    popa
    inc esi

finish:
    inc eax
    cmp eax, playlist_len
    jne while3
	; Instructiune de afisare! NU MODIFICATI!
c_print:
	xor ecx, ecx

c_print_loop:
	PRINTF32 `%c\x0`, [answer + ecx]
	inc ecx
	cmp ecx, answer_len
	jb c_print_loop
	PRINTF32 `\n\x0`

    ; Return 0.
    xor eax, eax
    leave
    ret
