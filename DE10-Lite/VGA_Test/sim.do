# sim.do - Simula vga_test sin necesidad de un proyecto (.mpf)
# Uso en ModelSim:  do sim.do

# 1) Crear la libreria "work" (donde se guardan los modulos compilados)
vlib work

# 2) Compilar los modulos
vlog vga_test.v vga_test_tb.v

# 3) Cargar el testbench (+acc permite ver las senales internas)
vsim -voptargs=+acc work.vga_test_tb

# 4) Agregar senales a la ventana Wave
add wave -radix unsigned /vga_test_tb/dut/h
add wave -radix unsigned /vga_test_tb/dut/v
add wave /vga_test_tb/hs
add wave /vga_test_tb/vs
add wave -radix hex /vga_test_tb/r
add wave -radix hex /vga_test_tb/g
add wave -radix hex /vga_test_tb/b

# 5) Correr hasta que el testbench llegue a $stop
run -all
wave zoom full
