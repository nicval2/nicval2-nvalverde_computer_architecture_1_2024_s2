module alu (
    input [31:0] A, B,           // Entradas A y B de 32 bits
    input [2:0] sel,             // Selector de operación de 3 bits
    output [31:0] C,             // Salida de 32 bits para el resultado
    output flagZ                 // Salida para la bandera de cero
);

    reg [31:0] alu_out_temp;      // Registro temporal para almacenar el resultado de la ALU
	
    // Bloque siempre sensible a cualquier cambio en las señales de entrada
    always @(*)
        case (sel)
		
            // Operación de suma
            3'b000: alu_out_temp = A + B; 
			
            // Operación de resta
            3'b001: alu_out_temp = A - B;
			
            // Operación de multiplicación
            3'b010: alu_out_temp = A * B;
			
            // Operación de división
            3'b011: alu_out_temp = A / B;
			
            // Operación de módulo (residuo de la división)
            3'b100: alu_out_temp = A % B;
			
            // Valor por defecto: suma
            default: alu_out_temp = A + B; 
		
        endcase 
		
    // Asignación del resultado de la ALU a la salida
    assign C = alu_out_temp;
	
    // Bandera Z (flagZ) se activa cuando el resultado de la ALU es cero
    assign flagZ = (alu_out_temp == 31'd0);	
	
endmodule
