# Mateus Azor - 2011100013
# Natalia Banhara - 2011100004

# INFO
# ship_list: [numero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

navios:	.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

matriz_navios: 	.space 	400			# 10 x 10 x 4 (integer size)

new_line:	.string "\n"

space:		.string " "

error_message:  .string "This boat is invalid\n"

here:		.string "Here\n"

	.text

main:
	
	la a0, navios				# carrega o endereco de navios em a0
	la a1, matriz_navios			# carrega o endereço de ship_matrix em a1
	
	addi s4, zero, 0			# s4 possui o número que cada navio vai ter na matriz
	
	call insere_embarcacoes			# chama a função insere_embarcacoes
	
	call reset
	
	call imprime_interface_navios

main_end:	

	nop					# no operation
	li   a7, 10				# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema

#########################################################
#insere_embarcacoes
# argumentos: a0 - endereço inicial da string navios
#             a1 - endereço inicial da matriz de navios (matriz_navios)
# retorno: a string navios agora possui os navios lidos 
#          e a matrix possui os navios inseridos nela, caso sejam válidos
# comentário: a função primeiramente lê a quantidade de navios a serem inseridos, 
#             depois os navios, checando caso sejam válidos e os inserindo na matrix
#
#########################################################
insere_embarcacoes:
	j le_navios

le_navios: 
	addi a1, zero, 2     # a1 possui o tamanho máximo de caracteres que será lido
	
	li a7, 8
	ecall
	
	lb t1, 0(a0)
	addi t1, t1, -48
	
	addi a0, a0, 2
	
	li a7, 8
	ecall
	
loop_input:
	beq t1, zero, end_input
	addi t2, zero, 8 			# t2 recebe 8 para ler um navio	
	addi s0, a0, 0
loop_input_one:
	beq t2, zero, insere_um_navio
	
	li a7, 8
	ecall
	
	addi a0, a0, 2
	
	addi t2, t2, -1
	j loop_input_one
	

end_loop_input_one:
	addi t1, t1, -1
	addi a1, zero, 2     # a1 possui o tamanho máximo de caracteres que será lido
	
	j loop_input
	
end_input:
	ret
	
insere_um_navio:
	
	la a1, matriz_navios
	
	# t1 -> contador de barcos
	# t2 -> direcao do barco
	# t3 -> tamanho do barco
	# t4 -> linha inicial do barco
	# t5 -> coluna inicial do barco
	
	addi a0, s0, 0				# a0 -> posição inicial do barco na string navios
	lb t2, 0(a0)				# carrega o proximo byte de a0 em t2 (direcao do barco)
	addi t2, t2, -48			# subtrai 48 do valor de t2 (convertendo o numero em string para inteiro)
	
	addi a0, a0, 4				# aponta o endere�o de a0 para o pr�ximo valor relevante
	lb t3, 0(a0)				# carrega o proximo byte de a0 em t3 (tamanho do barco)
	addi t3, t3, -48			# subtrai 48 do valor de t3 (convertendo o numero em string para inteiro)
	
	addi a0, a0, 4				# aponta o endere�o de a0 para o pr�ximo valor relevante
	lb t4, 0(a0)				# carrega o proximo byte de a0 em t4 (linha inicial do barco)
	addi t4, t4, -48			# subtrai 48 do valor de t4 (convertendo o numero em string para inteiro)
	
	addi a0, a0, 4				# aponta o endere�o de a0 para o pr�ximo valor relevante
	lb t5, 0(a0)				# carrega o proximo byte de a0 em t5 (coluna inicial do barco)
	addi t5, t5, -48			# subtrai 48 do valor de t5 (convertendo o numero em string para inteiro)
	
	addi s10, a0, 0
	
	addi a0, t2, 0
	li a7, 1
	ecall
	
	addi a0, t3, 0
	li a7, 1
	ecall
	
	addi a0, t4, 0
	li a7, 1
	ecall
	
	addi a0, t5, 0
	li a7, 1
	ecall
	
	addi a0, s10, 0


#começo da função de checagem #ARRUMAR PARA SEREM CHAMADAS DE FUNÇÕES SIMPLES
checks_values:
	addi s2, zero, 9			# S2 -> 9 (número máximo que uma linha ou coluna pode ter)
	
checks_position:
	bgt t4, s2, error_found			# identifica erro se a linha for maior que 9
	bgt t5, s2, error_found			# identifica erro se a coluna for maior que 9

	blt t4, zero, error_found		# identifica erro se a linha for menor que 0
	blt t5, zero, error_found		# identifica erro se a coluna for menor que 0
	
checks_first_digit:				# checa o primeiro digito -> deve ser igual a 0 ou 1
	addi t6, zero, 1			# t6 -> 1 (opção vertical)
	bgt t2, t6, error_found			# identifica erro se a posição for maior que 1
	blt t2, zero, error_found		# identifica erro se a posição for menor que 0
	
checks_length:
	addi t6, zero, 10			# t6 -> 10 (quantidade de linhas e colunas)
	bgt t3, t6, error_found			# identifica erro se o tamanho do barco for maior que 10
	blt t3, zero, error_found		# identifica erro se o tamanho do barco for menor que 0
	
checks_horizontal:
	bne t2, zero, checks_vertical		# desvia para checks_vertical se o barco for vertical
	add t6, t5, t3				# t6 -> tamanho do barco + coluna inicial (para verificar se ultrapassa as dimensoes)
	
checks_vertical:
	add t6, t4, t3				# t6 -> tamanho do barco + linha inicial (para verificar se ultrapassa as dimensoes)
	
checks_overdimension:

	# t3 -> tamanho do barco -> s6
	# t4 -> linha inicial do barco -> s8 se vertical
	# t5 -> coluna inicial do barco -> s7 se horizontal
	
	bgt t6, s2, error_found
	
	addi s6, t3, 0 				# s6 -> tamanho do barco
	
	addi s7, t5, 0				# s7 -> coluna inicial
	addi s8, t4, 0				# s8 -> linha inicial
	
loop_checks_overdimension:
	bge zero, s6, checks_values_ends	# desvia para checks_values_ends se já passou por todas posições que o barco ocupará
	
	la a1, matriz_navios			# a1 -> posição inicial da matriz
	
	addi s2, zero, 10
	mul s3, s8, s2
	addi s2, zero, 4
	add s3, s3, s7
	mul s2, s3, s2				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2				# a1 -> é delocado s2 vezes 

	lb s5, 0(a1)				# s5 -> valor na posição a1
	
	bne s5, zero, error_found		# identifica erro se o valor lido for diferente de 0
	
	bne t2, zero, checks_overdimension_vertical	# desvia para checks_overdimension_vertical caso o barco for vertical
	
checks_overdimension_horizontal:
	addi s7, s7, 1				# incrementa em 1 o número de colunas
	j overdimension_set_decrement
	
checks_overdimension_vertical:
	addi s8, s8, 1				# incrementa em 1 o número de linhas
	
overdimension_set_decrement:
	addi s6, s6, -1				# diminui em 1 o tamanho do barco para continuar a percorrer por ele
	j loop_checks_overdimension	
	
checks_values_ends:
	j set_values	

error_found:
	la a0, error_message			# mostra mensagem de erro
	li a7, 4
	ecall
	
	ret					# retorna
	# verifica se as posicoes sao validas
	
	# testes (caso a do pdf):
		# direcao >= 0 e <= 1
		# tamanho, linha e coluna iniciais >= 0 e <= 9
		
	# testes (caso b do pdf):
		# se direcao = 0, tamanho + linha inicial <= 10
		# se direcao = 0, tamanho + coluna inicial <= 10
		
	# testes (caso c do pdf):
		# deve existir uma formula matematica simples que detecta a colisao entre dois vetores em uma matriz (provavelmente coisa de ga) mas eu n conheco ent�o.....
		# na hora de colocar um navio, checar se cada uma de suas coordenadas nao esta ocupada por outro navio

set_values: 			# inserts one boat
	la a1, matriz_navios		# a1 -> posição inicial da matrix
	addi s4, s4, 1 			# incrementa o número que representa o navio na matrix
loop_set_values:
	bge zero, t3, set_end		# percorre todas as posições do navio até tamanho ser menor ou igual a 0
	
	la a1, matriz_navios
	
	addi s2, zero, 10
	mul s3, t4, s2
	addi s2, zero, 4
	add s3, s3, t5
	mul s2, s3, s2			# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2			# a1 -> é delocado s2 vezes
	
	sb s4, 0(a1)			# a posição de a1 recebe o valor que identifica o barco
	
	bne t2, zero, set_vertical	# desvia para set_vertical se o barco for vertical
set_horizontal:
	addi t5, t5, 1			# t5 + 1 -> aumenta coluna inicial
	j set_decrement			
	
set_vertical:
	addi t4, t4, 1			# t4 + 1 -> aumenta linha inicial
	
set_decrement:
	addi t3, t3, -1			# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	j loop_set_values
	
set_end:
	j end_loop_input_one			# desvia para loop_insert_ships

#ARRUMAR:::::::::::::::::::::::::::::::::::::::::::::::::::;IMPORTANT (CABEÇALHO)

#########################################################
# imprime_matriz_navios
# argumentos: a0 - endereço inicial da matriz navios
#             a1 - 0 imprime interface - 1 imprime navios
# retorno: ---- (nenhum retorno)
# comentário: 
#
#########################################################
imprime_interface_navios:
	la a1, matriz_navios
	
	addi a4, a1, 0 # coloca o valor de a1 (endereço incial da matriz) em a4
	addi t0, zero, 100 # contador do tamanho da matriz (t0 recebe o numero de elementos da matriz)
	addi t1, zero, 10 # contador das quebras de linha (t1 recebe o tamanho da linha da matriz)
p_loop:
	beq t1, zero, p_break # desvia se t1 (contador das quebras de linha) for igual a 0
	bge zero, t0, p_end # desvia se t0 (contador do tamanho da matriz) for menor ou igual a 0 ("maior que" invertido)
	
	lb a0, 0(a4) # coloca em a0 o conteudo de a4 (o primeiro elemento da lista) 
	li a7, 1 # coloca o valor 1 em a7 (1 = imprimir inteiro)
	ecall # faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, space # coloca o {str_space} em a0
	li a7, 4 # coloca o valor 4 em a7 (4 = imprimir string)
	ecall # faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi a4, a4, 4 # vai para o proximo valor de a4 (adicionando 4)
	
	addi t0, t0, -1 # decrementa o contador do tamanho da matriz
	addi t1, t1, -1 # decrementa o contador das quebras de linha

	j p_loop # desvia para {p_loop}
p_break:
	la a0, new_line # coloca o {str_break} em a0
	li a7, 4 # coloca o valor 4 em a7 (4 = imprimir string)
	ecall # faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi t1, zero, 10 # reinicia o contador em t1 (contador das quebras de linha)
	
	j p_loop # desvia para {p_loop}
p_end:
	la a0, new_line # coloca {str_break} em a0
	li a7, 4 # coloca o valor 4 em a7 (4 = imprimir string)
	ecall # faz a chamada de sistema (usando sempre o valor que esta em a7)

	ret # retorna

#ARRUMAR:::::::::::::::::::::::::::::::::::::::::::::::::::;IMPORTANT (CABEÇALHO)
reset:

	la a0, navios				# carrega s0 em a1 (volta a ship_list para a posicao inicial)
	la a1, matriz_navios				# carrega s1 em a2 (volta a ship_matrix para a posicao inicial)
	ret					# retorna
