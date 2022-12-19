		.data

navios:		.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

matriz_navios: 	  .space 	400


	.text
main: 

	la 	a0, navios  			# imprime string com posição dos navios
	li 	a7,4
	ecall


	
	la 	a0, navios  			# a0 recebe o endereço inicial da string navios
	la	a1, matriz_navios 		# a1 recebe o endereço inicial da matriz navios
	jal	insere_embarcacoes		# chama função que insere os navios



	la 	a0, matriz_navios  		# a0 recebe o endereço inicial da string navios
	li	a1, 1				# a1 indica que deve mostrar os navios
	jal	imprime_interface_navios	# imprime matriz depois de posicionar os navios




fim:	
	nop
	li   a7, 10
	ecall

#########################################################
#insere_embarcacoes
# argumentos: a0 - endereço inicial da matriz navios
#             a1 - 0 imprime interface - 1 imprime navios
# retorno: ---- (nenhum retorno)
# comentário: 
#
#########################################################
insere_embarcacoes:

		

	ret	




#########################################################
# imprime_matriz_navios
# argumentos: a0 - endereço inicial da matriz navios
#             a1 - 0 imprime interface - 1 imprime navios
# retorno: ---- (nenhum retorno)
# comentário: 
#
#########################################################
imprime_interface_navios:



	ret	

