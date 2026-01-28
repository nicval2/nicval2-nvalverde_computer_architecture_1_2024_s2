.global _start

.section .data
input_file:   .asciz "texto.txt"           @ Nombre del archivo de entrada
output_file:  .asciz "salida.txt"          @ Nombre del archivo de salida
buffer:       .space 100                   @ Buffer para almacenar las palabras leídas
word_list:    .space 400                   @ Espacio para almacenar hasta 100 palabras únicas
word_count:   .space 400                   @ Espacio para contar cuántas veces aparece cada palabra
newline:      .asciz "\n"                  @ Nueva línea para escribir en el archivo

.section .bss
input_fd:     .word 0                      @ Descriptor del archivo de entrada
output_fd:    .word 0                      @ Descriptor del archivo de salida

.section .text
_start:
    @ Abrir archivo de entrada (sys_open)
    ldr r0, =input_file                    @ Nombre del archivo
    mov r1, #0                             @ Modo lectura (O_RDONLY)
    mov r7, #5                             @ Syscall número para open
    svc #0                                 @ Llamada al sistema
    str r0, [sp, #0]                       @ Guardar descriptor de archivo en stack

    @ Inicializar contador de palabras
    mov r6, #0                             @ r6 será el contador total de palabras leídas
    mov r7, #0                             @ r7 será el índice para la lista de palabras

read_line:
    @ Leer palabra desde archivo (sys_read)
    ldr r0, [sp, #0]                       @ Descriptor del archivo
    ldr r1, =buffer                        @ Dirección del buffer
    mov r2, #100                           @ Tamaño del buffer (una palabra por línea)
    mov r7, #3                             @ Syscall número para read
    svc #0                                 @ Leer palabra
    cmp r0, #0                             @ Comprobar si se ha llegado al final del archivo
    beq write_output                       @ Si hemos terminado, escribir la salida

    @ Contar palabra y comprobar si ya está en la lista
    mov r8, #0                             @ r8 será el índice de comparación
    mov r9, #0                             @ r9 será la variable para almacenar coincidencias

compare_word:
    cmp r8, r7                             @ Comparar índice actual con número de palabras únicas
    beq add_word                           @ Si ya revisamos todas las palabras, agregar nueva
    ldr r0, =word_list
    add r0, r0, r8                         @ Apuntar a la palabra actual en la lista
    bl strcmp                              @ Comparar palabra actual con la palabra en el buffer
    cmp r0, #0                             @ Ver si la palabra ya está en la lista
    beq increment_count                    @ Si ya existe, incrementar el contador
    add r8, r8, #4                         @ Mover al siguiente índice de palabra
    b compare_word                         @ Repetir la comparación

add_word:
    @ Si la palabra es nueva, agregarla a la lista
    ldr r0, =word_list
    add r0, r0, r7                         @ Obtener dirección de la lista de palabras
    ldr r1, =buffer                        @ Dirección de la nueva palabra
    bl strcpy                              @ Copiar palabra al listado
    ldr r0, =word_count
    add r0, r0, r7                         @ Apuntar al contador de la palabra nueva
    mov r1, #1                             @ Inicializar el contador en 1
    str r1, [r0]                           @ Almacenar el valor
    add r7, r7, #4                         @ Aumentar el índice de palabras únicas
    b read_line                            @ Leer la siguiente línea

increment_count:
    @ Incrementar el contador de palabras si ya existe
    ldr r0, =word_count
    add r0, r0, r8                         @ Obtener dirección del contador para esta palabra
    ldr r1, [r0]                           @ Cargar el valor actual
    add r1, r1, #1                         @ Incrementar en 1
    str r1, [r0]                           @ Guardar de nuevo el valor incrementado
    b read_line                            @ Leer la siguiente línea

write_output:
    @ Abrir archivo de salida (sys_open)
    ldr r0, =output_file                   @ Nombre del archivo
    mov r1, #577                           @ Modo escritura, crear si no existe (O_WRONLY | O_CREAT)
    mov r2, #0644                          @ Permisos del archivo
    mov r7, #5                             @ Syscall número para open
    svc #0                                 @ Llamada al sistema
    str r0, [sp, #4]                       @ Guardar descriptor de archivo en stack

    @ Escribir las palabras y sus conteos en el archivo de salida
    mov r8, #0                             @ Reiniciar índice
write_word:
    cmp r8, r7                             @ Comparar índice con número de palabras
    beq finish                             @ Si ya escribimos todo, terminar
    ldr r0, =word_list
    add r0, r0, r8                         @ Obtener la palabra de la lista
    bl write_to_file                       @ Escribir palabra en el archivo
    ldr r0, =word_count
    add r0, r0, r8                         @ Obtener contador de la palabra
    ldr r1, [r0]                           @ Cargar valor
    bl itoa                                @ Convertir contador a string
    bl write_to_file                       @ Escribir el número en el archivo
    ldr r0, =newline
    bl write_to_file                       @ Escribir nueva línea
    add r8, r8, #4                         @ Siguiente palabra
    b write_word                           @ Repetir para la siguiente palabra

finish:
    @ Cerrar archivos y salir del programa
    ldr r0, [sp, #0]                       @ Descriptor de entrada
    mov r7, #6                             @ Syscall número para close
    svc #0
    ldr r0, [sp, #4]                       @ Descriptor de salida
    mov r7, #6                             @ Syscall número para close
    svc #0

    @ Salir del programa (sys_exit)
    mov r0, #0                             @ Código de salida
    mov r7, #1                             @ Syscall número para exit
    svc #0

write_to_file:
    @ Escribir cadena en archivo (sys_write)
    ldr r1, [sp, #4]                       @ Descriptor del archivo
    mov r2, #100                           @ Tamaño del buffer
    mov r7, #4                             @ Syscall número para write
    svc #0
    bx lr

strcmp:
    @ Comparar dos cadenas
    @ r0: puntero a la primera cadena
    @ r1: puntero a la segunda cadena
    loop:
        ldrb r2, [r0], #1        @ Leer un byte de la primera cadena y avanzar puntero
        ldrb r3, [r1], #1        @ Leer un byte de la segunda cadena y avanzar puntero
        cmp r2, r3               @ Comparar los caracteres
        bne not_equal            @ Si son diferentes, salta a not_equal
        cmp r2, #0               @ Si llegamos al final de ambas cadenas (carácter nulo)
        beq equal                @ Si son iguales, retorna 0
        b loop                   @ Si no, repite el ciclo
    not_equal:
        mov r0, #1               @ Retorna 1 si las cadenas son diferentes
        bx lr
    equal:
        mov r0, #0               @ Retorna 0 si las cadenas son iguales
        bx lr

strcpy:
    @ Copiar una cadena
    @ r0: destino
    @ r1: origen
    loop_copy:
        ldrb r2, [r1], #1        @ Leer un byte del origen
        strb r2, [r0], #1        @ Escribir ese byte en el destino
        cmp r2, #0               @ Ver si es el carácter nulo
        bne loop_copy            @ Si no es nulo, sigue copiando
    bx lr

itoa:
    @ Convertir entero a cadena
    @ r0: entero
    @ r1: buffer donde almacenar la cadena
    mov r2, r0                 @ Copia del número para trabajar con él
    add r1, r1, #4             @ Asigna espacio para el número (máximo 4 dígitos)
convert:
    mov r3, #10                @ Dividir por 10
    udiv r4, r2, r3            @ r4 = número / 10
    mls r5, r4, r3, r2         @ r5 = número % 10
    add r5, r5, #'0'           @ Convertir el dígito en carácter ASCII
    strb r5, [r1], #-1         @ Almacenar el carácter en el buffer
    mov r2, r4                 @ Actualizar el número
    cmp r2, #0                 @ Verificar si el número es 0
    bne convert                @ Si no es 0, seguir dividiendo
    bx lr                      @ Retornar
