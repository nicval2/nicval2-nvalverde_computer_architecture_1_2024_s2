.global _start

.section .data
input_file:   .asciz "text.txt"      @ Nombre del archivo de entrada
output_file:  .asciz "salida.txt"     @ Nombre del archivo de salida
buffer:       .space 100              @ Buffer para almacenar la palabra leída
msg_length:   .word 0                 @ Longitud de la palabra leída

.section .text
_start:
    @ Abrir archivo de entrada (sys_open)
    ldr r0, =input_file               @ Nombre del archivo
    mov r1, #0                        @ Modo lectura (O_RDONLY)
    mov r7, #5                        @ Syscall número para open
    svc #0                            @ Llamada al sistema
    mov r4, r0                        @ Guardar descriptor de archivo en r4

    @ Abrir archivo de salida (sys_open)
    ldr r0, =output_file              @ Nombre del archivo
    mov r1, #577                      @ Modo escritura, crear si no existe (O_WRONLY | O_CREAT)
    mov r2, #0644                     @ Permisos del archivo
    mov r7, #5                        @ Syscall número para open
    svc #0                            @ Llamada al sistema
    mov r6, r0                        @ Guardar descriptor de archivo de salida en r6

read_write_loop:
    @ Leer palabra del archivo (sys_read)
    mov r0, r4                        @ Descriptor de archivo
    ldr r1, =buffer                   @ Buffer donde almacenar la palabra
    mov r2, #100                      @ Tamaño máximo a leer (bloque)
    mov r7, #3                        @ Syscall número para read
    svc #0                            @ Llamada al sistema
    cmp r0, #0                        @ Comparar si r0 (número de bytes leídos) es 0
    beq end_program                   @ Si es 0, final del archivo, salir del bucle
    mov r5, r0                        @ Guardar número de bytes leídos en r5

    @ Escribir palabra en archivo de salida (sys_write)
    mov r0, r6                        @ Descriptor de archivo de salida
    ldr r1, =buffer                   @ Buffer con la palabra leída
    mov r2, r5                        @ Número de bytes leídos del archivo anterior
    mov r7, #4                        @ Syscall número para write
    svc #0                            @ Llamada al sistema

    b read_write_loop                 @ Volver a leer el siguiente bloque

end_program:
    @ Cerrar archivo de entrada (sys_close)
    mov r0, r4                        @ Descriptor de archivo
    mov r7, #6                        @ Syscall número para close
    svc #0                            @ Llamada al sistema

    @ Cerrar archivo de salida (sys_close)
    mov r0, r6                        @ Descriptor de archivo
    mov r7, #6                        @ Syscall número para close
    svc #0                            @ Llamada al sistema

    @ Salir del programa (sys_exit)
    mov r0, #0                        @ Código de salida
    mov r7, #1                        @ Syscall número para exit
    svc #0                            @ Llamada al sistema

