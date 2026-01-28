module register_file_tb();

    reg clk, rst;
    reg RegWrite;
    reg [3:0] read_reg1, read_reg2, write_reg;
    reg [20:0] write_data;
    wire [20:0] read_data1, read_data2;

    // Instanciar el archivo de registros
    register_file uut (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Generar el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Periodo de reloj = 10 unidades de tiempo
    end

    initial begin
        // Inicialización de señales
        rst = 1;
        RegWrite = 0;
        read_reg1 = 4'd0;
        read_reg2 = 4'd1;
        write_reg = 4'd0;
        write_data = 21'd0;
        #10;

        // Test 1: Desactivar reset y escribir en un registro
        rst = 0;
        RegWrite = 1;
        write_reg = 4'd2;
        write_data = 21'd50;
        #10;
        $display("Test 1 - Escribir 50 en R2, leer R0 y R1: R0 = %d, R1 = %d", read_data1, read_data2);

        // Test 2: Leer el registro escrito
        RegWrite = 0;
        read_reg1 = 4'd2;
        read_reg2 = 4'd3;
        #10;
        $display("Test 2 - Leer R2 (debe ser 50) y R3: R2 = %d, R3 = %d", read_data1, read_data2);

        // Test 3: Escribir en otro registro
        RegWrite = 1;
        write_reg = 4'd4;
        write_data = 21'd100;
        #10;
        $display("Test 3 - Escribir 100 en R4, leer R2 y R3: R2 = %d, R3 = %d", read_data1, read_data2);

        // Test 4: Resetear y verificar
        rst = 1;
        #10;
        $display("Test 4 - Después del reset: R2 = %d, R4 = %d", read_data1, read_data2);

        $finish;
    end

endmodule
