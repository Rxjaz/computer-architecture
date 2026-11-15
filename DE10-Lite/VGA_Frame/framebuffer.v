// framebuffer.v - La "pantalla en memoria"
//
// Doom dibuja cada cuadro en un framebuffer de 320x200 pixeles donde cada
// pixel es un byte: un INDICE (0..255) a una paleta de 256 colores.
// Aqui hacemos exactamente eso, con dos memorias:
//
//   fb  : 64000 bytes (320*200)  -> que indice de color tiene cada pixel
//   pal : 256 colores de 12 bits -> que color real es cada indice
//
// Por ahora las dos son ROM (solo lectura) y se llenan al compilar con
// frame.hex y palette.hex. Mas adelante, el MIPS sera quien ESCRIBA en fb.
module framebuffer (
    input             clk,
    input      [15:0] addr,      // 0..63999  (y*320 + x)
    output reg [7:0]  index,     // sale 1 ciclo despues de poner addr
    output reg [11:0] color      // sale 1 ciclo despues de index
);
    reg [7:0]  fb  [0:63999];
    reg [11:0] pal [0:255];

    initial begin
        $readmemh("frame.hex",   fb);
        $readmemh("palette.hex", pal);
    end

    // Lectura sincrona (con reloj): asi Quartus usa los bloques de memoria
    // M9K del FPGA en vez de gastar miles de registros.
    always @(posedge clk) begin
        index <= fb[addr];
        color <= pal[index];
    end
endmodule
