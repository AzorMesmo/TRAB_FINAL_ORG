# Mateus Azor - 2011100013
# Natalia Banhara - 2011100004

# INFO
# matriz_navios: [numero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

navios:	.asciz	"3\n1 5 1 1\n0 8 2 2\n0 1 6 4"

	#	"2\n1 6 1 1\n0 4 4 5"
	#	"4\n1 4 0 0\n0 8 5 2\n1 2 3 6\n1 3 7 3"
	#	"7\n0 5 8 1\n1 4 1 4\n0 7 6 3\n0 2 3 6\n1 4 3 2\n0 1 7 7\n1 4 1 8"
	
	#	"30\n1 8 1 4\n0 3 2 1\n1 4 6 7\n1 3 3 2\n0 5 4 5\n1 2 2 6\n1 5 5 5\n0 4 8 0\n0 8 0 0\n1 3 1 5\n1 5 3 1\n1 3 7 8\n0 3 2 7\n0 5 9 0\n0 3 1 0\n1 5 5 9\n0 2 7 2\n1 4 5 6\n0 1 1 3\n0 4 1 6\n0 1 9 6\n1 3 5 0\n0 2 5 7\n0 3 3 7\n0 2 0 8\n0 2 6 2\n0 1 4 0\n0 1 6 8\n1 2 2 0\n1 3 3 3"

matriz_navios: 	.space 	400			# 10 x 10 x 4 (tamanho de um inteiro)

new_line:	.string "\n"

space:		.string " "

error_message:  .string "Invalid Boats!\n"

	.text

main:
	
	la a0, navios				# carrega o endereco de navios em a0
	la a1, matriz_navios			# carrega o endereco de matriz_navios em a1
	
	addi s4, zero, 0			# s4 possui o numero que cada navio vai ter na matriz
	
	jal insere_embarcacoes			# chama a funcao insere_embarcacoes
	
	jal reset				# chama a funcao reset
	
	jal imprime_interface_navios		# chama a funcao imprime_interface_navios

main_end:	

	nop					# no operation
	li   a7, 10				# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema

 ###########################################################
 # funcao: insere_embarcacoes				   #
 # argumentos: a0 - endereco inicial da string navios	   #
 #             a1 - endereco inicial da matriz de navios   #
 # retorno: a1 - matriz preenchida com os navios	   #
 # comentario: le os navios a serem inseridos, checando    #
 # 	      caso sejam validos e os inserindo na matrix  #
 ###########################################################

insere_embarcacoes:

	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
loop_insere_embarcacoes:

	ble t1, zero, fim_insere_embarcacoes    # desvia se ja leu todos os navios
	
insere_um_navio:

	# t1 -> contador de barcos
	# t2 -> direcao do barco
	# t3 -> tamanho do barco
	# t4 -> linha inicial do barco
	# t5 -> coluna inicial do barco
	
	addi a0, a0, 2				# a0 -> posicao inicial do barco na string navios
	lb t2, 0(a0)				# carrega o proximo byte de a0 em t2 (direcao do barco)
	
	addi a0, a0, 2				# aponta o endereco de a0 para o proximo valor relevante
	lb t3, 0(a0)				# carrega o proximo byte de a0 em t3 (tamanho do barco)
	
	addi a0, a0, 2				# aponta o endereco de a0 para o proximo valor relevante
	lb t4, 0(a0)				# carrega o proximo byte de a0 em t4 (linha inicial do barco)
	
	addi a0, a0, 2				# aponta o endereco de a0 para o proximo valor relevante
	lb t5, 0(a0)				# carrega o proximo byte de a0 em t5 (coluna inicial do barco)
	
	addi t2, t2, -48			# subtrai 48 do valor de t2 (convertendo o numero em string para inteiro)
	addi t3, t3, -48			# subtrai 48 do valor de t3 (convertendo o numero em string para inteiro)
	addi t4, t4, -48			# subtrai 48 do valor de t4 (convertendo o numero em string para inteiro)
	addi t5, t5, -48			# subtrai 48 do valor de t5 (convertendo o numero em string para inteiro)
	
	jal s9, checa_valores			# chama funcao de checagem da validade dos navios e guarda em s9 o endereco de retorno
	
	beq a2, zero, fim_insere_embarcacoes_erro # desvia para fim_insere_embarcacoes_erro caso um erro seja detectado no navio
	
	la a1, matriz_navios			# a1 -> endereco inicial da matriz
	
	jal s9, coloca_valores			# chama função coloca_valores e guarda em s9 o endereço de retorno
	
	addi t1, t1, -1				# decrementa t1 em 1
	
	j loop_insere_embarcacoes
	
fim_insere_embarcacoes:

	ret					# retorna
	
fim_insere_embarcacoes_erro:			# imprime mensagem de erro caso um dos navios nao seja valido e retorna
			
	la a0, error_message			
	li a7, 4
	ecall
	ret
	


 ########################################################
 # funcao: checa_valores				#
 # argumentos: a1 -> matriz_navios		        #
 #	       t2 -> direcao do barco			#
 #	       t3 -> tamanho do barco			#
 # 	       t4 -> linha inicial do barco		#
 # 	       t5 -> coluna inicial do barco		#
 # retorno: a2 = 1 (se for valido)		        #
 #	    a2 = 0 (se nao for valido)		        #
 # comentario: checa se os valores do barco sao validos #
 ########################################################

checa_valores:

	addi s2, zero, 9			# s2 -> 9 (numero maximo que uma linha ou coluna pode ter)
	
	addi t6, zero, 1			# t6 -> 1 (opcao vertical)
	
checa_posicao:

	blt t4, zero, erro_encontrado		# identifica erro se a linha for menor que 0
	blt t5, zero, erro_encontrado		# identifica erro se a coluna for menor que 0
	
	bgt t4, s2, erro_encontrado		# identifica erro se a linha for maior que 9
	bgt t5, s2, erro_encontrado		# identifica erro se a coluna for maior que 9
	
checa_primeiro_digito:				# deve ser 0 ou 1

	bgt t2, t6, erro_encontrado		# identifica erro se a posicao for maior que 1
	blt t2, zero, erro_encontrado		# identifica erro se a posicao for menor que 0
	
	addi t6, zero, 10			# t6 -> 10 (quantidade de linhas e colunas)
	
checa_tamanho:

	blt t3, zero, erro_encontrado		# identifica erro se o tamanho do barco for menor que 0
	bgt t3, t6, erro_encontrado		# identifica erro se o tamanho do barco for maior que 10
	
checa_horizontal:

	bne t2, zero, checa_vertical		# desvia para checa_vertical se o barco for vertical
	
	add t6, t5, t3				# t6 -> tamanho do barco + coluna inicial (para verificar se ultrapassa as dimensoes)
	
	j checa_limite
	
checa_vertical:

	add t6, t4, t3				# t6 -> tamanho do barco + linha inicial (para verificar se ultrapassa as dimensoes)

checa_limite:

	addi t6, t6, -1				# subtrai 1 de t6 (pois a matriz comeca em 0 nao em 1)
	bgt t6, s2, erro_encontrado		# desvia para erro_encontrado se a posicao do barco ultrapassa os limites da matriz

checa_sobreposicao:

	# t3 -> tamanho do barco -> s6
	# t4 -> linha inicial do barco -> s8 se vertical
	# t5 -> coluna inicial do barco -> s7 se horizontal
	
	addi s6, t3, 0 				# s6 -> tamanho do barco
	addi s7, t5, 0				# s7 -> coluna inicial
	addi s8, t4, 0				# s8 -> linha inicial
	
loop_checa_sobreposicao:			# L = Linha | C = Coluna

	bge zero, s6, fim_checa_valores		# desvia para fim_checa_valores se ja passou por todas posicoes que o barco ocuparia
	
	addi s2, zero, 10			# s2 -> QTD_colunas -> 10
	addi s5, zero, 4			# s5 -> 4
	la a1, matriz_navios			# a1 -> posicao inicial da matriz

	mul s3, s8, s2				# s3 -> L * QTD_colunas
	add s3, s3, s7				# s3 -> L * QTD_colunas + C
	mul s2, s3, s5				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posicao
	
	add a1, a1, s2				# desloca s2 vezes a1

	lb s5, 0(a1)				# s5 -> valor na posicao a1
	
	bne s5, zero, erro_encontrado		# identifica erro se o valor lido for diferente de 0
	
	bne t2, zero, checa_sobreposicao_vertical # desvia para checa_sobreposicao_vertical caso o barco for vertical
	
checa_sobreposicao_horizontal:

	addi s7, s7, 1				# incrementa em 1 o numero de colunas
	
	j checa_sobreposicao_decrementa		# desvia para checa_sobreposicao_decrementa
	
checa_sobreposicao_vertical:

	addi s8, s8, 1				# incrementa em 1 o numero de linhas
	
checa_sobreposicao_decrementa:

	addi s6, s6, -1				# diminui em 1 o tamanho do barco para continuar a percorrer por ele
	
	j loop_checa_sobreposicao		# desvia para loop_checa_sobreposicao
	
fim_checa_valores:

	addi a2, zero, 1			# a2 = 1 (valido)
	
	jr s9					# desvia para o endere�o em s9 -> endere�o de retorno

erro_encontrado:

	addi a2, zero, 0			# a2 = 0 (invalido)
	
	jr s9					# desvia para o endere�o em s9 -> endere�o de retorno

 #########################################
 # funcao: coloca_valores		 #
 # argumentos: a1 -> matriz_navios	 #
 # retorno: a1 -> barco inserido	 #
 # comentario: insere um barco na matriz #
 #########################################

coloca_valores:
			
	addi s4, s4, 1 			# incrementa o numero que representa o navio na matrix
	
loop_coloca_valores:

	bge zero, t3, fim_coloca_valores # percorre todas as posicoes do navio ate o tamanho ser menor ou igual a 0
	
	addi s2, zero, 10		# QTD_colunas
	addi s5, zero, 4		# s5 -> 4
	la a1, matriz_navios		# a1 -> endereco inicial da matriz

	mul s3, t4, s2			# L * QTD_colunas
	add s3, s3, t5			# L * QTD_colunas + C
	mul s2, s3, s5			# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posicao
	
	add a1, a1, s2			# desloca s2 vezes a1
	
	sb s4, 0(a1)			# a posicao de a1 recebe o valor que identifica o barco
	
	bne t2, zero, coloca_valores_vertical # desvia para coloca_valores_vertical se o barco for vertical
	
coloca_valores_horizontal:

	addi t5, t5, 1			# t5 + 1 -> aumenta coluna inicial
	
	j coloca_valores_decrementa	# desvia para coloca_valores_decrementa
	
coloca_valores_vertical:

	addi t4, t4, 1			# t4 + 1 -> aumenta linha inicial
	
coloca_valores_decrementa:

	addi t3, t3, -1			# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	
	j loop_coloca_valores		# desvia para loop_coloca_valores
	
fim_coloca_valores:

	jr s9				# desvia para o endere�o em s9 -> endere�o de retorno

 ###################################
 # imprime_matriz_navios	   #
 # argumentos: a1 -> matriz_navios #
 #	      a0 -> navios	   #
 # comentario: imprime a matriz	   #
 ###################################

imprime_interface_navios:
	
	addi a4, a1, 0			# coloca o valor de a1 (endereco incial da matriz) em a4
	addi t0, zero, 100		# contador do tamanho da matriz (t0 recebe o numero de elementos da matriz)
	addi t1, zero, 10		# contador das quebras de linha (t1 recebe o tamanho da linha da matriz)

imprime_loop:

	beq t1, zero, imprime_nova_linha # desvia se t1 (contador das quebras de linha) for igual a 0
	bge zero, t0, fim_imprime	# desvia se t0 (contador do tamanho da matriz) for menor ou igual a 0 ("maior que" invertido)
	
	lb a0, 0(a4)			# coloca em a0 o conteudo de a4 (o primeiro elemento da lista) 
	li a7, 1			# coloca o valor 1 em a7 (1 = imprimir inteiro)
	ecall				# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, space			# coloca o {str_space} em a0
	li a7, 4			# coloca o valor 4 em a7 (4 = imprimir string)
	ecall				# faz a chamada de sistema (usando sempre o valor que esta em a7)
	ecall				# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi a4, a4, 4			# vai para o proximo valor de a4 (adicionando 4)
	
	addi t0, t0, -1			# decrementa o contador do tamanho da matriz
	addi t1, t1, -1			# decrementa o contador das quebras de linha

	j imprime_loop			# desvia para imprime_loop

imprime_nova_linha:

	la a0, new_line			# coloca o {str_break} em a0
	li a7, 4			# coloca o valor 4 em a7 (4 = imprimir string)
	ecall				# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi t1, zero, 10		# reinicia o contador em t1 (contador das quebras de linha)
	
	j imprime_loop			# desvia para imprime_loop

fim_imprime:

	la a0, new_line			# coloca {str_break} em a0
	li a7, 4			# coloca o valor 4 em a7 (4 = imprimir string)
	ecall				# faz a chamada de sistema (usando sempre o valor que esta em a7)

	ret				# retorna

###################################################
# funcao: reset					  #
# retorno: a0 -> posicao inicial da string navios #
#          a1 -> posicao inicial da matriz_navios #
###################################################

reset:

	la a0, navios			# carrega a string navios em a0
	la a1, matriz_navios		# carrega a matriz_navios em a1
	ret				# retorna
