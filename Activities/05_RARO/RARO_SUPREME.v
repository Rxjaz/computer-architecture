module RARO_SUPREME(
    input  [22:0] instruccion,
    output [31:0] DD,
    output        ZF
);
// Separar DROM[22:17], DRAM[16:11], WE[10], DataIn[9:4] y OP[3:0].
wire [5:0] DROM = instruccion[22:17];
wire [5:0] DRAM = instruccion[16:11];
wire WE = instruccion[10];
wire [5:0] DataIn = instruccion[9:4];
wire [3:0] OP = instruccion[3:0];
// Declarar dos cables de datos de 32 bits.
wire [31:0] c1, c2;
// RAM.DataIn recibe {26'b0, DataIn}.
wire [31:0] DataIn32 = {26'b0, DataIn};
// Instanciar ROM, RAM y MIPSALU de clase.
ROM bombon (.DirL(DROM), .Data(c1));
RAM burbuja (.DirL(DRAM), .we(WE), .DataIn(DataIn32), .DataOut(c2));
MIPSALU bellota (.ALUctl(OP),.A(c1),.B(c2),.ALUOut(DD),.Zero(ZF));
endmodule


module SISTEMA_RARO(
    input  [3:0]  selector, //Direccion para la ROM de instrucciones
    output [22:0] instruccion,
    output [31:0] DD,
    output        ZF
);
// Instanciar ROM_INSTRUCCIONES y RARO_SUPREME.
ROM_INSTRUCCIONES cerebro (.direccion(selector), .instruccion(instruccion));
RARO_SUPREME musculo (.instruccion(instruccion), .DD(DD), .ZF(ZF));
// El selector escoge la instruccion; no hay reloj ni PC.
endmodule
