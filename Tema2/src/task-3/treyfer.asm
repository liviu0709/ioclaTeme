section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt

    ; save t
    xor eax, eax ; t = 0
    mov al, [esi] ; var t de un byte
    xor edx, edx ; cnt runde
round:
    mov ecx, 0 ; contor byte din bloc
repeat:
    add al, [edi + ecx] ; t = t + byte din key pozitia curenta
    mov al, [sbox + eax] ; t = sbox[t]
    ; adun la t urm byte din bloc
    cmp ecx, 7 ; 7 -> blocksize 8, 1 -> blocksize 2
    je add_first_byte
    add al, [esi + ecx + 1]
    jmp skip
add_first_byte:
    add al, [esi]
skip:
    ; rotim t cu 1 bit la stanga
    rol al, 1

    ; Byte-ul de pe poziția (i + 1) % block_size din bloc va fi actualizat cu valoarea variabilei t
    cmp ecx, 7 ; 7 -> blocksize 8, 1 -> blocksize 2
    je update_first_byte
    mov [esi + ecx + 1], al
    jmp skip_update
update_first_byte:
    mov [esi], al
skip_update:

    inc ecx
    cmp ecx, 8
    jne repeat

    inc edx
    cmp edx, 10
    jne round

    	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

    mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt
    xor ebx, ebx ; counter runde
runde:
    mov ecx, 7 ; contor byte din bloc
for:
    xor eax, eax
    xor edx, edx
    mov al, [esi + ecx] ; un byte criptat
    add al, [edi + ecx] ; byte + byte din key pozitia curenta
    mov al, [sbox + eax] ; sbox[byte modificat pozitia curenta]
    cmp ecx, 7
    je add_first_byte2
    mov dl, [esi + ecx + 1] ; byte-ul urmator din bloc
    jmp skip2
add_first_byte2:
    mov dl, [esi] ; byte-ul urmator din bloc
skip2:
    ror dl, 1 ; rotim byte-ul urmator cu 1 bit la dreapta
    sub dl, al ; buttom - top
    ; salvam byte-ul decriptat
    cmp ecx, 7
    je update_first_byte2
    mov [esi + ecx + 1], dl
    jmp skip_update2
update_first_byte2:
    mov [esi], dl
skip_update2:


    dec ecx ; conditii oprire for
    cmp ecx, -1 ; verificam daca am parcurs primul byte (ecx = 0 -> decrementat -> -1)
    jne for

    inc ebx
    cmp ebx, 10 ; conditii oprire runde
    jne runde
	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

