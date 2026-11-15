// vga_mips_suma.v - El MIPS single cycle hace una suma y el resultado se ve en VGA
//
//   SW[9:5] --> $t1 --+
//                     +--> SC_MIPS (add $t0,$t1,$t2) --> $t0 --> texto --> monitor
//   SW[4:0] --> $t2 --+
//
// Como se usa:
//   1) Pon el primer numero en SW9..SW5 y el segundo en SW4..SW0 (en binario).
//   2) Manten presionado KEY0 ~1 segundo: se cargan en $t1 y $t2 y el PC vuelve a 0.
//   3) Suelta KEY0: el procesador ejecuta el programa de "imdata" y en el monitor
//      aparece $t0 = $t1 + $t2. Los LEDs muestran $t0 en binario.
//   Al encender (sin presionar nada) los registros traen lo de "rfdata": 5 + 3.
//
// Pantalla: 640x480 dividida en celdas de 32x32 -> 20 columnas x 15 renglones.
// Cada letra es de 8x8 y se dibuja 4 veces mas grande (cada pixel = cuadro de 4x4).
module vga_mips_suma #(
    parameter CPU_DIV_BIT = 23   // reloj del CPU = 50 MHz / 2^(23+1) ~ 3 Hz
) (
    input        MAX10_CLK1_50,
    input  [1:0] KEY,            // botones, activos en bajo (presionado = 0)
    input  [9:0] SW,
    output [9:0] LEDR,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output       VGA_HS,
    output       VGA_VS
);
    wire clk = MAX10_CLK1_50;

    // ================= 1) Reloj lento para el procesador =================
    // Un contador que cuenta a 50 MHz; uno de sus bits cambia ~3 veces por
    // segundo y ese bit es el reloj del MIPS. Asi se alcanza a ver el PC avanzar.
    reg [23:0] cpu_div = 24'd0;
    always @(posedge clk)
        cpu_div <= cpu_div + 24'd1;
    wire cpu_clk = cpu_div[CPU_DIV_BIT];

    // Boton de reset: se pasa por 2 flip-flops para que sea una senal limpia
    reg [1:0] rst_sync = 2'b00;
    always @(posedge clk)
        rst_sync <= {rst_sync[0], ~KEY[0]};
    wire cpu_reset = rst_sync[1];

    // ================= 2) El procesador =================
    wire [31:0] pc, inst, t0, t1, t2;
    SC_MIPS cpu (
        .clk(cpu_clk),
        .reset(cpu_reset),
        .in_t1({27'd0, SW[9:5]}),   // primer operando  (0..31)
        .in_t2({27'd0, SW[4:0]}),   // segundo operando (0..31)
        .dbg_pc(pc), .dbg_inst(inst),
        .dbg_t0(t0), .dbg_t1(t1), .dbg_t2(t2)
    );

    assign LEDR = t0[9:0];

    // ================= 3) Numeros -> digitos decimales =================
    wire [19:0] bcd0, bcd1, bcd2;
    bin2dec d0 (.bin(t0[15:0]), .bcd(bcd0));
    bin2dec d1 (.bin(t1[15:0]), .bcd(bcd1));
    bin2dec d2 (.bin(t2[15:0]), .bcd(bcd2));

    // Un digito (0..15) a su codigo ASCII: '0'..'9' y 'A'..'F'
    function [7:0] hexchar(input [3:0] d);
        hexchar = (d < 4'd10) ? (8'h30 + d) : (8'h37 + d);
    endfunction

    // 5 digitos BCD a texto, quitando los ceros a la izquierda ("00008" -> "    8")
    function [39:0] dec5(input [19:0] b);
        reg blank;
        integer k;
        begin
            blank = 1'b1;
            for (k = 4; k >= 0; k = k - 1) begin
                if (b[4*k +: 4] != 4'd0 || k == 0) blank = 1'b0;
                dec5[8*k +: 8] = blank ? " " : hexchar(b[4*k +: 4]);
            end
        end
    endfunction

    // ================= 4) Tiempos VGA =================
    wire       pix_en, hsync, vsync, visible;
    wire [9:0] h, v;
    vga_sync sync (
        .clk(clk), .pix_en(pix_en), .h(h), .v(v),
        .hsync(hsync), .vsync(vsync), .visible(visible)
    );

    wire [4:0] col  = h[9:5];   // celda: columna 0..19
    wire [4:0] fila = v[9:5];   // celda: renglon 0..14
    wire [2:0] gx   = h[4:2];   // pixel dentro de la letra (0..7)
    wire [2:0] gy   = v[4:2];

    // ================= 5) Que texto va en cada renglon =================
    // Cada renglon es un string de 20 letras exactas.
    reg [159:0] linea;
    always @(*) begin
        case (fila)
            5'd1:  linea = "  SC MIPS  -  SUMA  ";
            5'd3:  linea = {"    $T1 = ", dec5(bcd1), "     "};
            5'd4:  linea = {"  + $T2 = ", dec5(bcd2), "     "};
            5'd5:  linea = "    -------------   ";
            5'd6:  linea = {"    $T0 = ", dec5(bcd0), "     "};
            5'd8:  linea = "  ADD $T0,$T1,$T2   ";
            5'd11: linea = {"  PC = ", hexchar(pc[15:12]), hexchar(pc[11:8]),
                            hexchar(pc[7:4]), hexchar(pc[3:0]), "         "};
            5'd12: linea = {"  IR = ", hexchar(inst[31:28]), hexchar(inst[27:24]),
                            hexchar(inst[23:20]), hexchar(inst[19:16]),
                            hexchar(inst[15:12]), hexchar(inst[11:8]),
                            hexchar(inst[7:4]),   hexchar(inst[3:0]), "     "};
            default: linea = "                    ";
        endcase
    end

    // La letra de la columna "col" (la columna 0 esta en los bits mas altos)
    wire [7:0] letra = linea[8*(19 - col) +: 8];

    // ================= 6) Dibujo de la letra =================
    wire [7:0] bits;
    font_rom font (.ascii(letra), .row(gy), .bits(bits));
    wire pixel_on = bits[3'd7 - gx];

    // Color de cada renglon {R,G,B}
    reg [11:0] color_texto;
    always @(*) begin
        case (fila)
            5'd1:           color_texto = 12'hFF0;  // amarillo
            5'd6:           color_texto = 12'h0F0;  // verde (resultado)
            5'd8:           color_texto = 12'hF80;  // naranja
            5'd11, 5'd12:   color_texto = 12'h0FF;  // cian
            default:        color_texto = 12'hFFF;  // blanco
        endcase
    end
    wire [11:0] fondo = 12'h114;                   // azul oscuro

    // ================= 7) Salida (registrada, 1 ciclo de retraso) =================
    // Se retrasan tambien hsync y vsync para que lleguen junto con el color.
    reg [11:0] rgb_q = 12'h000;
    reg        hs_q  = 1'b1, vs_q = 1'b1;
    always @(posedge clk) begin
        hs_q  <= hsync;
        vs_q  <= vsync;
        rgb_q <= !visible ? 12'h000 : (pixel_on ? color_texto : fondo);
    end

    assign VGA_HS = hs_q;
    assign VGA_VS = vs_q;
    assign VGA_R  = rgb_q[11:8];
    assign VGA_G  = rgb_q[7:4];
    assign VGA_B  = rgb_q[3:0];
endmodule
