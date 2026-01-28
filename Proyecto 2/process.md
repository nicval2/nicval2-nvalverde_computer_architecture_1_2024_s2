# Proceso para el Desarrollo del ASIP de Escala de Grises

# Definición del ISA para el ASIP de Procesamiento de Imágenes en Escala de Grises

Este documento describe la propuesta inicial para el conjunto de instrucciones (ISA) del procesador ASIP dedicado a procesar imágenes en escala de grises. El procesador utiliza un formato de 16 bits para las instrucciones, optimizando el uso de registros, la memoria y las operaciones con píxeles.

## 1. Tamaño de la Instrucción
El formato de las instrucciones es de **16 bits**. Se elige este tamaño para optimizar la simplicidad y el uso eficiente de los registros en operaciones básicas de procesamiento de imágenes.

### Formato General de Instrucción (16 bits):
| Opcode (4 bits) | R1 (4 bits) | R2 (4 bits) | Inmediato/Offset (4 bits) |
- **Opcode (4 bits)**: Determina la operación que la instrucción ejecuta.
- **R1 (4 bits)**: Registro fuente o destino.
- **R2 (4 bits)**: Registro fuente, o destino si es una instrucción de carga/almacenamiento.
- **Inmediato/Offset (4 bits)**: Valor inmediato o desplazamiento en operaciones de memoria o saltos.

## 2. Tipos de Instrucciones

### Aritméticas y Lógicas
Instrucciones básicas para operar sobre registros.
- **ADD R1, R2, R3**: Suma los valores de R2 y R3, almacena el resultado en R1.
  - Formato: `0001 R1 R2 R3`
- **SUB R1, R2, R3**: Resta el valor de R3 al de R2 y guarda el resultado en R1.
  - Formato: `0010 R1 R2 R3`
- **AND R1, R2, R3**: Operación AND entre R2 y R3, resultado en R1.
  - Formato: `0011 R1 R2 R3`
- **OR R1, R2, R3**: Operación OR entre R2 y R3, resultado en R1.
  - Formato: `0100 R1 R2 R3`

### Transferencia de Datos
Instrucciones para mover datos entre registros y memoria.
- **MOV R1, #inmediato**: Carga un valor inmediato en el registro R1.
  - Formato: `0101 R1 0000 inmediato`
- **LOAD R1, [R2]**: Carga el valor de la dirección en R2 y lo almacena en R1.
  - Formato: `0110 R1 R2 0000`
- **STORE R1, [R2]**: Almacena el valor de R1 en la dirección apuntada por R2.
  - Formato: `0111 R1 R2 0000`

### Control de Flujo
Instrucciones para realizar saltos y controlar el flujo del programa.
- **CMP R1, R2**: Compara los valores de R1 y R2.
  - Formato: `1000 R1 R2 0000`
- **BEQ offset**: Salta a la dirección indicada por el offset si la comparación previa es igual.
  - Formato: `1001 R1 0000 offset`
- **BNE offset**: Salta a la dirección indicada si la comparación previa no es igual.
  - Formato: `1010 R1 0000 offset`

### Operaciones de E/S (Input/Output)
Manejo de archivos y periféricos, como lectura y escritura de imágenes.
- **OPEN R1, #archivo**: Abre un archivo cuyo nombre se encuentra en R1.
  - Formato: `1011 R1 0000 inmediato`
- **READ R1, [R2]**: Lee desde la ubicación apuntada por R2 y almacena el dato en R1.
  - Formato: `1100 R1 R2 0000`
- **WRITE [R1], R2**: Escribe el valor en R2 en la dirección apuntada por R1.
  - Formato: `1101 R1 R2 0000`

### Instrucciones Especiales para Procesamiento de Imágenes
Instrucciones diseñadas específicamente para operaciones con píxeles de imágenes.
- **PIXLOAD R1, [R2]**: Carga un valor de píxel desde memoria (ubicación en R2) en R1.
  - Formato: `1110 R1 R2 0000`
- **PIXSTORE [R1], R2**: Almacena un valor de píxel (R2) en la dirección de memoria apuntada por R1.
  - Formato: `1111 R1 R2 0000`




# ISA Basado en ARM 32 Bits

## Control (Tipo 00)
Este tipo de instrucción se utiliza para los saltos condicionales y no condicionales en ARM. Utiliza un campo de condición de 4 bits y un offset de 24 bits para el salto.
[Cond] [Opcode] [Offset] 31-28 27-24 23-0


- **Cond (4 bits):** Define si el salto es condicional o incondicional. Ejemplos de condiciones:
  - `0000`: Igual
  - `0001`: No igual
  - `1010`: Mayor o igual
  - `1011`: Menor
  - `1110`: Siempre (salto incondicional)
  
- **Opcode (4 bits):** Código de operación que define el tipo de salto.
  - `1010`: `b` (branch o salto incondicional)
  - `1011`: `bl` (branch con enlace)

- **Offset (24 bits):** Especifica el desplazamiento relativo a la dirección actual del PC (Program Counter).

## Memoria (Tipo 01)
ARM utiliza instrucciones de carga y almacenamiento que operan con un registro base y un offset para acceder a la memoria.
[Opcode] [Rn] [Rd] [Offset] 31-24 19-16 15-12 11-0

- **Opcode (8 bits):** Define la operación a realizar, ya sea de carga o almacenamiento.
  - `11100101`: `ldr` (load, carga desde memoria)
  - `11100100`: `str` (store, almacenamiento en memoria)
  
- **Rn (4 bits):** Registro base desde el cual se calcula la dirección de memoria.
- **Rd (4 bits):** Registro destino o fuente para almacenar los datos.
- **Offset (12 bits):** Desplazamiento que se suma al valor de `Rn` para calcular la dirección final.

## Datos (Tipo 10)
Instrucciones de procesamiento de datos en ARM. Pueden involucrar registros o valores inmediatos para realizar las operaciones aritméticas y lógicas.
[Cond] [Opcode] [Rn] [Rd] [Inmediato/Registro] 31-28 27-20 19-16 15-12 11-0

- **Cond (4 bits):** Determina si la instrucción se ejecuta de manera condicional.
- **Opcode (8 bits):** Define la operación a realizar (suma, resta, comparación, etc.).
  - `11100000`: `and` (operación AND lógica)
  - `11100010`: `sub` (resta)
  - `11101010`: `cmp` (comparación)
  
- **Rn (4 bits):** Primer registro fuente para la operación.
- **Rd (4 bits):** Registro destino donde se guardará el resultado.
- **Inmediato/Registro (12 bits):** Puede ser un valor inmediato o un segundo registro usado para la operación.

## Registros en ARM
ARM utiliza 16 registros de propósito general y algunos registros especializados:

- **R0-R12:** Registros de propósito general.
- **R13 (SP):** Stack Pointer (Puntero de Pila).
- **R14 (LR):** Link Register (Registro de Enlace para almacenar la dirección de retorno de una subrutina).
- **R15 (PC):** Program Counter (Contador de Programa).

Estos registros se usan para las diversas operaciones aritméticas, de carga/almacenamiento y control de flujo.


