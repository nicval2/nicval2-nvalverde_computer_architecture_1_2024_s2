module dmem_rom (input logic [31:0] address,
				output logic [31:0] rd);
	
	logic [31:0] dmem_ROM[0:8099];
	
	initial
	
		// Data meant to be read
		$readmemh("D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/Pruebas/test4/imageData.txt", dmem_ROM);
		//$readmemh("D:/.TEC/Arquitectura de Computadores/Jsantamaria_computer_architecture_1_2024_s2/src/Processor/imageData.txt", dmem_ROM);
		//$readmemh("C:\\Users\\Gustavo\\Desktop\\Jsantamaria_computer_architecture_1_2024_s2\\src\\Processor\\Pruebas\\imageData.txt",dmem_ROM);
		
		
	assign rd = dmem_ROM[address[31:0]];
	
endmodule 