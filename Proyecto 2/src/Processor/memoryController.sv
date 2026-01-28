module memoryController (
    input logic clk, we, switchStart, // Entradas: reloj, señal de escritura (write enable), y señal de inicio de switch
    input logic [31:0] pc, address, wd, // Entradas: Program Counter (pc), dirección, y datos de escritura
    output logic [31:0] rd, instruction // Salidas: datos leídos y la instrucción
);
						 
    // Variables internas para mapear las direcciones y almacenar los datos
    logic [31:0] mapAddressROM, mapAddressRAM, mapAddressInstructions, romData, ramData, instructionData;
						 
    // Instanciación de los módulos de memoria RAM y ROM
    dmem_ram ram (switchStart, clk, we, mapAddressRAM, wd, ramData); // RAM para memoria de datos
    dmem_rom rom (mapAddressROM, romData); // ROM para memoria de datos
    imem imem_rom (mapAddressInstructions, instructionData); // ROM para memoria de instrucciones
	
    always_latch begin
		
        // Lectura de instrucciones desde la memoria de instrucciones (imem)
        if (pc >= 'd0 && pc < 'd399) begin
            mapAddressInstructions = pc; // Mapea la dirección del PC a la memoria de instrucciones
            instruction = instructionData; // Asigna los datos de la instrucción leída a la salida
        end
		
        // Lectura de datos desde la memoria ROM
        if (address >= 'd400 && address < 'd8500) begin
            mapAddressROM = address - 'd400; // Ajusta la dirección para la ROM
            rd = romData; // Asigna los datos de ROM a la salida
        end
			
        // Lectura o escritura desde/para la memoria RAM
        else if (address >= 'd8500 && address < 'd138100) begin
            mapAddressRAM = address - 'd8500; // Ajusta la dirección para la RAM
            rd = ramData; // Asigna los datos de RAM a la salida
        end
				
        // Caso por defecto si no ocurre ninguna operación válida
        else begin
            mapAddressRAM = 32'b0; // Limpia la dirección de la RAM
            mapAddressROM = 32'b0; // Limpia la dirección de la ROM
            rd = 32'b0; // Limpia la salida de datos
        end
    end
						 
endmodule
