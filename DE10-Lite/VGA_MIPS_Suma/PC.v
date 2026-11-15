module PC(
    input clk, reset,
    input [31:0] PC_next,
    output reg [31:0] PC_out
);

// NUEVO: valor al encender la FPGA (sin esto el PC empieza indefinido en simulacion)
initial PC_out = 32'd0;

always @(posedge clk) begin //actualiza en cada flanco de subida del reloj (secuencial)
    if (reset) PC_out <= 32'd0;
    else       PC_out <= PC_next;
end

endmodule