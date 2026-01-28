module pc_register(
    input clk,            // Señal de reloj
    input clr,            // Señal de limpieza (clear) para restablecer el PC a 0
    input load,           // Señal de carga (load) para actualizar el valor del PC
    input [31:0] pc_in,   // Entrada de 32 bits con el valor del PC a cargar
    output [31:0] pc_out  // Salida de 32 bits con el valor actual del PC
);
	
    logic [31:0] pc;       // Registro para almacenar el valor actual del PC
    logic [31:0] pc_temp;  // Temporal para almacenar el valor del PC en cada ciclo
	
    // Bloque siempre activado por el flanco positivo del reloj
    always_ff @(posedge clk) begin
        pc_temp <= pc; // Actualiza el valor temporal del PC en cada ciclo de reloj
    end
	
    // Bloque sensible al flanco positivo del reloj y al flanco negativo del clr
    always_ff @(posedge clk, negedge clr) begin
        if (clr == 0) // Si la señal de clr es 0, se limpia el PC
            pc <= 0; // Restablece el PC a 0
        else if (load == 1) // Si la señal de carga (load) es 1
            pc <= pc_in; // Carga el valor de entrada en el PC
        else
            pc <= pc; // Mantiene el valor actual del PC
    end
	
    // Asigna el valor actual del PC a la salida
    assign pc_out = pc;

endmodule
