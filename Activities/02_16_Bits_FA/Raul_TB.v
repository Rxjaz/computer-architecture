`timescale 1ns/1ns
//1. Def. Modulo y I/O
module Raul_TB ();

//2. Def de Wires y reg
reg [3:0]A_tb;
reg [3:0]B_tb;
reg Cin_tb;
wire [4:0]R_tb;

/*module S4B(
	input [3:0]A,
	input [3:0]B,
	input Cin,
	output [4:0]R
);*/
	
//3. Instancias, assigns, Secuencias
S4B Raul(.A(A_tb),
		 .B(B_tb),
		 .Cin(Cin_tb),
		 .R(R_tb));

initial
begin
	//A=0011, B=0101, Cin=0; -> SUMA=1000 (3+5)
	A_tb=4'b0011;
	B_tb=4'b0101;
	Cin_tb=1'b0;
	#100;
	//A=0110, B=0001, Cin=0; -> SUMA=0111 (6+1)
	A_tb=4'b0110;
	B_tb=4'b0001;
	Cin_tb=1'b0;
	#100;
	//A=0010, B=0010, Cin=0; -> SUMA=0100 (2+2)
	A_tb=4'b0010;
	B_tb=4'b0010;
	Cin_tb=1'b0;
	#100;
	//A=0011, B=0011, Cin=0; -> SUMA=0110 (3+3)
	A_tb=4'b0011;
	B_tb=4'b0011;
	Cin_tb=1'b0;
	#100;
	//A=0101, B=0110, Cin=0; -> SUMA=1011 (5+6)
	A_tb=4'b0101;
	B_tb=4'b0110;
	Cin_tb=1'b0;
	#100;
	
	
	$stop;
end
endmodule
