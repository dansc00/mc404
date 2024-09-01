.section .data

.text
	main:
		addi sp, sp, -4
		sw ra, 0(sp)

		addi t0, zero, 4

		call input
				
		beq a0, zero, fact0 # caso a0 = 0
		
		addi a1, zero, 1
		add t0, zero, zero

		call fact
		
		addi t0, zero, 1
		
		call output

		lw ra, 0(sp)
		addi sp, sp, 4
		ret

	# le inteiro a ser calculado o fatorial
	input:
		ecall
	endInput:
		ret
	
	# fatorial recursivo
	fact:
		beq a0, a1, factReturn
		addi sp, sp, -4
		sw a0, 0(sp)
		addi sp, sp, -4
		sw ra, 0(sp)
		addi a0, a0, -1
		call fact
		lw ra, 0(sp)
		addi sp, sp, 4
		lw a1, 0(sp)
		sw ra, 0(sp)
		call mult
		lw ra, 0(sp)
		addi sp, sp, 4
		
	factReturn:
		addi a2, zero, 1
		ret
	
	# funcao multiplicacao
	mult:
		beq a1, a2, endMult
		add t0, t0, a0
		addi a1, a1, -1
		j mult 
	endMult:
		add a0, a0, t0
		add t0, zero, zero
		ret
	
	# imprime saida
	output:
		ecall
	endOutput:
		ret
	
	# caso fatorial de 0
	fact0:
		addi t0, zero, 1
		addi a0, zero, 1
		call output
		lw ra, 0(sp)
		addi sp, sp, 4
		ret
