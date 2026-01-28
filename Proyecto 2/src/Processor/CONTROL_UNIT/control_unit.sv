module control_unit (
    input logic [1:0] instruction_type, // Tipo de instrucción de 2 bits
    input logic [4:0] func,             // Código de función de 5 bits
    input logic rst,                    // Señal de reinicio
    output logic JumpI, JumpCI, JumpCD, // Señales de salto (inmediato, condicional, desviado)
    output logic MemToReg, MemRead, MemWrite, // Señales de control de memoria
    output logic [2:0] ALUOp,           // Operación de la ALU de 3 bits
    output logic ALUSrc, RegWrite,      // Señales de selección de ALU y escritura en registro
    output logic [1:0] ImmSrc, RegDtn,  // Selección de inmediato y destino de registro
    output logic RegSrc2,               // Selección de segundo registro fuente
    output logic [1:0] RegSrc1          // Selección de primer registro fuente
);
			
    // Lógica secuencial con latch
    always_latch begin
        // Si hay un reinicio (reset), poner todas las señales de control a 0
        if (rst) begin
            JumpI = 0;
            JumpCI = 0;
            JumpCD = 0;
            MemToReg = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUOp = 0;
            ALUSrc = 0;
            RegWrite = 0;
            ImmSrc = 0;
            RegDtn = 0;
            RegSrc2 = 0;
            RegSrc1 = 0;
        end
		
        // Instrucciones de datos sin inmediato
        if (instruction_type == 2'b10 && func[4] == 1'b0) begin
            JumpI = 0;
            JumpCI = 0;
            JumpCD = 0;
            MemToReg = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUSrc = 0;
            RegWrite = 1;
            ImmSrc = 2'bxx;
            RegDtn = 2'b01;
            RegSrc2 = 1'b1;
            RegSrc1 = 2'b10;
			
            // Operaciones aritméticas según el valor de func
            case (func[4:0])
                5'b00000: ALUOp = 3'b000; // Suma
                5'b00001: ALUOp = 3'b001; // Resta
                5'b00010: ALUOp = 3'b010; // Multiplicación
                5'b00011: ALUOp = 3'b011; // División
                5'b00100: ALUOp = 3'b100; // Residuo
                default: ALUOp = 3'b000; // Valor por defecto
            endcase
        end
		
        // Instrucciones de datos con inmediato
        if (instruction_type == 2'b10 && func[4] == 1'b1) begin
            JumpI = 0;
            JumpCI = 0;
            JumpCD = 0;
            MemToReg = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUSrc = 1;
            RegWrite = 1;
            ImmSrc = 2'b10;
            RegDtn = 2'b01;
            RegSrc2 = 1'bx;
            RegSrc1 = 2'b10;
			
            // Operaciones aritméticas inmediatas
            case (func[4:0])
                5'b11000: ALUOp = 3'b000; // Suma inmediata
                5'b11001: ALUOp = 3'b001; // Resta inmediata
                5'b11010: ALUOp = 3'b010; // Multiplicación inmediata
                5'b11011: ALUOp = 3'b011; // División inmediata
                5'b11100: ALUOp = 3'b100; // Residuo inmediato
                default: ALUOp = 3'b000; // Valor por defecto
            endcase
        end
			
        // Instrucciones de control
        if (instruction_type == 2'b00) begin
            MemToReg = 0;
            MemRead = 0;
            MemWrite = 0;
            ALUSrc = 0;
            ALUOp = 3'b001;
            RegWrite = 0;
            ImmSrc = 2'b00;
            RegDtn = 2'bxx;
            RegSrc2 = 1'b0;
            RegSrc1 = 2'b00;
			
            // Instrucciones de salto
            case (func[4:3])
                2'b00: begin
                    JumpI = 1; // Salto inmediato
                    JumpCI = 0;
                    JumpCD = 0;
                end
                2'b10: begin
                    JumpI = 0;
                    JumpCI = 1; // Salto condicional inmediato
                    JumpCD = 0;
                end
                2'b11: begin
                    JumpI = 0;
                    JumpCI = 0;
                    JumpCD = 1; // Salto condicional desviado
                end
                default: begin
                    JumpI = 0;
                    JumpCI = 0;
                    JumpCD = 0;
                end
            endcase
        end
			
        // Instrucciones de memoria
        if (instruction_type == 2'b01) begin
            JumpI = 0;
            JumpCI = 0;
            JumpCD = 0;
            ALUSrc = 1;
            ALUOp = 3'b000; // Usar ALU para sumar direcciones
            ImmSrc = 2'b01; // Fuente de inmediato para direcciones
            RegDtn = 2'b00;
            RegSrc2 = 1'bx;
            RegSrc1 = 2'b01;
			
            // Instrucciones de carga y almacenamiento
            if (func[4] == 1'b0) begin
                MemToReg = 1'bx;
                MemRead = 0;
                MemWrite = 1; // Escritura en memoria
                RegWrite = 0;
            end
            else if (func[4] == 1'b1) begin
                MemToReg = 1;
                MemRead = 1; // Lectura de memoria
                MemWrite = 0;
                RegWrite = 1; // Escritura en registro
            end
        end
			
    end
endmodule
