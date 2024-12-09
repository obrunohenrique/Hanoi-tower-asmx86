section .data
    pergunta db 'Qual seu nome?', 10 ;cria um ponteiro
    tamPerg equ $-pergunta

    ola db "Olá, "
    tamOla equ $-ola
    tamNome equ 10 ;tamanho max do nome é 10 char
    
section .bss ; section para variáveis estáticas de entrada
    nome resb tamNome


section .text
    global _start

_start:

    ; Imprimindo a pergunta
    mov rax, 1 ; syscall para escrita
    mov rdi, 1 ; 1º arg (saída padrão)
    mov rsi, pergunta ; a partir do que está sendo apontado por 'pergunta'
    mov rdx, tamPerg
    syscall

    ;ler o nome do user
    mov rax, 0
    mov rdi, 0
    mov rsi, nome
    mov rdx, tamNome
    syscall

    ; Imprimindo o "Olá, "
    mov rax, 1 ; syscall para escrita
    mov rdi, 1 ; 1º arg (saída padrão)
    mov rsi, ola ; 
    mov rdx, tamOla
    syscall

    ; Imprimindo o `${nome}`
    mov rax, 1 ; syscall para escrita
    mov rdi, 1 ; 1º arg (saída padrão)
    mov rsi, nome ; 
    mov rdx, tamNome
    syscall
    
    ;encerrando o programa
    mov rax, 60
    mov rdi, 0
    syscall
    
    