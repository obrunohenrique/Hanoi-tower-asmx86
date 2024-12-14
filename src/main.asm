section .data
    origem db "A"
    len equ $ - origem
    auxiliar db "B"
    destino db "C"
    
section .text
    global _start

_start:
    mov ecx, 11
    push ecx
    push origem
    push auxiliar
    push destino
    call hanoi

    mov eax, 1
    int 0x80

hanoi:
    push ebp            ; Salva o valor de EBP
    mov ebp, esp        ; Configura o novo quadro de pilha

    mov ecx, [ebp+20]   ; Pega o contador da pilha
    cmp ecx, 1
    je feito

    sub ecx, 1          ; Decrementa o contador
    push ecx
    mov eax, [ebp+16]   ; Pega a origem
    push eax
    mov eax, [ebp+8]    ; Pega o destino
    push eax
    mov eax, [ebp+12]   ; Pega o auxiliar
    push eax
    call hanoi
    add esp, 16         ; Limpa a pilha após chamada

    mov eax, [ebp+16]   ; Pega a origem
    push eax
    call print
    add esp, 4

    mov eax, [ebp+8]    ; Pega o destino
    push eax
    call print
    add esp, 4

    mov ecx, [ebp+20]   ; Pega o contador da pilha novamente
    sub ecx, 1
    push ecx
    mov eax, [ebp+12]   ; Pega o auxiliar
    push eax
    mov eax, [ebp+16]   ; Pega a origem
    push eax
    mov eax, [ebp+8]    ; Pega o destino
    push eax
    call hanoi
    add esp, 16         ; Limpa a pilha após chamada

    jmp done

feito:
    mov eax, [ebp+16]   ; Pega a origem
    push eax
    call print
    add esp, 4

    mov eax, [ebp+8]    ; Pega o destino
    push eax
    call print
    add esp, 4

done:
    mov esp, ebp        ; Restaura o valor original de ESP
    pop ebp             ; Restaura o valor original de EBP
    ret                 ; Retorna da função

print:
    push ebp
    mov ebp, esp
    mov edx, len
    mov ecx, [ebp+8]
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop ebp
    ret