`timescale 1ns/1ns
//1. Def. Modulo y I/O
module Victor_TB ();

//2. Def de Wires y reg
reg [15:0]A_tb;
reg [15:0]B_tb;
wire [15:0]R_tb;

/*module S16B (
	input [15:0]A,
	input [15:0]B,
	output [15:0]R
);*/
	
//3. Instancias, assigns, Secuencias
S16B Victor(.A(A_tb),
			.B(B_tb),
			.R(R_tb));
		 
initial
begin

	A_tb=16'd15;
	B_tb=-16'd30;
	#100;
	
	A_tb=16'd32767;
	B_tb=16'd500;
	#100;
	
	A_tb=16'd1256;
	B_tb=-16'd32767;
	#100;
	
	A_tb=16'd150;
	B_tb=16'd20;
	#100;
	
	A_tb=16'd25;
	B_tb=16'd100;
	#100;
	
	A_tb=16'd32767;
	B_tb=16'd1;
	#100;
	
	A_tb=16'd65535;
	B_tb=16'd1;
	#100;
	
	$stop;

end
endmodule