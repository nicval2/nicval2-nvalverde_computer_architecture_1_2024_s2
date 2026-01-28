.section .data
filename_in:  .asciz "text.txt"   @ Nombre del archivo de entrada
filename_out: .asciz "out.txt"    @ Nombre del archivo de salida
buffer:       .space 11024        @ Buffer donde se almacenarán las palabras
newline:      .asciz "\n"         @ Carácter de nueva línea
word_storage: .space 11024        @ Espacio en memoria para almacenar palabras leídas
msg_end:      .asciz "\nEnd of words\n"
word_count_msg: .asciz "Total words: "  @ Mensaje para el conteo de palabras
num_buffer:   .space 10           @ Espacio para convertir el número a texto

.section .text
.global _start

_start:
    @ Inicializar contador de palabras
    mov r6, #0                   @ r6 almacenará el conteo de palabras

    @ Abrir el archivo de entrada (syscall open)
    ldr r0, =filename_in         @ Nombre del archivo de entrada en r0
    mov r1, #0                   @ Modo de solo lectura (O_RDONLY)
    mov r7, #5                   @ Syscall número 5 (open)
    svc #0                       @ Llamada al sistema
    mov r4, r0                   @ Guardar el descriptor del archivo de entrada en r4

    @ Abrir el archivo de salida (syscall open) en modo de escritura y crear si no existe
    ldr r0, =filename_out        @ Nombre del archivo de salida en r0
    mov r1, #577                 @ Modo de escritura, crear si no existe (O_WRONLY | O_CREAT)
    mov r2, #0644                @ Permisos de archivo (rw-r--r--)
    mov r7, #5                   @ Syscall número 5 (open)
    svc #0                       @ Llamada al sistema
    mov r8, r0                   @ Guardar el descriptor del archivo de salida en r8

    @ Leer el archivo de entrada (syscall read)
read_file:
    mov r0, r4                   @ Descriptor del archivo en r0
    ldr r1, =buffer              @ Buffer en r1
    mov r2, #11024               @ Leer hasta 11024 bytes
    mov r7, #3                   @ Syscall número 3 (read)
    svc #0                       @ Llamada al sistema
    cmp r0, #0                   @ Verificar si se ha leído algo
    ble close_files              @ Si no se leyó nada, cerrar los archivos

    @ Almacenar las palabras en memoria
    ldr r3, =buffer              @ Cargar la dirección del buffer
    ldr r5, =word_storage        @ Puntero al área de almacenamiento en memoria
store_words:
    ldrb r2, [r3], #1            @ Leer byte por byte
    cmp r2, #0                   @ Si es final de archivo (byte 0), salir
    beq write_stored_words
    cmp r2, #10                  @ Comparar con nueva línea (\n)
    beq new_word                 @ Si es una nueva línea, almacenar la palabra
    strb r2, [r5], #1            @ Almacenar el carácter en word_storage
    b store_words

new_word:
    strb r2, [r5], #1            @ Añadir el carácter de nueva línea
    add r6, r6, #1               @ Incrementar el contador de palabras
    b store_words                @ Continuar leyendo más palabras

write_stored_words:
    @ Escribir el contenido almacenado en word_storage al archivo de salida (syscall write)
    mov r0, r8                   @ Descriptor del archivo de salida en r0
    ldr r1, =word_storage        @ Dirección del buffer de almacenamiento
    sub r2, r5, r1               @ Calcular el tamaño de los datos almacenados
    mov r7, #4                   @ Syscall número 4 (write)
    svc #0                       @ Llamada al sistema

    @ Escribir mensaje de fin al archivo de salida
    mov r0, r8                   @ Descriptor del archivo de salida en r0
    ldr r1, =msg_end             @ Mensaje de fin
    mov r2, #14                  @ Tamaño del mensaje
    mov r7, #4                   @ Syscall número 4 (write)
    svc #0                       @ Llamada al sistema

    @ Escribir el conteo total de palabras al archivo de salida
    mov r0, r8                   @ Descriptor del archivo de salida en r0
    ldr r1, =word_count_msg      @ Mensaje de conteo
    mov r2, #13                  @ Tamaño del mensaje "Total words: "
    mov r7, #4                   @ Syscall número 4 (write)
    svc #0                       @ Llamada al sistema

    @ Convertir el número de palabras (r6) a cadena e imprimirlo en el archivo de salida
    mov r1, r6                   @ Número de palabras en r6
    bl itoa                      @ Convertir a cadena
    ldr r1, =num_buffer          @ Puntero al número convertido
    mov r2, #10                  @ Tamaño máximo del número convertido
    mov r0, r8                   @ Descriptor del archivo de salida en r0
    mov r7, #4                   @ Syscall número 4 (write)
    svc #0                       @ Llamada al sistema

close_files:
    @ Cerrar el archivo de entrada (syscall close)
    mov r0, r4                   @ Descriptor del archivo de entrada en r0
    mov r7, #6                   @ Syscall número 6 (close)
    svc #0                       @ Llamada al sistema

    @ Cerrar el archivo de salida (syscall close)
    mov r0, r8                   @ Descriptor del archivo de salida en r0
    mov r7, #6                   @ Syscall número 6 (close)
    svc #0                       @ Llamada al sistema

    @ Salir del programa (syscall exit)
    mov r7, #1                   @ Syscall número 1 (exit)
    mov r0, #0                   @ Estado de salida 0
    svc #0                       @ Llamada al sistema

itoa:
    @ Convertir el valor en r1 a una cadena de caracteres
    mov r2, #10                  @ Base decimal
    ldr r3, =num_buffer          @ Puntero al buffer
    add r3, r3, #9               @ Apunta al final del buffer
    mov r4, #0                   @ Inicializar el final de la cadena con 0
    strb r4, [r3]                @ Guardar terminador de cadena

itoa_loop:
    mov r4, r1                   @ Copiar el número
    udiv r1, r4, r2              @ Dividir el número por la base (10)
    mls r4, r1, r2, r4           @ Obtener el dígito
    add r4, r4, #0x30            @ Convertir el dígito a ASCII
    sub r3, r3, #1               @ Mover el puntero hacia atrás
    strb r4, [r3]                @ Guardar el carácter
    cmp r1, #0                   @ Si el número es 0, terminamos
    bne itoa_loop
    mov pc, lr                   @ Retornar

