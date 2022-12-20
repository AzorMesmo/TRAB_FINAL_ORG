# Mateus Azor - 2011100013
# Nat�lia Banhara - 2011100004

# INFO
# ship_list: [n�mero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

ship_list:	.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

ship_matrix: 	.space 	400			# 10 x 10 x 4 (integer size)

new_line:	.string "\n"

	.text
main: 

	la a0, ship_list			# carrega o endereco de ship_list em a0
	li a7,4				# carrega o imediato 4 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema
	
	la a1, ship_matrix 		# carrega o endereco de ship_matrix em a1
	
	addi s0, a0, 0 #carrega em s0 a posição inicial do a0 (ship_list)
	addi s1, a1, 0 #carrega em s1 a posição inicial do a1 (ship_matrix)
	
	jal insert_ships			# chama a funcao insert_ships (ra -> t1)

main_end:	

	nop					# no operation
	li   a7, 10				# carrega o imediato 10 (print string) em a7 (registrador de system calls)
	ecall					# faz a chamada de sistema

# Nome: insert_ship
# Argumentos: a0 -> ship_list | a1 -> ship_matrix
# Retorno: XXX

insert_ships:

	#lw t0, 0(a0)
	lb t0, 0(a0)
	
	la a0, new_line
	li a7, 4
	ecall
	
	addi t0, t0, -48
	mv a0, t0
	
	li a7, 1
	ecall

	addi t1, zero, 0 #set t1 (counter of boats to insert) to 0
	
	#pegar o valor da horizontal ou vertical em t2
	#pegar o comprimento do navio em t3
	#depois comeca o looping
	
loop_insert_ships:
	bge t1, t0, end_insert_ships
		#looping de cada navio -> inserção
		#antes de inserir o navio, checar exceções
		
	


end_insert_ships:
	ret

# Nome: print_ships
# Argumentos: XXX
# Retorno: XXX

print_ships:

	ret
	
reset:
	addi a0, s0, 0 #a0 volta para a posição inicial
	addi a1, s1, 0 #a1 volta para a posição inicial
	ret