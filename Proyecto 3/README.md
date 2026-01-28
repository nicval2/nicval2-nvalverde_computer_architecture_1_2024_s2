# Proyecto 3: Alimentador Automático de Animales con Microcontrolador

## Descripción General del Proyecto

El sistema consiste en un **alimentador automático** que utiliza **dos sensores ultrasónicos** y **dos servomotores** para controlar el suministro de comida, además de un **buzzer** para alertas sonoras.

El funcionamiento general es el siguiente:
- Un sensor mide la cantidad de comida disponible para la mascota.
- Si la cantidad es menor a un umbral definido, se activa un servomotor que abre una compuerta durante un corto período de tiempo para dejar caer alimento.
- Un segundo sensor mide el nivel del contenedor principal de comida.
- Si el contenedor se encuentra vacío o por debajo de un nivel mínimo, se activa un buzzer de alerta y se acciona un segundo servomotor.


## Componentes del Sistema

- Microcontrolador
- 2 Sensores de distancia ultrasónicos
- 2 Servomotores
- 1 Buzzer
- Fuente de alimentación
- Placa perforada
- Estructura física (case)


## Funcionamiento del Sistema

### Sensor 1 – Nivel de comida para la mascota

Este sensor se encuentra ubicado en la parte externa del recipiente donde cae la comida. Su función es medir la distancia hasta la superficie del alimento disponible para la mascota.

- Si el nivel de comida es suficiente, el sistema permanece en reposo.
- Si el nivel de comida es menor a un umbral establecido, se activa el **Servo 1**.

### Servo 1 – Compuerta de dispensado

El **Servo 1** controla una tapa que permite la caída de alimento hacia el recipiente de la mascota.

- El servo gira **90 grados**
- La compuerta se abre durante aproximadamente **5 milisegundos**
- Luego regresa a su posición inicial


### Sensor 2 – Nivel de comida almacenada

Este sensor se ubica en el contenedor principal donde se almacena la comida.

- Mide qué tan lleno se encuentra el depósito
- Si el nivel de comida es muy bajo o el contenedor está vacío, se activa una alerta

### Servo 2 y Buzzer – Alerta de contenedor vacío

Cuando el **Sensor 2** detecta que el contenedor de comida está vacío:

- Se activa el **buzzer** como advertencia sonora
- El **Servo 2** gira **90 grados** como señal visual o mecánica de alerta


## Anexo
![Proyecto3_Arqui](https://github.com/user-attachments/assets/46a9ac48-489f-4162-b324-53c5c46f34b6)

