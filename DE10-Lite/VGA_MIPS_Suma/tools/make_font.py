# make_font.py - Genera font_rom.v (letras de 8x8) a partir de dibujos ASCII.
# Uso:  python tools/make_font.py   (desde la carpeta del proyecto)
# Cada letra es una matriz de 8x8: 'X' = pixel encendido, '.' = apagado.
G = {}
G['0'] = """
.XXXXX..
XX...XX.
XX..XXX.
XX.XXXX.
XXXX.XX.
XXX..XX.
.XXXXX..
........"""
G['1'] = """
...XX...
..XXX...
.XXXX...
...XX...
...XX...
...XX...
.XXXXXX.
........"""
G['2'] = """
.XXXXX..
XX...XX.
.....XX.
...XXX..
.XXX....
XX......
XXXXXXX.
........"""
G['3'] = """
.XXXXX..
XX...XX.
.....XX.
..XXXX..
.....XX.
XX...XX.
.XXXXX..
........"""
G['4'] = """
....XXX.
...XXXX.
..XX.XX.
.XX..XX.
XXXXXXX.
.....XX.
.....XX.
........"""
G['5'] = """
XXXXXXX.
XX......
XXXXXX..
.....XX.
.....XX.
XX...XX.
.XXXXX..
........"""
G['6'] = """
..XXXX..
.XX.....
XX......
XXXXXX..
XX...XX.
XX...XX.
.XXXXX..
........"""
G['7'] = """
XXXXXXX.
.....XX.
....XX..
...XX...
..XX....
..XX....
..XX....
........"""
G['8'] = """
.XXXXX..
XX...XX.
XX...XX.
.XXXXX..
XX...XX.
XX...XX.
.XXXXX..
........"""
G['9'] = """
.XXXXX..
XX...XX.
XX...XX.
.XXXXXX.
.....XX.
....XX..
.XXXX...
........"""
G['A'] = """
..XXX...
.XX.XX..
XX...XX.
XX...XX.
XXXXXXX.
XX...XX.
XX...XX.
........"""
G['B'] = """
XXXXXX..
XX...XX.
XX...XX.
XXXXXX..
XX...XX.
XX...XX.
XXXXXX..
........"""
G['C'] = """
.XXXXX..
XX...XX.
XX......
XX......
XX......
XX...XX.
.XXXXX..
........"""
G['D'] = """
XXXXX...
XX..XX..
XX...XX.
XX...XX.
XX...XX.
XX..XX..
XXXXX...
........"""
G['E'] = """
XXXXXXX.
XX......
XX......
XXXXXX..
XX......
XX......
XXXXXXX.
........"""
G['F'] = """
XXXXXXX.
XX......
XX......
XXXXXX..
XX......
XX......
XX......
........"""
G['I'] = """
.XXXXXX.
...XX...
...XX...
...XX...
...XX...
...XX...
.XXXXXX.
........"""
G['M'] = """
XX...XX.
XXX.XXX.
XXXXXXX.
XX.X.XX.
XX...XX.
XX...XX.
XX...XX.
........"""
G['P'] = """
XXXXXX..
XX...XX.
XX...XX.
XXXXXX..
XX......
XX......
XX......
........"""
G['R'] = """
XXXXXX..
XX...XX.
XX...XX.
XXXXXX..
XX.XX...
XX..XX..
XX...XX.
........"""
G['S'] = """
.XXXXX..
XX...XX.
XX......
.XXXXX..
.....XX.
XX...XX.
.XXXXX..
........"""
G['T'] = """
XXXXXXX.
...XX...
...XX...
...XX...
...XX...
...XX...
...XX...
........"""
G['U'] = """
XX...XX.
XX...XX.
XX...XX.
XX...XX.
XX...XX.
XX...XX.
.XXXXX..
........"""
G['X'] = """
XX...XX.
.XX.XX..
..XXX...
..XXX...
..XXX...
.XX.XX..
XX...XX.
........"""
G['$'] = """
...X....
.XXXXXX.
XX.X....
.XXXXX..
...X.XX.
XXXXXX..
...X....
........"""
G['='] = """
........
........
XXXXXXX.
........
XXXXXXX.
........
........
........"""
G['+'] = """
........
...XX...
...XX...
XXXXXXX.
...XX...
...XX...
........
........"""
G['-'] = """
........
........
........
XXXXXXX.
........
........
........
........"""
G[','] = """
........
........
........
........
........
...XX...
...XX...
..XX...."""

out = []
out.append("// font_rom.v - Letras de 8x8 pixeles (GENERADO por tools/make_font.py)")
out.append("// Entrada: codigo ASCII de la letra y fila (0..7). Salida: 8 bits de esa fila.")
out.append("// El bit 7 es el pixel de la IZQUIERDA. Letras no definidas salen en blanco.")
out.append("module font_rom (")
out.append("    input      [7:0] ascii,")
out.append("    input      [2:0] row,")
out.append("    output reg [7:0] bits")
out.append(");")
out.append("    always @(*) begin")
out.append("        case ({ascii, row})")
for ch in sorted(G):
    rows = [r for r in G[ch].strip('\n').split('\n')]
    assert len(rows) == 8 and all(len(r) == 8 for r in rows), ch
    for i, r in enumerate(rows):
        val = int(r.replace('X', '1').replace('.', '0'), 2)
        if val:
            out.append("            {8'h%02X, 3'd%d}: bits = 8'b%s; // '%s'" % (ord(ch), i, format(val, '08b'), ch))
out.append("            default: bits = 8'b00000000;")
out.append("        endcase")
out.append("    end")
out.append("endmodule")
open('font_rom.v', 'w').write('\n'.join(out) + '\n')
print("font_rom.v generado con", len(G), "letras")
