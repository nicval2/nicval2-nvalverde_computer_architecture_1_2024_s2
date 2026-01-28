# Proyecto 2 Grupal: ASIP para Interpolación de Imágenes

## Descripción General del Proyecto

El proyecto consiste en el diseño e implementación de un **procesador vectorial personalizado** cuyo **ISA es definido por el grupo**, enfocado en ejecutar eficientemente el algoritmo de **interpolación bilineal** sobre imágenes en escala de grises.

El sistema completo incluye:
- Arquitectura e ISA personalizados.
- Microarquitectura con **pipelining**.
- Soporte para memoria de instrucciones y datos.
- Interacción con el usuario para selección de cuadrantes de la imagen.
- Visualización del resultado mediante salida VGA.


## Especificación del Sistema

- Imagen de entrada en escala de grises con valores entre **[0, 255]**
- Dimensión mínima de imagen: **390 × 390**
- Selección de cuadrantes mediante periféricos (switches o botones)
- Almacenamiento de imágenes en memoria interna
- Visualización de la imagen resultante por **VGA**
- Medición y almacenamiento de ciclos por instrucción (CPI)
- Lectura de métricas mediante **JTAG**

---

## Arquitectura ISA

El ISA es completamente personalizado basado en x86 e incluye:

- Modos de direccionamiento adecuados
- Tipos y tamaños de datos
- Instrucciones aritméticas y lógicas
- Instrucciones de control de flujo
- Acceso a memoria
- Codificación clara y coherente de las instrucciones

