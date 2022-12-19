# Mateus Azor - 2011100013
# Nat·lia Banhara - XXXXXXXXXX

	.data

ship_list:	.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

ship_matrix: 	.space 	400

	.text
main: 

	la 	a0, ship_list			# carrega o endereco de ship_list em a0
	li 	a7,4				# carrega o imediato 4 em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema
	
	la 	a0, ship_list  			# carrega o endereco de ship_list em a0
	la	a1, ship_matrix 		# carrega o endereco de ship_matrix em a0
	jal	insert_ships			# chama a funcao insert_ships (ra -> t1)

	la 	a0, ship_matrix  		# a0 recebe o endere√ßo inicial da string navios
	li	a1, 1				# a1 indica que deve mostrar os navios
	jal	print_ships			# imprime matriz depois de posicionar os navios

main_end:	

	nop
	li   a7, 10
	ecall

# Nome: insert_ship
# Argumentos:
# Retorno:

insert_ships:

	ret

# Nome: print_ships
# Argumentos:
# Retorno:
print_ships:

	ret