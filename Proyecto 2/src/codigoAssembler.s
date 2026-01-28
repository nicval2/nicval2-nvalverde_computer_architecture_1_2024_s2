.global _start

.section .data
input_str: .asciz "10,20,\n30,40,"
buffer: .space 2054                  
newline: .asciz ",\n"

.section .text
_start:
    LDR R9, =input_str              @ Carga la dirección de la cadena de entrada
    LDR R0, =buffer                 @ Carga la dirección del buffer
    MOV R10 , #0
    MOV R11 , #0
    MOV R12 , #0
    MOV R7 , #0
            
    BL process_string               @ Procesa la cadena para encontrar y convertir los números

    @ Terminar el programa (llamada al sistema para salir)
    MOV R7, #1                      @ syscall: exit
    MOV R10, #0                      @ código de salida
    SWI 0

@ Función para procesar la cadena y convertir los números cuando se encuentra una coma
process_string:
    PUSH {R4, R5, LR}               @ Guardar registros utilizados
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    MOV R8, #0                      @ Índice de la cadena de entrada

process_loop:
    LDRB R3, [R9, R8]               @ Cargar el siguiente carácter de la cadena
    CMP R3, #0                      @ Comparar con el carácter nulo (fin de la cadena)
    BEQ process_done                @ Si es nulo, salir del bucle

    CMP R3, #44                     @ Comprobar si el carácter es una coma (ASCII 44)
    BEQ handle_comma                @ Si es una coma, manejar el número y continuar
    
    CMP R3, #10
    BEQ handle_space

    SUB R3, R3, #48                 @ Convertir el carácter ASCII a su valor numérico (0-9)

    MOV R2, #10
    MUL R4, R1, R2             @ Multiplica R1 por 10
    ADD R1, R4, R3

    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    B process_loop                  @ Repetir el bucle


handle_comma:
    ADD R10, R10, #1 
    
    ADD R12, R1, #0                 
    
    CMP R10, #1   
    BEQ A_loop
    
    MOV R5, #3 
    MOV R2, #2
    MUL R4, R2, R11
    ADD R4, R4, R12

    UDIV R1, R4, R5
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena

    @ Agregar la coma después del número en el buffer
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1               @ Almacenar la coma en el buffer y mover el puntero
    
    MOV R5, #3 
    MOV R2, #2
    MUL R4, R2, R12
    ADD R4, R4, R11

    UDIV R1, R4, R5
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena

    @ Agregar la coma después del número en el buffer
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1               @ Almacenar la coma en el buffer y mover el puntero
    
    @Calculo
    ADD R1, R12, #0
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena

    @ Agregar la coma después del número en el buffer
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1               @ Almacenar la coma en el buffer y mover el puntero
    
    
    MOV R11, R12
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    B process_loop                  @ Continuar procesando la cadena

A_loop:
    ADD R11, R1, #0
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1               @ Almacenar la coma en el buffer y mover el puntero
    
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    
    B process_loop                  @ Continuar procesando la cadena

handle_space:
    
    ADD R8, R8, #1
    MOV R10, #0 
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    MOV R5, R7
    MOV R6, R8
    PUSH {R7, R8, LR}               @ Guardar registros utilizados
    MOV R7, R5
    MOV R8, R6
    LDRB R4, =0x0A                  @ Cargar el carácter de nueva línea (ASCII 10)
    STRB R4, [R0], #1
    

    B process_loop2                  @ Continuar procesando la cadena
     

    
process_loop2:
    LDRB R3, [R9, R7]               @ Cargar el siguiente carácter de la cadena

    CMP R3, #44                     @ Comprobar si el carácter es una coma (ASCII 44)
    BEQ handle_comma2                @ Si es una coma, manejar el número y continuar
    
    CMP R3, #10
    BEQ handle_space2

    SUB R3, R3, #48                 @ Convertir el carácter ASCII a su valor numérico (0-9)

    MOV R2, #10
    MUL R4, R1, R2             @ Multiplica R1 por 10
    ADD R1, R4, R3

    ADD R7, R7, #1                @ Incrementar el índice de la cadena
    B process_loop2                  @ Repetir el bucle


handle_comma2:
    ADD R10, R10, #1 
    
    ADD R12, R1, #0                 
    
    CMP R10, #1   
    BEQ A_loop2
    
    MOV R12, R1
    ADD R7, R7, #1
    MOV R1, #0

    B process_loop3                 


handle_space2:
    ADD R7, R7, #1
    POP {R7, R8, LR}
    MOV R5, R7
    MOV R6, R8
    PUSH {R7, R8, LR}
    MOV R7, R5
    MOV R8, R6
    MOV R10, #0 
    MOV R1, #0 
    
    LDRB R4, =0x0A                  @ Cargar el carácter de nueva línea (ASCII 10)
    STRB R4, [R0], #1
    
    
    B process_loop4         
     

A_loop2:
    MOV R11, R1
    
    MOV R5, R1
    
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R7, R7, #1                  @ Incrementar el índice de la cadena
    
    B process_loop2                  @ Continuar procesando la cadena


process_loop3:
    LDRB R3, [R9, R8]               @ Cargar el siguiente carácter de la cadena

    CMP R3, #44                     @ Comprobar si el carácter es una coma (ASCII 44)
    BEQ handle_comma3               @ Si es una coma, manejar el número y continuar
    
    CMP R3, #0x0A
    BEQ handle_space3

    SUB R3, R3, #48                 @ Convertir el carácter ASCII a su valor numérico (0-9)

    MOV R2, #10
    MUL R4, R1, R2             @ Multiplica R1 por 10
    ADD R1, R4, R3

    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    B process_loop3                 @ Repetir el bucle
  
handle_comma3:

    CMP R10, #2   
    BEQ A_loop3
    
    MOV R5, R1


    MOV R2, #2
    MUL R4, R2, R11
    ADD R4, R4, R6
    MOV R2, #3
    UDIV R1, R4, R2
    
    
    MOV R2, #2
    MUL R4, R2, R12
    
    PUSH {R10, R12, LR}
    MOV R10, R5
    
    ADD R4, R4, R5
    MOV R2, #3
    UDIV R12, R4, R2
    
    
    MOV R2, #2
    MUL R4, R2, R1
    ADD R4, R4, R12
    MOV R2, #3
    UDIV R11, R4, R2
 
    
    MOV R1, R11
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 

    
    MOV R2, #2
    MUL R4, R2, R12
    ADD R4, R4, R11
    MOV R2, #3
    UDIV R1, R4, R2
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 

    MOV R1, R12
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 
    
    MOV R6, R10
    POP {R10, R12, LR}
    MOV R11, R12

    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    B process_loop2                  @ Continuar procesando la cadena

A_loop3:
    ADD R10, R10, #1
    
    MOV R6, R1
    MOV R2, #2
    MUL R4, R2, R6
    ADD R4, R4, R11
    MOV R2, #3
    UDIV R1, R4, R2
    MOV R10, R6
    PUSH {R10, LR}
        
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 
    
    POP {R10, LR}
    MOV R6, R10
    
    
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    
    B process_loop3                  @ Continuar procesando la cadena

handle_space3:
    MOV R10, #0
    MOV R7, R8
    MOV R1, #0                      
    B process_loop4                  @ Continuar procesando la cadena    

   
process_loop4:
    LDRB R3, [R9, R7]               @ Cargar el siguiente carácter de la cadena

    CMP R3, #44                     @ Comprobar si el carácter es una coma (ASCII 44)
    BEQ handle_comma4                @ Si es una coma, manejar el número y continuar
    
    CMP R3, #10
    BEQ handle_space4

    SUB R3, R3, #48                 @ Convertir el carácter ASCII a su valor numérico (0-9)

    MOV R2, #10
    MUL R4, R1, R2             @ Multiplica R1 por 10
    ADD R1, R4, R3

    ADD R7, R7, #1                @ Incrementar el índice de la cadena
    B process_loop4                  @ Repetir el bucle


handle_comma4:
    ADD R10, R10, #1 
    
    CMP R10, #1   
    BEQ A_loop4
    
    MOV R12, R1
    ADD R7, R7, #1
    MOV R1, #0

    B process_loop5                 


handle_space4:
    ADD R7, R7, #1
    POP {R7, R8, LR}
    MOV R7, R8
    MOV R10, #0 
    MOV R1, #0  
    
    LDRB R4, =0x0A                  @ Cargar el carácter de nueva línea (ASCII 10)
    STRB R4, [R0], #1
    
    B process_loop         
     

A_loop4:
    MOV R11, R1
    
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R7, R7, #1                  @ Incrementar el índice de la cadena
    
    B process_loop4                  @ Continuar procesando la cadena


process_loop5:
    LDRB R3, [R9, R8]               @ Cargar el siguiente carácter de la cadena

    CMP R3, #44                     @ Comprobar si el carácter es una coma (ASCII 44)
    BEQ handle_comma5               @ Si es una coma, manejar el número y continuar
    
    CMP R3, #0x0A
    BEQ handle_space5

    SUB R3, R3, #48                 @ Convertir el carácter ASCII a su valor numérico (0-9)

    MOV R2, #10
    MUL R4, R1, R2             @ Multiplica R1 por 10
    ADD R1, R4, R3

    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    B process_loop5                 @ Repetir el bucle
  
handle_comma5:

    CMP R10, #2   
    BEQ A_loop5
    
    MOV R5, R1
    MOV R2, #2
    MUL R4, R2, R6
    ADD R4, R4, R11
    MOV R2, #3
    UDIV R1, R4, R2
    
    MOV R2, #2
    MUL R4, R2, R5
    ADD R4, R4, R12
    PUSH {R10, R12, LR}
    MOV R10, R5
    MOV R2, #3
    UDIV R12, R4, R2
    
    MOV R2, #2
    MUL R4, R2, R1
    ADD R4, R4, R12
    MOV R2, #3
    UDIV R11, R4, R2
    
    MOV R1, R11
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 

    
    MOV R2, #2
    MUL R4, R2, R12
    ADD R4, R4, R11
    MOV R2, #3
    UDIV R1, R4, R2
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 

    MOV R1, R12
    
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 
    
    MOV R6, R10
    POP {R10, R12, LR}
    MOV R11, R12

    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    B process_loop4                  @ Continuar procesando la cadena

A_loop5:
    ADD R10, R10, #1
    
    MOV R6, R1
    MOV R2, #2
    MUL R4, R2, R6
    ADD R4, R4, R11
    MOV R2, #3
    UDIV R1, R4, R2
    MOV R10, R6
    PUSH {R10, LR}
        
    MOV R2, R0                      @ R2 apunta al buffer actual
    BL int_to_string                @ Llama a la función para convertir el número a cadena   
    
    POP {R10, LR}
    MOV R6, R10
    
    LDRB R4, =','                   @ Cargar el carácter de coma
    STRB R4, [R0], #1 
    
    MOV R1, #0                      @ Inicializar acumulador para el número resultante (R1 = número entero)
    ADD R8, R8, #1                  @ Incrementar el índice de la cadena
    
    B process_loop5                  @ Continuar procesando la cadena

handle_space5:
    MOV R10, #0
    MOV R7, R8
    MOV R1, #0 
    B process_loop                  @ Continuar procesando la cadena    


process_done:
    @ Imprimir el número convertido seguido de la coma
    MOV R7, #4                      @ syscall: write
    MOV R0, #1                      @ file descriptor: stdout
    LDR R1, =buffer                 @ Dirección del buffer que contiene el número convertido
    MOV R2, #2054                     
    SWI 0

    POP {R4, R5, LR}                @ Restaurar registros
    BX LR                           @ Regresar de la función

@ Función para convertir un número entero a una cadena de caracteres ASCII
int_to_string:
    PUSH {R4, R5, R6, LR}           @ Guardar registros utilizados
    MOV R2, #0                      @ Inicializar el índice del buffer
    MOV R6, #0
    MOV R14, #0
    CMP R1, #0                      @ Comprobar si el número es negativo
    BGE invertir_loop               @ Si es positivo o cero, saltar al bucle de conversión
    MOV R3, #45                     @ Cargar el carácter '-' (signo negativo)
    STRB R3, [R0], #1               @ Almacenar el signo negativo en el buffer
    NEG R1, R1                      @ Convertir el número a positivo

convert_loop:
    MOV R3, #10                     @ Divisor 10 para extraer los dígitos
    UDIV R4, R1, R3                 @ R4 = R1 / 10
    MLS R5, R4, R3, R1              @ R5 = R1 - (R4 * 10) -> obtener el residuo (dígito)
    ADD R5, R5, #48                 @ Convertir el dígito a su valor ASCII
    STRB R5, [R0, R2]               @ Guardar el carácter en el buffer
    ADD R2, R2, #1                  @ Incrementar el índice del buffer
    MOV R1, R4                      @ Actualizar el número para la siguiente iteración
    CMP R1, #0                      @ Comprobar si quedan dígitos
    BNE convert_loop                @ Si es diferente de cero, repetir el bucle

    MOV R5, #0                      @ Carácter nulo para finalizar la cadena
    STRB R5, [R0, R2]               @ Almacenar el nulo en el buffer

    ADD R0, R0, R2                  @ Mover el puntero del buffer después de escribir el número

    POP {R4, R5, R6, LR}            @ Restaurar registros
    BX LR                           @ Regresar de la función
    
    
invertir_loop:
    MOV R3, #10                     @ Divisor 10 para extraer los dígitos
    UDIV R4, R1, R3                 @ R4 = R1 / 10
    MLS R5, R4, R3, R1              @ R5 = R1 - (R4 * 10) -> obtener el residuo (dígito)
    MUL R14, R6, R3		     @ 
    ADD R6, R14, R5 
    MOV R1, R4                      @ Actualizar el número para la siguiente iteración
    CMP R1, #0                      @ Comprobar si quedan dígitos
    BNE invertir_loop               @ Si es diferente de cero, repetir el bucle

    ADD R1, R6, #0
    
    B convert_loop
