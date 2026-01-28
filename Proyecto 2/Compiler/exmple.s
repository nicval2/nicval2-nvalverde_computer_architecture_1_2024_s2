.section .data

.section .text
.global _start

_start:
    mov r0, #1
    mov r1, #5
    mov r2, #7
    mov r3, #1
    mov r11, sp
    mov r10, #2

    sub r4, r2, r0		@ dx = abs(x2 - x1)
    sub r5, r3, r1		@ dy = abs(y2 - y1)
    
    cmp r4, #0
    beq vertical_line
    
    cmp r5, #0
    BLT dy_negativo
    
    b bresenham_line

dy_negativo:
    rsb r5, r5, #0
    
    b bresenham_line

bresenham_line:
    
    mov r6, r0
    mov r7, r1
    mul r8, r5, r10		@ 2*dy
    sub r5, r8, r4		@ d = 2*dy - dx
    
    mul r9, r4, r10		@ 2*dx
    
    str r6, [r11]		@ Guardar coordenadas del primer pixel
    add r11, r11, #4
    str r7, [r11]
    add r11, r11, #4
    
    b bresenham_loop
    
    b _salida
    
vertical_line:
    add r3, r3, #1
    
    b vertical_line_loop

vertical_line_loop: 
    str r0, [r11]
    add r11, r11, #4
    str r1, [r11]
    add r11, r11, #4
    
    add r1, r1, #1
    cmp r1, r3
    bne vertical_line_loop
    
    b _salida

bresenham_loop:
    cmp r5, #0
    blt d_negativo
    bgt d_positivo
    beq d_positivo
    
d_negativo:
    add r5, r5, r8
    
    b bresenham_loop2
    
d_positivo:
    sub r4, r8, r9
    add r5, r5, r4
    
    cmp r3, r1
    bgt y2_mayor
    blt y1_mayor
    beq y1_mayor

y2_mayor:
    add r7, r7, #1
    b bresenham_loop2

y1_mayor:
    sub r7, r7, #1

bresenham_loop2:
    cmp r2, r0
    bgt x2_mayor
    blt x1_mayor
    beq x1_mayor
    
x2_mayor:
    add r6, r6, #1
    b bresenham_loop3

x1_mayor:
    sub r6, r6, #1
    
bresenham_loop3:
    str r6, [r11]
    add r11, r11, #4
    str r7, [r11]
    add r11, r11, #4
    
    add r0, r0, #1
    cmp r0, r2
    bne bresenham_loop
    
    b _salida

_salida:
    @ Terminar la ejecución del programa
    mov r7, #0x1
    mov r0, #0
    swi 0
