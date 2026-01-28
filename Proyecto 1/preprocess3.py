import re

def preprocess_text(input_file, output_file):
    # Leer el archivo de entrada
    with open(input_file, 'r') as f:
        text = f.read()
    
    # Eliminar signos de puntuación
    text = re.sub(r'[^\w\s]', '', text)
    
    # Convertir a minúsculas
    text = text.lower()
    
    # Separar palabras
    words = text.split()
    
    # Filtrar palabras insignificantes (opcional)
    stopwords = {"el", "la", "y", "en", "de", "a", "con"}  # Agrega más si es necesario
    filtered_words = [word for word in words if word not in stopwords]
    
    # Escribir cada palabra en una nueva línea en el archivo de salida
    with open(output_file, 'w') as f:
        for word in filtered_words:
            f.write(word + '\n')



input_file = 'D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//texto_entrada.txt'  # El archivo que contiene el texto normal
output_file = 'D://.TEC/Arquitectura de Computadores//Jsantamaria_computer_architecture_1_2024_s2//text5.txt'
preprocess_text(input_file, output_file)

print(f"El archivo {output_file} ha sido creado con éxito.")