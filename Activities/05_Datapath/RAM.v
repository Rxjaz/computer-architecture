//1.
module RAM (
	input [5:0]DirL,
	input we,
	input [31:0]DataIn,
	output reg[31:0]DataOut
	
);

//2. componentes internos
reg [31:0]mem[0:63];

always @*
begin
	if(we)
	begin //escribir
		mem[DirL]<=DataIn;
	end
	else //leer
	begin
		DataOut <= mem[DirL];
	end
end

initial begin
	$readmemb("memram",mem);
end
endmodule