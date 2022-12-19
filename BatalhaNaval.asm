# Mateus Azor - 2011100013
# Natália Banhara - XXXXXXXXXX

# INFO
# ship_list: [número de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

ship_list:	.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

ship_matrix: 	.space 	400			# 10 x 10 x 4 (integer size)

	.text
main: 

	la 	a0, ship_list			# carrega o endereco de ship_list em a0
	li 	a7,4				# carrega o imediato 4 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema
	
	la 	a0, ship_list  			# carrega o endereco de ship_list em a0
	la	a1, ship_matrix 		# carrega o endereco de ship_matrix em a0
	jal	insert_ships			# chama a funcao insert_ships (ra -> t1)

	la 	a0, ship_matrix  		# a0 recebe o endereÃ§o inicial da string navios
	li	a1, 1				# a1 indica que deve mostrar os navios
	jal	print_ships			# imprime matriz depois de posicionar os navios

main_end:	

	nop					# no operation
	li   a7, 10				# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema

# Nome: insert_ship
# Argumentos: a0 -> ship_list | a1 -> ship_matrix
# Retorno: XXX

insert_ships:

	lw t0, 0(a0)
	addi t0, t0, -48
	mv a0, t0
	
	li a7, 1
	ecall

	ret

# Nome: print_ships
# Argumentos: XXX
# Retorno: XXX

print_ships:

	ret