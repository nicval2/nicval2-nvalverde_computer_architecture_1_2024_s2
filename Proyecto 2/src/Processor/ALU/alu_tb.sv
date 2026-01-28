module alu_tb ();

    // Definir las señales de entrada y salida
    reg [20:0] A, B;     // Entradas de 21 bits
    reg [4:0] sel;       // Selector de operación de 5 bits (opcode)
    wire [20:0] C;       // Salida de 21 bits
    wire flagZ;          // Bandera de cero
    
    // Instanciamos el módulo ALU
    alu uut ( 
        .A(A), 
        .B(B), 
        .sel(sel), 
        .C(C), 
        .flagZ(flagZ)
    );

    initial begin
        // Test 1: Suma (Opcode: 00011)
        A = 21'd5;
        B = 21'd10;
        sel = 5'b00011;   // Suma
        #2;
        $display("Test 1 - Suma: A=%d, B=%d, C=%d, Zero=%b", A, B, C, flagZ);

        // Test 2: Resta (Opcode: 00101)
        A = 21'd15;
        B = 21'd5;
        sel = 5'b00101;   // Resta
        #2;
        $display("Test 2 - Resta: A=%d, B=%d, C=%d, Zero=%b", A, B, C, flagZ);

        // Test 3: Multiplicación (Opcode: 01001)
        A = 21'd3;
        B = 21'd7;
        sel = 5'b01001;   // Multiplicación
        #2;
        $display("Test 3 - Multiplicacion: A=%d, B=%d, C=%d, Zero=%b", A, B, C, flagZ);

        // Test 4: Division (Opcode: 01010)
        A = 21'd20;
        B = 21'd4;
        sel = 5'b01010;   // Division
        #2;
        $display("Test 4 - Division: A=%d, B=%d, C=%d, Zero=%b", A, B, C, flagZ);

        // Test 5: Resultado cero (Suma de numeros opuestos)
        A = 21'b000000000000000000101;
        B = 21'b111111111111111111011;
        sel = 5'b00011;   // Suma
        #2;
        $display("Test 5 - Suma de numeros opuestos (deberia ser 0): A=%d, B=%d, C=%d, Zero=%b", A, B, C, flagZ);
        
    end
    
endmodule
