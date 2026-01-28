module register_file (
    input [3:0] RS1,    // Dirección del primer registro fuente (lectura)
    input [3:0] RS2,    // Dirección del segundo registro fuente (lectura)
    input [3:0] RS3,    // Dirección del tercer registro fuente (lectura)
    input [3:0] RD,     // Dirección del registro de destino (escritura)
    input [31:0] WD,    // Datos a escribir en el registro de destino
    input wr_enable,    // Señal de habilitación de escritura
    input clk,          // Señal de reloj
    input rst,          // Señal de reinicio (reset)

    output [31:0] RD1,  // Datos leídos del primer registro fuente
    output [31:0] RD2,  // Datos leídos del segundo registro fuente
    output [31:0] RD3   // Datos leídos del tercer registro fuente
);

    // Declaración de 16 registros de 32 bits
    logic [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15;

    // Variables temporales para almacenar los valores leídos
    logic [31:0] RD1_temp, RD2_temp, RD3_temp;

    // Lógica combinacional para leer registros basados en RS1, RS2, RS3
    always @(*) begin
        // Lectura de RS1
        case (RS1)
            4'd0: RD1_temp = R0;
            4'd1: RD1_temp = R1;
            4'd2: RD1_temp = R2;
            4'd3: RD1_temp = R3;
            4'd4: RD1_temp = R4;
            4'd5: RD1_temp = R5;
            4'd6: RD1_temp = R6;
            4'd7: RD1_temp = R7;
            4'd8: RD1_temp = R8;
            4'd9: RD1_temp = R9;
            4'd10: RD1_temp = R10;
            4'd11: RD1_temp = R11;
            4'd12: RD1_temp = R12;
            4'd13: RD1_temp = R13;
            4'd14: RD1_temp = R14;
            4'd15: RD1_temp = R15;
            default: RD1_temp = 32'd0;
        endcase
        
        // Lectura de RS2
        case (RS2)
            4'd0: RD2_temp = R0;
            4'd1: RD2_temp = R1;
            4'd2: RD2_temp = R2;
            4'd3: RD2_temp = R3;
            4'd4: RD2_temp = R4;
            4'd5: RD2_temp = R5;
            4'd6: RD2_temp = R6;
            4'd7: RD2_temp = R7;
            4'd8: RD2_temp = R8;
            4'd9: RD2_temp = R9;
            4'd10: RD2_temp = R10;
            4'd11: RD2_temp = R11;
            4'd12: RD2_temp = R12;
            4'd13: RD2_temp = R13;
            4'd14: RD2_temp = R14;
            4'd15: RD2_temp = R15;
            default: RD2_temp = 32'd0;
        endcase

        // Lectura de RS3
        case (RS3)
            4'd0: RD3_temp = R0;
            4'd1: RD3_temp = R1;
            4'd2: RD3_temp = R2;
            4'd3: RD3_temp = R3;
            4'd4: RD3_temp = R4;
            4'd5: RD3_temp = R5;
            4'd6: RD3_temp = R6;
            4'd7: RD3_temp = R7;
            4'd8: RD3_temp = R8;
            4'd9: RD3_temp = R9;
            4'd10: RD3_temp = R10;
            4'd11: RD3_temp = R11;
            4'd12: RD3_temp = R12;
            4'd13: RD3_temp = R13;
            4'd14: RD3_temp = R14;
            4'd15: RD3_temp = R15;
            default: RD3_temp = 32'd0;
        endcase
    end

    // Lógica secuencial para escribir en el registro de destino en el flanco positivo del reloj
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reiniciar todos los registros a 0
            R0 = 32'd0;
            R1 = 32'd0;
            R2 = 32'd0;
            R3 = 32'd0;
            R4 = 32'd0;
            R5 = 32'd0;
            R6 = 32'd0;
            R7 = 32'd0;
            R8 = 32'd0;
            R9 = 32'd0;
            R10 = 32'd0;
            R11 = 32'd0;
            R12 = 32'd0;
            R13 = 32'd0;
            R14 = 32'd0;
            R15 = 32'd0;
        end
        else if (wr_enable) begin
            // Escribir en el registro de destino RD
            case (RD)
                4'd0: R0 = 32'd0;  // El registro 0 siempre es 0
                4'd1: R1 = WD;
                4'd2: R2 = WD;
                4'd3: R3 = WD;
                4'd4: R4 = WD;
                4'd5: R5 = WD;
                4'd6: R6 = WD;
                4'd7: R7 = WD;
                4'd8: R8 = WD;
                4'd9: R9 = WD;
                4'd10: R10 = WD;
                4'd11: R11 = WD;
                4'd12: R12 = WD;
                4'd13: R13 = WD;
                4'd14: R14 = WD;
                4'd15: R15 = WD;
            endcase
        end
    end

    // Asignar las salidas
    assign RD1 = RD1_temp;
    assign RD2 = RD2_temp;
    assign RD3 = RD3_temp;

endmodule
