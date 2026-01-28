module segment_mem_wb (
    input logic clk, rst,                    // Señales de reloj y reinicio
    input logic MemToReg_in, RegWrite_in,    // Señales de control para la escritura en registro y uso de memoria
    input logic [31:0] mem_in, alu_in,       // Entradas de los resultados de memoria y ALU
    input logic [3:0] RR3_in,                // Entrada del registro fuente (RR3)
    
    output logic MemToReg_out, RegWrite_out, // Salidas de control para la escritura en registro y uso de memoria
    output logic [31:0] mem_out, alu_out,    // Salidas de los resultados de memoria y ALU
    output logic [3:0] RR3_out               // Salida del registro fuente (RR3)
);

    // Bloque secuencial activado en el flanco negativo del reloj o en el flanco positivo del reset
    always_ff @(negedge clk, posedge rst) begin
        if (rst) begin
            // Si hay un reinicio, limpiar todas las salidas
            MemToReg_out = 0;
            RegWrite_out = 0;
            mem_out = 0;
            alu_out = 0;
            RR3_out = 0;
        end
        else begin
            // Almacenar los valores de entrada en las salidas
            MemToReg_out = MemToReg_in;
            RegWrite_out = RegWrite_in;
            mem_out = mem_in;
            alu_out = alu_in;
            RR3_out = RR3_in;
        end
    end

endmodule
