# ppm2png.py - Convierte frame_sim.ppm (P3) a PNG.  Uso: python tools/ppm2png.py frame_sim.ppm
import sys
from PIL import Image
t = open(sys.argv[1]).read().split()
w, h, mx = int(t[1]), int(t[2]), int(t[3])
px = [int(x) * 255 // mx for x in t[4:4 + w * h * 3]]
img = Image.new("RGB", (w, h))
img.putdata([tuple(px[i:i + 3]) for i in range(0, len(px), 3)])
out = sys.argv[1].rsplit(".", 1)[0] + ".png"
img.save(out)
print("guardado", out)
