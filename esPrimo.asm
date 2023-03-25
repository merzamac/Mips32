.data
    mensaje1: .asciiz "Ingrese un número: "
    mensaje2: .asciiz "El número ES PRIMO."
    mensaje3: .asciiz "El número NO ES PRIMO."
.text
    .globl main
    main:
        li $v0, 4	#obtener el numero desde la consola
        la $a0, mensaje1
        syscall

        li $v0, 5
        syscall
        
        move $a0, $v0	# el numero lo pasamos a $a0, sera el parametro para la funcion
        li   $a1,2	# $a1 sera el otro pasametro y lo iniciamos en 2
	jal ES_PRIMO	# saltamos a la funcion ES_PRIMO
	
	
	move $t0, $v0	# el resultado obtenido lo movemos a la variable $t0
	li $t1,1	# $t1 la usaremos para comparar con el resultado
        beq $t1,$t0, ES # si la funcion retorna 1, es primo 

        li $v0, 4
        la $a0, mensaje3 # mensaje no es primo
        syscall
        j fin

    ES:		# mensaje es primo
        li $v0, 4
        la $a0, mensaje2
        syscall

    fin:		#fin
    	li $v0, 10
        syscall
#--------------------------------------------------------------
    .globl ES_PRIMO
    ES_PRIMO:
	addi 	$sp,$sp,-8   	# ajustar la pila para 2 elementos
	sw 	$ra, 4($sp) 	# guardar la direccionn de retorno
	sw 	$a1, 0($sp)  	# guardar el argumento --> divisor
			     	# $a0 -> numero, nunca cambiara de valor
	
	div 	$t1,$a0,2    	# $t1 <-- numero/2 
	slt 	$t2,$t1,$a1 	# $t2 <-- ($t1 < divisor)? 0:1
	beq 	$t2,$zero,ELSE1 # $t2==0 --> ELSE 
	li 	$v0,1		# carga inmediata $v0 --> retornar 1 
	addi 	$sp,$sp,8 	# eliminar 2 elementos de la pila
	jr 	$ra 		# retornar al llamador
	
    ELSE1: 	
    	div 	$a0,$a1		# numero/divisor
	mfhi 	$t1		# obtengo resultado del registro $HI, donde se guardo el residuo de la divicion anterio
	bne 	$t1,$zero,ELSE2 # $t1(residuo) != 0 ?: 1->ELSE 
	li 	$v0,0		# carga inmediata $v0 --> retornar 0 
	addi 	$sp,$sp,8 	# eliminar 2 elementos de la pila
	jr 	$ra 		# retornar al llamador
	
    ELSE2: 	
        addi 	$a1,$a1,1 	# divisor + 1
	jal 	ES_PRIMO 	#llamar a ES_PRIMO con (numero, divisor + 1)
	
	lw 	$a1, 0($sp) 	# retorno de jal:restaura el argumento n
	lw 	$ra, 4($sp) 	# restaura la direcciï¿½n de retorno
	addi 	$sp, $sp,8 	# ajusta el puntero de pila para eliminar
	jr 	$ra 		# retorna al llamador
