`timescale 1ns/1ns

module Mux6_1 (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [7:0] D,
    input [2:0] Sel,
    output reg [7:0] R,
    output reg en
);

wire [7:0] r1, r2, r3, r4, r5, r6;

op1 U1(.A(A), .B(B), .C(C), .R(r1));
op2 U2(.A(A), .C(C), .R(r2));
op3 U3(.D(D), .R(r3));
op4 U4(.C(C), .D(D), .R(r4));
op5 U5(.D(D), .R(r5));
op6 U6(.B(B), .C(C), .R(r6));

always @(*)
begin
	case(Sel)
		3'b001: begin R = r1; en = 1'b1; end
        3'b010: begin R = r2; en = 1'b0; end
        3'b011: begin R = r3; en = 1'b1; end
        3'b100: begin R = r4; en = 1'b0; end
        3'b101: begin R = r5; en = 1'b0; end
        3'b110: begin R = r6; en = 1'b1; end
		default: begin R = 8'b0; en = 1'b0; end
	endcase
end
endmodule