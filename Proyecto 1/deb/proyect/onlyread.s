.global _start

.section .data
input_file:   .asciz "text.txt"      @ Nombre del archivo de entrada
output_file:  .asciz "salida.txt"     @ Nombre del archivo de salida
buffer:       .space 100              @ Buffer para almacenar la palabra leída
msg_length:   .word 0                 @ Longitud de la palabra leída
words:        .space 1000             @ Espacio para almacenar las palabras procesadas
word_counts:  .space 40               @ Espacio para almacenar las cuentas de palabras
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
    @ Aquí procesaremos la palabra, de momento ignoraremos este paso
    @ Para la próxima iteración
    b read_word_loop

end_of_file:
    @ Cerrar archivo de entrada (sys_close)
    mov r0, r4                        @ Descriptor de archivo
    mov r7, #6                        @ Syscall número para close
    svc #0                            @ Llamada al sistema

    @ Terminar el programa
    mov r0, #0                        @ Código de salida
    mov r7, #1                        @ Syscall número para exit
    svc #0                            @ Llamada al sistema

