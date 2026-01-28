module segment_ex_mem_tb();

    reg clk, rst;
    reg MemToReg_in, MemRead_in, MemWrite_in, RegWrite_in;
    reg [20:0] alu_in, RD3_in;
    reg [3:0] RR3_in;
    wire MemToReg_out, MemRead_out, MemWrite_out, RegWrite_out;
    wire [20:0] alu_out, RD3_out;
    wire [3:0] RR3_out;

    // Instanciar el módulo
    segment_ex_mem uut (
        .clk(clk),
        .rst(rst),
        .MemToReg_in(MemToReg_in),
        .MemRead_in(MemRead_in),
        .MemWrite_in(MemWrite_in),
        .RegWrite_in(RegWrite_in),
        .alu_in(alu_in),
        .RD3_in(RD3_in),
        .RR3_in(RR3_in),
        .MemToReg_out(MemToReg_out),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .RegWrite_out(RegWrite_out),
        .alu_out(alu_out),
        .RD3_out(RD3_out),
        .RR3_out(RR3_out)
    );

    // Generar el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Periodo de reloj = 10 unidades de tiempo
    end

    initial begin
        // Inicialización de señales
        rst = 1;
        MemToReg_in = 0;
        MemRead_in = 0;
        MemWrite_in = 0;
        RegWrite_in = 0;
        alu_in = 21'd0;
        RD3_in = 21'd0;
        RR3_in = 4'd0;
        #10;

        // Test 1: Reset desactivado
        rst = 0;
        MemToReg_in = 1;
        MemRead_in = 1;
        MemWrite_in = 0;
        RegWrite_in = 1;
        alu_in = 21'd100;
        RD3_in = 21'd200;
        RR3_in = 4'd5;
        #10;
        $display("Test 1 - MemToReg: %b, MemRead: %b, MemWrite: %b, RegWrite: %b, ALU_out: %d, RD3_out: %d, RR3_out: %d", 
                 MemToReg_out, MemRead_out, MemWrite_out, RegWrite_out, alu_out, RD3_out, RR3_out);

        // Test 2: Modificación de señales
        MemWrite_in = 1;
        alu_in = 21'd300;
        RD3_in = 21'd400;
        RR3_in = 4'd6;
        #10;
        $display("Test 2 - MemToReg: %b, MemRead: %b, MemWrite: %b, RegWrite: %b, ALU_out: %d, RD3_out: %d, RR3_out: %d", 
                 MemToReg_out, MemRead_out, MemWrite_out, RegWrite_out, alu_out, RD3_out, RR3_out);

        // Test 3: Reset activado
        rst = 1;
        #10;
        $display("Test 3 - Reset activado: MemToReg: %b, MemRead: %b, MemWrite: %b, RegWrite: %b, ALU_out: %d, RD3_out: %d, RR3_out: %d", 
                 MemToReg_out, MemRead_out, MemWrite_out, RegWrite_out, alu_out, RD3_out, RR3_out);

        $finish;
    end

endmodule
