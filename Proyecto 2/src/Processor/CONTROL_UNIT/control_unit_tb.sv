module control_unit_tb();

    // Definición de señales
    reg [4:0] opcode;        // Opcode de 5 bits
    reg rst;                 // Reset
    wire MemToReg, MemRead, MemWrite, ALUSrc, RegWrite, Jump, BranchEQ, BranchNE;
    wire [2:0] ALUOp;        // Operación de la ALU

    // Instancia del módulo de control unit
    control_unit uut (
        .opcode(opcode),
        .rst(rst),
        .MemToReg(MemToReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .BranchEQ(BranchEQ),
        .BranchNE(BranchNE),
        .ALUOp(ALUOp)
    );

    initial begin
        // Probar reset
        rst = 1;
        #5;
        rst = 0;
        
        // Test 1: LOADR (00000)
        opcode = 5'b00000;
        #5;
        $display("LOADR - MemToReg: %b, MemRead: %b, MemWrite: %b, ALUSrc: %b, RegWrite: %b", MemToReg, MemRead, MemWrite, ALUSrc, RegWrite);

        // Test 2: STOREB (00001)
        opcode = 5'b00001;
        #5;
        $display("STOREB - MemToReg: %b, MemRead: %b, MemWrite: %b, ALUSrc: %b, RegWrite: %b", MemToReg, MemRead, MemWrite, ALUSrc, RegWrite);

        // Test 3: ADD (SM) (00011)
        opcode = 5'b00011;
        #5;
        $display("ADD - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 4: SUB (RT) (00101)
        opcode = 5'b00101;
        #5;
        $display("SUB - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 5: ADDI (SMI) (00100)
        opcode = 5'b00100;
        #5;
        $display("ADDI - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 6: SUBI (RTI) (00110)
        opcode = 5'b00110;
        #5;
        $display("SUBI - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 7: MUL (MLT) (01001)
        opcode = 5'b01001;
        #5;
        $display("MUL - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 8: DIV (DV) (01010)
        opcode = 5'b01010;
        #5;
        $display("DIV - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 9: MLS (RYM) (01011)
        opcode = 5'b01011;
        #5;
        $display("MLS - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 10: STOREBI (10101)
        opcode = 5'b10101;
        #5;
        $display("STOREBI - MemToReg: %b, MemRead: %b, MemWrite: %b, ALUSrc: %b, RegWrite: %b", MemToReg, MemRead, MemWrite, ALUSrc, RegWrite);

        // Test 11: LDRBR (10110)
        opcode = 5'b10110;
        #5;
        $display("LDRBR - MemToReg: %b, MemRead: %b, MemWrite: %b, ALUSrc: %b, RegWrite: %b", MemToReg, MemRead, MemWrite, ALUSrc, RegWrite);

        // Test 12: J (B) (01111)
        opcode = 5'b01111;
        #5;
        $display("J - Jump: %b, RegWrite: %b", Jump, RegWrite);

        // Test 13: JL (BL) (10000)
        opcode = 5'b10000;
        #5;
        $display("JL - Jump: %b, RegWrite: %b", Jump, RegWrite);

        // Test 14: CMP (CMPI) (10001)
        opcode = 5'b10001;
        #5;
        $display("CMP - ALUOp: %b, RegWrite: %b", ALUOp, RegWrite);

        // Test 15: BEQ (JEQ) (10010)
        opcode = 5'b10010;
        #5;
        $display("BEQ - BranchEQ: %b", BranchEQ);

        // Test 16: BNE (JNE) (10011)
        opcode = 5'b10011;
        #5;
        $display("BNE - BranchNE: %b", BranchNE);

        // Test 17: BX (JX) (10100)
        opcode = 5'b10100;
        #5;
        $display("BX - Jump: %b, RegWrite: %b", Jump, RegWrite);

        // Test 18: SWI (SW) (01100)
        opcode = 5'b01100;
        #5;
        $display("SWI - RegWrite: %b, MemRead: %b, MemWrite: %b", RegWrite, MemRead, MemWrite);

        // Test 19: PUSH (PSH) (01101)
        opcode = 5'b01101;
        #5;
        $display("PUSH - MemWrite: %b, RegWrite: %b", MemWrite, RegWrite);

        // Test 20: POP (PP) (01110)
        opcode = 5'b01110;
        #5;
        $display("POP - MemRead: %b, RegWrite: %b", MemRead, RegWrite);

        // Test 21: STOREB (STRB) (00001)
        opcode = 5'b00001;
        #5;
        $display("STOREB - MemWrite: %b, ALUSrc: %b, RegWrite: %b", MemWrite, ALUSrc, RegWrite);

        // Test 22: ADD (SM) (00011)
        opcode = 5'b00011;
        #5;
        $display("ADD - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        // Test 23: SUB (RT) (00101)
        opcode = 5'b00101;
        #5;
        $display("SUB - ALUOp: %b, ALUSrc: %b, RegWrite: %b", ALUOp, ALUSrc, RegWrite);

        $finish;
    end

endmodule
