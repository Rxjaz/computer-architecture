`timescale 1ns/1ns

module Compuertas (
	input A,
	input B,
	output C_AND,
	output C_OR,
	output C_NOT,
	output C_NAND,
	output C_NOR,
	output C_XOR,
	output C_XNOR
);

assign C_AND  = A & B;
assign C_OR   = A | B;
assign C_NOT  = ~A;
assign C_NAND = ~(A & B);
assign C_NOR  = ~(A | B);
assign C_XOR  = A ^ B;
assign C_XNOR = ~(A ^ B);

endmodule
