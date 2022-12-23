# Mateus Azor - 2011100013
# Natalia Banhara - 2011100004

# INFO
# ship_list: [numero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

ship_list:	.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

ship_matrix: 	.space 	400			# 10 x 10 x 4 (integer size)

new_line:	.string "\n"

space:		.string " "

	.text

# TUDO QUE NAO ESTA COMENTADO NAO ESTARA PRESENTE NO CODIGO FINAL (TIPO PRINT PRA VER SE TA FUNCIONANDO E COISAS ASSIM)

main:
	
	la a1, ship_list			# carrega o endereco de ship_list em a1
	mv a0, a1				# carrega o valor de a1 em a0
	li a7,4					# carrega o imediato 4 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema
	
	la a2, ship_matrix 			# carrega o endereco de ship_matrix em a1
	
	addi s0, a1, 0				# carrega em s0 a posicao inicial do a0 (ship_list)
	addi s1, a2, 0				# carrega em s1 a posicao inicial do a1 (ship_matrix)
	
	jal insert_ships			# chama a funcao insert_ships

main_end:	

	nop					# no operation
	li   a7, 10				# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema

# Nome: insert_ship
# Argumentos: a0 -> ship_list | a1 -> ship_matrix
# Retorno: XXX

insert_ships:
	
	lb t1, 0(a1)				# carrega o primeiro byte de a1 em t1 (contador de barcos)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	addi t2, zero, 4			# carrega o valor 4 em t2 (numero de instrucoes por barco)
	
	la a0, new_line
	li a7, 4
	ecall
	ecall
	
is_get_values:

	# t1 -> contador de barcos
	# t2 -> direcao do barco
	# t3 -> tamanho do barco
	# t4 -> linha inicial do barco
	# t5 -> coluna inicial do barco

	beq t1, zero, end_insert_ships		# desvia se t1 (contador de barcos) for igual a 0
	
	addi a1, a1, 2				# aponta o endereço de a1 para o próximo valor relevante
	lb t2, 0(a1)				# carrega o proximo byte de a1 em t2 (direcao do barco)
	addi t2, t2, -48			# subtrai 48 do valor de t2 (convertendo o numero em string para inteiro)
	
	mv a0, t2
	li a7, 1
	ecall
	
	la a0, space
	li a7, 4
	ecall
	
	addi a1, a1, 2				# aponta o endereço de a1 para o próximo valor relevante
	lb t3, 0(a1)				# carrega o proximo byte de a1 em t3 (tamanho do barco)
	addi t3, t3, -48			# subtrai 48 do valor de t3 (convertendo o numero em string para inteiro)
	
	mv a0, t3
	li a7, 1
	ecall
	
	la a0, space
	li a7, 4
	ecall
	
	addi a1, a1, 2				# aponta o endereço de a1 para o próximo valor relevante
	lb t4, 0(a1)				# carrega o proximo byte de a1 em t4 (linha inicial do barco)
	addi t4, t4, -48			# subtrai 48 do valor de t4 (convertendo o numero em string para inteiro)
	
	mv a0, t4
	li a7, 1
	ecall
	
	la a0, space
	li a7, 4
	ecall
	
	addi a1, a1, 2				# aponta o endereço de a1 para o próximo valor relevante
	lb t5, 0(a1)				# carrega o proximo byte de a1 em t5 (coluna inicial do barco)
	addi t5, t5, -48			# subtrai 48 do valor de t5 (convertendo o numero em string para inteiro)
	
	mv a0, t5
	li a7, 1
	ecall
	
	la a0, space
	li a7, 4
	ecall

is_check_values:

	# verifica se as posicoes sao validas
	
	# testes (caso a do pdf):
		# direcao >= 0 e <= 1
		# tamanho, linha e coluna iniciais >= 0 e <= 9
		
	# testes (caso b do pdf):
		# se direcao = 0, tamanho + linha inicial <= 10
		# se direcao = 0, tamanho + coluna inicial <= 10
		
	# testes (caso c do pdf):
		# deve existir uma formula matematica simples que detecta a colisao entre dois vetores em uma matriz (provavelmente coisa de ga) mas eu n conheco então.....
		# na hora de colocar um navio, checar se cada uma de suas coordenadas nao esta ocupada por outro navio

is_set_values:

	# coloca os valores na matriz
	
	addi t1, t1, -1				# decrementa 1 de t1 (contador de barcos)
	
	j loop_insert_ships			# desvia para loop_insert_ships

is_end:

	ret

# Nome: print_ships
# Argumentos: XXX
# Retorno: XXX

print_ships:

	ret

# Nome: reset
# Argumentos: nenhum
# Retorno: nenhum

reset:

	addi a1, s0, 0				# carrega s0 em a1 (volta a ship_list para a posicao inicial)
	addi a2, s1, 0				# carrega s1 em a2 (volta a ship_matrix para a posicao inicial)
	ret					# retorna
