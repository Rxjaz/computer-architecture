# sim.do - Simula vga_mips_suma y guarda lo que veria el monitor en frame_sim.ppm
# Uso en ModelSim (estando en esta carpeta):  do sim.do
# Pone SW = 20 y 17, presiona KEY0, corre el MIPS y graba 1 cuadro (~32 ms simulados).

vlib work
vlog vga_mips_suma.v vga_sync.v font_rom.v bin2dec.v SC_MIPS.v PC.v Adder.v InstructionMemory.v ControlUnit.v RegisterFile.v ALUControl.v ALU.v vga_mips_suma_tb.v
vsim -voptargs=+acc work.vga_mips_suma_tb

add wave /vga_mips_suma_tb/dut/cpu_clk
add wave /vga_mips_suma_tb/dut/cpu_reset
add wave -radix hex      /vga_mips_suma_tb/dut/pc
add wave -radix hex      /vga_mips_suma_tb/dut/inst
add wave -radix unsigned /vga_mips_suma_tb/dut/t1
add wave -radix unsigned /vga_mips_suma_tb/dut/t2
add wave -radix unsigned /vga_mips_suma_tb/dut/t0
add wave /vga_mips_suma_tb/hs
add wave /vga_mips_suma_tb/vs

run -all
