// vga_sync.v - Generador de tiempos VGA 640x480 @ 60 Hz
// Es lo mismo que ya funciono en VGA_Test, pero separado en su propio modulo
// para poder reutilizarlo.
module vga_sync (
    input            clk,       // 50 MHz
    output reg       pix_en,    // 1 cada 2 ciclos -> 25 MHz (un pixel)
    output reg [9:0] h,         // columna actual (0..799)
    output reg [9:0] v,         // fila actual    (0..524)
    output           hsync,
    output           vsync,
    output           visible    // 1 dentro del area de 640x480
);
    initial begin
        pix_en = 1'b0;
        h = 10'd0;
        v = 10'd0;
    end

    always @(posedge clk)
        pix_en <= ~pix_en;

    always @(posedge clk) begin
        if (pix_en) begin
            if (h == 10'd799) begin
                h <= 10'd0;
                v <= (v == 10'd524) ? 10'd0 : v + 10'd1;
            end else
                h <= h + 10'd1;
        end
    end

    assign hsync   = ~((h >= 10'd656) && (h < 10'd752));
    assign vsync   = ~((v >= 10'd490) && (v < 10'd492));
    assign visible = (h < 10'd640) && (v < 10'd480);
endmodule
