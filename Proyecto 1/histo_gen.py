import matplotlib.pyplot as plt

# Leer el archivo
with open('archivo_procesado.txt', 'r') as file:
    lines = file.readlines()

# Procesar las líneas para extraer palabras y frecuencias
words = []
frequencies = []

for line in lines:
    word, freq = line.split()
    words.append(word)
    frequencies.append(int(freq))

# Crear el histograma
plt.figure(figsize=(10, 6))
plt.bar(words, frequencies, color='skyblue')
plt.xlabel('Palabras')
plt.ylabel('Frecuencia')
plt.title('Histograma de las 10 palabras más repetidas')
plt.xticks(rotation=45)
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()  # Ajustar el diseño para que todo encaje
plt.show()
