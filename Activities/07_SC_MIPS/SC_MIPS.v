module SC_MIPS(
	input clk,
	input reset
);

// Cables de datos
wire [31:0] PC_out, PC_next, Instruction;
wire [31:0] DR1, DR2, ALUResult;
wire [3:0] ALUctl;
wire Zero;

//Señales de control
wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
wire [1:0] ALUOp;

//1. Buscar la instrccion
PC pc(.clk(clk), .reset(reset), .PC_next(PC_next), .PC_out(PC_out));
Adder add4(.A(PC_out), .B(32'd4), .R(PC_next));
InstructionMemory im(.Address(PC_out), .Instruction(Instruction));

//2. Decidir que hacer
ControlUnit cu(
	.opcode(Instruction[31:26]),
	.RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
	.RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), 
	.Branch(Branch), .ALUOp(ALUOp)
);

//3. Leer y escribir registros
RegisterFile rf(
	.clk(clk),
	.RegWrite(RegWrite),
	.AR1(Instruction[25:21]),
	.AR2(Instruction[20:16]),
	.AW(Instruction[15:11]),
	.DW(ALUResult),
	.DR1(DR1),
	.DR2(DR2)
);

//4. Operar
ALUControl aluc(.ALUOp(ALUOp), .funct(Instruction[5:0]), .ALUctl(ALUctl));
ALU alu(.ALUctl(ALUctl), .A(DR1), .B(DR2), .ALUOut(ALUResult), .Zero(Zero));

endmodule