module jump_unit_tb();

    reg [20:0] pc;
    reg [20:0] offset;
    reg [1:0] jump_type;
    reg branch_taken;
    wire [20:0] jump_addr;
    wire link;

    // Instanciar la unidad de salto
    jump_unit uut (
        .pc(pc),
        .offset(offset),
        .jump_type(jump_type),
        .branch_taken(branch_taken),
        .jump_addr(jump_addr),
        .link(link)
    );

    initial begin
        // Test 1: Sin salto
        pc = 21'd100;
        offset = 21'd50;
        jump_type = 2'b00; // Sin salto
        branch_taken = 0;
        #5;
        $display("Test 1 - Sin salto: jump_addr = %d, link = %b", jump_addr, link);

        // Test 2: Salto condicional (no se cumple)
        jump_type = 2'b01; // Salto condicional
        branch_taken = 0;  // Condición no se cumple
        #5;
        $display("Test 2 - Salto condicional (no se cumple): jump_addr = %d, link = %b", jump_addr, link);

        // Test 3: Salto condicional (se cumple)
        branch_taken = 1;  // Condición se cumple
        #5;
        $display("Test 3 - Salto condicional (se cumple): jump_addr = %d, link = %b", jump_addr, link);

        // Test 4: Salto incondicional
        jump_type = 2'b10; // Salto incondicional
        branch_taken = 0;  // No importa el valor de branch_taken
        #5;
        $display("Test 4 - Salto incondicional: jump_addr = %d, link = %b", jump_addr, link);

        // Test 5: Salto con enlace
        jump_type = 2'b11; // Salto con enlace
        #5;
        $display("Test 5 - Salto con enlace: jump_addr = %d, link = %b", jump_addr, link);

        $finish;
    end

endmodule
