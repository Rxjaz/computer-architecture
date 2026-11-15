module PC(
    input clk, reset,
    input [31:0] PC_next,
    output reg [31:0] PC_out
);

always @(posedge clk) begin //actualiza en cada flanco de subida del reloj (secuencial)
    if (reset) PC_out <= 32'd0;
    else       PC_out <= PC_next;
end

endmodule