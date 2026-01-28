from PIL import Image
import numpy as np


def convert_to_grayscale_and_save(image_path, output_image_path, output_file):
    # Cargar la imagen
    image = Image.open(image_path)

    # Convertir la imagen a escala de grises
    grayscale_image = image.convert('L')

    # Guardar la imagen en escala de grises
    grayscale_image.save(output_image_path)

    # Obtener los valores de los píxeles en formato numpy
    pixels = np.array(grayscale_image)

    # Abrir el archivo de salida
    with open(output_file, 'w') as file:
        # Iterar sobre las filas de la matriz de píxeles
        for i, row in enumerate(pixels):
            # Convertir cada fila a una cadena de valores separados por comas
            row_values = ",".join(map(str, row))
            # Si es la última fila, no agregamos el salto de línea al final
            if i == len(pixels) - 1:
                file.write(f"{row_values}")
            else:
                file.write(f"{row_values},\n")

    print(f"La imagen se ha convertido a escala de grises y se ha guardado en {output_image_path}.")
    print(f"Los valores de los píxeles se han guardado en {output_file} en formato de matriz.")


# Ejemplo de uso
image_path = r'C:\Users\nicva\OneDrive\Escritorio\Arqui\Jsantamaria_computer_architecture_1_2024_s2\images\imagen.jpg'  # Ruta de la imagen de entrada
output_image_path = r'C:\Users\nicva\OneDrive\Escritorio\Arqui\Jsantamaria_computer_architecture_1_2024_s2\images\imagen_gris.jpg'  # Ruta donde se guardará la imagen en grises
output_file = r'C:\Users\nicva\OneDrive\Escritorio\Arqui\Jsantamaria_computer_architecture_1_2024_s2\files\grayscale_values.txt'  # Ruta del archivo de texto donde se guardarán los valores de los píxeles

convert_to_grayscale_and_save(image_path, output_image_path, output_file)
