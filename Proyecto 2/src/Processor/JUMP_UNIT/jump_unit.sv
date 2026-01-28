module jump_unit(
    input FlagZ,     // Señal de bandera de cero (FlagZ) de la ALU
    input JumpCD,    // Señal de control de salto condicional diferente
    input JumpCI,    // Señal de control de salto condicional igual
    input JumpI,     // Señal de control de salto inmediato
    output PCSource  // Salida que determina la fuente del PC (Program Counter)
);
	
    // XOR entre FlagZ y JumpCD (detecta si hay un salto condicional diferente)
    // xor_gate = FlagZ ^ JumpCD
    // AND que indica si se debe realizar un salto condicional diferente
    // and_gate_1 = (FlagZ ^ JumpCD) & JumpCD
    // AND que indica si se debe realizar un salto condicional inmediato
    // and_gate_2 = FlagZ & JumpCI
    // OR que determina la fuente del PC basado en los saltos y la bandera
    // or_gate = ((FlagZ ^ JumpCD) & JumpCD) | JumpI | (FlagZ & JumpCI)
	
    assign PCSource = ((FlagZ ^ JumpCD) & JumpCD) | JumpI | (FlagZ & JumpCI);

endmodule

