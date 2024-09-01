.section .text
main:
    
    addi t0, zero, 4 #le valor do teclado para o multiplicando
    ecall

    addi t0, zero, 5 #valor do multiplicador
    addi t1, zero, 1 #contador de iteracao
    add t2, zero, a0 #armazena resultado
    beq a0, zero, end; #termina caso multiplicacao com 0
    call while 
    
while:

    beq t1, t0, end
    add a0, a0, t2
    addi t1, t1, 1
    j while

end:
    addi t0, zero, 1
    ecall
    jr ra 



