module imem (input logic [31:0] pc,
				output logic [31:0] instruction);
	
	logic [31:0] imem_ROM[399:0];
	
	initial
	
		/// Instructions memory.
		$readmemh("D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/Pruebas/test4/instructions.txt", imem_ROM);
		//$readmemh("D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/instructions.txt", imem_ROM);
		//$readmemh("C:\\Users\\Gustavo\\Desktop\\Jsantamaria_computer_architecture_1_2024_s2\\src\\Processor\\Pruebas\\instructions.txt",imem_ROM);
		
		
	assign instruction = imem_ROM[pc[31:0]];
	
endmodule 