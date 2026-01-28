module sign_extend(input logic [27:0] num_in, // Inmediato de 27 bits según la green card
							input logic [1:0] imm_src, // Selección de inmediato
							output logic [31:0] num_out); // Salida extendida a 32 bits

	always_comb
		case(imm_src)
		
			// 27-bit unsigned immediate
			2'b00: num_out = { {12{num_in[19]}}, num_in[19:0]};
			
			// 17-bit unsigned immediate
			2'b01: num_out = { {14{num_in[17]}}, num_in[17:0]};
			
			// 24-bit two's complement shifted branch
			2'b10: num_out = { {15{num_in[16]}}, num_in[16:0]};
			
			default: num_out = 32'bx; // Valor indefinido en caso de fuente de inmediato no válida
		endcase
	
endmodule