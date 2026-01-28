.global _start

.section .data
input_str: .asciz "10\n20\n-\n30\n40\n"
buffer: .space 2054
newline: .asciz ",\n"

.section .text
_start:
    loadr r9, =input_str
    loadr r0, =buffer
    movei r10, #0
    movei r11, #0
    movei r12, #0
    movei r7, #0

    jl process_string

    movei r7, #1
    movei r10, #0
    swi 0

process_string:
    psh {r4, r5, lr}
    movei r1, #0
    movei r8, #0

process_loop:
    ldrbr r3, [r9, r8]
    cmpi r3, #0
    jeq process_done
    cmpi r3, #10
    jeq handle_comma
    cmpi r3, #45
    jeq handle_space
    rti r3, r3, #48
    movei r2, #10
    mlt r4, r1, r2
    sm r1, r4, r3
    smi r8, r8, #1
    j process_loop

handle_comma:
    smi r10, r10, #1
    sm r12, r1
    cmpi r10, #1
    jeq A_loop
    movei r5, #3
    movei r2, #2
    mlt r4, r2, r11
    sm r4, r4, r12
    dv r1, r4, r5
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    movei r5, #3
    movei r2, #2
    mlt r4, r2, r12
    sm r4, r4, r11
    dv r1, r4, r5
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    sm r1, r12
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    sm r11, r12
    movei r1, #0
    smi r8, r8, #1
    j process_loop

A_loop:
    sm r11, r1
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    movei r1, #0
    smi r8, r8, #1
    j process_loop

handle_space:
    smi r8, r8, #2
    movei r10, #0
    movei r1, #0
    sm r5, r7
    sm r6, r8
    psh {r7, r8, lr}
    sm r7, r5
    sm r8, r6
    ldrbi r4, =#45
    storebi r4, [r0], #1
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    j process_loop2

process_loop2:
    ldrbr r3, [r9, r7]
    cmpi r3, #10
    jeq handle_comma2
    cmp r3, #45
    beq handle_space2
    rti r3, r3, #48
    movei r2, #10
    mlt r4, r1, r2
    sm r1, r4, r3
    smi r7, r7, #1
    j process_loop2

handle_comma2:
    smi r10, r10, #1
    cmp r10, #1
    beq A_loop2
    sm r12, r1
    smi r7, r7, #1
    movei r1, #0
    j process_loop3

handle_space2:
    pp {r7, r8, lr}
    sm r5, r7
    sm r6, r8
    psh {r7, r8, lr}
    sm r7, r5
    sm r8, r6
    movei r10, #0
    movei r1, #0
    ldrbi r4, =#45
    storebi r4, [r0], #1
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    j process_loop4

A_loop2:
    sm r11, r1
    movei r1, #0
    smi r7, r7, #1
    j process_loop2

process_loop3:
    ldrbr r3, [r9, r8]
    cmpi r3, #10
    jeq handle_comma3
    cmpi r3, #45
    jeq handle_space3
    rti r3, r3, #48
    movei r2, #10
    mlt r4, r1, r2
    sm r1, r4, r3
    smi r8, r8, #1
    j process_loop3

handle_comma3:
    cmpi r10, #2
    jeq A_loop3
    sm r5, r1
    movei r2, #2
    mlt r4, r2, r11
    sm r4, r4, r6
    dv r1, r4, #3
    movei r2, #2
    mlt r4, r2, r12
    psh {r10, r12, lr}
    sm r10, r5
    sm r4, r4, r5
    dv r12, r4, #3
    mlt r4, r2, r1
    sm r4, r4, r12
    dv r11, r4, #3
    sm r1, r11
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    movei r2, #2
    mlt r4, r2, r12
    sm r4, r4, r11
    dv r1, r4, #3
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    sm r1, r12
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    sm r6, r10
    pp {r10, r12, lr}
    sm r11, r12
    movei r1, #0
    smi r8, r8, #1
    j process_loop2

A_loop3:
    smi r10, r10, #1
    sm r6, r1
    movei r2, #2
    mlt r4, r2, r1
    sm r4, r4, r11
    dv r1, r4, #3
    sm r10, r6
    psh {r10, lr}
    sm r2, r0
    jl int_to_string
    pp {r10, lr}
    sm r6, r10
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    movei r1, #0
    smi r8, r8, #1
    j process_loop3

handle_space3:
    movei r10, #0
    sm r7, r8
    movei r1, #0
    j process_loop4

process_loop4:
    ldrbr r3, [r9, r7]
    cmpi r3, #10
    jeq handle_comma4
    cmpi r3, #45
    jeq handle_space4
    rti r3, r3, #48
    movei r2, #10
    mlt r4, r1, r2
    sm r1, r4, r3
    smi r7, r7, #1
    j process_loop4

handle_comma4:
    smi r10, r10, #1
    cmp r10, #1
    beq A_loop4
    sm r12, r1
    smi r7, r7, #1
    movei r1, #0
    j process_loop5

handle_space4:
    pp {r7, r8, lr}
    sm r7, r8
    movei r10, #0
    movei r1, #0
    ldrbi r4, =#45
    storebi r4, [r0], #1
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    j process_loop

A_loop4:
    sm r11, r1
    movei r1, #0
    smi r7, r7, #1
    j process_loop4

process_loop5:
    ldrbr r3, [r9, r8]
    cmpi r3, #10
    jeq handle_comma5
    cmpo r3, #45
    jeq handle_space5
    rti r3, r3, #48
    movei r2, #10
    mlt r4, r1, r2
    sm r1, r4, r3
    smi r8, r8, #1
    j process_loop5

handle_comma5:
    cmpi r10, #2
    jeq A_loop5
    sm r5, r1
    movei r2, #2
    mlt r4, r2, r6
    sm r4, r4, r11
    dv r1, r4, #3
    movei r2, #2
    mlt r4, r2, r5
    sm r4, r4, r12
    psh {r10, r12, lr}
    sm r10, r5
    dv r12, r4, #3
    mlt r4, r2, r1
    sm r4, r4, r12
    dv r11, r4, #3
    sm r1, r11
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    movei r2, #2
    mlt r4, r2, r12
    sm r4, r4, r11
    dv r1, r4, #3
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    sm r1, r12
    sm r2, r0
    jl int_to_string
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    sm r6, r10
    pp {r10, r12, lr}
    sm r11, r12
    movei r1, #0
    smi r8, r8, #1
    j process_loop4

A_loop5:
    smi r10, r10, #1
    sm r6, r1
    movei r2, #2
    mlt r4, r2, r6
    sm r4, r4, r11
    dv r1, r4, #3
    sm r10, r6
    psh {r10, lr}
    sm r2, r0
    jl int_to_string
    pp {r10, lr}
    sm r6, r10
    ldrbi r4, =0x0A
    storebi r4, [r0], #1
    movei r1, #0
    smi r8, r8, #1
    j process_loop5

handle_space5:
    movei r10, #0
    sm r7, r8
    movei r1, #0
    j process_loop

process_done:
    movei r7, #4
    movei r0, #1
    loadr r1, =buffer
    movei r2, #2054
    sw 0
    pp {r4, r5, lr}
    jx lr

int_to_string:
    psh {r4, r5, r6, lr}
    movei r2, #0
    movei r6, #0
    movei r14, #0
    cmp r1, #0
    bge invertir_loop
    movei r3, #45
    storebi r3, [r0], #1
    rti r1, #0, r1

convert_loop:
    movei r3, #10
    dv r4, r1, r3
    mls r5, r4, r3, r1
    smi r5, r5, #48
    storeb r5, [r0, r2]
    smi r2, r2, #1
    sm r1, r4
    cmpi r1, #0
    bne convert_loop
    movei r5, #0
    storeb r5, [r0, r2]
    sm r0, r0, r2
    pp {r4, r5, r6, lr}
    jx lr

invertir_loop:
    movei r3, #10
    dv r4, r1, r3
    mls r5, r4, r3, r1
    mlt r14, r6, r3
    sm r6, r14, r5
    sm r1, r4
    cmp r1, #0
    bne invertir_loop
    sm r1, r6, #0
    j convert_loop
