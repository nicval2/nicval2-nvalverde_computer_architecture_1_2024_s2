# Pseudocódigo en Ensamblador para Procesar Valores de Escala de Grises
### 1. Inicialización:

    1. Cargar la dirección de memoria donde comenzará el almacenamiento de los valores de escala de grises.
    2. Abrir el archivo .txt que contiene los valores de los píxeles en escala de grises.
### 2. Lectura del Archivo .txt:

    1. Leer línea por línea desde el archivo hasta encontrar el delimitador de inicio ---.
    2. Para cada línea de valor:
        a. Convertir la cadena de texto a un valor numérico.
        b. Almacenar ese valor en el registro correspondiente.
        c. Guardar el valor en la memoria a partir de la dirección base especificada.
### 3. Cierre del Archivo:

    1. Continuar leyendo hasta encontrar el delimitador de fin ---.
    2. Cerrar el archivo.
Fin del Programa:

    1. Terminar la ejecución y regresar al sistema operativo o al punto de control.

# Así podría ser la estructura un poco mas detallada

INICIO:
    LOAD  R1, direccion_base_memoria   ; R1 almacena la dirección base de la memoria donde se guardarán los valores
    CALL  ABRIR_ARCHIVO, "grayscale_values.txt"  ; Llamar función para abrir el archivo

LEER_LINEA:
    CALL  LEER_LINEA_ARCHIVO           ; Llamar función para leer una línea del archivo
    CMP   linea_actual, "---"          ; Comparar si es el delimitador de inicio
    BEQ   COMENZAR_PROCESO             ; Saltar si se encuentra el delimitador

COMENZAR_PROCESO:
    CALL  LEER_LINEA_ARCHIVO           ; Leer la siguiente línea
    CMP   linea_actual, "---"          ; Verificar si es el delimitador de fin
    BEQ   FIN_PROCESO                  ; Saltar a la finalización si es el delimitador de fin

PROCESAR_VALOR:
    CALL  CONVERTIR_TEXTO_A_NUMERO      ; Convertir el valor leído (cadena de texto) a un número
    STORE valor_convertido, [R1]        ; Almacenar el valor en memoria en la dirección apuntada por R1
    ADD   R1, R1, 1                    ; Incrementar la dirección de memoria
    JMP   COMENZAR_PROCESO              ; Repetir para el siguiente valor

FIN_PROCESO:
    CALL  CERRAR_ARCHIVO                ; Cerrar el archivo
    HALT                                ; Terminar la ejecución

FIN:
