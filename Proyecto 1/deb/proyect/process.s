.data
.balign 4
string: .asciz "Computer Architecture Module preparation questions and answers Computer questions\0"  @ Cadena de texto
words:  .space  256   @ Espacio para almacenar las palabras encontradas
counts: .space  256   @ Espacio para contar las ocurrencias de cada palabra
word_buffer: .space  32   @ Buffer temporal para almacenar palabras al imprimir

.text
.global _start
_start:
    ldr r0, =string        @ Cargar la dirección de la cadena en r0
    lrdr r1, =words         @ Cargar la dirección del array de palabras en r1
    ldr r2, =counts        @ Cargar la dirección del array de contadores en r2
    mov r3, #0             @ Inicializar el índice de palabras
    mov r4, #0             @ Inicializar el índice de caracteres
    mov r5, #0             @ Inicializar el tamaño de la palabra

next_word:
    ldrb r6, [r0, r4]      @ Cargar el carácter actual en r6
    cmp r6, #0             @ Comparar con el carácter nulo
    beq print_words        @ Si es nulo, imprimir palabras
    cmp r6, #32            @ Comparar con el espacio
    beq store_word         @ Si es espacio, almacenar palabra

    strb r6, [r1, r5]      @ Almacenar carácter en el array de palabras
    add r5, r5, #1         @ Incrementar el tamaño de la palabra
    add r4, r4, #1         @ Mover al siguiente carácter
    b next_word            @ Volver al inicio del bucle

store_word:
    cmp r5, #0             @ Comprobar si hay caracteres en la palabra
    beq next_word          @ Si no hay caracteres, continuar
    strb r0, [r1, r5]      @ Terminar la palabra con un nulo
    bl count_word          @ Llamar a la función para contar la palabra
    mov r5, #0             @ Reiniciar el tamaño de la palabra
    add r4, r4, #1         @ Mover al siguiente carácter
    b next_word            @ Volver al inicio del bucle

count_word:
    mov r7, #0             @ Inicializar el contador para la palabra
    ldr r8, =words         @ Dirección del array de palabras
    ldr r9, =counts        @ Dirección del array de contadores

next_count:
    cmp r7, r3             @ Comparar el índice de la palabra actual con el número de palabras
    beq new_word           @ Si se han comparado todas, agregar nueva palabra
    ldr r10, [r8, r7]      @ Cargar la palabra actual
    ldr r11, =0            @ Inicializar la comparación
    cmp r11, r10           @ Comparar con la nueva palabra
    beq increment_count     @ Si es igual, incrementar el contador
    add r7, r7, #1         @ Mover al siguiente índice
    b next_count           @ Repetir

increment_count:
    ldr r12, [r9, r7]      @ Cargar el contador actual
    add r12, r12, #1       @ Incrementar el contador
    str r12, [r9, r7]      @ Almacenar el nuevo contador
    bx lr                  @ Regresar

new_word:
    strb r0, [r1, r5]      @ Guardar la nueva palabra en el array
    strb r0, [r9, r3]      @ Inicializar el contador en cero
    add r3, r3, #1         @ Incrementar el número de palabras
    bx lr                  @ Regresar

print_words:
    mov r0, #0             @ Inicializar el índice para imprimir
    ldr r1, =words         @ Cargar la dirección del array de palabras
    ldr r2, =counts        @ Cargar la dirección del array de contadores

print_loop:
    cmp r0, r3             @ Comparar índice con el número de palabras
    bge exit_program       @ Si hemos impreso todas las palabras, salir

    ldrb r3, [r1, r0]      @ Cargar la palabra en el buffer
    strb r3, [word_buffer] @ Almacenar la palabra en el buffer
    add r0, r0, #1         @ Incrementar el índice
    mov r7, #4             @ syscall para escribir
    mov r0, #1             @ Escribir en stdout
    ldr r1, =word_buffer   @ Dirección del buffer
    bl strlen              @ Llamar a strlen para obtener la longitud
    svc 0                  @ Llamar al sistema

    ldr r3, [r2, r0]       @ Cargar el contador
    bl print_number        @ Llamar a la función para imprimir el número
    b print_loop           @ Volver al bucle

exit_program:
    mov r0, #0             @ Código de salida
    mov r7, #1             @ syscall número para exit
    svc 0                  @ Llamada al sistema para terminar el programa

strlen:                     @ Función para calcular la longitud de una cadena
    mov r2, #0             @ Inicializar longitud en 0
strlen_loop:
    ldrb r3, [r1, r2]      @ Cargar el carácter
    cmp r3, #0             @ Comprobar si es el final de la cadena
    beq strlen_done        @ Si es nulo, finalizar
    add r2, r2, #1         @ Incrementar longitud
    b strlen_loop          @ Volver al bucle
strlen_done:
    mov r0, r2             @ Retornar longitud
    bx lr                  @ Regresar

print_number:              @ Función para imprimir un número
    @ Implementar impresión de números aquí
    bx lr                  @ Regresar

