`timescale 1ns/1ns
//1. Def. Modulo y I/O

module S16B (
	input [15:0]A,
	input [15:0]B,
	output [15:0]R
);

/*
module S4B(
	input [3:0]A,
	input [3:0]B,
	input Cin,
	output [4:0]R
);*/

//2. Def de Componentes internos
wire C1, C2, C3;

//3. Instancias, assigns, Secuencias
S4B S0(.A(A[3:0]), .B(B[3:0]), .Cin(0), .R({C1, R[3:0]}));
S4B S1(.A(A[7:4]), .B(B[7:4]), .Cin(C1), .R({C2, R[7:4]}));
S4B S2(.A(A[11:8]), .B(B[11:8]), .Cin(C2), .R({C3, R[11:8]}));
S4B S3(.A(A[15:12]), .B(B[15:12]), .Cin(C3), .R(R[15:12]));

endmodule