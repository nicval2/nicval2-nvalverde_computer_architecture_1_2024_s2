#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WORD_LENGTH 100
#define MAX_WORDS 10000

// Estructura para almacenar palabras y su frecuencia
typedef struct {
    char word[MAX_WORD_LENGTH];
    int count;
} WordFrequency;

// Función para buscar una palabra en el arreglo de palabras
int find_word(WordFrequency words[], int num_words, const char *word) {
    for (int i = 0; i < num_words; i++) {
        if (strcmp(words[i].word, word) == 0) {
            return i;
        }
    }
    return -1;
}

// Función de comparación para ordenar por frecuencia
int compare(const void *a, const void *b) {
    WordFrequency *wordA = (WordFrequency *)a;
    WordFrequency *wordB = (WordFrequency *)b;
    return wordB->count - wordA->count;
}

int main() {
    FILE *input_file = fopen("text.txt", "r");
    if (input_file == NULL) {
        perror("Error al abrir el archivo de entrada");
        return 1;
    }

    WordFrequency words[MAX_WORDS];
    int num_words = 0;
    char buffer[MAX_WORD_LENGTH];

    // Leer el archivo palabra por palabra
    while (fgets(buffer, MAX_WORD_LENGTH, input_file)) {
        // Eliminar el salto de línea al final
        buffer[strcspn(buffer, "\n")] = 0;

        int index = find_word(words, num_words, buffer);
        if (index != -1) {
            words[index].count++;
        } else {
            // Nueva palabra, agregarla al arreglo
            strcpy(words[num_words].word, buffer);
            words[num_words].count = 1;
            num_words++;
        }
    }

    fclose(input_file);

    // Ordenar las palabras por frecuencia
    qsort(words, num_words, sizeof(WordFrequency), compare);

    // Escribir las 10 palabras más frecuentes en el archivo de salida
    FILE *output_file = fopen("output.txt", "w");
    if (output_file == NULL) {
        perror("Error al abrir el archivo de salida");
        return 1;
    }

    int top_words = (num_words < 10) ? num_words : 10;
    for (int i = 0; i < top_words; i++) {
        fprintf(output_file, "%s: %d\n", words[i].word, words[i].count);
    }

    fclose(output_file);

    printf("Las 10 palabras más frecuentes se han escrito en output.txt\n");

    return 0;
}
