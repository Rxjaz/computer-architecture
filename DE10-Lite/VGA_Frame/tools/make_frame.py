"""
make_frame.py - Genera los archivos de memoria para VGA_Frame.

Crea una imagen de 320x200 (la resolucion original de Doom) con colores
indexados: cada pixel guarda un numero de 0 a 255 que apunta a una paleta
de 256 colores, igual que hace Doom.

Salida (en la carpeta del proyecto):
  frame.hex    -> 64000 lineas, un byte por pixel (indice de color)
  palette.hex  -> 256 lineas, un color de 12 bits (RRRRGGGGBBBB) por linea
  preview.png  -> como deberia verse en el monitor

Uso:
  python make_frame.py                 # genera el pasillo de ejemplo
  python make_frame.py mi_imagen.png   # convierte cualquier imagen

Requiere: pip install pillow numpy
"""
import sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw

W, H = 320, 200          # resolucion del framebuffer (como Doom)
VIEW_H = 168             # alto de la vista 3D; abajo va la barra de estado
OUT = Path(__file__).resolve().parent.parent


def corridor():
    """Pasillo en perspectiva, calculado pixel por pixel (idea de un raycaster)."""
    f, cx, cy = 160.0, W / 2, VIEW_H / 2
    FLOOR, CEIL, ZMAX = 0.6, 0.9, 10.0      # distancias en "metros"
    x = (np.arange(W) + 0.5 - cx) / f
    y = (np.arange(VIEW_H) + 0.5 - cy) / f
    dx, dy = np.meshgrid(x, y)

    with np.errstate(divide="ignore"):
        z_wall = np.where(dx != 0, 1.0 / np.abs(dx), np.inf)
        z_flat = np.where(dy > 0, FLOOR / dy, np.where(dy < 0, CEIL / -dy, np.inf))
    z = np.minimum(np.minimum(z_wall, z_flat), ZMAX)
    img = np.zeros((VIEW_H, W, 3))

    def bricks(u, v, base):
        row = np.floor(v / 0.22)
        uu = u / 0.5 + 0.5 * (row % 2)
        mortar = ((uu % 1) < 0.07) | (((v / 0.22) % 1) < 0.12)
        return np.where(mortar[..., None], [70, 62, 55], base)

    wall = (z == z_wall) & (z < ZMAX)
    floor = (z == z_flat) & (dy > 0) & (z < ZMAX) & ~wall
    ceil = (z == z_flat) & (dy < 0) & (z < ZMAX) & ~wall
    back = z >= ZMAX

    # Paredes laterales: ladrillo
    tex = bricks(z, dy * z, [150, 95, 60])
    img[wall] = tex[wall]
    # Piso: mosaico de cuadros
    fx, fz = dx * z, z
    checker = ((np.floor(fx / 0.5) + np.floor(fz / 0.5)) % 2)[..., None]
    img[floor] = np.where(checker, [105, 105, 95], [75, 75, 70])[floor]
    # Techo: oscuro con lamparas cada 2 m
    lamp = ((z % 2.0) < 0.35) & (np.abs(dx * z) < 0.3)
    img[ceil] = np.where(lamp[..., None], [255, 240, 180], [45, 45, 55])[ceil]
    # Pared del fondo con una puerta
    bx, by = dx * ZMAX, dy * ZMAX
    door = (np.abs(bx) < 0.35) & (by > -0.45)
    stripes = ((by * 10) % 1 < 0.5)[..., None]
    back_col = np.where(door[..., None], np.where(stripes, [60, 120, 70], [40, 90, 50]),
                        bricks(bx + 5, by, [150, 95, 60]))
    img[back] = back_col[back]

    # Sombreado por distancia (lo lejano se ve mas oscuro)
    light = np.clip(1.25 - z / 9.0, 0.22, 1.0)
    light = np.where(lamp & ceil, 1.0, light)
    img = img * light[..., None]

    frame = np.zeros((H, W, 3))
    frame[:VIEW_H] = img
    pic = Image.fromarray(np.clip(frame, 0, 255).astype(np.uint8))

    # Barra de estado (como la de Doom, pero propia)
    d = ImageDraw.Draw(pic)
    d.rectangle([0, VIEW_H, W - 1, H - 1], fill=(85, 85, 85))
    d.line([0, VIEW_H, W - 1, VIEW_H], fill=(160, 160, 160))
    for i, (label, val) in enumerate([("PC", "0040"), ("ALU", "ADD"), ("REG", "$t0")]):
        x0 = 8 + i * 104
        d.rectangle([x0, VIEW_H + 6, x0 + 96, H - 6], fill=(40, 40, 40), outline=(150, 150, 150))
        d.text((x0 + 6, VIEW_H + 11), f"{label}: {val}", fill=(230, 60, 40))
    return pic


def to_12bit(pic):
    """La DE10-Lite tiene 4 bits por color: redondear cada canal a 16 niveles."""
    a = np.asarray(pic.convert("RGB"), dtype=np.float32)
    a = np.round(a / 17.0) * 17.0
    return Image.fromarray(a.astype(np.uint8))


def main():
    if len(sys.argv) > 1:
        pic = Image.open(sys.argv[1]).convert("RGB").resize((W, H), Image.LANCZOS)
    else:
        pic = corridor()

    pic = to_12bit(pic)
    q = pic.quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    idx = np.asarray(q, dtype=np.uint8)
    pal = np.array(q.getpalette()[:768] + [0] * (768 - len(q.getpalette()[:768]))).reshape(256, 3)

    with open(OUT / "frame.hex", "w") as fh:
        fh.writelines(f"{v:02X}\n" for v in idx.flatten())
    with open(OUT / "palette.hex", "w") as fh:
        for r, g, b in pal:
            fh.write(f"{r >> 4:X}{g >> 4:X}{b >> 4:X}\n")

    used = len(np.unique(idx))
    preview = q.convert("RGB").resize((W * 2, H * 2), Image.NEAREST)
    preview.save(OUT / "preview.png")
    print(f"frame.hex ({W}x{H}), palette.hex ({used} colores usados de 256), preview.png")


if __name__ == "__main__":
    main()
