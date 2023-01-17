.section .data
	#caractere de parada (.)
	endInputChar:
		.word 0x2e

.text
	main:	
		addi sp, sp, -4
		sw ra, 0(sp)
		
		lui a1, %hi(endInputChar)
		addi a1, a1, %lo(endInputChar)
		lbu a1, 0(a1) # valor em ascii
		addi t0, zero, 5
		
		call input

		addi t0, zero, 2
		call output

		lw ra, 0(sp)
		addi sp, sp, 4
		ret

	# le caracteres e armazena na pilha ate o caractere de parada
	input:
		ecall
		sub t1, a0, a1
		beq t1, zero, endInput	
		addi sp, sp, -4
		addi a2, a2, 4
		sw a0, 0(sp)
		add t1, zero, zero
		add t2, zero, zero
		j input
	endInput:
		ret
	
	# imprime entrada invertida
	output:
		beq a2, zero, endOutput		
		lw a0, 0(sp)
		ecall
		addi sp, sp, 4
		addi a2, a2, -4
		j output
	endOutput:
		ret
