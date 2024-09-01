.section .data
	str1mc: 
		.word 0x434d
	str2404:
		.word 0x21343034 
	
.text
	main:
		addi sp, sp, -4 #aloca espaco na pilha
		sw ra, 0(sp) # armazena endereco de retorno
		lui a0, %hi(str1mc) # le endereco de str1
		addi a0, a0, %lo(str1mc)
		lui a1, %hi(str2404) # le endereco de str2
		addi a1, a1, %lo(str2404)
		call printf # printa
		lw ra, 0(sp) # carrega endereco de retorno
		addi sp, sp, 4 # restaura pilha
		ret
	printf:
		add a2, a1, zero
		addi a1, zero, 2
		addi t0, zero, 3
		ecall
		add a0, a2, zero
		addi a1, zero, 4
		ecall
		ret
