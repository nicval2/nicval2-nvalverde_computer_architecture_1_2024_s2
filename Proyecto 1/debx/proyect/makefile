# Nombre del archivo
ASM_SOURCE = process.asm
OBJ_FILE = process.o
EXECUTABLE = process

# Lista de palabras a buscar
WORDS = "\"the\"" "\"a\"" "\"of\"" "\"and\"" "\"in\"" "\"to\"" "\"i\"" "\"on\"" "\"you\"" "\"that\""

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJ_FILE)
	ld -o $@ $^

$(OBJ_FILE): $(ASM_SOURCE)
	nasm -f elf64 -o $@ $<

run: $(EXECUTABLE)
	@for word in $(WORDS); do \
		echo "Buscando la palabra $$word..."; \
		nasm -f elf64 -o process.o process.asm -DSEARCH_WORD=$$word; \
		ld -o process process.o; \
		./process; \
	done

clean:
	rm -f $(OBJ_FILE) $(EXECUTABLE)

.PHONY: all clean run

