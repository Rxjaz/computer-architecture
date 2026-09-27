`timescale 1ns/1ns

module MIPSALU (
	input [31:0] A, B,
	input [3:0] ALUctrl,
	output reg [31:0] ALUout,
	output ZF
);

assign ZF = (ALUout==0);
always @(*) begin
	case (ALUctrl)
	4'd0: ALUout <= A & B;
	4'd1: ALUout <= A | B;
	4'd2: ALUout <= A + B;
	4'd6: ALUout <= A - B;
	4'd7: ALUout <= A < B ? 1 : 0;
	4'd12: ALUout <= ~(A | B);
	default: ALUout <= 0;
	endcase
end
endmodule