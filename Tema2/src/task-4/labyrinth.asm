%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss
section .data
format_num db "%c ", 0
format_newline db 10, 0
ultimaMutare db -1 ; vreau sa tin minte ultima mutare
; 1 - jos, 2 - sus, 3 - dreapta, 4 - stanga

section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth
    ;; DO NOT MODIFY
    push eax
    push ebx
    ;; Freestyle starts here
    ; incepem de la 0, 0
    xor eax, eax
    xor ebx, ebx
am_de_lucru:
    ;verific daca am ajuns la DST

    ; cmp eax, ecx - 1 -> TEAPA, nu merge
    dec ecx
    cmp eax, ecx
    je end_fix_ecx
    inc ecx
    ; cmp ebx, edx - 1 -> TEAPA, nu merge
    dec edx
    cmp ebx, edx
    je end_fix_edx
    inc edx


    ; verificam bitii de pe langa noi
    ; jos, daca eax permite

    cmp [ultimaMutare], byte 2 ; verific daca ultima mutare a fost in sus
    je skip_check_jos
    cmp eax, ecx
    je skip_check_jos
    mov edi, [esi + eax * 4 + 1 * 4]
    push edx
    mov dl, [edi + ebx]
    cmp dl, '0'
    pop edx
    je move_jos
skip_check_jos:
    cmp [ultimaMutare], byte 1 ; verific daca ultima mutare a fost in jos
    je skip_check_sus
    ; sus, daca eax permite
    cmp eax, 0
    je skip_check_sus
    mov edi, [esi + eax * 4 - 1 * 4]
    push edx
    mov dl, [edi + ebx]
    cmp dl, '0'
    pop edx
    je move_sus
skip_check_sus:
    cmp [ultimaMutare], byte 4 ; verific daca ultima mutare a fost in stanga
    je skip_check_dreapta
    ; dreapta, daca ebx permite
    cmp ebx, edx
    je skip_check_dreapta
    mov edi, [esi + eax * 4]
    push edx
    mov dl, [edi + ebx + 1]
    cmp dl, '0'
    pop edx
    je move_dreapta
skip_check_dreapta:
    cmp [ultimaMutare], byte 3 ; verific daca ultima mutare a fost in dreapta
    je skip_check_stanga
    ; stanga, daca ebx permite
    cmp ebx, 0
    je skip_check_stanga
    mov edi, [esi + eax * 4]
    push edx
    mov dl, [edi + ebx - 1]
    cmp dl, '0'
    pop edx
    je move_stanga
skip_check_stanga:


    jmp am_de_lucru
move_jos:
    inc eax
    mov [ultimaMutare], byte 1
    jmp am_de_lucru
move_sus:
    dec eax
    mov [ultimaMutare], byte 2
    jmp skip_check_jos
move_dreapta:
    inc ebx
    mov [ultimaMutare], byte 3
    jmp am_de_lucru
move_stanga:
    dec ebx
    mov [ultimaMutare], byte 4
    jmp am_de_lucru



    ; parcurg matricea
    mov eax, 0
for_linie:

    mov ebx, 0
    ; parcurg coloane
for_coloana:
    pusha
    ; astfel, avem un vector de pointeri(de dim 4) la linii
    mov edi, [esi + eax * 4] ; matricea nu este alocata in zona de memorie continua
    mov edi, [edi + ebx]
    push edi
    push format_num
    call printf
    pop eax
    pop eax
    popa
    ; afisare matrice


    inc ebx
    cmp ebx, edx
    jne for_coloana

    pusha
    push format_newline
    call printf
    pop eax
    popa


    inc eax
    cmp eax, ecx
    jne for_linie

    ;; Freestyle ends here
end_fix_edx:
    inc edx
    jmp end
end_fix_ecx:
    inc ecx
end:
    mov edi, ebx
    pop ebx
    mov [ebx], edi
    mov edi, eax
    pop eax
    mov [eax], edi
    ;; DO NOT MODIFY

    popa
    leave
    ret

    ;; DO NOT MODIFY
