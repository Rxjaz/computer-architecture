// vga_mips_suma_tb.v - Simula el sistema y guarda lo que veria el monitor
// en frame_sim.ppm (se abre con GIMP, o con tools/ppm2png.py).
// Usa un reloj de CPU rapido (CPU_DIV_BIT = 2) para no esperar millones de ciclos.
`timescale 1ns/1ns
module vga_mips_suma_tb;
    reg        clk = 1'b0;
    reg  [1:0] key = 2'b11;          // botones sueltos
    reg  [9:0] sw  = {5'd20, 5'd17}; // 20 + 17 = 37
    wire [9:0] ledr;
    wire [3:0] r, g, b;
    wire       hs, vs;

    vga_mips_suma #(.CPU_DIV_BIT(2)) dut (
        .MAX10_CLK1_50(clk), .KEY(key), .SW(sw), .LEDR(ledr),
        .VGA_R(r), .VGA_G(g), .VGA_B(b), .VGA_HS(hs), .VGA_VS(vs)
    );

    always #10 clk = ~clk;   // 50 MHz

    integer f, n;
    reg cap = 1'b0, grabando = 1'b0;

    initial begin
        // 1) Presionar KEY0 un rato: carga SW en $t1, $t2 y pone PC = 0
        #100  key[0] = 1'b0;
        #2000 key[0] = 1'b1;
        // 2) Dejar correr unas instrucciones
        #2000;
        $display("t1=%0d t2=%0d t0=%0d  LEDR=%b", dut.t1, dut.t2, dut.t0, ledr);
        // 3) Esperar el inicio de un cuadro y grabarlo
        wait (dut.h == 0 && dut.v == 0);
        f = $fopen("frame_sim.ppm", "w");
        $fwrite(f, "P3\n640 480\n15\n");
        n = 0;
        grabando = 1'b1;
        wait (n == 640*480);
        $fclose(f);
        $display("Listo: frame_sim.ppm  (t0 = %0d)", dut.t0);
        $stop;
    end

    // Ver comentarios: el color sale 1 ciclo despues de calcularse
    always @(posedge clk) begin
        if (grabando && cap) begin
            $fwrite(f, "%0d %0d %0d\n", r, g, b);
            n = n + 1;
        end
        cap <= dut.pix_en && dut.visible;
    end
endmodule
