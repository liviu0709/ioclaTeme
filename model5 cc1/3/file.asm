; DO NOT MODIFY THIS FILE
section .text

global find
global check_string
global catch_me

extern printf
extern strlen
extern gets
extern exit

find:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    or edx, 0xBEEF  
    xor eax, edx
    sub eax, 0xDEAD

    leave
    ret

check_string:
    push ebp
    mov ebp, esp

    ; preserve ebx forced by C calling convention
    push ebx

    mov esi, [ebp + 8]   ; s
    cmp byte [esi], 'a'
    jne invalid

    push esi
    call strlen
    add esp, 4
    dec eax
    
    mov esi, [ebp + 8]   ; s
    cmp byte [esi + eax], 'S'
    jne invalid

    xor edx, edx
    xor ebx, ebx
    xor ecx, ecx 


counter:
    cmp byte [esi + ecx], 0
    je check
    
    mov al, byte [esi + ecx]
    cmp al, 'A'
    jb next
    cmp al, 'Z'
    ja lower_check
    
    inc edx
    jmp next


lower_check:
    cmp al, 'a'
    jb next
    cmp al, 'z'
    ja next
    inc ebx

next:
    inc ecx
    jmp counter
    
check:
    cmp edx, 2
    jb invalid
    cmp ebx, 3      
    jb invalid
    jmp valid
  
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

