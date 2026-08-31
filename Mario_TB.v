`timescale 1ns/1ns
//1. Def. Modulo y I/O
module Mario_TB ();

//2. Def de Wires y reg
reg A_tb;
reg B_tb;
reg Cin_tb;
wire SUMA_tb;
wire Co_tb;

/*
module FA (
	input X,
	input Y,	
	input C_in,
	output SUMA,
	output C_out
); */
	
//3. Instancias, assigns, Secuencias
FA mario(.X(A_tb),
		 .Y(B_tb),
		 .C_in(Cin_tb),
		 .SUMA(SUMA_tb),
		 .C_out(Co_tb));

initial
begin
	//A=0, B=0, Cin=0; -> SUMA=0, Co=0
	A_tb=1'b0;
	B_tb=1'b0;
	Cin_tb=1'b0;
	#100;
	//-> SUMA=1, Co=0
	A_tb=1'b1;
	B_tb=1'b0;
	Cin_tb=1'b0;
	#100;
	//-> SUMA=0, Co=1
	A_tb=1'b1;
	B_tb=1'b1;
	Cin_tb=1'b0;
	#100;
	//-> SUMA=1 Co=1
	A_tb=1'b1;
	B_tb=1'b1;
	Cin_tb=1'b1;
	#100;
	
	$stop;
end
endmodule
