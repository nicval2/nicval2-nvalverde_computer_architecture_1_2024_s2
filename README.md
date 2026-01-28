# Proyectos – Arquitectura de Computadores I (CE4301)

Este repositorio contiene una colección de proyectos desarrollados como parte del curso **CE4301 – Arquitectura de Computadores I** del Instituto Tecnológico de Costa Rica.  Cada proyecto aborda distintos niveles de abstracción del hardware, desde programación en ensamblador, diseño de arquitecturas personalizadas, hasta la implementación de sistemas embebidos con microcontroladores.

---

## Proyecto 1 – Histograma de Palabras en Ensamblador

### Descripción
Este proyecto consiste en la implementación de un programa en **lenguaje ensamblador** que procesa un archivo de texto y genera la frecuencia de aparición de las palabras, con el objetivo de construir un **histograma de las 10 palabras más repetidas**.

El procesamiento del texto se realiza completamente en ensamblador, mientras que el preprocesamiento y la visualización del histograma pueden implementarse en un lenguaje de alto nivel.

### Objetivo
Comprender el funcionamiento interno de una arquitectura de procesador mediante la programación en ensamblador, optimizando el uso de instrucciones y recursos del sistema.

### Tecnologías y Herramientas
- ISA: x86 / ARM / RISC-V
- Lenguaje: Ensamblador
- Herramientas de simulación y depuración
- Lenguaje de alto nivel para visualización

---

## Proyecto 2 – ASIP para Interpolación Bilineal de Imágenes

### Descripción
En este proyecto se diseñó e implementó un **Application-Specific Instruction-set Processor (ASIP)** enfocado en la **interpolación bilineal de imágenes en escala de grises**.  
El ISA fue completamente personalizado y la microarquitectura implementada con **pipelining**.

El sistema permite seleccionar un cuadrante de la imagen de entrada, aplicar interpolación bilineal y mostrar el resultado por VGA, además de medir el desempeño en ciclos por instrucción.

### Objetivo
Aplicar conceptos avanzados de arquitectura y microarquitectura para demostrar las ventajas de un procesador especializado frente a arquitecturas de propósito general.

### Tecnologías y Herramientas
- Lenguaje: SystemVerilog
- Diseño de ISA personalizado
- Pipelining
- Simulación y pruebas unitarias
- FPGA Terasic DE1-SoC
- VGA, memoria y JTAG

---

## Proyecto 3 – Alimentador Automático de Animales con Microcontrolador

### Descripción
Este proyecto consiste en el diseño e implementación de un **alimentador automático para mascotas**, utilizando un microcontrolador, sensores ultrasónicos, servomotores y un buzzer.

El sistema detecta:
- Si el plato de la mascota tiene poca comida, dispensando alimento automáticamente.
- Si el contenedor principal de comida está vacío, activando una alerta sonora y mecánica.

### Objetivo
Diseñar un sistema embebido funcional que resuelva un problema real, integrando sensores, actuadores y control mediante microcontroladores.

### Tecnologías y Herramientas
- Microcontrolador
- Sensores ultrasónicos
- Servomotores
- Buzzer
- Placa perforada
- Diseño de hardware y software embebido
