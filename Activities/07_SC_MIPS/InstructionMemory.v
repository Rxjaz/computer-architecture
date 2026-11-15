module InstructionMemory(
    input  [31:0] Address,
    output [31:0] Instruction
);

reg [31:0] mem [0:63];
/* se neceita dividir el PC entre 4 para pasar de
“dirección en bytes” a “número de instrucción”
para hacerlo solo se quitan los ultimos dos bits
*/
assign Instruction = mem[Address[31:2]];

initial begin
    $readmemh("imdata", mem);
end

endmodule