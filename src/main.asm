section .data
    pergunta db 'Digite o numero de discos: ' ,0xa
    tam equ $-pergunta                                     
    
    conq db 'Concluido!', 0xa
    tam2 equ $-conq
    
    texto:
                          db        "Mova o disco "
        num:              db        " "
                          db        " do topo da torre "
        torre_origem:     db        " "  
                          db        " para a torre "     
        torre_destino:    db        " ", 0xa  
        tamtexto            equ       $-texto


    ; definição de variáveis sem valores iniciais
section .bss

    discos resb 3                ; Espaço reservado para dados ainda não inicializados

section .text

    global _start

    _start:                             
        mov edx,tam                     ; Define o tamanho da mensagem
        mov ecx,pergunta                   ; Carrega a mensagem 'pergunta'
        mov ebx,1                       ; Define a saída padrão
        mov eax,4                       ; Operação de escrita no terminal
        int 0x80                        ; Interrupção para o kernel do Linux

        ; Lê a entrada do usuário
        mov edx, 3                      ; Define o tamanho máximo da entrada
        mov ecx, discos                 ; Guarda a entrada em 'discos'
        mov ebx, 0                      ; Define a entrada padrão
        mov eax, 3                      ; Configura para operação de leitura
        int 0x80                        ; Interrupção para o kernel do Linux
        
        mov edx, discos                 ; Coloca o endereço do número de discos em edx
        call    strtoint

        push dword "B"                  ; Empilha a representação da torre "B" na pilha
        push dword "C"                  ; Empilha a representação da torre "C" na pilha
        push dword "A"                  ; Empilha a representação da torre "A" na pilha
        push eax                        ; Empilha o número de discos na pilha                       

        call processaHanoi     
        
        mov edx, tam2                   ; Define o tamanho da mensagem final
        mov ecx, conq                   ; Carrega a mensagem final
        mov ebx, 1                      ; Configura a saída padrão
        mov eax, 4
        int 0x80
        
        mov eax, 1                      ; Comando para encerrar o programa
        mov ebx, 0                      ; Configura a saída padrão  
        int 0x80                        ; Interrupção para o kernel do Linux

    processaHanoi:
        push ebp                        ; Salva o valor de ebp na pilha
        mov ebp,esp                     ; Atualiza ebp para apontar para o topo da pilha

        mov eax,[ebp+8]                 ; Carrega o número de discos para eax
        cmp eax,0x0                     ; Compara eax com 0
        jle feito                       ; Se eax <= 0, pula para o final
        
        dec eax                         ; Diminui 1 do valor em eax
        push dword [ebp+16]             ; Empilha a torre auxiliar 
        push dword [ebp+20]             ; Empilha a torre de destino
        push dword [ebp+12]             ; Empilha a torre de origem
        push dword eax                  ; Empilha o número de discos - 1
        call processaHanoi              ; Chamada recursiva da função

        add esp,12                      ; Libera 12 bytes de espaço
        push dword [ebp+16]             ; Empilha a torre de origem
        push dword [ebp+12]             ; Empilha a torre de destino
        push dword [ebp+8]              ; Empilha o número do disco atual
        call print                      ; Chama a função para exibir o movimento

        add esp,12                      ; Libera 12 bytes de espaço
        push dword [ebp+12]             ; Empilha a torre de origem
        push dword [ebp+16]             ; Empilha a torre auxiliar
        push dword [ebp+20]             ; Empilha a torre de destino
        mov eax,[ebp+8]                 ; Carrega o número atual de discos em eax
        dec eax                         ; Diminui 1 do valor de eax

        push dword eax                  ; Empilha eax com o valor atualizado
        call processaHanoi              ; Chamada recursiva

    feito:
        mov esp,ebp                     ; Restaura o valor original de esp
        pop ebp                         ; Remove ebp da pilha
        ret                             ; Retorna para a função anterior

    ; Rotina para converter string em número inteiro

    strtoint:
    xor     eax, eax                    ; Zera o registrador eax
    mov     ebx, 10                     ; Define 10 como base para conversão
    
    .loop:
        movzx   ecx, byte [edx]         ; Carrega um byte de edx para ecx
        inc     edx                     ; Avança para o próximo byte
        cmp     ecx, '0'                ; Verifica se é menor que '0'
        jb      .done                   ; Se for, pula para o fim
        cmp     ecx, '9'                ; Verifica se é maior que '9'
        ja      .done                   ; Se for, pula para o fim
        sub     ecx, '0'                ; Converte de ASCII para inteiro
        imul    eax, ebx                ; Multiplica o acumulador pela base
        add     eax, ecx                ; Soma o número atual ao acumulador
        jmp     .loop                   ; Repete o processo
    
    .done:
        ret 

    print:
        push ebp                        ; Salva o valor atual de ebp
        mov ebp, esp                    ; Atualiza ebp para o topo da pilha
        
        mov eax, [ebp + 12]             ; Carrega a torre de origem
        mov [torre_origem], al          ; Atualiza o valor da torre de origem
        
        mov eax, [ebp + 8]              ; Carrega o disco atual
        add al, '0'                     ; Converte para ASCII
        mov [num], al                   ; Salva o número convertido
        
        mov eax, [ebp + 16]             ; Carrega a torre de destino
        mov [torre_destino], al         ; Atualiza o valor da torre de destino

        mov edx, tamtexto                 ; Define o tamanho da mensagem formatada
        mov ecx, texto                  ; Carrega a mensagem formatada
        mov ebx, 1                      ; Permite a saída padrão
        mov eax, 4                      ; Configura operação de escrita
        int 0x80                        ; Interrupção para o kernel do Linux

        mov     esp, ebp                ; Restaura o valor original de esp
        pop     ebp                     ; Recupera o valor de ebp
        ret                             ; Retorna para a função anterior
