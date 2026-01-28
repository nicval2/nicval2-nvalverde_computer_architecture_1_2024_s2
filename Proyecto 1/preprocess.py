import string
import os

def preprocesar_archivo(nombre_archivo_entrada, nombre_archivo_salida):
    try:
        # Abrir el archivo de entrada para lectura
        with open(nombre_archivo_entrada, 'r', encoding='utf-8') as archivo_entrada:
            texto = archivo_entrada.read()
        
        # Convertir a minúsculas para uniformidad
        texto = texto.lower()
        
        # Eliminar puntuaciones
        texto_sin_puntuacion = texto.translate(str.maketrans('', '', string.punctuation))
        
        # Tokenizar (dividir el texto en palabras)
        palabras = texto_sin_puntuacion.split()
        
        # Guardar las palabras tokenizadas en el archivo de salida temporalmente
        with open(nombre_archivo_salida, 'w', encoding='utf-8') as archivo_salida:
            for palabra in palabras:
                archivo_salida.write(palabra + '\n')
        
        # Calcular el tamaño del archivo de salida
        tamaño_archivo = os.path.getsize(nombre_archivo_salida)
        
        # Agregar 0.5 KB (512 bytes) al tamaño calculado
        tamaño_archivo += 512
        
        # Ahora escribe el tamaño del archivo al principio
        with open(nombre_archivo_salida, 'r+', encoding='utf-8') as archivo_salida:
            contenido = archivo_salida.read()  # Leer el contenido actual
            archivo_salida.seek(0, 0)  # Volver al principio del archivo
            archivo_salida.write(f"Size: {tamaño_archivo} bytes\n\n" + contenido)
        
        print(f"Preprocesamiento completo. Archivo guardado como {nombre_archivo_salida} con tamaño al inicio.")
    
    except FileNotFoundError:
        print(f"Error: El archivo {nombre_archivo_entrada} no fue encontrado.")
    except Exception as e:
        print(f"Ocurrió un error: {e}")


nombre_archivo_entrada = 'D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//texto_entrada.txt'
nombre_archivo_salida = 'D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//texto_preprocesado.txt'
preprocesar_archivo(nombre_archivo_entrada, nombre_archivo_salida)
