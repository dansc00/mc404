.section .data
	string1: 
		.word 0x69676944 
	string2: 
		.word 0x6f206574
	string3: 
		.word 0x61762073 
	string4: 
		.word 0x65726f6c
	string5: 
		.word 0x6f642073 
	string6: 
		.word 0x74657620
	string7: 
		.word 0x726f     
.text
	main:
		addi sp, sp, -24
		sw ra, 0(sp)

		lui a0, %hi(string1)
		addi a0, a0, %lo(string1) # armazena endereco base das strings
		
		addi a1, zero, 4 # salto de 4 bytes
		addi a2, zero, 7 # numero de iteracoes
		add a3, zero, zero # contador
		addi t0, zero, 3 # syscall ID print string
		 
		call print
		
		addi a2, zero, 4 # numero de iteracoes
		add a3, zero, zero  # contador
		addi t0, zero, 4 # syscall ID read int
		ecall
		add s0, zero, a0 # adiciona valor lido em s0 como base do vetor de inteiros
		sw s0, 4(sp) # coloca s0 na pilha
		
		call input
		
		lw ra, 0(sp)
		addi sp, sp, 4
		ret
		
		print:
			beq a3, a2, end_print	
			ecall
			addi a3, a3, 1
			add a0, a0, a1
			j print
		end_print:
			ret
		
		input:
			beq a3, a2, end_input
			ecall
			add s1, zero, a0;
			sw s1, 0(a1)
			addi a3, a3, 1
			addi a1, a1, 4
			j input
		end_input:
			ret
			
			