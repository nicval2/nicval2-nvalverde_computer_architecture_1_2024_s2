import re
import struct

def preprocess_to_binary_with_length(input_file, output_file):
    # Leer el contenido del archivo de entrada
    with open(input_file, 'r', encoding='utf-8') as f:
        text = f.read()

    # Eliminar signos de puntuación y convertir a minúsculas
    text = re.sub(r'[^\w\s]', '', text)
    text = text.lower()

    # Separar las palabras
    words = text.split()

    # Crear archivo de salida binario
    with open(output_file, 'wb') as f:
        for word in words:
            # Obtener la longitud de la palabra
            length = len(word)

            # Escribir la longitud (1 byte)
            f.write(struct.pack('B', length))  # 'B' para un byte sin signo

            # Escribir la palabra en formato binario
            f.write(word.encode('utf-8'))

    print(f"Archivo '{output_file}' generado con éxito.")

def visualizar_salida_binaria(output_file):
    # Leer el archivo binario generado y mostrar su contenido en formato legible
    with open(output_file, 'rb') as f:
        contenido = f.read()
        print("Contenido en formato hexadecimal:")
        print(contenido.hex())  # Mostrar en formato hexadecimal



# Ejemplo de uso
preprocess_to_binary_with_length('D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//texto_entrada.txt', 'D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//texto_preprocesado2.txt')
visualizar_salida_binaria('D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//texto_preprocesado2.txt')+
+ 