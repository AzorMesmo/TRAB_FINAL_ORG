# Mateus Azor - 2011100013
# Natalia Banhara - 2011100004

# INFO
# matriz_navios: [numero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

navios:	.asciz	"3\n1 5 1 1\n0 8 2 2\n0 1 6 4"

matriz_navios: 	.space 	400			# 10 x 10 x 4 (integer size)

matriz_jogo:    .space  400			# 10 x 10 x 4 (integer size)

new_line:	.string "\n"

space:		.string " "

linha:		.string "Linha: "

coluna:		.string "Coluna: "

nao_terminou:	.string "Partida não terminou!\n"

terminou:	.string  "Partida terminou!\n"

error_message:  .string "This boat is invalid\n"

error_message_partida:   .string "This position is invalid, please give me a valid one\n"

error_message_partida_repetida:  .string  "You've already tried this one!\n"

here:  		.string "Here\n"

	.text

main:
	
	la a0, navios				# carrega o endereco de navios em a0
	la a1, matriz_navios			# carrega o endereço de matriz_navios em a1
	
	addi s4, zero, 0			# s4 possui o número que cada navio vai ter na matriz
	
	jal insere_embarcacoes			# chama a função insere_embarcacoes
	
	jal reset				# chama a função reset
	
	jal s9, imprime_matriz_navios		# chama a função imprime_interface_navios
	
	call partida
	
	la a1, matriz_jogo
	
	jal s9, imprime_matriz_navios
	
	la a1, matriz_jogo
	
	jal s9, zera_matriz
	
	la a1, matriz_jogo
	
	jal s9, imprime_matriz_navios

main_end:	

	nop					# no operation
	li   a7, 10				# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema

#########################################################
#insere_embarcacoes
# argumentos: a0 - endereço inicial da string navios
#             a1 - endereço inicial da matriz de navios (matriz_navios)
# retorno: a1 - matriz preenchida com os navios
# comentário: a função lê os navios a serem inseridos, checando caso sejam válidos e os inserindo na matrix
#
#########################################################
insere_embarcacoes:
	lb t1, 0(a0)			# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
loop_insere_embarcacoes:
	ble t1, zero, fim_insere_embarcacoes                 # desvia se já leu todos os navios
	
insere_um_navio:
	jal s9, le_navios
	
	addi s11, zero, 0 			# s11 recebe 0 para identificar que se trata da primeira opção, ou seja
						# ainda estamos checando todos os valores (quando for 1, quer dizer que
						# estamos jogando e checando linha e coluna
	
	jal s9, checa_valores			# chama função de checagem da validade dos navios e guarda em s9 o endereço de retorno
	
	beq a2, zero, fim_insere_embarcacoes_erro  # desvia para fim_insere_embarcacoes_erro caso um erro seja detectado no navio
	
	la a1, matriz_navios			# a1 -> endereço inicial da matriz
	
	jal s9, coloca_valores			# chama função coloca_valores e guarda em s9 o endereço de retorno
	
	addi t1, t1, -1				# decrementa t1 em 1
	
	j loop_insere_embarcacoes
	
fim_insere_embarcacoes:
	ret
	
fim_insere_embarcacoes_erro:		# imprime mensagem de erro caso um dos navios não seja válido e retorna
	la a0, error_message
	li a7, 4
	ecall
	ret
	
#########################################################
# partida
# argumentos: a2 -> matriz_jogo
#	      a1 -> matriz_navios
#	      a0 -> navios
# retorno:(nenhum retorno)
# comentário: representa a partida
#########################################################
partida:
	la a1, matriz_jogo
	
	jal s9, imprime_matriz_navios
loop_partida:
	# Linha = t4
	# Coluna = t5

	la a0, linha	#imprime string com "Linha: "
	li a7, 4
	ecall
	
	li a7, 5	#pede a linha
	ecall
	
	addi t4, a0, 0		# guarda o valor da linha em t4
	
	la a0, coluna 		# imprime string com "Coluna: "
	li a7, 4
	ecall
	
	li a7, 5		# pede a coluna
	ecall
	
	addi t5, a0, 0		# guarda o valor da coluna em t5
	
	addi s11, zero, 1
	
	jal s9, checa_valores		# checa se linha e coluna são válidas
	
	beq a2, zero, partida_mensagem_erro
	
	jal s7, partida_coloca_valores
	
	beq a2, zero, partida
	
	jal s7, partida_checa_fim
	
	beq a2, zero, partida
	
	ret
	
partida_mensagem_erro:
	la a0, error_message_partida
	li a7, 4
	ecall
	
	j partida
	
	
#########################################################
# partida_coloca_valores
# argumentos: t4 -> linha
#	      t5 -> coluna	
# retorno: matriz_jogo com a posição escolhida, 1 se acertou e -1 se errou
#	   a2 -> 1 (acertou), a2 -> 0 (errou)
#
# comentário: coloca a posicao linha x coluna que o jogador escolheu, se jogada ainda não foi realizado
#########################################################	
partida_coloca_valores:
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2

	addi s2, zero, 10		# QTD_colunas
	mul s3, t4, s2			# L * QTD_colunas
	addi s5, zero, 4		# s5 -> 4
	add s3, s3, t5			# L * QTD_colunas + C
	mul s2, s3, s5			# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2			# a1 -> é delocado s2 vezes
	
	lb s5, 0(a1)			# s5 -> valor na posição a1
	
	add a2, a2, s2
	
	lb s6, 0(a2)
	
	bne s6, zero, partida_ja_realizada
	
	beq s5, zero, partida_errou		# identifica que errou a posição de um navio se o valor lido 0
	
partida_acertou:
	addi s4, zero, 1			# s4 -> 1 (acertou navio)
	sb s4, 0(a2)
	jal s6, partida_checa_fim
	
	addi a2, zero, 1
	jr s7

partida_errou:
	addi s4, zero, -1			# s4 -> -1 (errou navio)
	sb s4, 0(a2)
	addi a2, zero, 0
	jr s7
	
partida_ja_realizada:
	la a0, error_message_partida_repetida
	li a7, 4
	ecall
	
	jr s7
	
	
#########################################################
# partida_checa_fim
# argumentos: ???????
# retorno: a2 = 1 (terminou) ou a2 = 0 (não terminou)
# comentário: ????????
#########################################################
partida_checa_fim:
	la a0, navios
	lb t1, 0(a0)			# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
loop_partida_checa_fim:
	ble t1, zero, partida_terminou                 # desvia se já leu todos os navios
	jal s9, le_navios
	
loop_navio:
	bge zero, t3, partida_terminou		# percorre todas as posições do navio até tamanho ser menor ou igual a 0

	addi s10, zero, 1
	addi s2, zero, 10		# QTD_colunas
	
	la a1, matriz_jogo

	mul s3, t4, s2			# L * QTD_colunas
	addi s5, zero, 4		# s5 -> 4
	add s3, s3, t5			# L * QTD_colunas + C
	mul s2, s3, s5			# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2			# a1 -> é deslocado s2 vezes
	
	lb s5, 0(a1)
	
	bne s5, s10, partida_navio_nao_encontrado
continua:
	bne t2, zero, loop_navio_vertical	# desvia para loop_navio_vertical se o barco for vertical
loop_navio_horizontal:
	addi t5, t5, 1			# t5 + 1 -> aumenta coluna inicial
	j loop_navio_valores_decrementa			
	
loop_navio_vertical:
	addi t4, t4, 1			# t4 + 1 -> aumenta linha inicial
	
loop_navio_valores_decrementa:
	addi t3, t3, -1			# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	j loop_navio
	
partida_terminou:
	addi a2, zero, 1
	j partida_mensagem_terminou
	
partida_navio_nao_encontrado:
	addi t1, t1, -1
	bne  t1, zero, loop_partida_checa_fim
partida_nao_terminou:	
	j partida_mensagem_nao_terminou

partida_mensagem_terminou:
	la a0, terminou
	li a7, 4
	ecall
	
	jr s7

partida_mensagem_nao_terminou:
	addi a2, zero, 0
	
	la a0, nao_terminou
	li a7, 4
	ecall
	
	jr s7

	
#########################################################
#le_navios
# argumentos: a0 - endereço inicial da string navios
# retorno: 
# t1 -> contador de barcos
# t2 -> direcao do barco
# t3 -> tamanho do barco
# t4 -> linha inicial do barco
# t5 -> coluna inicial do barco
# comentário: a função lê os navios a serem inseridos, checando caso sejam válidos e os inserindo na matrix
#
#########################################################
le_navios:
	addi a0, a0, 2				# a0 -> posição inicial do barco na string navios
	lb t2, 0(a0)				# carrega o proximo byte de a0 em t2 (direcao do barco)
	
	addi a0, a0, 2				# aponta o endere�o de a0 para o pr�ximo valor relevante
	lb t3, 0(a0)				# carrega o proximo byte de a0 em t3 (tamanho do barco)
	
	addi a0, a0, 2				# aponta o endere�o de a0 para o pr�ximo valor relevante
	lb t4, 0(a0)				# carrega o proximo byte de a0 em t4 (linha inicial do barco)
	
	addi a0, a0, 2				# aponta o endere�o de a0 para o pr�ximo valor relevante
	lb t5, 0(a0)				# carrega o proximo byte de a0 em t5 (coluna inicial do barco)
	
	addi t2, t2, -48			# subtrai 48 do valor de t2 (convertendo o numero em string para inteiro)
	addi t3, t3, -48			# subtrai 48 do valor de t3 (convertendo o numero em string para inteiro)
	addi t4, t4, -48			# subtrai 48 do valor de t4 (convertendo o numero em string para inteiro)
	addi t5, t5, -48			# subtrai 48 do valor de t5 (convertendo o numero em string para inteiro)
	
	jr s9	
	

#########################################################
# checa_valores
# argumentos: a1 -> matriz_navios
# retorno: a2 = 1 (se for válida)
#	   a2 = 0 (se não for válida)
# comentário: checa se os valores do barco são válidos
#
#########################################################
checa_valores:
	addi s2, zero, 9			# S2 -> 9 (número máximo que uma linha ou coluna pode ter)
	addi t6, zero, 1			# t6 -> 1 (opção vertical)
checa_posicao:
	blt t4, zero, erro_encontrado		# identifica erro se a linha for menor que 0
	blt t5, zero, erro_encontrado		# identifica erro se a coluna for menor que 0
	
	bgt t4, s2, erro_encontrado		# identifica erro se a linha for maior que 9
	bgt t5, s2, erro_encontrado		# identifica erro se a coluna for maior que 9
	
	bne s11, zero, fim_checa_valores
	
checa_primeiro_digito:				# checa o primeiro digito -> deve ser igual a 0 ou 1
	bgt t2, t6, erro_encontrado			# identifica erro se a posição for maior que 1
	addi t6, zero, 10			# t6 -> 10 (quantidade de linhas e colunas)
	blt t2, zero, erro_encontrado		# identifica erro se a posição for menor que 0
	
checa_tamanho:
	blt t3, zero, erro_encontrado		# identifica erro se o tamanho do barco for menor que 0
	bgt t3, t6, erro_encontrado			# identifica erro se o tamanho do barco for maior que 10
	
checa_horizontal:
	bne t2, zero, checa_vertical		# desvia para checks_vertical se o barco for vertical
	add t6, t5, t3				# t6 -> tamanho do barco + coluna inicial (para verificar se ultrapassa as dimensoes)
	
	j checa_limite
	
checa_vertical:
	add t6, t4, t3				# t6 -> tamanho do barco + linha inicial (para verificar se ultrapassa as dimensoes)

checa_limite:
	addi t6, t6, -1
	bgt t6, s2, erro_encontrado

checa_sobreposicao:

	# t3 -> tamanho do barco -> s6
	# t4 -> linha inicial do barco -> s8 se vertical
	# t5 -> coluna inicial do barco -> s7 se horizontal
	
	addi s6, t3, 0 				# s6 -> tamanho do barco
	addi s7, t5, 0				# s7 -> coluna inicial
	addi s8, t4, 0				# s8 -> linha inicial
	
loop_checa_sobreposicao:
	bge zero, s6, fim_checa_valores	# desvia para checks_values_ends se já passou por todas posições que o barco ocupará
	
	addi s2, zero, 10			# QTD_colunas
	
	la a1, matriz_navios			# a1 -> posição inicial da matriz

	mul s3, s8, s2				# L * QTD_colunas
	addi s5, zero, 4			# s5 -> 4
	add s3, s3, s7				# L * QTD_colunas + C
	mul s2, s3, s5				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2				# a1 -> é delocado s2 vezes 

	lb s5, 0(a1)				# s5 -> valor na posição a1
	
	bne s5, zero, erro_encontrado		# identifica erro se o valor lido for diferente de 0
	
	bne t2, zero, checa_sobreposicao_vertical	# desvia para checks_overdimension_vertical caso o barco for vertical
	
checa_sobreposicao_horizontal:
	addi s7, s7, 1				# incrementa em 1 o número de colunas
	j checa_sobreposicao_decrementa
	
checa_sobreposicao_vertical:
	addi s8, s8, 1				# incrementa em 1 o número de linhas
	
checa_sobreposicao_decrementa:
	addi s6, s6, -1				# diminui em 1 o tamanho do barco para continuar a percorrer por ele
	j loop_checa_sobreposicao	
	
fim_checa_valores:
	addi a2, zero, 1			# a2 = 1 (válida)
	jr s9

erro_encontrado:
	addi a2, zero, 0			# a2 = 0 (inválida)
	jr s9					# retorna

#########################################################
# coloca_valores
# argumentos: a1 -> matriz_navios
# retorno: a1 possui o barco inserido nela
# comentário: insere um barco na matriz
#
#########################################################
coloca_valores: 			
	addi s4, s4, 1 			# incrementa o número que representa o navio na matrix
loop_coloca_valores:
	bge zero, t3, fim_coloca_valores		# percorre todas as posições do navio até tamanho ser menor ou igual a 0
	
	addi s2, zero, 10		# QTD_colunas
	
	la a1, matriz_navios

	mul s3, t4, s2			# L * QTD_colunas
	addi s5, zero, 4		# s5 -> 4
	add s3, s3, t5			# L * QTD_colunas + C
	mul s2, s3, s5			# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2			# a1 -> é delocado s2 vezes
	
	sb s4, 0(a1)			# a posição de a1 recebe o valor que identifica o barco
	
	bne t2, zero, coloca_valores_vertical	# desvia para coloca_valores_vertical se o barco for vertical
coloca_valores_horizontal:
	addi t5, t5, 1			# t5 + 1 -> aumenta coluna inicial
	j coloca_valores_decrementa			
	
coloca_valores_vertical:
	addi t4, t4, 1			# t4 + 1 -> aumenta linha inicial
	
coloca_valores_decrementa:
	addi t3, t3, -1			# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	j loop_coloca_valores
	
fim_coloca_valores:
	jr s9

#########################################################
# imprime_matriz_navios
# argumentos: a1 -> matriz
# retorno:(nenhum retorno)
# comentário: imprime a matriz
#
#########################################################
imprime_matriz_navios:
	
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

	jr s9 # retorna

#########################################################
# zera_matriz
# argumentos: a1 -> matriz
# retorno:(nenhum retorno)
# comentário: imprime a matriz ????????????????????????????????// arrumar todos comentários e descrição da função
#
#########################################################
zera_matriz:
	addi a4, a1, 0 # coloca o valor de a1 (endereço incial da matriz) em a4
	addi t0, zero, 100 # contador do tamanho da matriz (t0 recebe o numero de elementos da matriz)
zera_loop:
	bge zero, t0, zera_end # desvia se t0 (contador do tamanho da matriz) for menor ou igual a 0 ("maior que" invertido)
	
	sb zero, 0(a4) # coloca em a0 o conteudo de a4 (o primeiro elemento da lista) 
	
	addi a4, a4, 4 # vai para o proximo valor de a4 (adicionando 4)
	
	addi t0, t0, -1 # decrementa o contador do tamanho da matriz

	j zera_loop # desvia para {p_loop}
zera_end:
	jr s9 # retorna	

#########################################################
# reset
# retorno: coloca em a0 a posição inicial da string navios, em a1 a posição inicial da matriz_navios
# e em a2 a posição inicial da matriz_jogo
#########################################################
reset:

	la a0, navios				# carrega a string navios em a0
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2
	ret					# retorna
