# Abrir el archivo de texto
with open('text.txt', 'r') as file:
    # Leer todo el contenido del archivo
    text = file.read()

# Dividir el texto en palabras
words = text.split()

# Verificar si hay al menos una palabra
if len(words) > 0:
    # Obtener la primera palabra
    first_word = words[1]
    
    # Contar cuántas veces aparece la primera palabra en el texto
    count = words.count(first_word)
    
    # Imprimir el resultado
    print(f"La palabra '{first_word}' aparece {count} veces en el texto.")
else:
    print("El archivo está vacío o no contiene palabras.")

