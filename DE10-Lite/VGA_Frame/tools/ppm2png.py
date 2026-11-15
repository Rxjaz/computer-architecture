"""
ppm2png.py - Convierte frame_sim.ppm (lo que genera el testbench) a PNG.

Uso:  python tools/ppm2png.py            (lee frame_sim.ppm, crea frame_sim.png)
Requiere: pip install pillow numpy
"""
import sys
import numpy as np
from PIL import Image

src = sys.argv[1] if len(sys.argv) > 1 else "frame_sim.ppm"
tok = open(src).read().split()
w, h, maxv = int(tok[1]), int(tok[2]), int(tok[3])
px = np.array(tok[4:4 + w * h * 3], dtype=np.float32).reshape(h, w, 3)
Image.fromarray((px * 255 / maxv).astype(np.uint8)).save(src.rsplit(".", 1)[0] + ".png")
print("Guardado:", src.rsplit(".", 1)[0] + ".png")
