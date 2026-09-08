`timescale 1ns/1ns

module MUX4_1 (
	input I0,
	input I1,
	input I2,
	input I3,
	input [1:0]Sel,
	output Y
);

/*
module MUX2_1 (
	input I0,
	input I1,
	input Sel,
	output Y
); */

wire A, B;

MUX2_1 R1(.I0(I0), .I1(I1), .Sel(Sel[0]), .Y(A));
MUX2_1 R2(.I0(I2), .I1(I3), .Sel(Sel[0]), .Y(B));
MUX2_1 R3(.I0(A), .I1(B), .Sel(Sel[1]), .Y(Y));

endmodule