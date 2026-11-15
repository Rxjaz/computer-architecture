# Reloj de la tarjeta: 50 MHz
create_clock -name CLK50 -period 20.000 [get_ports MAX10_CLK1_50]

# Reloj lento del MIPS: sale del bit 23 del contador (50 MHz / 2^24 ~ 3 Hz)
create_generated_clock -name CPU_CLK -source [get_ports MAX10_CLK1_50] -divide_by 16777216 [get_registers {cpu_div[23]}]

# El VGA solo "mira" los registros del MIPS; no hace falta que los dos relojes
# esten sincronizados, asi que se le dice a Quartus que no los compare.
set_clock_groups -asynchronous -group {CLK50} -group {CPU_CLK}

derive_clock_uncertainty
