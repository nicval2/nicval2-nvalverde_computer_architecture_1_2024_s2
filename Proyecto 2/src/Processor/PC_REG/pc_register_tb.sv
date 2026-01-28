module pc_register_tb();

    // Definir señales
    reg clk;
    reg rst;
    reg [20:0] pc_in;
    reg pc_write;
    wire [20:0] pc_out;

    // Instanciar el módulo pc_register
    pc_register uut (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .pc_write(pc_write),
        .pc_out(pc_out)
    );

    // Generar el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Periodo de reloj = 10 unidades de tiempo
    end

    initial begin
        // Inicializar señales
        rst = 1;
        pc_in = 21'd0;
        pc_write = 0;
        #10;
        
        // Quitar el reset y probar
        rst = 0;
        #10;
        
        // Test 1: Escribir en el PC
        pc_in = 21'd100;
        pc_write = 1;
        #10;
        $display("Test 1 - PC: %d", pc_out);
        
        // Test 2: Escribir en el PC
        pc_in = 21'd200;
        #10;
        $display("Test 2 - PC: %d", pc_out);

        // Test 3: Deshabilitar la escritura
        pc_write = 0;
        pc_in = 21'd300;
        #10;
        $display("Test 3 - PC (no debe cambiar): %d", pc_out);

        // Test 4: Resetear el PC
        rst = 1;
        #10;
        rst = 0;
        $display("Test 4 - PC después del reset: %d", pc_out);

        $finish;
    end

endmodule
