module RegisterFile(
	input clk,
	input RegWrite,
	input [4:0] AR1, AR2, AW,
	input [31:0] DW,
	output [31:0] DR1, DR2,
	// NUEVO: para cargar los operandos desde los switches de la tarjeta
	input load,              // 1 mientras se presiona KEY0
	input [31:0] load_t1,    // valor que se guarda en $t1 ($9)
	input [31:0] load_t2,    // valor que se guarda en $t2 ($10)
	// NUEVO: registros que se muestran en el monitor
	output [31:0] t0, t1, t2 // $8, $9, $10
);

reg [31:0] registers [0:31];

assign DR1 = registers[AR1];
assign DR2 = registers[AR2];

// NUEVO: "ventanas" para ver los registros desde afuera del procesador
assign t0 = registers[8];
assign t1 = registers[9];
assign t2 = registers[10];

always @(posedge clk) begin
    if (RegWrite && AW != 5'd0) //se va a escribir? y la direccion no es 0?
		registers[AW] <= DW; //guarda el dato DW en el registro numero AW

    // NUEVO: con load=1 se meten los valores de los switches a $t1 y $t2
    if (load) begin
        registers[9]  <= load_t1;
        registers[10] <= load_t2;
    end
end

initial begin
    $readmemb("rfdata", registers); // al encender: $t1 = 5, $t2 = 3
end

endmodule
