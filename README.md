# Computer Architecture — Verilog Activities

> **Work in progress:** the course is still ongoing.

Class activities for the **Computer Architecture** course at CUCEI. Each activity designs and tests a digital component in **Verilog**, starting from basic logic and building up to MIPS processor blocks.

## Structure

```
.
├── Activities/   # Class activities, one folder per assignment
├── DE10-Lite/    # Tests and experiments on the DE10-Lite FPGA board
└── Reports/      # PDF reports for the activities
```

- **`Activities/`**: each folder is an independent activity with its Verilog modules, testbenches and simulation files.
- **`DE10-Lite/`**: designs synthesized and tested on the Terasic DE10-Lite (MAX 10) board, such as VGA output.
- **`Reports/`**: reports with the design explanation and simulation results.

## Tools

- **Language:** Verilog HDL
- **Simulation:** ModelSim
- **Synthesis:** Intel Quartus Prime (DE10-Lite)

## Running a simulation

Most activities load memory files with `$readmemb`/`$readmemh` using relative paths, so run the simulation from inside the activity's folder (several include a `sim.do` script for ModelSim).

## Author

[@Rxjaz](https://github.com/Rxjaz) — Student at CUCEI, Universidad de Guadalajara.

---

*Academic project.*
