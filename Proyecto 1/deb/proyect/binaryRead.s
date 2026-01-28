.section .data
file_name: .asciz "text2.txt"  // Nombre del archivo de entrada
buffer: .skip 256               // Buffer para leer los datos
binary_buffer: .skip 32         // Buffer para almacenar la representación binaria

.section .text
.global _start

_start:
    // Abrir el archivo
    ldr r0, =file_name  // Nombre del archivo
    mov r1, #0          // Modo lectura
    mov r7, #5          // syscall: open
    svc #0

    // Guardar el file descriptor
    mov r4, r0          // Guardar file descriptor en r4
    cmp r0, #0          // Verificar si el archivo se abrió correctamente
    blt error_exit      // Si hubo un error, salir

    // Leer el archivo
    ldr r1, =buffer     // Buffer para almacenar los datos leídos
    mov r2, #256        // Leer hasta 256 bytes
    mov r7, #3          // syscall: read
    svc #0

    // Guardar el número de bytes leídos en r5
    mov r5, r0          // Guardar la cantidad de bytes leídos
    cmp r5, #0          // Verificar si se leyó algo
    blt error_exit      // Si hubo un error, salir

    // Convertir el número de bytes leídos (r5) a binario
    mov r6, r5          // Guardar la cantidad de bytes en r6
    ldr r0, =binary_buffer  // Apuntar al buffer binario
    mov r1, #32         // Vamos a convertir 32 bits

convert_to_binary:
    cmp r1, #0          // Verificar si ya hemos convertido todos los bits
    beq print_binary    // Si ya hemos terminado, imprimir

    mov r2, #1          // Máscara para extraer el bit menos significativo
    and r3, r6, r2      // Extraer el bit menos significativo
    cmp r3, #0          // Comparar si el bit es 0 o 1
    moveq r3, #'0'      // Si es 0, almacenar '0'
    movne r3, #'1'      // Si es 1, almacenar '1'
    strb r3, [r0], #1   // Almacenar el carácter en el buffer binario

    lsr r6, r6, #1      // Desplazar el valor a la derecha
    sub r1, r1, #1      // Decrementar el contador de bits
    b convert_to_binary // Repetir hasta que hayamos terminado

print_binary:
    // Imprimir el número en binario
    ldr r0, =1          // Descriptor de salida (stdout)
    ldr r1, =binary_buffer  // Apuntar al buffer con los bits convertidos
    mov r2, #32         // Longitud a imprimir (32 bits)
    mov r7, #4          // syscall: write
    svc #0

    // Salida del programa
    mov r7, #1          // syscall: exit
    mov r0, #0          // Código de salida (éxito)
    svc #0

error_exit:
    // Código de salida en caso de error
    mov r7, #1          // syscall: exit
    mov r0, #1          // Código de salida (error)
    svc #0

