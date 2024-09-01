.section .text
main:
    addi t0,zero,5 # adiciona conteudo do registrador zero(0) com o imediato 5
    addi t1,zero,5

    add a0, t1, t0 # soma t1 com t0 e guarda em a0
    addi t0, zero, 1
    
    ecall
    jr ra