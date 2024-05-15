%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
;
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp

    ; save registers
    pusha

    ; TODO: Implement the depth first search algorith, using the `expand`
    ; function to get the neighbours. When a node is visited, print it by
    ; calling `printf` with the format string in section .data.
    ; current node
    mov eax, [ebp + 8]
    ; expand function
    mov ebx, [ebp + 12]

    ; print current node
    pusha
    push eax
    push fmt_str
    call printf
    ; clear stack
    add esp, 8
    popa

    ; mark current node as visited
    mov dword [visited + 4 * eax], 1

    ; get neighboors
    push eax
    ; expand call
    call ebx
    ; clear stack
    add esp, 4
    ; now eax has structure pointer

    ; counter for
    mov ecx, 0

for:
    ; address of neighboors cnt
    cmp ecx, [eax]
    jge for_completed

    ; get neighboor
    ; load vector start
    mov edx, [eax + 4]
    ; get neighboor
    mov edx, [edx + 4 * ecx]
    ; check if visited
    cmp dword [visited + 4 * edx], 1
    je skip_this

    ; recursive call
    ; expand
    push ebx
    ; node
    push edx
    call dfs
    ; clear stack
    add esp, 8

skip_this:
    inc ecx
    jmp for

for_completed:
    ; restore registers
    popa

    leave
    ret
