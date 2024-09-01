.section .data
	array:
		.align 2
		
.text
	main:	
		addi sp, sp, -32
		sw ra, 0(sp)

		addi t0, zero, 4 # syscall read int
		addi a1, zero, 20 # tamanho do vetor em bytes a ser percorridos para cada operacao
		lui s0, %hi(array)
		addi s0, s0, %lo(array)
		sw s0, 4(sp)		

		call input

		lw s0, 4(sp)
		add a0, zero, zero
		sw s0, 4(sp)
		addi a1, a1, -4 # n-1

		call bubbleSortLoop1

		lw s0, 4(sp)
		addi a1, a1, 4 # n+1
		addi t0, zero, 1 #syscall print int
		add a0, zero, zero
		sw s0, 4(sp)

		call output
		
		lw s0, 4(sp)
		lw ra, 0(sp)
		addi sp, sp, 32
		ret

	# le vetor de inteiros
	input:
		bge a0, a1, endInput
		sw a0, 8(sp)
		ecall
		sw a0, 0(s0)
		lw a0, 8(sp)
		addi a0, a0, 4
		addi s0, s0, 4
		j input
	endInput:
		ret

	# imprime vetor de inteiros
	output:
		bge a0, a1, endOutput
		sw a0, 8(sp)
		lw a0, 0(s0)
		ecall
		lw a0, 8(sp)
		addi a0, a0, 4
		addi s0, s0, 4
		j output	
	endOutput:
		ret
	
	# loop externo do bubble sort
	bubbleSortLoop1:
		bge a0, a1, endBubbleSortLoop1
		sw ra, 8(sp)
		sw a0, 12(sp)
		add a0, zero, zero
		sw s0, 16(sp)
		call bubbleSortLoop2
		lw s0, 16(sp)
		lw a0, 12(sp)
		addi a0, a0, 4
		lw ra, 8(sp)
		j bubbleSortLoop1
	endBubbleSortLoop1:
		ret

	# loop interno do bubble sort
	bubbleSortLoop2:
		bge a0, a1, endBubbleSortLoop2
		sw ra, 20(sp)
		sw a0, 24(sp)
		sw a1, 28(sp)
		lw a0, 0(s0)
		lw a1, 4(s0)
		call bubbleSortCond
		lw a1, 20(sp)
		lw a0, 24(sp)
		lw ra, 28(sp)
		addi a0, a0, 4
		addi s0, s0, 4
		j bubbleSortLoop2
	endBubbleSortLoop2:
		ret

	# troca posicoes do vetor ordenando
	bubbleSortCond:
		blt a0, a1, endBubbleSortCond 
		sw a1, 0(s0)
		sw a0, 4(s0)
	endBubbleSortCond:
		ret
