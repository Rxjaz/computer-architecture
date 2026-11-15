catch {quit -sim}
vlib work
vlog *.v
vsim work.SC_MIPS_TB

# Senales principales
add wave sim:/SC_MIPS_TB/clk
add wave sim:/SC_MIPS_TB/reset
add wave -radix unsigned sim:/SC_MIPS_TB/dut/PC_out
add wave -radix hex sim:/SC_MIPS_TB/dut/Instruction
add wave sim:/SC_MIPS_TB/dut/RegWrite
add wave -radix decimal sim:/SC_MIPS_TB/dut/ALUResult

# Registros que escribe el programa
add wave -radix decimal {sim:/SC_MIPS_TB/dut/rf/registers[8]}
add wave -radix decimal {sim:/SC_MIPS_TB/dut/rf/registers[11]}
add wave -radix decimal {sim:/SC_MIPS_TB/dut/rf/registers[12]}
add wave -radix decimal {sim:/SC_MIPS_TB/dut/rf/registers[13]}
add wave -radix decimal {sim:/SC_MIPS_TB/dut/rf/registers[14]}

run -all
wave zoom full
