# sim.do - Simula vga_frame y guarda lo que veria el monitor en frame_sim.ppm
# Uso en ModelSim (estando en esta carpeta):  do sim.do
# Tarda un poco: simula 1 cuadro completo (~16 ms de tiempo simulado).

vlib work
vlog vga_sync.v framebuffer.v vga_frame.v vga_frame_tb.v
vsim -voptargs=+acc work.vga_frame_tb

add wave /vga_frame_tb/hs
add wave /vga_frame_tb/vs
add wave -radix unsigned /vga_frame_tb/dut/h
add wave -radix unsigned /vga_frame_tb/dut/v
add wave -radix unsigned /vga_frame_tb/dut/addr
add wave -radix hex /vga_frame_tb/dut/index
add wave -radix hex /vga_frame_tb/dut/color

run -all
