`timescale 1ns/1ns
//1. Def. Modulo y I/O
module S4B(
	input [3:0]A,
	input [3:0]B,
	input Cin,
	output [4:0]R
);

/*
module FA (
	input X,
	input Y,	
	input C_in,
	output SUMA,
	output C_out
); */

//2. Def de Componentes internos
wire C1, C2, C3;

//3. Instancias, assigns, Secuencias
FA bit0(.X(A[0]), .Y(B[0]), .C_in(Cin), .SUMA(R[0]), .C_out(C1));
FA bit1(.X(A[1]), .Y(B[1]), .C_in(C1), .SUMA(R[1]), .C_out(C2));
FA bit2(.X(A[2]), .Y(B[2]), .C_in(C2), .SUMA(R[2]), .C_out(C3));
FA bit3(.X(A[3]), .Y(B[3]), .C_in(C3), .SUMA(R[3]), .C_out(R[4]));

endmodule