module ControlUnit(
	input [5:0] opcode, //bits [31:26]: indican el tipo de instrucción
	output reg RegDst, //registro destino rt (0) o rd (1)
	output reg ALUSrc, //desde donde toma el segundo operando la ALU, reg 0 inmediato 1
	output reg MemtoReg, //se va a mandar algo de la memoria de datos a el BR?
	output reg RegWrite, //se escribe en el banco de registros?
	output reg MemRead, //la memoria de datos va a leer?
	output reg MemWrite, //se va a escribir algo en la memoria de datos?
	output reg Branch, //es un salto condicional? (beq)
	output reg [1:0] ALUOp //le dice al ALU Control el tipo de operacion
);

always @(*) begin
	case (opcode)
		6'b000000: begin //Tipo R
			RegDst = 1'b1;
			ALUSrc = 1'b0;
			MemtoReg = 1'b0;
			RegWrite = 1'b1;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			Branch = 1'b0;
			ALUOp = 2'b10;
		end
		default: begin
			RegDst = 1'b0;
			ALUSrc = 1'b0;
			MemtoReg = 1'b0;
			RegWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			Branch = 1'b0;
			ALUOp = 2'b00;
		end
	endcase
end

endmodule