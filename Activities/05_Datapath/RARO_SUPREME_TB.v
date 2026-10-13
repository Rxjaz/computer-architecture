`timescale 1ns/1ps
// Banco de observacion para alumnos. No calcula ni muestra respuestas esperadas.
module RARO_SUPREME_TB;
    reg [3:0] selector;
    wire [22:0] instruccion;
    wire [31:0] DD;
    wire ZF;
    integer i;

    SISTEMA_RARO dut(.selector(selector), .instruccion(instruccion),
                     .DD(DD), .ZF(ZF));

    initial begin
        $dumpfile("raro_supreme.vcd");
        $dumpvars(0, RARO_SUPREME_TB);
        $display("Sel | instruccion[22:0]       | DD[31:0]  | ZF");
        for (i=0; i<16; i=i+1) begin
            selector=i[3:0];
            #10; // estabilizacion; en WE=1 la RAM escribe sin reloj
            $display("%2d  | %023b | %08h | %b",i,instruccion,DD,ZF);
        end
        $finish;
    end
endmodule