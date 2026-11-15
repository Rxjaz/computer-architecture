// vga_frame.v - Muestra en el monitor una imagen guardada en memoria
//
// La imagen mide 320x200 (como Doom). Cada pixel se dibuja como un cuadro
// de 2x2 en el monitor -> 640x400, y sobran 40 lineas negras arriba y abajo.
//
//   vga_sync  --(h, v)-->  calculo de direccion  --addr-->  framebuffer --color--> VGA
//
module vga_frame (
    input        MAX10_CLK1_50,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output       VGA_HS,
    output       VGA_VS
);
    wire clk = MAX10_CLK1_50;

    // ---------------- 1) Tiempos VGA ----------------
    wire       pix_en, hsync, vsync, visible;
    wire [9:0] h, v;
    vga_sync sync (
        .clk(clk), .pix_en(pix_en), .h(h), .v(v),
        .hsync(hsync), .vsync(vsync), .visible(visible)
    );

    // ---------------- 2) De pixel del monitor a pixel de la imagen ----------
    // Zona de la imagen en el monitor: filas 40..439 (400 lineas)
    wire       in_img = visible && (v >= 10'd40) && (v < 10'd440);
    wire [9:0] vy     = v - 10'd40;
    wire [8:0] px     = h[9:1];        // h / 2  -> 0..319
    wire [7:0] py     = vy[8:1];       // vy / 2 -> 0..199

    // addr = py * 320 + px   (320 = 256 + 64, asi que se hace con corrimientos)
    wire [15:0] addr = ({8'd0, py} << 8) + ({8'd0, py} << 6) + {7'd0, px};

    // ---------------- 3) Leer la memoria ----------------
    wire [7:0]  index;
    wire [11:0] color;
    framebuffer fbuf (.clk(clk), .addr(addr), .index(index), .color(color));

    // ---------------- 4) Pipeline ----------------
    // La memoria tarda 2 ciclos en entregar el color. Las demas senales
    // (sync, zona de imagen, pix_en) se retrasan 2 ciclos tambien para
    // que lleguen al monitor JUNTO con su color.
    reg [1:0] hs_d = 2'b11, vs_d = 2'b11, img_d = 2'b00, vis_d = 2'b00, pe_d = 2'b00;  // pe_d solo lo usa el testbench
    always @(posedge clk) begin
        hs_d  <= {hs_d[0],  hsync};
        vs_d  <= {vs_d[0],  vsync};
        img_d <= {img_d[0], in_img};
        vis_d <= {vis_d[0], visible};
        pe_d  <= {pe_d[0],  pix_en};
    end

    // ---------------- 5) Salida ----------------
    assign VGA_HS = hs_d[1];
    assign VGA_VS = vs_d[1];
    assign VGA_R  = img_d[1] ? color[11:8] : 4'h0;
    assign VGA_G  = img_d[1] ? color[7:4]  : 4'h0;
    assign VGA_B  = img_d[1] ? color[3:0]  : 4'h0;
endmodule
