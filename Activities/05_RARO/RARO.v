//1.
module RARO(
	input [5:0]DRom,
	input [5:0]DRam,
	input we,
	input [31:0]DataIn,
	input [3:0]op,
	output [31:0]DD,
	output  ZF
);

wire [31:0]c1,c2;

ROM romina (.DirL(DRom),.Data(c1));

RAM ramones(.DirL(DRam),.we(we),.DataIn(DataIn),.DataOut(c2));

MIPSALU salucita(.ALUctl(op),.A(c1),.B(c2),.ALUOut(DD),.Zero(ZF));

endmodule