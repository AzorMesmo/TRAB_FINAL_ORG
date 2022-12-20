# Mateus Azor - 2011100013
# Natalia Banhara - 2011100004

# INFO
# ship_list: [numero de navios]\n[0 - horizontal / 1 - vertical] [comprimento do navio] [linha inicial] [coluna inicial]\n ...

	.data

ship_list:	.asciz	"3\n1 5 1 1\n0 5 2 2\n0 1 6 4"

ship_matrix: 	.space 	400			# 10 x 10 x 4 (integer size)

new_line:	.string "\n"

	.text
main: 
	# tirei do a0 pq agnt sempre usa o a0 pras system calls
	
	la a1, ship_list			# carrega o endereco de ship_list em a0
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
	
	lb t1, 0(a1)				# carrega o primeiro byte de a0 em t1 (contador de barcos)
	
	la a0, new_line
	li a7, 4
	ecall
	
	addi t1, t1, -48			# subritai 48 do valor de t1 (convertendo o numero em string para inteiro)
	
	mv a0, t2
	li a7, 1
	ecall
	
	#acho que agnt vai ter que ter dois loops, ou ler e inserir no mesmo loop (gosto mais dessa ideia se pa)
	
	# melhor pegar esses valores direto no loop ? pode ser mais facil ? n sei..
	#pegar o valor da horizontal ou vertical em t2
	#pegar o comprimento do navio em t3
	#depois comeca o looping
	
loop_insert_ships:

	beq t1, zero, end_insert_ships		# desvia se t1 (contador de barcos) for igual a 0
		#looping de cada navio -> inserção
		#antes de inserir o navio, checar exceções
		
		
		
	


end_insert_ships:
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
