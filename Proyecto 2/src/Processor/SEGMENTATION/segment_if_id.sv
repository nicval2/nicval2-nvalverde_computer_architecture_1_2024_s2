module segment_if_id (
    input logic clk, rst,                   // Señales de reloj y reinicio
    input logic [31:0] pc_out, instruction, // Entradas: Program Counter (PC) y la instrucción de 32 bits
    output logic [31:0] pc,                 // Salida: Program Counter almacenado
    output logic [1:0] instr_31_30,         // Campo de bits [31:30] de la instrucción
    output logic [4:0] instr_29_25,         // Campo de bits [29:25] de la instrucción
    output logic [3:0] instr_27_24, instr_21_18, instr_20_17, instr_7_4, instr_23_20, // Campos de 4 bits de la instrucción
    output logic [3:0] instr_16_13, instr_25_22, instr_24_21, instr_11_8, // Otros campos de 4 bits
    output logic [27:0] instr_27_0           // Campo de bits [27:0] de la instrucción
);

    // Bloque secuencial activado en el flanco negativo del reloj o el flanco positivo de rst
    always_ff @(negedge clk, posedge rst) begin
        if (rst) begin
            // Si hay un reinicio, limpiar todas las salidas
            pc = 0;
            instr_31_30 = 0;
            instr_29_25 = 0;
            instr_27_24 = 0;
            instr_21_18 = 0;
            instr_20_17 = 0;
            instr_7_4 = 0;
            instr_23_20 = 0;
            instr_16_13 = 0;
            instr_25_22 = 0;
            instr_24_21 = 0;
            instr_11_8 = 0;
            instr_27_0 = 0;
        end
        else begin
            // Almacenar los valores de pc e instrucción cuando no hay reinicio
            pc = pc_out;
            instr_31_30 = instruction[31:30]; // Extraer los bits [31:30] de la instrucción
            instr_29_25 = instruction[29:25]; // Extraer los bits [29:25] de la instrucción
            instr_27_24 = instruction[27:24]; // Extraer los bits [27:24] de la instrucción
            instr_21_18 = instruction[21:18]; // Extraer los bits [21:18] de la instrucción
            instr_20_17 = instruction[20:17]; // Extraer los bits [20:17] de la instrucción
            instr_7_4 = instruction[7:4];     // Extraer los bits [7:4] de la instrucción
            instr_23_20 = instruction[23:20]; // Extraer los bits [23:20] de la instrucción
            instr_16_13 = instruction[16:13]; // Extraer los bits [16:13] de la instrucción
            instr_25_22 = instruction[25:22]; // Extraer los bits [25:22] de la instrucción
            instr_24_21 = instruction[24:21]; // Extraer los bits [24:21] de la instrucción
            instr_11_8 = instruction[11:8];   // Extraer los bits [11:8] de la instrucción
            instr_27_0 = instruction[27:0];   // Extraer los bits [27:0] de la instrucción
        end
    end

endmodule
