`timescale 1ns/1ns
//1. Def. Modulo y I/O
//2. Def de Componentes internos
//3. Instancias, assigns, Secuencias

module op5 (
	input [7:0]D,
	output [7:0]R
);

assign R = D % 2;

endmodule
