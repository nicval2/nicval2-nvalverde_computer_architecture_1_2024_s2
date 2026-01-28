module segment_mem_wb_tb();
    // Clock and Reset
    logic clk, reset;

    // Signals for MEM/WB Segment
    logic [21:0] mem_data_in;
    logic [21:0] alu_result_in;
    logic MemToReg_in;
    logic RegWrite_in;
    logic [21:0] write_data_out;
    logic MemToReg_out;
    logic RegWrite_out;

    // Instantiate MEM/WB Segment
    segment_mem_wb mem_wb (
        .clk(clk),
        .reset(reset),
        .mem_data_in(mem_data_in),
        .alu_result_in(alu_result_in),
        .MemToReg_in(MemToReg_in),
        .RegWrite_in(RegWrite_in),
        .write_data_out(write_data_out),
        .MemToReg_out(MemToReg_out),
        .RegWrite_out(RegWrite_out)
    );

    // Clock Generation
    always #5 clk = ~clk;

    // Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        mem_data_in = 22'b0;
        alu_result_in = 22'b0;
        MemToReg_in = 0;
        RegWrite_in = 0;

        // Reset the system
        #10 reset = 0;

        // Test case: Write ALU result to register
        alu_result_in = 22'h123456;
        mem_data_in = 22'hFFFFFF;
        MemToReg_in = 0; // Select ALU result
        RegWrite_in = 1; // Enable register write
        #10;

        // Test case: Write Memory data to register
        alu_result_in = 22'hABCDEF;
        mem_data_in = 22'h654321;
        MemToReg_in = 1; // Select memory data
        RegWrite_in = 1; // Enable register write
        #10;

        // Test case: Disable register write
        alu_result_in = 22'h111111;
        mem_data_in = 22'h222222;
        MemToReg_in = 0; // Select ALU result
        RegWrite_in = 0; // Disable register write
        #10;

        // Finish simulation
        $stop;
    end
endmodule

