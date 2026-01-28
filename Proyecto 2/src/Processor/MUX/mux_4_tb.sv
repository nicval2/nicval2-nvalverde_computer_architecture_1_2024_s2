module mux_4_tb;

    // Parámetros
    parameter N = 21;

    // Señales de prueba
    reg [N-1:0] A, B, C, D;
    reg [1:0] sel;
    wire [N-1:0] E;

    // Instanciar el multiplexor 4 a 1
    mux_4 #(N) uut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .sel(sel),
        .E(E)
    );

    // Inicializar las señales y aplicar estímulos
    initial begin
        // Estímulo 1: Seleccionar A
        A = 21'd1;
        B = 21'd2;
        C = 21'd3;
        D = 21'd4;
        sel = 2'b00; // Seleccionar A
        #10;
        $display("Selector: %b, E = %d", sel, E);
        
        // Estímulo 2: Seleccionar B
        sel = 2'b01; // Seleccionar B
        #10;
        $display("Selector: %b, E = %d", sel, E);
        
        // Estímulo 3: Seleccionar C
        sel = 2'b10; // Seleccionar C
        #10;
        $display("Selector: %b, E = %d", sel, E);
        
        // Estímulo 4: Seleccionar D
        sel = 2'b11; // Seleccionar D
        #10;
        $display("Selector: %b, E = %d", sel, E);

        // Terminar simulación
        $finish;
    end

endmodule
