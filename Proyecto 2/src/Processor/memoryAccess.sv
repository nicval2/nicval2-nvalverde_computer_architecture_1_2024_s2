module memoryAccess (
    input logic clk,               // Señal de reloj
    input logic memWriteM,         // Señal de habilitación de escritura en memoria
    input logic switchStart,       // Señal de inicio
    input logic [31:0] pc,         // Contador de programa (Program Counter)
    input logic [31:0] address,    // Dirección de memoria para acceso
    input logic [31:0] wd,         // Datos a escribir en memoria
    output logic [31:0] rd,        // Datos leídos de memoria
    output logic [31:0] instruction // Instrucción leída de la memoria de instrucciones
);

    // Instancia del módulo memoryController
    memoryController memoryControllerUnit (
        clk,              // Reloj
        memWriteM,        // Señal de habilitación de escritura
        switchStart,      // Señal de inicio
        pc,               // Contador de programa (PC)
        address,          // Dirección de memoria
        wd,               // Datos a escribir en memoria
        rd,               // Datos leídos de memoria
        instruction       // Instrucción leída
    );

endmodule
