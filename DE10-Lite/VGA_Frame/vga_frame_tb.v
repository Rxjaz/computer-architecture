`timescale 1ns/1ps
// vga_frame_tb.v - Simula un cuadro completo y GUARDA LO QUE VERIA EL MONITOR
// en frame_sim.ppm (640x480). Asi puedes revisar tu imagen sin la tarjeta.
module vga_frame_tb;
    reg clk = 0;
    always #10 clk = ~clk;   // 50 MHz

    wire [3:0] r, g, b;
    wire hs, vs;
    vga_frame dut (.MAX10_CLK1_50(clk), .VGA_R(r), .VGA_G(g), .VGA_B(b),
                   .VGA_HS(hs), .VGA_VS(vs));

    integer f, n = 0;
    initial begin
        f = $fopen("frame_sim.ppm", "w");
        $fwrite(f, "P3\n640 480\n15\n");   // formato PPM de texto, 4 bits por color
    end

    // Un pixel por cada pulso de pix_en (ya retrasado igual que el color)
    always @(posedge clk) begin
        if (dut.pe_d[1] && dut.vis_d[1] && n < 640*480) begin
            $fwrite(f, "%0d %0d %0d\n", r, g, b);
            n = n + 1;
            if (n == 640*480) begin
                $fclose(f);
                $display("Listo: frame_sim.ppm (640x480) guardado");
                $stop;
            end
        end
    end
endmodule
