`timescale 1ns/1ns
//1. Def. Modulo y I/O
module Mux6_1_TB ();

//2. Def de Wires y reg
reg [3:0]A_tb;
reg [3:0]B_tb;
reg [3:0]C_tb;
reg [7:0]D_tb;
reg [2:0]Sel_tb;
wire [7:0]R_tb;
wire en_tb;
integer i;

/*module Mux6_1 (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [7:0] D,
    input [2:0] Sel,
    output reg [7:0] R,
    output reg en
);*/
	
//3. Instancias, assigns, Secuencias
Mux6_1 Mux6_1_TB(.A(A_tb),
				 .B(B_tb),
				 .C(C_tb),
				 .D(D_tb),
				 .Sel(Sel_tb),
				 .R(R_tb),
				 .en(en_tb));
		 
initial
begin
for (i=0; i<5; i=i+1) begin

	A_tb=$random%16;
	B_tb=$random%16;
	C_tb=$random%16;
	D_tb=$random%256;
	
	Sel_tb=3'b001;
	#100;
	Sel_tb=3'b010;
	#100;
	Sel_tb=3'b011;
	#100;
	Sel_tb=3'b100;
	#100;
	Sel_tb=3'b101;
	#100;
	Sel_tb=3'b110;
	#100;
	
	end
	
	$stop;

end
endmodule