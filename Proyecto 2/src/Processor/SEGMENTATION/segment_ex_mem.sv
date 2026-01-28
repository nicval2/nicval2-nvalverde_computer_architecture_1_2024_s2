module segment_ex_mem (
    input logic clk, rst,                     // Señales de reloj y reinicio
    input logic MemToReg_in, MemRead_in, MemWrite_in, RegWrite_in, // Señales de control (entrada)
    input logic [31:0] alu_in, RD3_in,        // Entradas de los resultados de la ALU y el registro RD3
    input logic [3:0] RR3_in,                 // Entrada del registro fuente RR3
    
    output logic MemToReg_out, MemRead_out, MemWrite_out, RegWrite_out, // Señales de control (salida)
    output logic [31:0] alu_out, RD3_out,     // Salidas de los resultados de la ALU y el registro RD3
    output logic [3:0] RR3_out                // Salida del registro fuente RR3
);

    // Bloque secuencial activado en el flanco negativo del reloj o en el flanco positivo del reset
    always_ff @(negedge clk, posedge rst) begin
        if (rst) begin
            // Si hay un reinicio, limpiar todas las salidas
            MemToReg_out = 0;
            MemRead_out = 0;
            MemWrite_out = 0;
            RegWrite_out = 0;
            alu_out = 0;
            RD3_out = 0;
            RR3_out = 0;
        end
        else begin
            // Almacenar los valores de entrada en las salidas
            MemToReg_out = MemToReg_in;
            MemRead_out = MemRead_in;
            MemWrite_out = MemWrite_in;
            RegWrite_out = RegWrite_in;
            alu_out = alu_in;
            RD3_out = RD3_in;
            RR3_out = RR3_in;
        end
    end

endmodule
