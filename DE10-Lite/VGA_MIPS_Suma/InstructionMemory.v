module InstructionMemory(
    input  [31:0] Address,
    output [31:0] Instruction
);

reg [31:0] mem [0:63];
/* se neceita dividir el PC entre 4 para pasar de
"direccion en bytes" a "numero de instruccion"
para hacerlo solo se quitan los ultimos dos bits

NUEVO (para la FPGA): solo se usan los bits [7:2] del PC, porque la memoria
tiene 64 palabras (2^6). Asi, cuando el PC pasa de 252 vuelve a leer mem[0]
y el programa se repite solo. En la simulacion original mem[Address[31:2]]
funcionaba, pero en hardware un indice fuera de rango no esta definido.
*/
assign Instruction = mem[Address[7:2]];

integer i;
initial begin
    // NUEVO: llenar con ceros primero. 0x00000000 es "sll $0,$0,0" (un NOP):
    // es tipo R pero escribe en $0, y $0 nunca se modifica.
    for (i = 0; i < 64; i = i + 1)
        mem[i] = 32'h00000000;
    $readmemh("imdata", mem);
end

endmodule
