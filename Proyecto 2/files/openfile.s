.arch armv7-a
.fpu vfpv3
.eabi_attribute 67, "2.09"
.eabi_attribute 6, 10

.section .data
    EjemploFloat: .float 4.566
    constante: .float 75.0
    name_input: .asciz "input.bin"  @ Cambia el nombre del archivo de entrada a tokens.bin
    name_output: .asciz "salida.bin" @ Cambia el nombre del archivo de salida a salida.bin

    .align 1
    buffer: .space 2063  @ Tamaño del buffer ajustado a 2,063 bytes

.section .text
.globl _start

_start:
    @ Abrir el archivo de entrada
    mov r7, #0x5
    ldr r0, =name_input
    mov r1, #0  @ O_RDWR para lectura y escritura
    mov r2, #0  @ Sin permisos especiales
    swi 0

    @ Guardar el descriptor del archivo de entrada en r3
    mov r3, r0

    @ Leer desde el archivo de entrada al buffer
    mov r7, #0x3
    mov r0, r3  @ Descriptor del archivo de entrada
    ldr r1, =buffer
    ldr r2, =2063  @ Tamaño del buffer
    swi 0

    @ Abrir el archivo de salida
    mov r7, #0x5
    ldr r0, =name_output
    mov r1, #0x41  @ O_WRONLY | O_CREAT | O_TRUNC (crear archivo y truncar si existe)
    mov r2, #0666  @ Permisos para lectura y escritura
    swi 0

    @ Guardar el descriptor del archivo de salida en r4
    mov r4, r0

    @ Escribir desde el buffer al archivo de salida
    mov r7, #0x4
    mov r0, r4  @ Descriptor del archivo de salida
    ldr r1, =buffer
    ldr r2, =2063  @ Tamaño del buffer
    swi 0

    @ Cerrar el archivo de entrada
    mov r7, #6
    mov r0, r3  @ Descriptor del archivo de entrada
    swi 0

    @ Cerrar el archivo de salida
    mov r7, #6
    mov r0, r4  @ Descriptor del archivo de salida
    swi 0

    @ Terminar la ejecución del programa
    mov r7, #1
    mov r0, #0
    swi 0
