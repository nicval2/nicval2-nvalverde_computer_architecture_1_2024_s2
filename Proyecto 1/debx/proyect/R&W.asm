section .data
    filename db 'text.txt', 0    ; Nombre del archivo a leer
    buffer   times 12000 db 0      ; Buffer para almacenar el contenido del archivo
    msg_len  equ 12000; Tamaño del buffer

section .bss
    fd resb 1                    ; Descriptor del archivo

section .text
    global _start

_start:
    ; 1. Abrir el archivo (sys_open)
    mov eax, 5                   ; Número de syscall para sys_open
    lea ebx, [filename]           ; Dirección del nombre del archivo
    mov ecx, 0                    ; Modo lectura (O_RDONLY)
    int 0x80                      ; Interrupción para llamar al kernel
    mov [fd], eax                 ; Guardar el descriptor del archivo

    ; 2. Leer el archivo (sys_read)
    mov eax, 3                    ; Número de syscall para sys_read
    mov ebx, [fd]                 ; Descriptor del archivo
    lea ecx, [buffer]             ; Buffer donde almacenar los datos
    mov edx, msg_len              ; Cantidad máxima de bytes a leer
    int 0x80                      ; Interrupción para llamar al kernel

    ; 3. Imprimir en consola (sys_write)
    mov eax, 4                    ; Número de syscall para sys_write
    mov ebx, 1                    ; Descriptor de la salida estándar (stdout)
    lea ecx, [buffer]             ; Buffer donde están los datos leídos
    mov edx, msg_len              ; Longitud de los datos a escribir
    int 0x80                      ; Interrupción para llamar al kernel

    ; 4. Cerrar el archivo (sys_close)
    mov eax, 6                    ; Número de syscall para sys_close
    mov ebx, [fd]                 ; Descriptor del archivo
    int 0x80                      ; Interrupción para llamar al kernel

    ; Salir del programa (sys_exit)
    mov eax, 1                    ; Número de syscall para sys_exit
    xor ebx, ebx                  ; Código de salida 0
    int 0x80                      ; Interrupción para llamar al kernel

