//1. Def. Modulo y I/O
//2. Def de Componentes internos
//3. Instancias, assigns, Secuencias
`timescale 1ns/1ns

module MUX2_1 (
	input I0,
	input I1,
	input Sel,
	output Y
);

wire Sel_n, and0, and1;

assign Sel_n = ~Sel;
assign and0 = I0 & Sel_n;
assign and1 = I1 & Sel;
assign Y = and0 | and1;

endmodule
