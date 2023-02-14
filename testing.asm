# Mateus Azor - 2011100013
# Natalia Banhara - 2011100004

# matriz_navios: [numero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...
# navios originais: "3\n1 5 1 1\n0 8 2 2\n0 2 6 4"

	.data

navios0:			.asciz	"3\n1 3 1 3\n0 9 4 1\n1 5 5 5"

navios1:			.asciz	"4\n0 5 0 2\n0 4 3 0\n1 3 4 6\n1 2 8 2"

navios2:			.asciz	"5\n0 2 0 3\n0 1 2 8\n0 1 4 1\n1 3 5 7\n0 2 9 0"

navios3:			.asciz	"2\n0 1 3 9\n0 1 6 2"

navios4:			.asciz	"5\n0 1 3 3\n0 1 3 6\n0 1 5 2\n0 1 5 7\n0 4 6 3"

matriz_navios: 			.space 	400	# 10 x 10 x 4 (integer size)

matriz_jogo:    		.space  400	# 10 x 10 x 4 (integer size)

voce_placar:    		.word  0, 0, 0
# primeiro = afundados
# segundo = quantidade de tiros ja disparados
# terceiro = quantidade de tiros que acertaram o alvo
# sempre le em s0 e s1

recorde_placar: 		.word 0, 0
# primeiro = afundados
# segundo = quantidade de tiros ja disparados e quantidade de tiros que acertaram o alvo
# sempre le em s0 e s1

navios_escolhidos: 		.word 0

new_line:			.string "\n"

space:				.string " "

linha:				.string "\nLinha: "

coluna:				.string "Coluna: "

recorde:			.string "Recorde\n\n"

voce:				.string "Jogo Atual\n\n"

tiros:				.string "Tiros: "

acertos:			.string "Acertos: "

afundados:			.string "Afundados: "

ultimo_tiro:			.string "\nUltimo Tiro: "

error_message:  		.string "Barco Invalido\n"

error_message_partida: 		.string "Posicao Invalida, Tente Novamente\n"

error_message_partida_repetida: .string  "Invalido Novamente, Tente Outra Posicao\n"

opcoes:				.string "1 - Reiniciar o jogo\n2 - Mostrar a matriz atual\n3 - Fazer uma nova jogada\n0 - Sair\n\n"

opcao_invalida: 		.string "\nOpcao Invalida!\n"

mensagem_venceu: 		.string "Congrats! You Won!!\n"

bem_vindo:			.string "Bem Vindo a Batalha Naval em Assembly!\n"

acoes_menu:			.string "\n1 - Jogar\n2 - Selecionar Navios\n0 - Sair\n\n"

embarcacoes:			.string "\n1 -> Facil\n2 -> Medio\n3 -> Dificil\n4 -> HARDCORE\n0 -> :)\n\n"

selecionados:			.string "\nConjunto De Navios Selecionado!\n"

	.text

main:
	
	la a0, bem_vindo				# carrega a string {bem_vindo} em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	
main_loop:

	la a0, acoes_menu				# carrega a string {acoes_menu} em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	li a7, 5					# carrega o imediato 5 (read int) em a7
	ecall						# faz a chamada de sistema
	
	addi a1, zero, 1				# adicona 1 em a0
	beq a0, a1, main_play				# desvia caso a0 (input do usuario) seja 1 (jogar)
	
	addi a1, zero, 2				# adicona 2 em a0
	beq a0, a1, main_choose				# desvia caso a0 (input do usuario) 2 (escolher navios)
		
	beq a0, zero, main_end				# desvia caso a0 (input do usuario) seja 0 (sair)

main_invalida:
			
	la a0, opcao_invalida				# carrega a string opcao_invalida em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	
	j main_loop					# desvia para main_loop
	
main_choose:

	la a0, embarcacoes				# carrega a string {embarcacoes} em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	li a7, 5					# carrega o imediato 5 (read int) em a7
	ecall						# faz a chamada de sistema
		
	addi a1, zero, 1				# adicona 1 em a0
	beq a0, a1, ships0				# desvia caso a0 (input do usuario) seja 1
	
	addi a1, zero, 2				# adicona 2 em a0
	beq a0, a1, ships1				# desvia caso a0 (input do usuario) seja 2
	
	addi a1, zero, 3				# adicona 3 em a0
	beq a0, a1, ships2				# desvia caso a0 (input do usuario) seja 3
	
	addi a1, zero, 4				# adicona 4 em a0
	beq a0, a1, ships3				# desvia caso a0 (input do usuario) seja 4
	
	beq a0, zero, ships4				# desvia caso a0 (input do usuario) seja 0
		
	la a0, opcao_invalida				# carrega a string {acoes_menu} em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
		
	j main_choose					# desvia para main_choose

ships0:

	la a0, selecionados				# carrega a string selecionados em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema

	addi t1, zero, 0				# adiciona 0 em t1 (valor do conjunto de navios escolhido)
	la t0, navios_escolhidos			# carrega o endereço de navios_escolhidos em t0
	sw t1, 0(t0) 					# salva t1 no endereço de t0 (conjunto de navios escolhido)

	j main_loop					# desvia para main_loop

ships1:

	la a0, selecionados				# carrega a string selecionados em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	
	addi t1, zero, 1				# adiciona 1 em t1 (valor do conjunto de navios escolhido)
	la t0, navios_escolhidos			# carrega o endereço de navios_escolhidos em t0
	sw t1, 0(t0) 					# salva t1 no endereço de t0 (conjunto de navios escolhido)

	j main_loop					# desvia para main_loop

ships2:

	la a0, selecionados				# carrega a string selecionados em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	
	addi t1, zero, 2				# adiciona 2 em t1 (valor do conjunto de navios escolhido)
	la t0, navios_escolhidos			# carrega o endereço de navios_escolhidos em t0
	sw t1, 0(t0) 					# salva t1 no endereço de t0 (conjunto de navios escolhido)

	j main_loop					# desvia para main_loop

ships3:

	la a0, selecionados				# carrega a string selecionados em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
		
	addi t1, zero, 3				# adiciona 3 em t1 (valor do conjunto de navios escolhido)
	la t0, navios_escolhidos			# carrega o endereço de navios_escolhidos em t0
	sw t1, 0(t0) 					# salva t1 no endereço de t0 (conjunto de navios escolhido)

	j main_loop					# desvia para main_loop

ships4:

	la a0, selecionados				# carrega a string selecionados em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	
	addi t1, zero, 4				# adiciona 4 em t1 (valor do conjunto de navios escolhido)
	la t0, navios_escolhidos			# carrega o endereço de navios_escolhidos em t0
	sw t1, 0(t0) 					# salva t1 no endereço de t0 (conjunto de navios escolhido)

	j main_loop					# desvia para main_loop

main_play:

	addi s4, zero, 0				# s4 -> o numero que cada navio vai ter na matriz
	
	jal reset					# chama a funcao reset
	
	jal insere_embarcacoes				# chama a funcao insere_embarcacoes

	call partida					# chama a funcao partida

main_end:	

	li   a7, 10					# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall						# faz a chamada de sistema

 #########################################################
 # funcao: insere_embarcacoes				 #
 # argumentos: a0 - endereco inicial da string navios	 #
 #             a1 - endereco inicial da matriz de navios #
 # retorno: a1 - matriz preenchida com os navios	 #
 # comentario: a funcao le os navios a serem inseridos,	 #
 # checando caso sejam validos e os inserindo na matriz	 #
 #########################################################

insere_embarcacoes:

	lb t1, 0(a0)					# carrega a0 em t1 (contador de barcos)
	addi t1, t1, -48				# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	la s0, recorde_placar				# armazena o endereço de recorde_placar em s0
	sw t1, 0(s0)					# armazena o recorde de s0 em t1
	
loop_insere_embarcacoes:

	ble t1, zero, fim_insere_embarcacoes		# desvia se ja leu todos os navios
	
insere_um_navio:

	jal s9, le_navio				# chama funcao le_navio e guarda em s9 o endereco de retorno
	
	addi s11, zero, 0 				# s11 recebe 0 para identificar que ainda estamos checando todos os valores
							# (quando for 1, quer dizer que estamos jogando e checando linha e coluna)
	
	jal s9, checa_valores				# chama funcao checa_valores e guarda em s9 o endereco de retorno
	
	beq a2, zero, fim_insere_embarcacoes_erro  	# desvia para fim_insere_embarcacoes_erro caso um erro seja detectado no navio
	
	la a1, matriz_navios				# a1 -> endereco inicial da matriz
	
	jal s9, coloca_valores				# chama funcao coloca_valores e guarda em s9 o endereco de retorno
	
	addi t1, t1, -1					# decrementa t1 em 1
	
	j loop_insere_embarcacoes			# desvia para loop_insere_embarcacoes
	
fim_insere_embarcacoes:

	ret						# retorna
	
fim_insere_embarcacoes_erro:

	la a0, error_message				# carrega a string error_message em a0
	li a7, 4					# carrega o imediato 4 (print string) em a7
	ecall						# faz a chamada de sistema
	
	ret						# retorna
	
 ########################################
 # funcao: partida			#
 # argumentos: a2 -> matriz_jogo	#
 #	      a1 -> matriz_navios	#
 #	      a0 -> navios		#
 # retorno: nenhum			#
 # comentário: apresenta toda a partida #
 ########################################

partida:

	j loop_partida				# desvia para loop_partida
	
partida_menu:

	la a1, matriz_jogo			# carrega o endereço de matriz_jogo em a1
	
	jal s9, imprime_matriz_navios		# imprime matriz do jogo
	
	jal s9, placar				# imprime o placar do jogo
	
	la a0, opcoes				# carrega opcoes em a0
	li a7, 4				# carrega o imediato 4 (print string) em a7
	ecall					# faz a chamada de sistema
	li a7, 5				# carrega o imediato 5 (read int) em a7
	ecall					# faz a chamada de sistema
	
	addi a1, zero, 1			# a1 -> 1
	beq a0, a1, partida_reiniciar		# caso opcao = 1 -> reiniciar jogo
	
	addi a1, zero, 2			# a1 -> 2
	beq a0, a1, partida_mostrar_matriz	# caso opcao = 2 -> mostrar matriz de navios
	
	addi a1, zero, 3			# a1 -> 3
	beq a0, a1, partida			# caso opcao = 3 -> continuar a partida
	
	beq a0, zero, partida_fim		# caso opcao = 0 -> sair
	
	la a0, opcao_invalida			# caso opcao diferente de 1, 2, 3 e 4, imprime opcao errada e pede de novo
	li a7, 4				# carrega o imediato 4 (print string) em a7
	ecall					# faz a chamada de sistema
	
	j partida_menu				# desvia para partida_menu
	
partida_reiniciar:

	la a1, matriz_jogo			# coloca a matriz_jogo em a1
	
	jal s9, zera_matriz			# coloca todos os valores valendo 0

partida_reiniciar_placar:

	la s0, voce_placar			# carrega o endereço de voce_placar em s0
	sw zero, 0(s0)				# afundados (voce) = 0

	addi s0, s0, 4				# vai para o proximo valor de s0
	sw zero, 0(s0)				# tiros (voce) = 0
	
	addi s0, s0, 4				# vai para o proximo valor de s0
	sw zero, 0(s0)				# acertos (voce) = 0

	j partida				# desvia para partida

partida_mostrar_matriz:

	la a1, matriz_navios			# a1 -> matriz dos navios
	jal s9, imprime_matriz_navios		# imprime a matriz dos navios
	
	j partida_menu				# desvia para partida_menu
	
loop_partida:

	# Linha = t4
	# Coluna = t5

	la a0, linha				# imprime string com "Linha: "
	li a7, 4				# carrega o imediato 4 (print string) em a7
	ecall					# faz a chamada de sistema
	li a7, 5				# carrega o imediato 5 (read int) em a7
	ecall					# faz a chamada de sistema
	
	addi t4, a0, 0				# guarda o valor da linha em t4
	
	la a0, coluna 				# imprime string com "Coluna: "
	li a7, 4				# carrega o imediato 4 (print string) em a7
	ecall					# faz a chamada de sistema
	li a7, 5				# carrega o imediato 5 (read int) em a7
	ecall					# faz a chamada de sistema
	
	addi t5, a0, 0				# guarda o valor da coluna em t5
	
	jal s9, partida_placar_l_c		# desvia para partida_placar_l_c guardando o r.a. em s9
	
loop_partida_checa_valores:

	addi s11, zero, 1			# s11 -> 1 (quer dizer que em checa_valores, apos checar a linha e coluna, retorna)
	jal s9, checa_valores			# checa se linha e coluna sao validas
	
	beq a2, zero, partida_mensagem_erro	# vai para partida_mensagem_erro caso partida seja inválida
	
loop_partida_coloca_valores:

	jal s7, partida_coloca_valores		# vai para partida_coloca_valores para colocar a posicao do barco digitada
	
	beq a2, zero, partida_menu		# se errou, vai para partida_menu
	
loop_partida_checa_afundou:

	jal s7, partida_checa_fim		# vai para partida_checa_fim (checa se afundou algum barco)
	
	beq a2, zero, partida_menu		# se nao afundou nenhum, vai para partida_menu
	
loop_partida_fim:

	la a0, navios_escolhidos		# carrega o endereço de navios escolhidos em a0
	lw t1, 0(a0)				# carrega o valor de a0 em t1
	
	addi a0, zero, 0			# a0 -> 0
	beq t1, a0, lpf0			# desvia se t1 = a0
	
	addi a0, zero, 1			# a0 -> 1
	beq t1, a0, lpf1			# desvia se t1 = a0
	
	addi a0, zero, 2			# a0 -> 2
	beq t1, a0, lpf2			# desvia se t1 = a0
	
	addi a0, zero, 3			# a0 -> 3
	beq t1, a0, lpf3			# desvia se t1 = a0
	
	addi a0, zero, 4			# a0 -> 4
	beq t1, a0, lpf4			# desvia se t1 = a0

lpf0:

	la a0, navios0				# carrega o endereco de navios0 em a0
	lb t1, 0(a0)			        # t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_fim_continua			# desvia para loop_fim_continua
	
lpf1:

	la a0, navios1				# carrega o endereco de navios1 em a0
	lb t1, 0(a0)			        # t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_fim_continua			# desvia para loop_fim_continua
	
lpf2:

	la a0, navios2				# carrega o endereco de navios2 em a0
	lb t1, 0(a0)			        # t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_fim_continua			# desvia para loop_fim_continua
	
lpf3:

	la a0, navios3				# carrega o endereco de navios3 em a0
	lb t1, 0(a0)			        # t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_fim_continua			# desvia para loop_fim_continua
	
lpf4:

	la a0, navios4				# carrega o endereco de navios4 em a0
	lb t1, 0(a0)			        # t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)

loop_fim_continua:
			
	la s2, voce_placar
	lw s2, 0(s2)				# s2 -> numero de navios afundados
	
	bne s2, t1, partida_menu		# se ainda não afundou todos os navios, vai para partida_menu
	
	la a0, mensagem_venceu			# imprime mensegem que venceu
	li a7, 4				# carrega o imediato 4 (print string) em a7
	ecall					# faz a chamada de sistema
	
partida_fim:

	ret					# retorna
	
partida_placar_l_c:

	addi a5, t4, 0				# a5 -> posicao da linha (para o placar)
	addi a6, t5, 0				# s6 -> posicao da coluna (para o placar)
	jr s9					# retrna para o endereço de s9
	
partida_mensagem_erro:

	la a0, error_message_partida		# imprime mensagem de partida inválida
	li a7, 4				# carrega o imediato 4 (print string) em a7
	ecall					# faz a chamada de sistema
	
	j partida_menu				# desvia para partida_menu
	
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

	addi s2, zero, 10			# QTD_colunas
	mul s3, t4, s2				# L * QTD_colunas
	addi s5, zero, 4			# s5 -> 4
	add s3, s3, t5				# L * QTD_colunas + C
	mul s2, s3, s5				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2				# a1 -> deslocado s2 vezes
	
	lb s5, 0(a1)				# s5 -> valor na posicao a1
	
	add a2, a2, s2
	
	lb s6, 0(a2)				# s6 -> valor na posicao em matriz_jogo
	
	bne s6, zero, partida_ja_realizada	# se o valor for diferente de 0, jogada ja foi feita
	
	la s0, voce_placar
	addi s1, zero, 1
	jal s9, configura_placar		# tiros + 1
	
	
	beq s5, zero, partida_errou		# identifica que errou a posição de um navio se o valor lido for 0
	
partida_acertou:

	addi s4, zero, 1			# s4 -> 1 (acertou navio)
	sb s4, 0(a2)				# coloca 1 na posicao escolhida
	
	addi a2, zero, 1			# a2 = 1 (acertou)
	
	la s0, voce_placar
	addi s1, zero, 2
	jal s9, configura_placar		# acertos + 1
	
	jr s7

partida_errou:

	addi s4, zero, -1			# s4 -> -1 (errou navio)
	sb s4, 0(a2)				# coloca -1 na posicao escolhida
	addi a2, zero, 0			# a2 = 0 (errou)
	
	jr s7
	
partida_ja_realizada:

	la a0, error_message_partida_repetida
	li a7, 4
	ecall
	
	jr s7
	
#########################################################
# partida_checa_fim
# retorno: a2 = 1 (terminou) ou a2 = 0 (não terminou)
# comentário: retora 1 em a2, se afundou um navio, ou 0 se não afundou nenhum, posicao onde afundou fica com -2
#########################################################

partida_checa_fim:

	la a0, navios_escolhidos		# carrega o endereço de navios escolhidos em a0
	lw t1, 0(a0)				# carrega o valor de a0 em t1
	
	addi a0, zero, 0			# a0 -> 0
	beq t1, a0, pf0				# desvia se t1 = a0
	
	addi a0, zero, 1			# a0 -> 1
	beq t1, a0, pf1				# desvia se t1 = a0
	
	addi a0, zero, 2			# a0 -> 2
	beq t1, a0, pf2				# desvia se t1 = a0
	
	addi a0, zero, 3			# a0 -> 3
	beq t1, a0, pf3				# desvia se t1 = a0
	
	addi a0, zero, 4			# a0 -> 4
	beq t1, a0, pf4				# desvia se t1 = a0
	
pf0:

	la a0, navios0				# carrega o endereço de navios0 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_partida_checa_fim		# desvia para loop_partida_checa_fim
	
pf1:

	la a0, navios1				# carrega o endereço de navios1 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_partida_checa_fim		# desvia para loop_partida_checa_fim
	
pf2:

	la a0, navios2				# carrega o endereço de navios2 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_partida_checa_fim		# desvia para loop_partida_checa_fim
	
pf3:

	la a0, navios3				# carrega o endereço de navios3 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j loop_partida_checa_fim		# desvia para loop_partida_checa_fim
	
pf4:

	la a0, navios4				# carrega o endereço de navios4 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
loop_partida_checa_fim:

	ble t1, zero, partida_terminou          # desvia se ja leu todos os navios
	jal s9, le_navio			# le o proximo navio
	
loop_navio:

	beq zero, t3, partida_terminou		# percorre todas as posicoes do navio ate tamanho ser menor ou igual a 0

	addi s4, zero, 1			# s4 -> 1 (para testar se posicao tem 1)
	addi s2, zero, 10			# QTD_colunas
	
	la a1, matriz_jogo

	mul s3, t4, s2				# L * QTD_colunas
	addi s5, zero, 4			# s5 -> 4
	add s3, s3, t5				# L * QTD_colunas + C
	mul s2, s3, s5				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2				# a1 -> deslocado s2 vezes
	
	lb s5, 0(a1)				# s5 -> valor na posicao
	
	bne s5, s4, partida_navio_nao_encontrado # se valor nao for 1, nao afundou o navio
	
continua:

	bne t2, zero, loop_navio_vertical	# desvia para loop_navio_vertical se o barco for vertical
	
loop_navio_horizontal:

	addi t5, t5, 1				# t5 + 1 -> aumenta coluna inicial
	j loop_navio_valores_decrementa			
	
loop_navio_vertical:

	addi t4, t4, 1				# t4 + 1 -> aumenta linha inicial
	
loop_navio_valores_decrementa:

	addi t3, t3, -1				# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	j loop_navio
	
partida_terminou:

	addi a2, zero, 1			# a2 -> 1 (afundou um navio)
	
	la s0, voce_placar
	addi s1, zero, 0
	jal s9, configura_placar		# afundados (voce) + 1
	
	jal s9, afunda_navio			# chama funcao que coloca -2 nas posicoes do navio afundado
	
	jr s7
	
partida_navio_nao_encontrado:

	addi t1, t1, -1
	bne  t1, zero, loop_partida_checa_fim
	
partida_nao_terminou:
	
	addi a2, zero, 0			# a2 -> 0 (nao afundou nenhum navio)

	jr s7

	
 ########################################################
 # funcao: le_navio					#
 # argumentos: a0 - endereço inicial da string navios	#
 # retorno: 						#
 # t1 -> contador de barcos				#
 # t2 -> direcao do barco				#
 # t3 -> tamanho do barco				#
 # t4 -> linha inicial do barco				#
 # t5 -> coluna inicial do barco			#			
 # comentário: a função lê os navios a serem inseridos, #
 # checando caso sejam válidos e os inserindo na matriz #
 ########################################################

le_navio:

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
	
	jr s9					# desvia para o endereco em s9

 ########################################################
 # funcao: checa_valores				#
 # argumentos: a1 -> matriz_navios			#
 # retorno: a2 = 1 (se for válida)			#
 #	    a2 = 0 (se não for válida)			#
 # comentário: checa se os valores do barco são válidos #
 ########################################################

checa_valores:

	addi s2, zero, 9			# adiciona 9 (numero maximo de cada linha/coluna) em s2
	addi t6, zero, 1			# adiona 1 (opcao vertical) em t6
	
checa_posicao:

	blt t4, zero, erro_encontrado		# identifica erro se a linha for menor que 0
	blt t5, zero, erro_encontrado		# identifica erro se a coluna for menor que 0
	
	bgt t4, s2, erro_encontrado		# identifica erro se a linha for maior que 9
	bgt t5, s2, erro_encontrado		# identifica erro se a coluna for maior que 9
	
	bne s11, zero, fim_checa_valores	# desvia para fim_checa_valores se s11 for 0 (nao estamos em jogo)
	
checa_primeiro_digito:				# checa o primeiro digito -> deve ser igual a 0 ou 1
			
	bgt t2, t6, erro_encontrado		# identifica erro se a posição for maior que 1
	addi t6, zero, 10			# adiciona 10 (quantidade de linhas e colunas) em t6
	blt t2, zero, erro_encontrado		# identifica erro se a posição for menor que 0
	
checa_tamanho:

	la s0, recorde_placar			# carrega o endereço de recorde_placar em s0
	addi s0, s0, 4				# vai para proxima posicao de s0
	lw s1, 0(s0)				# carrega em s1 o conteudo de s0
	add s1, s1, t3				# adiciona o valor de t3 em s1
	sw s1, 0(s0)				# numero de tiros e acertos do recorde
	
	blt t3, zero, erro_encontrado		# identifica erro se o tamanho do barco for menor que 0
	bgt t3, t6, erro_encontrado		# identifica erro se o tamanho do barco for maior que 10
	
checa_horizontal:

	bne t2, zero, checa_vertical		# desvia para checa_vertical se o barco for vertical
	add t6, t5, t3				# t6 -> tamanho do barco + coluna inicial (para verificar se ultrapassa as dimensoes)
	
	j checa_limite				# desvia para checa limite
	
checa_vertical:

	add t6, t4, t3				# t6 -> tamanho do barco + linha inicial (para verificar se ultrapassa as dimensoes)

checa_limite:

	addi t6, t6, -1				# diminui o valor de t6 em 1
	bgt t6, s2, erro_encontrado		# desvia para erro_encontrado se t6 for maior que s2

checa_sobreposicao:

	# t3 -> tamanho do barco -> s6
	# t4 -> linha inicial do barco -> s8 se vertical
	# t5 -> coluna inicial do barco -> s7 se horizontal
	
	addi s6, t3, 0 				# s6 -> tamanho do barco
	addi s7, t5, 0				# s7 -> coluna inicial
	addi s8, t4, 0				# s8 -> linha inicial
	
loop_checa_sobreposicao:

	bge zero, s6, fim_checa_valores		# desvia para checks_values_ends se já passou por todas posições que o barco ocupará
	
	addi s2, zero, 10			# QTD_colunas
	
	la a1, matriz_navios			# a1 -> posicao inicial da matriz

	mul s3, s8, s2				# L * QTD_colunas
	addi s5, zero, 4			# s5 -> 4
	add s3, s3, s7				# L * QTD_colunas + C
	mul s2, s3, s5				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2				# a1 -> delocado s2 vezes 

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

	addi a2, zero, 1			# a2 = 1 (valida)
	
	jr s9					# desvia para o endereço de s9

erro_encontrado:

	addi a2, zero, 0			# a2 = 0 (invalida)
	
	jr s9					# desvia para o endereço de s9

 ############################################
 # funcao: coloca_valores		    #
 # argumentos: a1 -> matriz_navios	    #
 # retorno: a1 possui o barco inserido nela #
 # comentário: insere um barco na matriz    #
 ############################################

coloca_valores:
		
	addi s4, s4, 1 				# incrementa s4 (numero que representa o navio na matriz) em 1
	
loop_coloca_valores:

	bge zero, t3, fim_coloca_valores 	# percorre todas as posicoes do navio ate tamanho ser menor ou igual a 0
	
	addi s2, zero, 10			# QTD_colunas
	
	la a1, matriz_navios			# carrega o endereço de matriz_navios em a1

	mul s3, t4, s2				# L * QTD_colunas
	addi s5, zero, 4			# s5 -> 4
	add s3, s3, t5				# L * QTD_colunas + C
	mul s2, s3, s5				# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2				# a1 -> deslocado s2 vezes
	
	sb s4, 0(a1)				# a posicao de a1 recebe o valor que identifica o barco
	
	bne t2, zero, coloca_valores_vertical 	# desvia para coloca_valores_vertical se o barco for vertical
	
coloca_valores_horizontal:

	addi t5, t5, 1				# t5 + 1 -> aumenta coluna inicial
	j coloca_valores_decrementa		# desvia para coloca_valores_decrementa
	
coloca_valores_vertical:

	addi t4, t4, 1				# t4 + 1 -> aumenta linha inicial
	
coloca_valores_decrementa:

	addi t3, t3, -1				# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	j loop_coloca_valores			# desvia para loop_coloca_valores
	
fim_coloca_valores:

	jr s9					# desvia para o endereço de s9

 #################################
 # funcao: imprime_matriz_navios #
 # argumentos: a1 -> matriz	 #
 # retorno:(nenhum retorno)	 #
 # comentario: imprime a matriz	 #
 #################################

imprime_matriz_navios:

	la a0, new_line 			# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi a4, a1, 0 				# coloca o valor de a1 (endereço incial da matriz) em a4
	addi t0, zero, 100 			# contador do tamanho da matriz (t0 recebe o numero de elementos da matriz)
	addi t1, zero, 10 			# contador das quebras de linha (t1 recebe o tamanho da linha da matriz)
	
p_loop:

	beq t1, zero, p_break 			# desvia se t1 (contador das quebras de linha) for igual a 0
	bge zero, t0, p_end 			# desvia se t0 (contador do tamanho da matriz) for menor ou igual a 0 ("maior que" invertido)
	
	lb a0, 0(a4) 				# coloca em a0 o conteudo de a4 (o primeiro elemento da lista) 
	li a7, 1 				# coloca o valor 1 em a7 (1 = imprimir inteiro)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, space 				# coloca o {str_space} em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi a4, a4, 4 				# vai para o proximo valor de a4 (adicionando 4)
	
	addi t0, t0, -1 			# decrementa o contador do tamanho da matriz
	addi t1, t1, -1 			# decrementa o contador das quebras de linha

	j p_loop 				# desvia para {p_loop}

p_break:

	la a0, new_line 			# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi t1, zero, 10 			# reinicia o contador em t1 (contador das quebras de linha)
		
	j p_loop 				# desvia para {p_loop}

p_end:

	jr s9 					# retorna


#########################################################
# afunda_navio
# retorno: nas posicoes do navio afundado, fica com -2
#
#########################################################
afunda_navio:

	la s4, navios_escolhidos		# carrega o endereço de navios escolhidos em s4
	lw t2, 0(s4)				# carrega o valor de s4 em t2
	
	addi s4, zero, 0			# s4 -> 0
	beq t2, s4, an0				# desvia se t2 = s4
	
	addi s4, zero, 1			# s4 -> 1
	beq t2, s4, an1				# desvia se t2 = s4
	
	addi s4, zero, 2			# s4 -> 2
	beq t2, s4, an2				# desvia se t2 = s4
	
	addi s4, zero, 3			# s4 -> 3
	beq t2, s4, an3				# desvia se t2 = s4
	
	addi s4, zero, 4			# s4 -> 4
	beq t2, s4, an4				# desvia se t2 = s4
	
an0:

	la s4, navios0				# carrega o endereço de navios0 em s4
	lb t2, 0(s4)				# carrega o valor de s4 em t2
	addi t2, t2, -48  			# t2 -> barcos totais
	
	j afunda_continuacao			# desvia para afunda_continuacao

an1:

	la s4, navios1				# carrega o endereço de navios1 em s4
	lb t2, 0(s4)				# carrega o valor de s4 em t2
	addi t2, t2, -48  			# t2 -> barcos totais
	
	j afunda_continuacao			# desvia para afunda_continuacao
	
an2:

	la s4, navios2				# carrega o endereço de navios2 em s4
	lb t2, 0(s4)				# carrega o valor de s4 em t2
	addi t2, t2, -48  			# t2 -> barcos totais
	
	j afunda_continuacao			# desvia para afunda_continuacao
	
an3:

	la s4, navios3				# carrega o endereço de navios3 em s4
	lb t2, 0(s4)				# carrega o valor de s4 em t2
	addi t2, t2, -48  			# t2 -> barcos totais
	
	j afunda_continuacao			# desvia para afunda_continuacao
	
an4:

	la s4, navios4				# carrega o endereço de navios4 em s4
	lb t2, 0(s4)				# carrega o valor de s4 em t2
	addi t2, t2, -48  			# t2 -> barcos totais
			
afunda_continuacao:
	
	addi a3, t1, 0   # t1 -> barco atual em ordem contrária
	addi s3, zero, -1
	mul a3, a3, s3
	add t1, t2, a3
	addi t1, t1, 1  # t1 -> barco atual
	
	addi s3, zero, 6
	mul s3, s3, t1
	add t1, t2, a3
	addi a3, zero, 2
	mul t1, t1, a3
	add s3, s3, t1  # deslocamento
			#6 * barco_atual(t1) = 6
			# x = barcos totais(ler em t4 -> 3) - barco atual(a3 -> 3) = 0
			# x * 2 = 0
			# 6 * barco_atual(t1) + x * 2 = 6
	
	add s4, s4, s3
	
	addi t2, zero, -4
	
	add s4, s4, t2
	
	lb t2, 0(s4)
	addi t2, t2, -48  # t2 -> horizontal ou vertical
	
	addi s4, s4, 2
	
	lb t3, 0(s4)
	addi t3, t3, -48  # t3 -> tamanho
	
	addi s4, s4, 2
	
	lb t4, 0(s4)
	addi t4, t4, -48  # t4 -> linha inicial
	
	addi s4, s4, 2
	
	lb t5, 0(s4)
	addi t5, t5, -48  # t5 -> coluna inicial
	
	
	addi s4, zero, -2  # s4 -> -2 (afundou)

loop_afunda_navio:

	bge zero, t3, fim_afunda_navio		# percorre todas as posições do navio até tamanho ser menor ou igual a 0
	
	addi s2, zero, 10		# QTD_colunas
	
	la a1, matriz_jogo

	mul s3, t4, s2			# L * QTD_colunas
	addi s5, zero, 4		# s5 -> 4
	add s3, s3, t5			# L * QTD_colunas + C
	mul s2, s3, s5			# s2 -> (L * QTD_colunas + C) * 4 -> deslocamento para posição
	
	add a1, a1, s2			# a1 -> é delocado s2 vezes
	
	sb s4, 0(a1)			# a posição de a1 recebe o valor que identifica que o barco afundou
	
	bne t2, zero, afunda_navio_vertical # desvia para coloca_valores_vertical se o barco for vertical
	
afunda_navio_horizontal:

	addi t5, t5, 1			# t5 + 1 -> aumenta coluna inicial
	j afunda_navio_decrementa			
	
afunda_navio_vertical:

	addi t4, t4, 1			# t4 + 1 -> aumenta linha inicial
	
afunda_navio_decrementa:

	addi t3, t3, -1			# decrementa o tamanho do barco em 1 para continuar preenchendo na matriz
	j loop_afunda_navio
	
fim_afunda_navio:

	jr s9

 ############################
 # funcao: zera_matriz	    #
 # argumentos: a1 -> matriz #
 # retorno: matriz de 0's   #
 ############################

zera_matriz:

	addi a4, a1, 0			# coloca o valor de a1 (endereço incial da matriz) em a4
	addi t0, zero, 100 		# contador do tamanho da matriz (t0 recebe o numero de elementos da matriz)
	
zera_loop:

	bge zero, t0, zera_end 		# desvia se t0 (contador do tamanho da matriz) for menor ou igual a 0 ("maior que" invertido)
	
	sb zero, 0(a4) 			# coloca em a4 o valor zero
	
	addi a4, a4, 4			# vai para o proximo valor de a4 (adicionando 4)
	
	addi t0, t0, -1 		# decrementa o contador do tamanho da matriz

	j zera_loop 			# desvia para zera_loop
	
zera_end:

	jr s9 				# retorna	
	
 #######################################################
 # funcao: placar				       #
 # retorno:(nenhum retorno)			       #
 # comentário: mostra o placar do jogador e do recorde #
 #######################################################

placar:

	la a0, new_line 			# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, navios_escolhidos		# carrega o endereço de navios escolhidos em a0
	lw a7, 0(a0)				# carrega o valor de a0 em a7
	
	addi a0, zero, 0			# a0 -> 0
	beq a7, a0, p0				# desvia se a7 = a0
	
	addi a0, zero, 1			# a0 -> 1
	beq a7, a0, p1				# desvia se a7 = a0
	
	addi a0, zero, 2			# a0 -> 2
	beq a7, a0, p2				# desvia se a7 = a0
	
	addi a0, zero, 3			# t0 -> 3
	beq a7, a0, p3				# desvia se a7 = a0
	
	addi a0, zero, 4			# t0 -> 4
	beq a7, a0, p4				# desvia se a7 = a0
	
p0:

	la a0, navios0				# coloca o endereço de navios0 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j placar_recorde			# desvia para placar recorde
	
p1:

	la a0, navios1				# coloca o endereço de navios1 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j placar_recorde			# desvia para placar recorde
	
p2:

	la a0, navios2				# coloca o endereço de navios2 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j placar_recorde			# desvia para placar recorde
	
p3:

	la a0, navios3				# coloca o endereço de navios3 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	j placar_recorde			# desvia para placar recorde
	
p4:

	la a0, navios4				# coloca o endereço de navios4 em a0
	lb t1, 0(a0)				# t1 -> contador de barcos (em ascii)
	addi t1, t1, -48			# subtrai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
placar_recorde:

	la a0, recorde				# coloca recorde em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la s0, recorde_placar			# carrega o endereço de recorde_placar em s0
	
	la a0, afundados			# coloca afundados em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	lw s1, 0(s0)				# carrega o valor do emdereço de s0 em s1 (quantidade de afundados -> recorde)
	addi a0, s1, 0				# a0 -> s1
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, tiros				# coloca tiros em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi s0, s0, 4				# vai para o proximo valor de s0	
	lw s1, 0(s0)				# carrega o valor do emdereço de s0 em s1 (qantidade de tiros -> recorde)
	addi a0, s1, 0				# a0 -> s1
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, acertos				# coloca acertos em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)

	addi a0, s1, 0				# adiciona o valor de s1 em a0 (quantidade de acertos -> recorde)
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
placar_voce:

	la a0, voce				# coloca voce em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la s0, voce_placar			# carrega voce_placar em s0
	
	la a0, afundados			# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	lw s1, 0(s0)				# carrega o valor do emdereço de s0 em s1 (quantidade de afundados -> voce)
	addi a0, s1, 0				# a0 -> s1
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, tiros				# coloca tiros em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi s0, s0, 4				# vai para o proximo valor de s0	
	lw s1, 0(s0)				# carrega o valor do emdereço de s0 em s1 (quantidade de tiros -> voce)
	addi a0, s1, 0				# a0 -> s1
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, acertos				# coloca acertos em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)

	addi s0, s0, 4				# vai para o proximo valor de s0	
	lw s1, 0(s0)				# carrega o valor do emdereço de s0 em s1 (quantidade de acertos -> voce)
	addi a0, s1, 0				# a0 -> s1
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, ultimo_tiro			# carrega o endereço ultimo_tiro em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi a0, a5, 0				# a0 -> a5 (linha ultimo tiro)
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, space				# coloca space em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	addi a0, a6, 0				# a0 -> a6 (coluna ultimo tiro)
	li a7, 1				# coloca o valor 1 em a7 (1 = imprimir inteirp)
	ecall					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	la a0, new_line				# coloca new_line em a0
	li a7, 4 				# coloca o valor 4 em a7 (4 = imprimir string)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	ecall 					# faz a chamada de sistema (usando sempre o valor que esta em a7)
	
	jr s9					# desvia para o endereço de a9
	
#########################################################
# configura_placar
# argumentos: s0 -> placar
#	      s1 -> opcao
# retorno: a2 = 1 (terminou) ou a2 = 0 (não terminou)
# comentário: retora 1 em a2, se afundou um navio, ou 0 se não afundou nenhum, posicao onde afundou fica com -2
#########################################################

configura_placar:

	beq s1, zero, aumenta_afundados
	
	addi s10, zero, 1
	
	beq s10, s1, aumenta_tiros
	
	addi s10, zero, 2
	
	beq s10, s1, aumenta_acertos

aumenta_afundados:

	lw s1, 0(s0) 
	addi s1, s1, 1
	sw s1, 0(s0)		# afundados + 1
	
	jr s9
	
aumenta_tiros:

	addi s0, s0, 4
	lw s1, 0(s0) 
	addi s1, s1, 1
	sw s1, 0(s0)		# tiros + 1
	
	jr s9
	
aumenta_acertos:

	addi s0, s0, 8
	lw s1, 0(s0) 
	addi s1, s1, 1
	sw s1, 0(s0)		# acertos + 1
	
	jr s9

 ###################################################
 # funcao: reset				   #
 # retorno: a0 -> posição inicial da string navios #
 #	   a1 -> posição inicial da matriz_navios  #
 # 	   a2 -> posição inicial da matriz_jogo	   #
 ###################################################

reset:

	la t0, navios_escolhidos		# carrega o endereço de navios escolhidos em t0
	lw t1, 0(t0)				# carrega o valor de t0 em t1
	
	addi t0, zero, 0			# t0 -> 0
	beq t1, t0, r0				# desvia se t1 = t0
	
	addi t0, zero, 1			# t0 -> 1
	beq t1, t0, r1				# desvia se t1 = t0
	
	addi t0, zero, 2			# t0 -> 2
	beq t1, t0, r2				# desvia se t1 = t0
	
	addi t0, zero, 3			# t0 -> 3
	beq t1, t0, r3				# desvia se t1 = t0
	
	addi t0, zero, 4			# t0 -> 4
	beq t1, t0, r4				# desvia se t1 = t0

r0:

	la a0, navios0				# carrega a string navios0 em a0
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2
	
	ret					# retorna
	
r1:

	la a0, navios1				# carrega a string navios1 em a0
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2
	
	ret					# retorna
	
r2:

	la a0, navios2				# carrega a string navios2 em a0
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2
	
	ret					# retorna
	
r3:

	la a0, navios3				# carrega a string navios3 em a0
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2
	
	ret					# retorna
	
r4:

	la a0, navios4				# carrega a string navios4 em a0
	la a1, matriz_navios			# carrega a matriz_navios em a1
	la a2, matriz_jogo			# carrega a matriz_jogo em a2
	
	ret					# retorna
