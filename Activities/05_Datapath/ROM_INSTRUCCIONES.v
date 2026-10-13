module ROM_INSTRUCCIONES(
    input  [3:0] direccion,
    output [22:0] instruccion
);
// Memoria de 16 palabras de 23 bits.
reg [22:0]mem[0:15];
// Lectura combinacional por direccion.
assign instruccion = mem [direccion];
// Cargar mem_instrucciones.txt con $readmemb.
initial begin
	$readmemb("mem_instrucciones",mem);
end
endmodule