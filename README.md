# Computer Architecture — MIPS Processor in Verilog

> **Work in progress.**

School project for the **Computer Architecture** course (CUCEI). The final goal is to design and implement a **complete MIPS processor** in **Verilog**. The project is built in stages: it starts with basic digital components that are gradually integrated into the datapath and the control unit.

## Goal

Implement a 32-bit MIPS processor capable of running a subset of the MIPS ISA (R, I and J-type instructions).

## Structure

The repository is split into two parts:

- **`Activities/`**: class assignments. Each folder is an independent activity where a single component is designed and tested on its own.
- **`MIPS_Project/`**: the final project. This is where the components from the activities will be integrated into the complete MIPS processor.

```
.
├── Activities/           # Class activities
│   ├── 01_Logic_Gates/   # Basic logic gates
│   ├── 02_16_Bits_FA/    # Adders: HA, FA, 4-bit and 16-bit
│   ├── 03_MUX6_1/        # 6:1 multiplexer with operations
│   ├── 04_ALU/           # 32-bit MIPS ALU
│   └── 05_Datapath/      # ROM, ALU and register file connected
├── MIPS_Project/         # Final project: MIPS processor
└── Reports/              # PDF reports for each activity
```

## Testbenches

Each testbench, with the activity it belongs to and the module it tests:

| Activity | Testbench | Module | What it checks |
|----------|-----------|--------|----------------|
| 02 | `Mario_TB.v` | `FA` (`FA.v`) | 1-bit Full Adder with several combinations of `X`, `Y` and `C_in`. |
| 02 | `Raul_TB.v` | `S4B` (`4BFA.v`) | 4-bit adder with several sums (3+5, 6+1, 2+2, 3+3, 5+6). |
| 02 | `Victor_TB.v` | `S16B` (`16BFA.v`) | 16-bit adder with negative values and overflow cases (`32767 + 1`, `65535 + 1`). |
| 03 | `Mux6_1_TB.v` | `Mux6_1` (`Mux6_1.v`) | All 6 `Sel` values with random inputs (`$random`) over 5 iterations. |
| 04 | `MIPSALU_TB.v` | `MIPSALU` (`MIPSALU.v`) | Every ALU operation with three operand pairs, including `0xFFFFFFFF + 1`, to check the `ZF` flag. |

## Tools

- **Language:** Verilog HDL
- **Simulation:** ModelSim

## Reports

The [`Reports/`](Reports/) folder contains the report for each activity, with the design explanation and simulation results.

## Author

[@Rxjaz](https://github.com/Rxjaz) — Student at CUCEI, Universidad de Guadalajara.

---

*Academic project.*