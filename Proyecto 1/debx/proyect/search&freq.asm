section .data
    filename db 'text.txt', 0              ; Nombre del archivo a leer
    buffer   times 12000 db 0              ; Buffer para almacenar el contenido del archivo
    msg_len  equ 12000                     ; Tamaño máximo del buffer
    search_word db 'and', 0                ; Palabra a buscar (cambiable)
    found_msg db 'La palabra fue encontrada: ', 0
    newline db 10                          ; Carácter de nueva línea ('\n')
    space db ' '                           ; Carácter de espacio (' ')
    found_count_buffer times 10 db 0       ; Buffer para mostrar el número de coincidencias

section .bss
    fd resq 1                              ; Descriptor del archivo
    bytes_read resq 1                      ; Cantidad de bytes leídos
    word_count resq 1                      ; Cantidad de coincidencias de la palabra buscada
    word_length resb 1                     ; Longitud de la palabra a buscar

section .text
    global _start

_start:
    ; 1. Calcular la longitud de la palabra a buscar
    mov rsi, search_word                   ; Puntero a la palabra
    xor rcx, rcx                           ; Inicializar contador de longitud
count_word_length:
    cmp byte [rsi+rcx], 0                  ; Ver si llegamos al final de la palabra
    je store_word_length                   ; Si es el final, salir del bucle
    inc rcx                                ; Incrementar contador
    jmp count_word_length
store_word_length:
    mov [word_length], cl                  ; Guardar la longitud de la palabra

    ; 2. Abrir el archivo (sys_open)
    mov rax, 2                             ; Número de syscall para sys_open (en 64 bits, 2 es open)
    lea rdi, [filename]                    ; Dirección del nombre del archivo
    xor rsi, rsi                           ; Modo lectura (O_RDONLY)
    syscall                                ; Realizar llamada al sistema
    mov [fd], rax                          ; Guardar el descriptor del archivo

    ; Verificar si el archivo se abrió correctamente
    cmp rax, 0
    js _error_exit                         ; Si el valor en rax es negativo, hubo error

    ; 3. Leer el archivo (sys_read)
    mov rax, 0                             ; Número de syscall para sys_read (en 64 bits, 0 es read)
    mov rdi, [fd]                          ; Descriptor del archivo
    lea rsi, [buffer]                      ; Buffer donde almacenar los datos
    mov rdx, msg_len                       ; Cantidad máxima de bytes a leer
    syscall                                ; Realizar llamada al sistema

    ; Guardar el número de bytes leídos
    mov [bytes_read], rax

    ; Verificar si la lectura fue exitosa
    cmp rax, 0
    jle _close_file                        ; Si no se leyó nada o hubo error, cerrar archivo

    ; 4. Inicializar contador de coincidencias
    xor rbx, rbx                           ; Inicializar contador de coincidencias (rbx = 0)
    lea rsi, [buffer]                      ; Apuntar al buffer
    mov rcx, [bytes_read]                  ; Número de bytes leídos

    ; 5. Buscar la palabra en cada línea
search_loop:
    cmp rcx, [word_length]                 ; Verificar que queden suficientes bytes para una palabra
    jl search_done                         ; Si no, finalizar búsqueda

    ; Comparar la palabra byte a byte con la longitud de la palabra
    push rcx                               ; Guardar el número de bytes restantes
    push rsi                               ; Guardar la posición en el buffer
    mov rdi, search_word                   ; Puntero a la palabra a buscar
    mov rdx, [word_length]                 ; Comparar exactamente [word_length] bytes

compare_word:
    mov al, [rsi]                          ; Cargar un byte del buffer
    cmp al, [rdi]                          ; Comparar con el byte correspondiente de la palabra
    jne skip_search                        ; Si no coinciden, saltar
    inc rsi                                ; Avanzar al siguiente byte en el buffer
    inc rdi                                ; Avanzar al siguiente byte de la palabra
    dec rdx                                ; Reducir el contador de bytes restantes de la palabra
    jnz compare_word                       ; Continuar hasta comparar toda la palabra

    ; Verificar delimitadores antes y después de la palabra
    pop rsi                                ; Restaurar la posición en el buffer
    pop rcx                                ; Restaurar el número de bytes restantes

    ; Verificar delimitador antes de la palabra
    cmp rsi, buffer                        ; Si estamos al principio del buffer
    je check_after_word                    ; Si es el principio del buffer, no hay delimitador antes
    mov al, [rsi-1]                        ; Obtener el byte antes de la palabra
    cmp al, [space]                        ; Verificar si es un espacio
    je check_after_word                    ; Si es un espacio, verificar después de la palabra
    cmp al, [newline]                      ; Verificar si es un salto de línea
    je check_after_word                    ; Si es un salto de línea, verificar después de la palabra
    jmp skip_search                        ; Si no es un delimitador válido, saltar

check_after_word:
    ; Verificar delimitador después de la palabra
    add rsi, [word_length]                 ; Avanzar después de la palabra
    dec rcx                                ; Reducir el número de bytes restantes
    cmp rcx, 0                             ; Verificar si queda algo en el buffer
    je found_increment                     ; Si es el final del buffer, cuenta la palabra
    mov al, [rsi]                          ; Cargar el carácter después de la palabra
    cmp al, [space]                        ; Verificar si es un espacio
    je found_increment                     ; Si es un espacio, es una coincidencia
    cmp al, [newline]                      ; Verificar si es un salto de línea
    je found_increment                     ; Si es un salto de línea, es una coincidencia
    jmp skip_search                        ; Si no, continuar la búsqueda

found_increment:
    inc rbx                                ; Incrementar el contador de coincidencias
    jmp search_loop                        ; Continuar búsqueda

skip_search:
    ; Si no es la palabra buscada, avanzar al siguiente byte
    add rsi, 1                             ; Avanzar al siguiente byte
    dec rcx                                ; Reducir número de bytes restantes
    jmp search_loop                        ; Continuar búsqueda

search_done:
    ; Guardar el número de coincidencias en [word_count]
    mov [word_count], rbx

    ; 6. Imprimir el mensaje de coincidencias (sys_write)
    mov rax, 1                             ; Número de syscall para sys_write (en 64 bits, 1 es write)
    mov rdi, 1                             ; Descriptor de la salida estándar (stdout)
    lea rsi, [found_msg]                   ; Mensaje a mostrar
    mov rdx, 32                            ; Longitud del mensaje
    syscall                                ; Realizar llamada al sistema

    ; 7. Convertir el número de coincidencias a string
    mov rax, [word_count]                  ; Cargar el número de coincidencias
    call int_to_string                     ; Convertir el número a cadena

    ; 8. Imprimir el número de coincidencias (sys_write)
    mov rax, 1                             ; Número de syscall para sys_write
    mov rdi, 1                             ; Descriptor de la salida estándar (stdout)
    lea rsi, [found_count_buffer]          ; Buffer con el número convertido a string
    mov rdx, 10                            ; Longitud máxima del número (como cadena)
    syscall                                ; Realizar llamada al sistema

    ; 9. Cerrar el archivo (sys_close)
_close_file:
    mov rax, 3                             ; Número de syscall para sys_close (en 64 bits, 3 es close)
    mov rdi, [fd]                          ; Descriptor del archivo
    syscall                                ; Realizar llamada al sistema

    ; Salir del programa (sys_exit)
    mov rax, 60                            ; Número de syscall para sys_exit (en 64 bits, 60 es exit)
    xor rdi, rdi                           ; Código de salida 0
    syscall                                ; Realizar llamada al sistema

; Función para convertir un número en RAX a cadena ASCII
int_to_string:
    mov rdi, found_count_buffer + 9        ; Apuntar al final del buffer
    mov byte [rdi], 0                      ; Terminar la cadena con NULL
    dec rdi

convert_loop:
    xor rdx, rdx                           ; Limpiar rdx
    mov rbx, 10                            ; Divisor (base 10)
    div rbx                                ; Dividir rax entre 10
    add dl, '0'                            ; Convertir el dígito a carácter ASCII
    mov [rdi], dl                          ; Almacenar el carácter
    dec rdi                                ; Mover al siguiente carácter
    test rax, rax                          ; Comprobar si rax es 0
    jnz convert_loop                       ; Si no, seguir dividiendo
    ret

_error_exit:
    ; Manejo de errores (salir del programa)
    mov rax, 60                            ; sys_exit en 64 bits
    mov rdi, 1                             ; Código de error 1
    syscall                                ; Realizar llamada al sistema

