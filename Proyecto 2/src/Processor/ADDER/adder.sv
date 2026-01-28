module adder (
    input [31:0] A,  // Entrada A de 32 bits
    input [31:0] B,  // Entrada B de 32 bits
    output [31:0] C  // Salida C de 32 bits, que será la suma de A y B
);

    // Asigna a C la suma de A y B
    assign C = A + B;

endmodule
