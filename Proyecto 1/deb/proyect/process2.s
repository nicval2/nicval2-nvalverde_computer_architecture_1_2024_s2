.global _start

.section .data
input_file:   .asciz "texto.txt"      @ Nombre del archivo de entrada
output_file:  .asciz "salida.txt"     @ Nombre del archivo de salida
buffer:       .space 100              @ Buffer para almacenar la palabra leída
msg_length:   .word 0                 @ Longitud de la palabra leída
words:        .space 1000             @ Espacio para almacenar las palabras procesadas
word_counts:  .space 40               @ Espacio para almacenar las cuentas de palabras (hasta 10 palabras)
num_words:    .word 0                 @ Número de palabras distintas leídas

.section .text
_start:
    @ Abrir archivo de entrada (sys_open)
    ldr r0, =input_file               @ Nombre del archivo
    mov r1, #0                        @ Modo lectura (O_RDONLY)
    mov r7, #5                        @ Syscall número para open
    svc #0                            @ Llamada al sistema
    mov r4, r0                        @ Guardar descriptor de archivo en r4

read_word_loop:
    @ Leer palabra del archivo (sys_read)
    mov r0, r4                        @ Descriptor de archivo
    ldr r1, =buffer                   @ Buffer donde almacenar la palabra
    mov r2, #1                        @ Leer un byte a la vez
    mov r7, #3                        @ Syscall número para read
    svc #0                            @ Llamada al sistema

    cmp r0, #0                        @ Si no se leyó nada, fin de archivo
    beq end_of_file

    @ Verificar si es un espacio o salto de línea (separador de palabra)
    ldrb r3, [r1]                     @ Cargar el byte leído
    cmp r3, #' '                      @ Comprobar si es un espacio
    beq process_word                  @ Si es espacio, procesar palabra
    cmp r3, #10                       @ Comprobar si es salto de línea
    beq process_word                  @ Si es salto de línea, procesar palabra

    @ Continuar construyendo la palabra
    b read_word_loop

process_word:
    @ Comparar la palabra leída con las palabras existentes en el array de palabras
    ldr r6, =num_words                @ Cargar número de palabras distintas
    ldr r6, [r6]                      @ Cargar el valor de num_words
    mov r7, #0                        @ Índice de comparación

compare_loop:
    cmp r7, r6                        @ Si r7 == num_words, significa que es una palabra nueva
    beq add_new_word                  @ Si no se encuentra la palabra, añadirla al array

    @ Cargar la palabra del array de palabras
    ldr r8, =words                    @ Dirección del array de palabras
    add r8, r8, r7, lsl #5            @ Cargar la palabra en el índice correspondiente (cada palabra ocupa 32 bytes)
    
    @ Comparar la palabra del buffer con la palabra del array
    mov r9, #0                        @ Índice de comparación de caracteres
compare_chars:
    ldrb r10, [r1, r9]                @ Cargar el byte actual de la palabra leída
    ldrb r11, [r8, r9]                @ Cargar el byte actual de la palabra en el array
    cmp r10, r11                      @ Comparar los caracteres
    bne next_word                     @ Si no son iguales, probar con la siguiente palabra
    cmp r10, #0                       @ Si ambos son '\0', la palabra es igual
    beq increment_count               @ Palabra encontrada, incrementar el contador
    add r9, r9, #1                    @ Pasar al siguiente carácter
    b compare_chars

next_word:
    add r7, r7, #1                    @ Probar con la siguiente palabra
    b compare_loop

increment_count:
    @ Incrementar el contador de la palabra
    ldr r8, =word_counts              @ Dirección del array de cuentas
    add r8, r8, r7, lsl #2            @ Cargar el contador en el índice correspondiente
    ldr r9, [r8]                      @ Cargar el contador
    add r9, r9, #1                    @ Incrementar el contador
    str r9, [r8]                      @ Guardar el nuevo valor del contador
    b read_word_loop                  @ Volver a leer más palabras

add_new_word:
    @ Añadir una nueva palabra al array de palabras
    ldr r8, =words                    @ Dirección del array de palabras
    add r8, r8, r6, lsl #5            @ Posicionar en el índice de la nueva palabra
    mov r9, #0                        @ Índice de caracteres

copy_new_word:
    ldrb r10, [r1, r9]                @ Cargar el byte actual de la palabra leída
    strb r10, [r8, r9]                @ Guardar el byte en el array de palabras
    cmp r10, #0                       @ Si es el fin de la palabra
    beq initialize_count              @ Saltar a la inicialización del contador
    add r9, r9, #1                    @ Continuar con el siguiente byte
    b copy_new_word

initialize_count:
    @ Inicializar el contador para la nueva palabra
    ldr r8, =word_counts              @ Dirección del array de cuentas
    add r8, r8, r6, lsl #2            @ Posicionar en el índice correspondiente
    mov r9, #1                        @ Inicializar el contador en 1
    str r9, [r8]                      @ Guardar el contador
    add r6, r6, #1                    @ Incrementar el número de palabras distintas
    ldr r8, =num_words                @ Actualizar num_words
    str r6, [r8]
    b read_word_loop                  @ Volver a leer más palabras

end_of_file:
    @ Cerrar archivo de entrada (sys_close)
    mov r0, r4                        @ Descriptor de archivo
    mov r7, #6                        @ Syscall número para close
    svc #0                            @ Llamada al sistema

    @ Terminar el programa
    mov r0, #0                        @ Código de salida
    mov r7, #1                        @ Syscall número para exit
    svc #0                            @ Llamada al sistema

