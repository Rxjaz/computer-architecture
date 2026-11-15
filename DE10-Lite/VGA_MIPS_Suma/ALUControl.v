module ALUControl(
    input  [1:0] ALUOp,
    input  [5:0] funct,
    output reg [3:0] ALUctl
);

always @(*) begin
    case (ALUOp) //00 y 01: la operación ya está decidida, se ignora funct (lw, sw, beq)
        2'b00: ALUctl = 4'b0010; //add para lw y sw
        2'b01: ALUctl = 4'b0110; //sub para beq
        2'b10: begin
            case (funct) //funct si importa
                6'b100100: ALUctl = 4'b0000; // and
                6'b100101: ALUctl = 4'b0001; // or
				6'b100000: ALUctl = 4'b0010; // add
                6'b100010: ALUctl = 4'b0110; // sub
                6'b101010: ALUctl = 4'b0111; // slt
				6'b100111: ALUctl = 4'b1100; // nor
                default:   ALUctl = 4'b0000;
            endcase
        end
        default: ALUctl = 4'b0000;
    endcase
end

endmodule