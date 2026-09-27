`timescale 1ns/1ns
//1. Def. Modulo y I/O
//2. Def de Componentes internos
//3. Instancias, assigns, Secuencias

module op6 (
	input [3:0]B,
	input [3:0]C,
	output [7:0]R
);

assign R = B + C;

endmodule
