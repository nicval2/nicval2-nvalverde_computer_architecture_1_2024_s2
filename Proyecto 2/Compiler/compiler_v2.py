import os

labels = {}
register_map = {f"r{i}": f"{i:04b}" for i in range(13)}  # Registros en minúsculas
register_map['lr'] = '1100'

data_proc = {
    "loadr": "00000",
    "storeb": "00001",
    "storebi": "10101",
    "ldrbi": "00010",
    "ldrbr": "10110",
    "sm": "00011",
    "smi": "00100",
    "rt": "00101",
    "rti": "00110",
    "move": "00111",
    "movei": "01000",
    "mlt": "01001",
    "dv": "01010",
    "rym": "01011",
    "sw": "01100",
    "psh": "01101",
    "pp": "01110",
    "j": "01111",
    "jl": "10000",
    "cmpi": "10001",
    "jeq": "10010",
    "jne": "10011",
    "jx": "10100",
}

def createBinaryFile(binary):
    with open("binary.obj", "a") as f:
        f.write(binary)

def calcular_desplazamiento(etiqueta_actual, labels, lineNumber):
    direccion_destino = labels.get(etiqueta_actual, None)
    if direccion_destino is None:
        print("Error: No se encontró la etiqueta en el diccionario.")
        return
    desplazamiento = direccion_destino - lineNumber
    return desplazamiento

def parse_instruction(line, lineNumber, pc):
    line = line.strip()
    parts = line.split()
    
    if not parts:
        return
    
    # Manejar directivas
    if parts[0] == '.global':
        if len(parts) > 1:
            label_name = parts[1]
            labels[label_name] = None  # La dirección será asignada más tarde
            return
        else:
            print(f"Error: No se especificó etiqueta en .global en línea {lineNumber + 1}")
            return

    if parts[0].startswith('.'):
        # Manejar otras directivas
        if parts[0] in {'.section', '.data', '.text', '.asciz', '.space'}:
            return  # Ignorar estas directivas en la compilación
        else:
            print(f"Error: Directiva desconocida {parts[0]} en línea {lineNumber + 1}")
            return

    # Manejo de etiquetas
    if ':' in parts[0]:
        label_name = parts[0].replace(':', '')
        labels[label_name] = pc  # Asignar dirección actual a la etiqueta
        parts = parts[1:]  # Eliminar etiqueta de las parte

    opcode = parts[0].lower() if parts else None

    if opcode in data_proc:
        bin_opcode = data_proc[opcode]
        
        if opcode in {"loadr", "storeb", "ldrbr"}:
            rsd = register_map.get(parts[1].strip(','), '0000')
            rsn_v = register_map.get(parts[2].strip(','), '0000')
            rsn = bin(int(rsn_v))[2:].zfill(12)
            binary = f"{bin_opcode}{rsd}{rsn}\n"
        
        elif opcode in {"ldrbi", "storebi"}:
            rsd = register_map.get(parts[1].strip(','), '0000')
            immediate = int(parts[2])
            binary = f"{bin_opcode}{rsd}{immediate:012b}\n"

        elif opcode in {"sm", "move", "mlt", "dv"}:
            rsd = register_map.get(parts[1].strip(','), '0000')
            rsn = register_map.get(parts[2].strip(','), '0000')
            rsm_v= register_map.get(parts[3].strip(','), '0000')
            rsm = bin(int(rsm_v))[2:].zfill(8)
            binary = f"{bin_opcode}{rsd}{rsn}{rsm}\n"

        elif opcode in {"smi", "movei"}:
            rsd = register_map.get(parts[1].strip(','), '0000')
            rsn = register_map.get(parts[2].strip(','), '0000')
            immediate = int(parts[3]) 
            binary = f"{bin_opcode}{rsd}{rsn}{immediate:08b}\n"  # 8 bits para el inmediato

        elif opcode in {"rym", "pp", "psh"}:
            rsd = register_map.get(parts[1].strip(','), '0000')
            rsn = register_map.get(parts[2].strip(','), '0000')
            rsm = register_map.get(parts[3].strip(','), '0000')
            rsr = register_map.get(parts[4].strip(','), '0000')
            binary = f"{bin_opcode}{rsd}{rsn}{rsm}{rsr}\n"
        
        elif opcode in {"rt", "rti"}:
            rsd = register_map.get(parts[1].strip(','), '0000')
            rsn = register_map.get(parts[2].strip(','), '0000')
            rsm_v= register_map.get(parts[3].strip(','), '0000')
            rsm = bin(int(rsm_v))[2:].zfill(8)
            binary = f"{bin_opcode}{rsd}{rsn}{rsm}\n" 

        elif opcode in {"j", "jl", "jeq", "jne", "jx"}:
            label = parts[1]
            if label in labels:
                branch = labels[label]
                offset = branch - (pc + 1) #pc+3
                binary = f"{bin_opcode}{offset & 0xFFFF:016b}\n"  
            else:
                print(f"Error: Etiqueta desconocida '{label}' en línea {lineNumber + 1}")
                return

        elif opcode == "sw":
            #rsd = register_map.get(parts[1].strip(','), '0000')
            interruption = 0
            binary = f"{bin_opcode}{interruption:016b}\n"#{rsd:016b}{interruption:016b}\n"


        elif opcode == "cmpi":
            rsd = register_map.get(parts[1].strip(','), '0000')
            rsn_v = register_map.get(parts[2].strip(','), '0000')
            rsn = bin(int(rsn_v))[2:].zfill(12)
            binary = f"{bin_opcode}{rsd}{rsn}\n"

        createBinaryFile(binary)
    else:
        print(f"Error: Instrucción desconocida {opcode} en línea {lineNumber + 1}")


def parseFile(f):
    if os.access(f, os.R_OK):
        with open(f) as fp:
            file = fp.read()
    else:
        print("Error: No se puede leer el archivo.")
        return

    lineNumber = 0
    address = 0
    for line in file.splitlines():
        line = line.split(';')[0].strip()  
        if line:
            if ':' in line:
                label_name = line.split(':')[0].strip()
                labels[label_name] = address
            else:
                parse_instruction(line, lineNumber, address)
                address += 2 
            lineNumber += 1
    if "_start" not in labels:
        print("Error: La etiqueta '_start' no está definida.")

def getfile(f):
    print("Obteniendo archivo", f)
    path = os.path
    if path.exists(f):
        parseFile(f)
    else:
        print("Error: Archivo no encontrado!")

if __name__ == "__main__":
    print("Compilador en ejecución...")
    getfile("Compiler/prueba.txt")