module sign_extend_tb();

    reg [11:0] num_in;
    reg [1:0] imm_src;
    wire [20:0] num_out;

    // Instancia del módulo
    sign_extend uut (
        .num_in(num_in),
        .imm_src(imm_src),
        .num_out(num_out)
    );

    initial begin
        // Test 1: 12-bit unsigned immediate (imm_src = 2'b00)
        num_in = 12'b000011110000;
        imm_src = 2'b00;
        #5;
        $display("Test 1 - 12-bit unsigned: num_out = %b", num_out);

        // Test 2: 8-bit unsigned immediate (imm_src = 2'b01)
        num_in = 12'b000000001111;
        imm_src = 2'b01;
        #5;
        $display("Test 2 - 8-bit unsigned: num_out = %b", num_out);

        // Test 3: 12-bit two's complement immediate (imm_src = 2'b10)
        num_in = 12'b111100001111;  // Número negativo
        imm_src = 2'b10;
        #5;
        $display("Test 3 - 12-bit signed (negative): num_out = %b", num_out);

        // Test 4: 12-bit two's complement immediate (positive case)
        num_in = 12'b000010001111;  // Número positivo
        imm_src = 2'b10;
        #5;
        $display("Test 4 - 12-bit signed (positive): num_out = %b", num_out);

        $finish;
    end

endmodule
