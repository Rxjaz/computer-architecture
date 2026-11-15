// vga_test.v - Primera prueba VGA para la DE10-Lite (640x480 @ 60 Hz)
// Muestra 8 barras de color verticales con un marco blanco alrededor.
module vga_test (
    input        MAX10_CLK1_50,   // reloj de 50 MHz de la tarjeta
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output       VGA_HS,
    output       VGA_VS
);
    // 1) Reloj de pixel: 50 MHz / 2 = 25 MHz (se usa como "enable")
    reg pix_en = 1'b0;
    always @(posedge MAX10_CLK1_50)
        pix_en <= ~pix_en;

    // 2) Contadores: h = columna (0..799), v = fila (0..524)
    reg [9:0] h = 10'd0;
    reg [9:0] v = 10'd0;
    always @(posedge MAX10_CLK1_50) begin
        if (pix_en) begin
            if (h == 10'd799) begin
                h <= 10'd0;
                v <= (v == 10'd524) ? 10'd0 : v + 10'd1;
            end else
                h <= h + 10'd1;
        end
    end

    // 3) Pulsos de sincronia (activos en bajo)
    assign VGA_HS = ~((h >= 10'd656) && (h < 10'd752));
    assign VGA_VS = ~((v >= 10'd490) && (v < 10'd492));

    // 4) Que color va en cada pixel visible
    wire visible = (h < 10'd640) && (v < 10'd480);
    wire border  = (h == 10'd0) || (h == 10'd639) || (v == 10'd0) || (v == 10'd479);

    reg [2:0] rgb;  // {rojo, verde, azul}
    always @(*) begin
        if      (h <  80) rgb = 3'b111; // blanco
        else if (h < 160) rgb = 3'b110; // amarillo
        else if (h < 240) rgb = 3'b011; // cian
        else if (h < 320) rgb = 3'b010; // verde
        else if (h < 400) rgb = 3'b101; // magenta
        else if (h < 480) rgb = 3'b100; // rojo
        else if (h < 560) rgb = 3'b001; // azul
        else              rgb = 3'b000; // negro
        if (border) rgb = 3'b111;
    end

    // Fuera del area visible hay que mandar negro
    assign VGA_R = (visible && rgb[2]) ? 4'hF : 4'h0;
    assign VGA_G = (visible && rgb[1]) ? 4'hF : 4'h0;
    assign VGA_B = (visible && rgb[0]) ? 4'hF : 4'h0;
endmodule
