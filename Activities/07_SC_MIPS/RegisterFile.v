module RegisterFile(
	input clk,
	input RegWrite,
	input [4:0] AR1, AR2, AW,
	input [31:0] DW,
	output [31:0] DR1, DR2
);

reg [31:0] registers [0:31];

assign DR1 = registers[AR1];
assign DR2 = registers[AR2];

always @(posedge clk) begin
    if (RegWrite && AW != 5'd0) //se va a escribir? y la direccion no es 0?
		registers[AW] <= DW; //guarda el dato DW en el registro numero AW
end

initial begin
    $readmemb("rfdata", registers);
end

endmodule