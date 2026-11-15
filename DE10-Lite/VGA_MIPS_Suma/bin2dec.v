// bin2dec.v - Convierte un numero binario de 16 bits a 5 digitos decimales (BCD)
// Algoritmo "double dabble" (shift-and-add-3): por cada bit, si algun digito
// vale 5 o mas se le suma 3, y luego todo se recorre 1 bit a la izquierda.
// Ejemplo: 16'd8 -> bcd = 20'h00008   |   16'd1234 -> bcd = 20'h01234
module bin2dec (
    input      [15:0] bin,
    output reg [19:0] bcd   // {decenas de millar, millares, centenas, decenas, unidades}
);
    integer i;
    always @(*) begin
        bcd = 20'd0;
        for (i = 15; i >= 0; i = i - 1) begin
            if (bcd[3:0]   >= 4'd5) bcd[3:0]   = bcd[3:0]   + 4'd3;
            if (bcd[7:4]   >= 4'd5) bcd[7:4]   = bcd[7:4]   + 4'd3;
            if (bcd[11:8]  >= 4'd5) bcd[11:8]  = bcd[11:8]  + 4'd3;
            if (bcd[15:12] >= 4'd5) bcd[15:12] = bcd[15:12] + 4'd3;
            if (bcd[19:16] >= 4'd5) bcd[19:16] = bcd[19:16] + 4'd3;
            bcd = {bcd[18:0], bin[i]};
        end
    end
endmodule
