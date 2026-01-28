module segment_id_ex_tb();

    reg clk, rst;
    reg MemToReg_in, MemRead_in, MemWrite_in, ALUSrc_in, RegWrite_in;
    reg [2:0] ALUOp_in;
    reg [20:0] pc_in, RD1_in, RD2_in, RD3_in, num_in;
    reg [3:0] RR3_in;
    wire MemToReg_out, MemRead_out, MemWrite_out, ALUSrc_out, RegWrite_out;
    wire [2:0] ALUOp_out;
    wire [20:0] pc_out, RD1_out, RD2_out, RD3_out, num_out;
    wire [3:0] RR3_out;

    // Instanciar el módulo
    segment_id_ex uut (
        .clk(clk),
        .rst(rst),
        .MemToReg_in(MemToReg_in),
        .MemRead_in(MemRead_in),
        .MemWrite_in(MemWrite_in),
        .ALUOp_in(ALUOp_in),
        .ALUSrc_in(ALUSrc_in),
        .RegWrite_in(RegWrite_in),
        .pc_in(pc_in),
        .RD1_in(RD1_in),
        .RD2_in(RD2_in),
        .RD3_in(RD3_in),
        .RR3_in(RR3_in),
        .num_in(num_in),
        .MemToReg_out(MemToReg_out),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .ALUOp_out(ALUOp_out),
        .ALUSrc_out(ALUSrc_out),
        .RegWrite_out(RegWrite_out),
        .pc_out(pc_out),
        .RD1_out(RD1_out),
        .RD2_out(RD2_out),
        .RD3_out(RD3_out),
        .RR3_out(RR3_out),
        .num_out(num_out)
    );

    // Generar el reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Periodo de reloj = 10 unidades de tiempo
    end

    initial begin
        // Inicializar señales
        rst = 1;
        MemToReg_in = 0;
        MemRead_in = 0;
        MemWrite_in = 0;
        ALUOp_in = 3'b000;
        ALUSrc_in = 0;
        RegWrite_in = 0;
        pc_in = 21'd0;
        RD1_in = 21'd0;
        RD2_in = 21'd0;
        RD3_in = 21'd0;
        RR3_in = 4'd0;
        num_in = 21'd0;
        #10;

        // Test 1: Desactivar reset y pasar señales
        rst = 0;
        MemToReg_in = 1;
        MemRead_in = 1;
        MemWrite_in = 0;
        ALUOp_in = 3'b101;
        ALUSrc_in = 1;
        RegWrite_in = 1;
        pc_in = 21'd100;
        RD1_in = 21'd200;
        RD2_in = 21'd300;
        RD3_in = 21'd400;
        RR3_in = 4'd5;
        num_in = 21'd500;
        #10;
        $display("Test 1 - MemToReg: %b, MemRead: %b, MemWrite: %b, ALUOp: %b, ALUSrc: %b, RegWrite: %b, PC: %d, RD1: %d, RD2: %d, RD3: %d, RR3: %d, Num: %d", 
                 MemToReg_out, MemRead_out, MemWrite_out, ALUOp_out, ALUSrc_out, RegWrite_out, pc_out, RD1_out, RD2_out, RD3_out, RR3_out, num_out);

        // Test 2: Modificación de señales
        MemWrite_in = 1;
        ALUOp_in = 3'b010;
        pc_in = 21'd600;
        RD1_in = 21'd700;
        RD2_in = 21'd800;
        RD3_in = 21'd900;
        RR3_in = 4'd6;
        num_in = 21'd1000;
        #10;
        $display("Test 2 - MemToReg: %b, MemRead: %b, MemWrite: %b, ALUOp: %b, ALUSrc: %b, RegWrite: %b, PC: %d, RD1: %d, RD2: %d, RD3: %d, RR3: %d, Num: %d", 
                 MemToReg_out, MemRead_out, MemWrite_out, ALUOp_out, ALUSrc_out, RegWrite_out, pc_out, RD1_out, RD2_out, RD3_out, RR3_out, num_out);

        // Test 3: Activar reset
        rst = 1;
        #10;
        $display("Test 3 - Reset activado: MemToReg: %b, MemRead: %b, MemWrite: %b, ALUOp: %b, ALUSrc: %b, RegWrite: %b, PC: %d, RD1: %d, RD2: %d, RD3: %d, RR3: %d, Num: %d", 
                 MemToReg_out, MemRead_out, MemWrite_out, ALUOp_out, ALUSrc_out, RegWrite_out, pc_out, RD1_out, RD2_out, RD3_out, RR3_out, num_out);

        $finish;
    end

endmodule
