module control_hazard (
    input logic clk, rst, Jump, BranchTaken,   // Señales de control para el salto
    input logic [20:0] next_pc_if,             // Dirección del siguiente PC desde IF
    input logic [20:0] target_pc,              // Dirección objetivo del salto
    output logic [20:0] pc_out,                // Dirección de PC corregida
    output logic flush                         // Señal de flush para manejar riesgos
);
    logic prediction;  // Señal para la predicción del salto

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            prediction <= 0;        // Inicializar la predicción
            flush <= 0;             // No se necesita flush al inicio
            pc_out <= 21'd0;        // PC inicial
        end else begin
            if (Jump) begin
                // Predicción de salto: si el salto es tomado, cargar el target PC
                prediction <= BranchTaken;
                pc_out <= (BranchTaken) ? target_pc : next_pc_if;
            end else begin
                pc_out <= next_pc_if;  // Continuar con el próximo PC si no hay salto
            end

            // Si la predicción es incorrecta, hacer flush
            flush <= (Jump && (BranchTaken != prediction));
        end
    end
endmodule
