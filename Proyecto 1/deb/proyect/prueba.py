from collections import Counter
import time

# Función para leer el archivo y contar las palabras
def contar_palabras(archivo):
    # Abrir el archivo en modo lectura
    with open(archivo, 'r', encoding='utf-8') as f:
        # Leer todas las palabras del archivo
        palabras = f.read().splitlines()  # Cada línea tiene una palabra
        
        # Contar la frecuencia de cada palabra
        contador_palabras = Counter(palabras)
        
        # Obtener las 10 palabras más comunes
        palabras_comunes = contador_palabras.most_common(10)
        
        return palabras_comunes

# Especificar el archivo a leer
archivo_txt = 'text.txt'

# Iniciar la medición del tiempo
inicio = time.time()

# Llamar a la función y mostrar el resultado
palabras_frecuentes = contar_palabras(archivo_txt)

# Terminar la medición del tiempo
fin = time.time()

# Imprimir las 10 palabras más comunes con su frecuencia
for palabra, frecuencia in palabras_frecuentes:
    print(f"{palabra}: {frecuencia} veces")

# Imprimir el tiempo de ejecución
print(f"El tiempo de ejecución fue: {fin - inicio:.4f} segundos")

