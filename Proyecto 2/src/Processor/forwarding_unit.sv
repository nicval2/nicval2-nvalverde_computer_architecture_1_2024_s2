module forwarding_unit (
    input logic [3:0] EX_Rd, MEM_Rd, WB_Rd,  // Registros destino en EX, MEM, WB
    input logic EX_RegWrite, MEM_RegWrite, WB_RegWrite,  // Señales de escritura en registro
    input logic [3:0] ID_Rs1, ID_Rs2,       // Registros fuente en la etapa ID
    output logic [1:0] forwardA, forwardB   // Señales de adelantamiento para las ALU sources
);

    always_comb begin
        // Adelantamiento para la fuente A (primer operando de la ALU)
        if (EX_RegWrite && (EX_Rd != 4'd0) && (EX_Rd == ID_Rs1)) 
            forwardA = 2'b10;  // Adelantamiento desde EX
        else if (MEM_RegWrite && (MEM_Rd != 4'd0) && (MEM_Rd == ID_Rs1)) 
            forwardA = 2'b01;  // Adelantamiento desde MEM
        else 
            forwardA = 2'b00;  // No adelantamiento

        // Adelantamiento para la fuente B (segundo operando de la ALU)
        if (EX_RegWrite && (EX_Rd != 4'd0) && (EX_Rd == ID_Rs2)) 
            forwardB = 2'b10;  // Adelantamiento desde EX
        else if (MEM_RegWrite && (MEM_Rd != 4'd0) && (MEM_Rd == ID_Rs2)) 
            forwardB = 2'b01;  // Adelantamiento desde MEM
        else 
            forwardB = 2'b00;  // No adelantamiento
    end
endmodule
