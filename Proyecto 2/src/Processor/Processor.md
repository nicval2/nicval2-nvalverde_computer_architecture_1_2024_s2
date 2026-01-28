# Módulos

## 1. ALU (Unidad Aritmético Lógica)
Realiza operaciones aritméticas y lógicas en dos operandos (`A` y `B`) según la señal de selección (`sel`). Las operaciones incluyen suma, resta, multiplicación, división, y residuo. También se genera una bandera `flagZ` que indica si el resultado es cero.

## 2. Control Unit (Unidad de Control)
Genera las señales de control necesarias para la ejecución de instrucciones, basadas en el tipo de instrucción y función. Se manejan instrucciones aritméticas, de control de flujo, y de memoria. Los resultados son señales como `Jump`, `MemRead`, `MemWrite`, `ALUOp`, entre otras.

## 3. PC Register (Registro del Contador de Programa)
Almacena y actualiza la dirección de la próxima instrucción a ejecutar (PC). Se puede resetear y habilitar/deshabilitar su actualización mediante la señal `pc_write`.

## 4. Sign Extend (Extensor de Signo)
Extiende un inmediato de menor tamaño a 21 bits, dependiendo del tipo de inmediato (sin signo o con signo). Es útil para operaciones con inmediatos, como instrucciones de carga, almacenamiento y saltos.

## 5. Jump Unit (Unidad de Salto)
Calcula la nueva dirección de salto en caso de instrucciones como `J`, `JL`, o saltos condicionales. También guarda la dirección de retorno cuando se utiliza un salto con enlace (`JL`).

## 6. Segment EX/MEM (Segmento de Ejecución/Memoria)
Transfiere las señales y datos entre las etapas de **ejecución** (EX) y **memoria** (MEM) del pipeline. Almacena los resultados de la ALU, datos de registros, y señales de control como `MemRead`, `MemWrite`, y `RegWrite`.

## 7. Segment ID/EX (Segmento de Decodificación/Ejecución)
Transfiere las señales de control y datos desde la etapa de **decodificación** (ID) a la etapa de **ejecución** (EX). Incluye señales como `ALUOp`, `ALUSrc`, y datos de registros, además del contador de programa.

## 8. Segment IF/ID (Segmento de Búsqueda/Decodificación)
Transfiere el valor del contador de programa (PC) y descompone la instrucción obtenida en la etapa **fetch** (IF) para que sea usada en la etapa de **decodificación** (ID). Extrae diferentes campos de la instrucción como los registros y opcodes.

## 9. Segment MEM/WB (Segmento de Memoria/Escritura)
Transfiere las señales y datos desde la etapa de **memoria** (MEM) a la etapa de **escritura** (WB). Decide si se debe escribir en un registro el valor proveniente de la memoria o el resultado de la ALU y maneja las señales de control como `RegWrite` y `MemToReg`.

# Hay muchos de estos que están sin probar
Lo hice rápido, con lo que ya tenía, pero hay que probar, los testbench están 100% teóricos, hay que ver si están bien, probar y demás, ni siquiera compilé lo último