module segment_id_ex (
    input logic JumpI_in, JumpCI_in, JumpCD_in, // Señales de control de salto (entrada)
    input logic clk, rst,                      // Señales de reloj y reinicio
    input logic MemToReg_in, MemRead_in, MemWrite_in, // Señales de control de memoria (entrada)
    input logic [2:0] ALUOp_in,                // Operación de la ALU (entrada)
    input logic ALUSrc_in, RegWrite_in,        // Señales de control de la ALU y escritura en registro (entrada)
    input logic [31:0] pc_in, RD1_in, RD2_in, RD3_in, // Entradas de datos (PC, registros RD1, RD2, RD3)
    input logic [3:0] RR3_in,                  // Registro fuente RR3 (entrada)
    input logic [31:0] num_in,                 // Dato numérico adicional (entrada)
    
    output logic MemToReg_out, MemRead_out, MemWrite_out, // Señales de control de memoria (salida)
    output logic [2:0] ALUOp_out,              // Operación de la ALU (salida)
    output logic ALUSrc_out, RegWrite_out,     // Señales de control de la ALU y escritura en registro (salida)
    output logic [31:0] pc_out, RD1_out, RD2_out, RD3_out, // Salidas de datos (PC, registros RD1, RD2, RD3)
    output logic [3:0] RR3_out,                // Registro fuente RR3 (salida)
    output logic [31:0] num_out,               // Dato numérico adicional (salida)
    output logic JumpI_out, JumpCI_out, JumpCD_out // Señales de control de salto (salida)
);

    // Bloque secuencial activado en el flanco negativo del reloj o el flanco positivo de rst
    always_ff @(negedge clk, posedge rst) begin
        if (rst) begin
            // Si hay un reinicio, limpiar todas las salidas
            JumpI_out = 0;
            JumpCI_out = 0;
            JumpCD_out = 0;
            MemToReg_out = 0;
            MemRead_out = 0;
            MemWrite_out = 0;
            ALUOp_out = 0;
            ALUSrc_out = 0;
            RegWrite_out = 0;
            pc_out = 0;
            RD1_out = 0;
            RD2_out = 0;
            RD3_out = 0;
            RR3_out = 0;
            num_out = 0;
        end
        else begin
            // Si no hay reinicio, almacenar los valores de entrada en las salidas
            JumpI_out = JumpI_in;
            JumpCI_out = JumpCI_in;
            JumpCD_out = JumpCD_in;
            MemToReg_out = MemToReg_in;
            MemRead_out = MemRead_in;
            MemWrite_out = MemWrite_in;
            ALUOp_out = ALUOp_in;
            ALUSrc_out = ALUSrc_in;
            RegWrite_out = RegWrite_in;
            pc_out = pc_in;
            RD1_out = RD1_in;
            RD2_out = RD2_in;
            RD3_out = RD3_in;
            RR3_out = RR3_in;
            num_out = num_in;
        end
    end

endmodule
