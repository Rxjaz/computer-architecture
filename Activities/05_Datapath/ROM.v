
module ROM (
	input [5:0]DirL,
	output [31:0]Data
	);
 
 
reg [31:0]mem[0:63];

assign Data = mem [DirL];

initial begin
	$readmemb("memrom",mem);
end

/*
initial begin
	mem[0]=32'd22;
	mem[1]=32'd33;
	mem[2]=32'd16;
	mem[3]=32'd33;
	mem[4]=32'd44;
	mem[5]=32'd55;
end*/

endmodule
