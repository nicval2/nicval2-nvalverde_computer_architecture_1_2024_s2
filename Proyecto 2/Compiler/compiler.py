import os

typeDictionary = {
    "SCI": "00",
    "SCD": "00",
    "SI": "00",
    "SIF": "00",

    "GDR": "01",
    "CRG": "01",

    "SUM": "10",
    "RES": "10",
    "MUL": "10",
    "DIV": "10",
    "RSD": "10",
    "SUMI": "10",
    "RESI": "10",
    "MULI": "10",
    "DIVI": "10",
    "RSDI": "10"
}

# opcode dictionary definition
opcodeDictionary = {
    "SCI": "10",
    "SCD": "11",
    "SI": "00",
    "SIF": "01",

    "GDR": "0",
    "CRG": "1",

    "SUM": "00000",
    "RES": "00001",
    "MUL": "00010",
    "DIV": "00011",
    "RSD": "00100",    
    "SUMI": "11000",
    "RESI": "11001",
    "MULI": "11010",
    "DIVI": "11011",
    "RSDI": "11100"
}

# register dictionary definition
registerDictionary = {
    "R0": "0000",
    "R1": "0001",
    "R2": "0010",
    "R3": "0011",
    "R4": "0100",
    "R5": "0101",
    "R6": "0110",
    "R7": "0111",
    "R8": "1000",
    "R9": "1001",
    "R10": "1010",
    "R11": "1011",
    "R12": "1100",
    "R13": "1101",
    "R14": "1110",
    "R15": "1111"
}
# binary_to_string
def binaryToTwosComplement(binary_input):
    complement = ""

    for bit in binary_input:
        if bit == "0":
            complement += "1"
        else:
            complement += "0"

    complement = int(complement, 2)
    complement += 1
    complement = bin(complement).replace("0b", "")

    return complement

def extendSign(value, instr_type, op_code, line_pointer):

    # Control instruction
    if instr_type == "00":
        immediate_value = value - line_pointer
    # Memory or data instruction
    else:
        immediate_value = value

    binary_repr = bin(abs(immediate_value)).replace("0b", "")
    binary_length = len(binary_repr)

    # Control instruction
    if instr_type == "00":

        is_conditional = op_code[0]

        # Conditional instruction
        if is_conditional == "1":
            extension = "0" * (20 - binary_length)
            binary_repr = extension + binary_repr

            # PC - direction
            if immediate_value < 0:
                binary_repr = binaryToTwosComplement(binary_repr)

            return binary_repr
            
        # Unconditional instruction
        else:
            extension = "0" * (28 - binary_length)
            binary_repr = extension + binary_repr

            # PC - direction
            if immediate_value < 0:
                binary_repr = binaryToTwosComplement(binary_repr)

            return binary_repr            

    # Memory instruction
    elif instr_type == "01":
        extension = "0" * (18 - binary_length)
        binary_repr = extension + binary_repr

        # PC - direction
        if immediate_value < 0:
            binary_repr = binaryToTwosComplement(binary_repr)

        return binary_repr 

    # Data instruction
    else:
        immediate_flag = op_code[0]

        # Immediate
        if immediate_flag == "1":
            extension = "0" * (17 - binary_length)
            binary_repr = extension + binary_repr

            # PC - direction
            if immediate_value < 0:
                binary_repr = binaryToTwosComplement(binary_repr)

            return binary_repr

def insertStallsForControlInstructions(instruction_list, instruction_type_dict):

    updated_instructions = instruction_list.copy()

    # This ensures no index out of range error
    updated_instructions.append("*")

    stall_instruction = ['SUM', 'R0', 'R0', 'R0', "********************"]

    index = 0

    # Loop through each instruction
    for instruction in updated_instructions:

        if len(instruction) > 1:
            current_instr = instruction[0]
            current_instr_type = instruction_type_dict[current_instr]

            # Control instruction
            if current_instr_type == "00":
                updated_instructions.insert(index + 1, stall_instruction)
                updated_instructions.insert(index + 2, stall_instruction)
                updated_instructions.insert(index + 3, stall_instruction)
                updated_instructions.insert(index + 4, stall_instruction)           

        index += 1

    return updated_instructions

def insertStallsForDependencies(instruction_list, instruction_type_dict, opcode_dict):

    updated_instructions = instruction_list.copy()

    # This ensures no index out of range error
    updated_instructions.append("*")

    stall_instruction = ['SUM', 'R0', 'R0', 'R0', "********************"]

    index = 0

    # Loop through each instruction
    for instruction in updated_instructions:

        if len(instruction) > 1:

            if updated_instructions[index + 1] == "*":
                break

            current_instruction = instruction[0]
            current_instruction_type = instruction_type_dict[current_instruction]
            current_dest_reg = instruction[1]

            if current_dest_reg != "R0":

                # Instruction
                if len(updated_instructions[index + 1]) > 1:
                    next_instruction_elements = updated_instructions[index + 1]
                # Label
                else:
                    next_instruction_elements = updated_instructions[index + 2]

                next_instruction = next_instruction_elements[0]
                next_instruction_type = instruction_type_dict[next_instruction]

                # Memory instruction
                if current_instruction_type == "01" and current_instruction == "CRG":

                    # Control instruction
                    if next_instruction_type == "00":

                        next_opcode = opcode_dict[next_instruction]
                        is_conditional = next_opcode[0]

                        # Conditional instruction
                        if is_conditional == "1":

                            next_source1 = next_instruction_elements[1]
                            next_source2 = next_instruction_elements[2]

                            if current_dest_reg == next_source1 or current_dest_reg == next_source2:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)
                                updated_instructions.insert(index + 3, stall_instruction)

                    # Memory instruction
                    elif next_instruction_type == "01":

                        next_opcode = opcode_dict[next_instruction]
                        is_grd_instruction = next_opcode[0]

                        # GRD instruction
                        if is_grd_instruction == "0":

                            next_source = next_instruction_elements[1]
                            next_dest_reg = next_instruction_elements[3]

                            if current_dest_reg == next_source or current_dest_reg == next_dest_reg:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)
                                updated_instructions.insert(index + 3, stall_instruction)

                        # CRG instruction
                        else:
                            next_source = next_instruction_elements[3]

                            if current_dest_reg == next_source:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)
                                updated_instructions.insert(index + 3, stall_instruction)

                    # Data instruction
                    else:

                        next_source2 = next_instruction_elements[2]
                        next_source3 = next_instruction_elements[3]

                        if current_dest_reg == next_source2 or current_dest_reg == next_source3:
                            updated_instructions.insert(index + 1, stall_instruction)
                            updated_instructions.insert(index + 2, stall_instruction)
                            updated_instructions.insert(index + 3, stall_instruction)

                # Data instruction
                else:

                    # Control instruction
                    if next_instruction_type == "00":

                        next_opcode = opcode_dict[next_instruction]
                        is_conditional = next_opcode[0]

                        # Conditional instruction
                        if is_conditional == "1":

                            next_source1 = next_instruction_elements[1]
                            next_source2 = next_instruction_elements[2]

                            if current_dest_reg == next_source1 or current_dest_reg == next_source2:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)
                                updated_instructions.insert(index + 3, stall_instruction)

                    # Memory instruction
                    elif next_instruction_type == "01":

                        next_opcode = opcode_dict[next_instruction]
                        is_grd_instruction = next_opcode[0]

                        # GRD instruction
                        if is_grd_instruction == "0":

                            next_source = next_instruction_elements[1]
                            next_dest_reg = next_instruction_elements[3]

                            if current_dest_reg == next_source or current_dest_reg == next_dest_reg:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)
                                updated_instructions.insert(index + 3, stall_instruction)

                        # CRG instruction
                        else:
                            next_source = next_instruction_elements[3]

                            if current_dest_reg == next_source:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)
                                updated_instructions.insert(index + 3, stall_instruction)

                    # Data instruction
                    else:

                        next_source2 = next_instruction_elements[2]
                        next_source3 = next_instruction_elements[3]

                        if current_dest_reg == next_source2 or current_dest_reg == next_source3:
                            updated_instructions.insert(index + 1, stall_instruction)
                            updated_instructions.insert(index + 2, stall_instruction)
                            updated_instructions.insert(index + 3, stall_instruction)

        index += 1

    return updated_instructions[:-1]

def insertStallsForInstructionSequence(instruction_list, instruction_type_dict, opcode_dict):

    updated_instructions = instruction_list.copy()

    # This ensures no index out of range error
    updated_instructions.append("*")

    stall_instruction = ['SUM', 'R0', 'R0', 'R0', "********************"]

    index = 0

    # Loop through each instruction
    for instruction in updated_instructions:

        if len(instruction) > 1:

            if updated_instructions[index + 2] == "*":
                break

            current_instruction = instruction[0]
            current_instruction_type = instruction_type_dict[current_instruction]
            current_dest_reg = instruction[1]

            if current_dest_reg != "R0":

                # Instruction
                if len(updated_instructions[index + 2]) > 1:
                    next_instruction_elements = updated_instructions[index + 2]
                # Label
                else:
                    next_instruction_elements = updated_instructions[index + 3]

                next_instruction = next_instruction_elements[0]
                next_instruction_type = instruction_type_dict[next_instruction]

                # Memory instruction
                if current_instruction_type == "01" and current_instruction == "CRG":

                    # Control instruction
                    if next_instruction_type == "00":

                        next_opcode = opcode_dict[next_instruction]
                        is_conditional = next_opcode[0]

                        # Conditional instruction
                        if is_conditional == "1":

                            next_source1 = next_instruction_elements[1]
                            next_source2 = next_instruction_elements[2]

                            if current_dest_reg == next_source1 or current_dest_reg == next_source2:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)

                    # Memory instruction
                    elif next_instruction_type == "01":

                        next_opcode = opcode_dict[next_instruction]
                        is_grd_instruction = next_opcode[0]

                        # GRD instruction
                        if is_grd_instruction == "0":

                            next_source = next_instruction_elements[1]
                            next_dest_reg = next_instruction_elements[3]

                            if current_dest_reg == next_source or current_dest_reg == next_dest_reg:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)

                        # CRG instruction
                        else:

                            next_source = next_instruction_elements[3]

                            if current_dest_reg == next_source:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)

                    # Data instruction
                    else:

                        next_source2 = next_instruction_elements[2]
                        next_source3 = next_instruction_elements[3]

                        if current_dest_reg == next_source2 or current_dest_reg == next_source3:
                            updated_instructions.insert(index + 1, stall_instruction)
                            updated_instructions.insert(index + 2, stall_instruction)

                # Data instruction
                else:

                    # Control instruction
                    if next_instruction_type == "00":

                        next_opcode = opcode_dict[next_instruction]
                        is_conditional = next_opcode[0]

                        # Conditional instruction
                        if is_conditional == "1":

                            next_source1 = next_instruction_elements[1]
                            next_source2 = next_instruction_elements[2]

                            if current_dest_reg == next_source1 or current_dest_reg == next_source2:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)

                    # Memory instruction
                    elif next_instruction_type == "01":

                        next_opcode = opcode_dict[next_instruction]
                        is_grd_instruction = next_opcode[0]

                        # GRD instruction
                        if is_grd_instruction == "0":

                            next_source = next_instruction_elements[1]
                            next_dest_reg = next_instruction_elements[3]

                            if current_dest_reg == next_source or current_dest_reg == next_dest_reg:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)

                        # CRG instruction
                        else:

                            next_source = next_instruction_elements[3]

                            if current_dest_reg == next_source:
                                updated_instructions.insert(index + 1, stall_instruction)
                                updated_instructions.insert(index + 2, stall_instruction)

                    # Data instruction
                    else:

                        next_source2 = next_instruction_elements[2]
                        next_source3 = next_instruction_elements[3]

                        if current_dest_reg == next_source2 or current_dest_reg == next_source3:
                            updated_instructions.insert(index + 1, stall_instruction)
                            updated_instructions.insert(index + 2, stall_instruction)

        index += 1

    return updated_instructions[:-1]

def insertStallsForLongInstructionSequence(instruction_list, instruction_type_dict, opcode_dict):

    updated_instructions = instruction_list.copy()

    # This ensures no index out of range error
    updated_instructions.append("*")

    stall_instruction = ['SUM', 'R0', 'R0', 'R0', "********************"]

    index = 0

    # Loop through each instruction
    for instruction in updated_instructions:

        if len(instruction) > 1:

            if updated_instructions[index + 3] == "*":
                break

            current_instruction = instruction[0]
            current_instruction_type = instruction_type_dict[current_instruction]
            current_dest_reg = instruction[1]

            if current_dest_reg != "R0":

                # Instruction
                if len(updated_instructions[index + 3]) > 1:
                    next_instruction_elements = updated_instructions[index + 3]
                # Label
                else:
                    next_instruction_elements = updated_instructions[index + 4]

                next_instruction = next_instruction_elements[0]
                next_instruction_type = instruction_type_dict[next_instruction]

                # Memory instruction
                if current_instruction_type == "01" and current_instruction == "CRG":

                    # Control instruction
                    if next_instruction_type == "00":

                        next_opcode = opcode_dict[next_instruction]
                        is_conditional = next_opcode[0]

                        # Conditional instruction
                        if is_conditional == "1":

                            next_source1 = next_instruction_elements[1]
                            next_source2 = next_instruction_elements[2]

                            if current_dest_reg == next_source1 or current_dest_reg == next_source2:
                                updated_instructions.insert(index + 1, stall_instruction)

                    # Memory instruction
                    elif next_instruction_type == "01":

                        next_opcode = opcode_dict[next_instruction]
                        is_grd_instruction = next_opcode[0]

                        # GRD instruction
                        if is_grd_instruction == "0":

                            next_source = next_instruction_elements[1]
                            next_dest_reg = next_instruction_elements[3]

                            if current_dest_reg == next_source or current_dest_reg == next_dest_reg:
                                updated_instructions.insert(index + 1, stall_instruction)

                        # CRG instruction
                        else:
                            next_source = next_instruction_elements[3]

                            if current_dest_reg == next_source:
                                updated_instructions.insert(index + 1, stall_instruction)

                    # Data instruction
                    else:

                        next_source2 = next_instruction_elements[2]
                        next_source3 = next_instruction_elements[3]

                        if current_dest_reg == next_source2 or current_dest_reg == next_source3:
                            updated_instructions.insert(index + 1, stall_instruction)

                # Data instruction
                else:

                    # Control instruction
                    if next_instruction_type == "00":

                        next_opcode = opcode_dict[next_instruction]
                        is_conditional = next_opcode[0]

                        # Conditional instruction
                        if is_conditional == "1":

                            next_source1 = next_instruction_elements[1]
                            next_source2 = next_instruction_elements[2]

                            if current_dest_reg == next_source1 or current_dest_reg == next_source2:
                                updated_instructions.insert(index + 1, stall_instruction)

                    # Memory instruction
                    elif next_instruction_type == "01":

                        next_opcode = opcode_dict[next_instruction]
                        is_grd_instruction = next_opcode[0]

                        # GRD instruction
                        if is_grd_instruction == "0":

                            next_source = next_instruction_elements[1]
                            next_dest_reg = next_instruction_elements[3]

                            if current_dest_reg == next_source or current_dest_reg == next_dest_reg:
                                updated_instructions.insert(index + 1, stall_instruction)

                        # CRG instruction
                        else:
                            next_source = next_instruction_elements[3]

                            if current_dest_reg == next_source:
                                updated_instructions.insert(index + 1, stall_instruction)

                    # Data instruction
                    else:

                        next_source2 = next_instruction_elements[2]
                        next_source3 = next_instruction_elements[3]

                        if current_dest_reg == next_source2 or current_dest_reg == next_source3:
                            updated_instructions.insert(index + 1, stall_instruction)

        index += 1

    return updated_instructions[:-1]

def controlHazardUnit(instruction_list, instruction_type_dict, opcode_dict):

    # Apply stalls for each case
    case0 = insertStallsForControlInstructions(instruction_list, instruction_type_dict)
    case1 = insertStallsForDependencies(case0, instruction_type_dict, opcode_dict)
    case2 = insertStallsForInstructionSequence(case1, instruction_type_dict, opcode_dict)
    case3 = insertStallsForLongInstructionSequence(case2, instruction_type_dict, opcode_dict)    

    return case3

def parseInstructionFile(filename):

    # Open the specified file for reading
    with open(filename, 'r') as file:
        code_lines = file.readlines()

    # Variable to store all the parsed instruction elements
    instruction_elements = []

    # Iterate through each line in the file
    for line in code_lines:
        
        # Flag to indicate if the current instruction is a memory instruction (type 01)
        is_memory_instruction = False

        elements = []
        current_element = ""

        # Slice the current line to check if it's a label
        last_char = line[-2]

        # If the current line contains a label
        if last_char == ":":
            instruction_elements.append([line[:-2]])

        # If the current line contains an instruction
        else:
            # Iterate through each character in the current line
            for char in line:

                # Check for delimiters (spaces, commas, parentheses)
                if char in (" ", ",", "(", ")"):

                    # Set memory flag if encountering a parenthesis
                    if char == "(":
                        is_memory_instruction = True

                    if current_element != "":
                        elements.append(current_element)

                    current_element = ""

                else:
                    current_element += char

            # Remove the newline character from the last element
            current_element = current_element[:-1]
            elements.append(current_element)
            
            # Remove last element if the current instruction is a memory instruction
            if is_memory_instruction:
                elements.pop()

            instruction_elements.append(elements)
            
    return instruction_elements
def buildLabelDictionary(instruction_list):
    
    label_dict = {}

    # Variable to track the current line number
    line_counter = 0

    # Iterate over the instructions to identify labels
    for instruction in instruction_list:

        line_counter += 1

        instruction_length = len(instruction)

        # If the instruction is a label
        if instruction_length == 1:

            # Add the label to the dictionary with the corresponding line number
            label_dict[instruction[0]] = line_counter

            # Remove the label from the instruction list
            instruction_list.remove(instruction)

    return label_dict, instruction_list

def generateBinaryInstructions(filename, instruction_list, instruction_type_dict, opcode_dict, register_dict, label_dict):

    # Open the binary output file for writing
    with open(filename, 'w') as binary_file:

        # Variable to track the current line number
        line_counter = 0

        # Iterate through each instruction in the instruction list
        for elements in instruction_list:

            line_counter += 1

            print("elements = ", elements)        
                
            instruction_type = instruction_type_dict[elements[0]]
            opcode = opcode_dict[elements[0]]

            memory_padding = "000"
            data_padding = "0000000000000"

            # Control instruction
            if instruction_type == "00":

                conditional = opcode[0]

                # Conditional instruction
                if conditional == "1":

                    register1 = register_dict[elements[1]]
                    register2 = register_dict[elements[2]]

                    address = elements[3]
                    address = label_dict[address]
                    address = extendSign(address, instruction_type, opcode, line_counter)

                    instruction = instruction_type + opcode + register1 + register2 + address

                    print(instruction_type + " " + opcode + " " + register1 + " " + register2 + " " + address)

                # Unconditional instruction
                else:
                    address = elements[1]
                    address = label_dict[address]
                    address = extendSign(address, instruction_type, opcode, line_counter)

                    instruction = instruction_type + opcode + address

                    print(instruction_type + " " + opcode + " " + address)

            # Memory instruction
            elif instruction_type == "01":

                register1 = register_dict[elements[1]]

                immediate_value = int(elements[2])
                immediate_value = extendSign(immediate_value, instruction_type, opcode, line_counter)

                register2 = register_dict[elements[3]]       

                instruction = instruction_type + opcode + memory_padding + register1 + register2 + immediate_value

                print(instruction_type + " " + opcode + " " + memory_padding + " " + register1 + " " + register2 + " " + immediate_value)

            # Data instruction
            else:

                immediate_flag = opcode[0]

                # Immediate
                if immediate_flag == "1":

                    register1 = register_dict[elements[1]]
                    register2 = register_dict[elements[2]]
                    
                    immediate_value = int(elements[3])
                    immediate_value = extendSign(immediate_value, instruction_type, opcode, line_counter)

                    instruction = instruction_type + opcode + register1 + register2 + immediate_value

                    print(instruction_type + " " + opcode + " " + register1 + " " + register2 + " " + immediate_value)

                # No immediate
                else:

                    register1 = register_dict[elements[1]]
                    register2 = register_dict[elements[2]]
                    register3 = register_dict[elements[3]]

                    instruction = instruction_type + opcode + register1 + register2 + register3 + data_padding

                    print(instruction_type + " " + opcode + " " + register1 + " " + register2 + " " + register3 + " " + data_padding)
            
            print(" ")

            # Write the binary instruction to the file
            binary_file.write(instruction + "\n")

    return instruction_list

def main():
    # Definir las rutas de los archivos de entrada y salida
    input_file_path = 'C:\\Users\\yarit\\OneDrive - Estudiantes ITCR\\Escritorio\\IIS2024\\PROV2\\prueba.txt'
    output_file_path = 'C:\\Users\\yarit\\OneDrive - Estudiantes ITCR\\Escritorio\\IIS2024\\PROV2\\binaryCode3.txt'
    
    # Verificar si el archivo de entrada existe
    if os.path.exists(input_file_path):
        # Extraer los elementos de las instrucciones
        instruction_list = parseInstructionFile(input_file_path)

        # Aplicar la unidad de control de riesgos (hazard control)
        instruction_list = controlHazardUnit(instruction_list, typeDictionary, opcodeDictionary)

        # Construir el diccionario de etiquetas y actualizar la lista de instrucciones
        label_dict, instruction_list = buildLabelDictionary(instruction_list)

        # Generar el archivo de código binario
        generateBinaryInstructions(output_file_path, instruction_list, typeDictionary, opcodeDictionary, registerDictionary, label_dict)
        
        print(f"Binary instructions generated successfully in {output_file_path}")
    else:
        print(f"Error: Input file {input_file_path} not found.")

# Ejecutar la función main
if __name__ == "__main__":
    main()
