`timescale 1ns/1ns

module FA (
	input X,
	input Y,	
	input C_in,
	output SUMA,
	output C_out
);

/*
module HA (
	input A,
	input B,
	output S,
	output C
); */

wire C1, C2, C3;

HA juan (.A(X), .B(Y), .S(C1), .C(C2));

HA pedro (.A(C1), .B(C_in), .S(SUMA), .C(C3));

assign C_out = C3 | C2;

endmodule