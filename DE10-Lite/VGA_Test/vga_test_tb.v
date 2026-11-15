`timescale 1ns/1ps
module vga_test_tb;
    reg clk = 0;
    always #10 clk = ~clk;  // 50 MHz
    wire [3:0] r, g, b;
    wire hs, vs;
    vga_test dut(.MAX10_CLK1_50(clk), .VGA_R(r), .VGA_G(g), .VGA_B(b), .VGA_HS(hs), .VGA_VS(vs));

    integer hs_count = 0;
    always @(negedge hs) hs_count = hs_count + 1;
    initial begin
        // Un cuadro completo: 800*525 pixeles * 40 ns = 16.8 ms
        #16800000;
        $display("Lineas (pulsos HS) en un cuadro: %0d (esperado 525)", hs_count);
        $stop;
    end
endmodule
