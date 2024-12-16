section .data

    mova db 'Faca a movimentacao: '
    lenmova equ $ - mova
    
    origem db "A"
    len equ $ - origem
    auxiliar db "B"
    destino db "C"
    
    linha db 0x0a
    
section .text
    global _start

_start:
    mov ecx, 10 ; numero de discos
    push ecx
    push origem
    push auxiliar
    push destino
    call processahanoi

    mov eax, 1
    int 0x80

mostrar:
    push ebp
    mov ebp, esp                        
    mov edx, len
    mov ecx, [ebp+8]
    mov ebx, 1
    mov eax, 4
    int 0x80
    pop ebp
    ret

processahanoi:
    push ebp            ; Salva o valor de EBP
    mov ebp, esp        ; Configura o novo quadro de pilha

    mov ecx, [ebp+20]   ; Pega o contador da pilha
    cmp ecx, 1
    je casoBase

    sub ecx, 1          ; Decrementa o contador
    push ecx
    mov eax, [ebp+16]   ; Pega a origem
    push eax
    mov eax, [ebp+8]    ; Pega o destino
    push eax
    mov eax, [ebp+12]   ; Pega o auxiliar
    push eax
    call processahanoi
    add esp, 16         ; Limpa a pilha após chamada
    
    mov eax, 4
    mov ebx, 1
    mov ecx, mova
    mov edx, lenmova
    int 0x80

    mov eax, [ebp+16]   ; Pega a origem
    push eax
    call mostrar
    add esp, 4
    

    mov eax, [ebp+8]    ; Pega o destino
    push eax
    call mostrar
    add esp, 4
    
    ; pular linha
    mov eax, 4
    mov ebx, 1
    mov ecx, linha
    mov edx, 1
    
    int 0x80
    

    mov ecx, [ebp+20]   ; Pega o contador da pilha novamente
    sub ecx, 1
    push ecx
    mov eax, [ebp+12]   ; Pega o auxiliar
    push eax
    mov eax, [ebp+16]   ; Pega a origem
    push eax
    mov eax, [ebp+8]    ; Pega o destino
    push eax
    call processahanoi
    add esp, 16         ; Limpa a pilha após chamada

    jmp done

casoBase:

    mov eax, 4
    mov ebx, 1
    mov ecx, mova
    mov edx, lenmova
    int 0x80

    mov eax, [ebp+16]   ; Pega a origem
    push eax
    call mostrar
    add esp, 4

    mov eax, [ebp+8]    ; Pega o destino
    push eax
    call mostrar
    add esp, 4
    
    ; pular linha
    mov eax, 4
    mov ebx, 1
    mov ecx, linha
    mov edx, 1
    int 0x80

done:
    mov esp, ebp        ; Restaura o valor original de ESP
    pop ebp             ; Restaura o valor original de EBP
    ret                 ; Retorna da função

