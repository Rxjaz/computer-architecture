`timescale 1ns/1ns

module MIPSALU_TB ();

reg [31:0]A_tb, B_tb;
reg [3:0]ALUctrl_tb;
wire [31:0]ALUout_tb;
wire ZF_tb;

MIPSALU MIPSALU_TB(.A(A_tb),
				   .B(B_tb),
				   .ALUctrl(ALUctrl_tb),
				   .ALUout(ALUout_tb),
				   .ZF(ZF_tb));

initial
begin

	A_tb=32'd121;
	B_tb=32'd31;
	ALUctrl_tb=4'd0; #100;
	ALUctrl_tb=4'd1; #100;
	ALUctrl_tb=4'd2; #100;
	ALUctrl_tb=4'd6; #100;
	ALUctrl_tb=4'd7; #100;
	ALUctrl_tb=4'd12; #100;
	
	A_tb=32'd4294967295;
	B_tb=32'd1;
	ALUctrl_tb=4'd0; #100;
	ALUctrl_tb=4'd1; #100;
	ALUctrl_tb=4'd2; #100;
	ALUctrl_tb=4'd6; #100;
	ALUctrl_tb=4'd7; #100;
	ALUctrl_tb=4'd12; #100;
	
	A_tb=32'd0;
	B_tb=32'd1;
	ALUctrl_tb=4'd0; #100;
	ALUctrl_tb=4'd1; #100;
	ALUctrl_tb=4'd2; #100;
	ALUctrl_tb=4'd6; #100;
	ALUctrl_tb=4'd7; #100;
	ALUctrl_tb=4'd12; #100;
	
	$stop;

end
endmodule