.section .data
input_file:   .asciz "text.txt"
message:      .asciz "Archivo cargado en memoria\n"
msg_len = . - message

.section .bss
file_size:    .space 4

.section .text
.global _start

_start:
    @ Abrir el archivo de entrada
    ldr r0, =input_file
    mov r1, #0                    @ Modo lectura (O_RDONLY)
    ldr r7, =5                    @ sys_open
    svc 0

    mov r4, r0                    @ Guardar descriptor de archivo

    @ Obtener tamaño del archivo usando fstat
    ldr r0, =file_size            @ Puntero al espacio reservado para el tamaño
    mov r1, r4                    @ Descriptor de archivo
    ldr r7, =197                  @ sys_fstat en ARM
    svc 0

    @ Leer el tamaño del archivo
    ldr r2, [r0]                  @ Cargar el tamaño del archivo desde file_size

    @ Definiciones de constantes para mmap
    .equ PROT_READ, 0x1
    .equ MAP_PRIVATE, 0x02

    @ Mapear archivo en memoria
    mov r0, #0                    @ NULL, el kernel elige dónde mapear
    mov r1, r2                    @ Tamaño del archivo
    mov r3, #PROT_READ            @ Permisos de lectura
    mov r4, #MAP_PRIVATE
    mov r5, r4                    @ Descriptor de archivo
    mov r6, #0                    @ Offset 0
    ldr r7, =192                  @ sys_mmap en ARM
    svc 0

    @ Imprimir mensaje de confirmación
    mov r0, #1                    @ stdout
    ldr r1, =message              @ Dirección del mensaje
    mov r2, #msg_len              @ Longitud del mensaje
    ldr r7, =4                    @ sys_write
    svc 0

    @ Desmapear archivo y cerrar descriptor
    mov r1, r0                    @ Dirección base del mapeo
    mov r2, r2                    @ Tamaño del archivo
    ldr r7, =91                   @ sys_munmap
    svc 0

    mov r0, r4                    @ Descriptor de archivo
    ldr r7, =6                    @ sys_close
    svc 0

    @ Salir del programa
    mov r0, #0
    ldr r7, =1                    @ sys_exit
    svc 0

