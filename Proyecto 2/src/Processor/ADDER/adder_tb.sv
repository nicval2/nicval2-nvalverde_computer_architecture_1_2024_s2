module adder_tb ();
    
    logic [3:0] rsd, rsn;
    logic [7:0] rsm;
    logic [20:0] instruction;
    
    adder adder_TB (rsd, rsn, rsm, instruction);
    
    initial begin
        /*// Test de suma 1:
        rsd = 4'b0001; // Registro destino
        rsn = 4'b0010; // Registro fuente 1
        rsm = 4'b0011; // Registro fuente 2
        imm = 8'b00000001; // Constante/Inmediato
        #2;*/
        
         // Test de suma 2:
		 rsd = 4'b0100;
		 rsn = 4'b0101;
		 rsm = 8'b00000011;
		 #2;
		 
		 // Mostrar el opcode y la instrucción
		 $display("Opcode: %b", instruction[20:16]);  // Ver el opcode (5 bits más significativos)
		 $display("Instruction: %b", instruction);  // Ver la instrucción completa
			  
        // Test de suma 3:
        /*rsd = 4'b0111;
        rsn = 4'b1000;
        rsm = 4'b1001;
        imm = 8'b00000011;
        #2;*/
    end
    
endmodule
