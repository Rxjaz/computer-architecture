`timescale 1ns/1ns
//1. Def. Modulo y I/O
//2. Def de Componentes internos
//3. Instancias, assigns, Secuencias

module op4 (
	input [3:0]C,
	input [7:0]D,
	output [7:0]R
);

assign R = C * D;

endmodule
