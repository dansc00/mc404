.section .data
	
	# mensagem da interface menu
	 menuMessage:
		.word 0x434c4143
        	.word 0x44414c55
        	.word 0x2041524f
       		.word 0x554e454d
        	.word 0x532b203a
        	.word 0x20414d4f
        	.word 0x4255532d
        	.word 0x43415254
        	.word 0x2a204f41
        	.word 0x544c554d
        	.word 0x494c5049
        	.word 0x41434143
        	.word 0x442f204f
        	.word 0x53495649
        	.word 0x64204f41
        	.word 0x4f432062
        	.word 0x4220564e
        	.word 0x52414e49
        	.word 0x62204149
		.word 0x4f432064
		.word 0x4420564e
		.word 0x4d494345
		.word 0x62204c41
		.word 0x4f432068
		.word 0x4820564e
		.word 0x0d5845
	
	# mensagem da interface de entrada de opcao
    	inputMessage:
		.word 0x69676944
		.word 0x61206574
		.word 0x63706f20
		.word 0x0d3a6f61
	# opcao 1 +
	opt1:
		.word 0x202b
	# opcao 2 -
	opt2:
		.word 0x202d
	# opcao 3 *
	opt3:
		.word 0x202a
	# opcao 4 div(barra)
	opt4:
		.word 0x202f
	# opcao 5 db
	opt5:
		.word 0x6264
	# opcao 5 bd
	opt6:
		.word 0x6462
	# opcao 7 bh
	opt7:
		.word 0x6862
	# mensagem de entrada para os operadores aritmeticos
	inputOpts:
		.word 0x69676944
		.word 0x6f206574
		.word 0x706f2073
		.word 0x64617265
		.word 0x7365726f
		.word 0x0d3a
	# mensagem de entrada para as operacoes de conversao
	inputConv:
		.word 0x69676944
		.word 0x6f206574
		.word 0x6c617620
		.word 0x0d3a726f
	# aviso de overflow
	overflowMessage:
		.word 0x7265766f
		.word 0x776f6c66
		.word 0x74656420
		.word 0x61746365
		.word 0x0d6f64
	# mensagem de saida para as operacoes aritmeticas
    	outputMessage:
		.word 0x75736552
		.word 0x6461746c
		.word 0x0d3a6f
.section .text

	main:
        	addi sp, sp, -4
        	sw ra, 0(sp)
		
		# inicio impressao do menu
        	lui a0, %hi(menuMessage)
        	addi a0, a0, %lo(menuMessage)
        	addi a1, zero, 103

        	call printString
		# fim impressao do menu
		
		# inicio leitura da opcao de entrada
		lui a0, %hi(inputMessage)
		addi a0, a0, %lo(inputMessage)
		addi a1, zero, 16

		call printString
		
		addi a1, zero, 2

		call input
		# fim leitura da opcao de entrada
		
		# inicio da chamada de operacoes
		lui a1, %hi(opt1)
		addi a1, a1, %lo(opt1)
		addi a2, zero, 2		
		
		addi sp, sp, -4
		sw a0, 0(sp)

		call strcmp # testa opcao escolhida
		beq a0, zero, sumInput

		lw a0, 0(sp)

		lui a1, %hi(opt2)
		addi a1, a1, %lo(opt2)		
		
		sw a0, 0(sp)

		call strcmp
		beq a0, zero, subInput
	
		lw a0, 0(sp)

		lui a1, %hi(opt3)
		addi a1, a1, %lo(opt3)

		sw a0, 0(sp)

		call strcmp
		beq a0, zero, multInput
		
		lw a0, 0(sp)

		lui a1, %hi(opt4)
		addi a1, a1, %lo(opt4)

		sw a0, 0(sp)

		call strcmp
		beq a0, zero, divInput

		lw a0, 0(sp)
		
		lui a1, %hi(opt5)
		addi a1, a1, %lo(opt5)

		sw a0, 0(sp)

		call strcmp
		beq a0, zero, convBinInput

		lw a0, 0(sp)

		lui a1, %hi(opt6)
		addi a1, a1, %lo(opt6)

		sw a0, 0(sp)

		call strcmp
		beq a0, zero, bdInput

		lw a0, 0(sp)

		lui a1, %hi(opt7)
		addi a1, a1, %lo(opt7)

		sw a0, 0(sp)
		
		call strcmp
		beq a0, zero, bhInput
		# fim da chamada de operacoes
	
	# le valores a serem somados em a0 e a1, soma e retorna resultado em a0
	sumInput:
		lw a0, 0(sp)
		addi sp, sp, 4

		addi sp, sp, -4
		sw ra, 0(sp)

		call inputArtOpt

		lw ra, 0(sp)
		addi sp, sp, 4		

		add a2, zero, zero # carry in , out
		addi a3, zero, 32 # iteracoes (32 bits)
		add a4, zero, zero # marca bit a ser somado
		add s0, zero, zero # guarda resultado parcial
		add t5, zero, a0 # t5 e t6, guardam valores de entrada para teste de overflow
		add t6, zero, a1		

		addi sp, sp, -4
		sw ra, 0(sp)

		addi sp, sp, -4
		sw t5, 0(sp)

		call sum

		lw t5, 0(sp)
		addi sp, sp, 4

		call checkOverflow
		
		call printOutput		

		lw ra, 0(sp)
		addi sp, sp, 4
		j exit	
	sum:
		andi t0, a0, 1 # obtem bit menos signficativo
		andi t1, a1, 1
		xor t2, t0, t1
		xor t2, t2, a2		
		
		sll t2, t2, a4 # desloca bits do resultado parcial
		xor s0, s0, t2
		addi a4, a4, 1
		
		and t3, t0, t1 # atribui valor ao carry out
		and t4, t0, a2
		and t5, t1, a2
		or a2, t3, t4
		or a2, a2, t5

		srli a0, a0, 1 # desloca valores de entrada
		srli a1, a1, 1

		addi a3, a3, -1
		beq a3, zero, endSum # testa fim dos operadores
		j sum
	endSum:
		add a0, zero, s0
		ret
	
	# le valores a serem subtraidos em a0 e a1, subtrai e retorna o resultado em a0
	subInput:
		lw a0, 0(sp)
		addi sp, sp, 4

		addi sp, sp, -4
		sw ra, 0(sp)

		call inputArtOpt

		lw ra, 0(sp)
		addi sp, sp, 4

		xori a1, a1, 0xFFFFFFFF # inverte e soma 1 no segundo operando (c2)
		addi a1, a1, 1
		addi a3, zero, 32
		add t5, zero, a0 # t5 e t6, armazenam entradas para teste de overflow
		add t6, zero, a1		

		addi sp, sp, -4
		sw ra, 0(sp)

		addi sp, sp, -4
		sw t5, 0(sp)

		call sum # soma a0 com c2 de a1 (a0 + (-a1))

		lw t5, 0(sp)
		addi sp, sp, 4
		
		call checkOverflow

		call printOutput		

		lw ra, 0(sp)
		addi sp, sp, 4
		j exit

	# verifica overflow, se nao houve retorna a funcao q chamou, se houve imprime aviso e encerra
	checkOverflow:	
		slt t0, t6, zero
		slt t1, a0, t5
		bne t0, t1, Overflow
		ret
	Overflow:
		lui a0, %hi(overflowMessage)
                addi a0, a0, %lo(overflowMessage)
                addi t0, zero, 3
                addi a1, zero, 19
                ecall

                lw ra, 0(sp)
                addi sp, sp, 4
                j exit
	
	#le valores a serem multiplicados em a0 e a1, multiplica e retorna o resultado em a0
	multInput:
		lw a0, 0(sp)
		addi sp, sp, 4

		addi sp, sp, -4
		sw ra, 0(sp)

		call inputArtOpt

		lw ra, 0(sp)
		addi sp, sp, 4
		addi a2, zero, 32		

		addi sp, sp, -4
		sw ra, 0(sp)

		call mult
		
		call printOutput

		lw ra, 0(sp)
		addi sp, sp, 4
		j exit
	mult:	
		andi t0, a0, 1 # obtem bits menos significativos
		andi t1, a1, 1
		
		addi sp, sp, -4
		sw ra, 0(sp)

		call multSum

		lw ra, 0(sp)
		addi sp, sp, 4

		slli a0, a0, 1 # desloca multiplicando a esquerda
		srli a1, a1, 1 # desloca multiplicador a direita
		addi a2, a2, -1		

		beq a2, zero, endMult 	
		j mult
	endMult:
		add a0, zero, s0	
		ret
	
	# realiza a soma da multiplicacao
	multSum:
		beq t1, zero, endMultSum 
		add s0, s0, a0
	endMultSum:
		ret

	# le valores a serem divididos em a0 e a1, divide e retorna o resultado em a0 
	divInput:
		lw a0, 0(sp)
		addi sp, sp, 4
		
		addi sp, sp, -4
		sw ra, 0(sp)

		call inputArtOpt
		
		call div0

		lw ra, 0(sp)
		addi sp, sp, 4
		addi a2, zero, 33

		addi sp, sp, -4
		sw ra, 0(sp)
		
		add t0, zero, a0 # resto comeca com valor do dividendo
	
		call div

		call printOutput
	
		lw ra, 0(sp)
		addi sp, sp, 4
		j exit
	div:
		addi sp, sp, -4
		sw ra, 0(sp)
		
		sub t0, t0, a1 		

		call divSub
		
		lw ra, 0(sp)
		addi sp, sp, 4

		srli a1, a1, 1 # desloca divisor a direita
		addi a2, a2, -1		

		beq a2, zero, endDiv
		j div
	endDiv:
		add a0, zero, s0
		ret
	
	# realiza a subtracao da divisao
	divSub:
		bge t0, zero, endDivSub
		add t0, a1, t0
		slli s0, s0, 1
		add s0, s0, zero
		ret
	endDivSub:
		slli s0, s0, 1
		addi s0, s0, 1
		ret

	# verifica divisao por zero
	div0:
		bne a1, zero, endDiv0
		
		lw ra, 0(sp)
		addi sp, sp, 4
		j exit
	endDiv0:
		ret
	
	# converte valor decimal em a0 para binario e imprime
	convBinInput:
		lw a0, 0(sp)
		addi sp, sp, 4

		addi sp, sp, -4
		sw ra, 0(sp)		

		call inputConvOpt
		
		addi a1, zero, 32
		add a2, zero, a1
		addi t0, zero, 1		

		call convBin

		lw ra, 0(sp)
		addi sp, sp, 4
		j exit
	convBin:
		andi t1, a0, 1
		
		addi sp, sp, -4
		sw t1, 0(sp)

		srli a0, a0, 1		
		addi a1, a1, -1		

		beq a1, zero, printConvBin	
		j convBin
	printConvBin:
		lw a0, 0(sp)
		addi sp, sp, 4

		ecall
		addi a2, a2, -1
		beq a2, zero, endConvBin
		j printConvBin
	endConvBin:
		ret
		
	# le entrada das operacoes aritmeticas
	inputArtOpt:
		lui a0, %hi(inputOpts)
		addi a0, a0, %lo(inputOpts)
		addi a1, zero, 22

		addi sp, sp, -4
		sw ra, 0(sp)

		call printString

		lw ra, 0(sp)
		addi sp, sp, 4

		addi t0, zero, 4
		ecall
		addi sp, sp, -4
		sw a0, 0(sp)
		ecall
		add a1, zero, a0
		lw a0, 0(sp)
		addi sp, sp, 4
		ret
	
	# le entrada das operacoes de conversao
	inputConvOpt:
		lui a0, %hi(inputConv)
		addi a0, a0, %lo(inputConv)
		addi a1, zero, 16

		addi sp, sp, -4
		sw ra, 0(sp)
		
		call printString

		lw ra, 0(sp)
		addi sp, sp, 4

		addi t0, zero, 4
		ecall
		ret	

	# imprime string com endereco em a0 e tamanho em a1
	printString:
		addi t0, zero, 3
        	ecall        
        	ret

	# le opcao de entrada e guarda no endereco de a0
    	input:
		addi t0, zero, 6
		ecall
		ret
	
	# compara strings em a0 e a1, retorna em a0, 0 se strings iguais, outro valor se strings diferentes
	strcmp:
		lbu t0, 0(a0)
		lbu t1, 0(a1)
		sub t2, t0, t1
		bne t2, zero, endStrcmp
		addi a0, a0, 1
		addi a1, a1, 1
		addi a2, a2, -1
		bne a2, zero, strcmp
	endStrcmp:
		add a0, t2, zero
		ret
	
	# imprime saida das operacoes aritmeticas
	printOutput:
		addi sp, sp, -4
		sw a0, 0(sp)
		
		lui a0, %hi(outputMessage)
		addi a0, a0, %lo(outputMessage)
		addi a1, zero, 11

		addi sp, sp, -4
		sw ra, 0(sp)

		call printString

		lw ra, 0(sp)
		addi sp, sp, 4

		lw a0, 0(sp)
		addi sp, sp, 4

		addi t0, zero, 1
		ecall
		ret
		
	# encerra programa
	exit:
		lw ra, 0(sp)
		addi sp, sp, 4
		ret
