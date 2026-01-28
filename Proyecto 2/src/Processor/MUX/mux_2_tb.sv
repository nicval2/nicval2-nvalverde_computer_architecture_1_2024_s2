module mux_2_tb;

    // Parámetros
    parameter N = 21;

    // Señales de prueba
    reg [N-1:0] A, B;
    reg sel;
    wire [N-1:0] C;

    // Instanciar el multiplexor 2 a 1
    mux_2 #(N) uut (
        .A(A),
        .B(B),
        .sel(sel),
        .C(C)
    );

    // Inicializar las señales y aplicar estímulos
    initial begin
        // Estímulo 1: Seleccionar A
        A = 21'd10;
        B = 21'd20;
        sel = 1'b0; // Seleccionar A
        #10;
        $display("Selector: %b, C = %d", sel, C);
        
        // Estímulo 2: Seleccionar B
        sel = 1'b1; // Seleccionar B
        #10;
        $display("Selector: %b, C = %d", sel, C);

        // Terminar simulación
        $finish;
    end

endmodule
