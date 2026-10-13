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
│   └── 05_Datapath/      # RARO SUPREME: instruction ROM driving ROM, RAM and ALU
├── MIPS_Project/         # Final project: MIPS processor
└── Reports/              # PDF reports for each activity
```

## Activity 05 — RARO SUPREME Datapath

A small combinational datapath that connects a data **ROM**, a **RAM** and the **MIPS ALU**, driven by a 16-word **instruction ROM** (no clock or PC: a 4-bit `selector` picks the instruction).

Each instruction is 23 bits wide:

| Bits | Field | Description |
|------|-------|-------------|
| `[22:17]` | `DROM` | ROM address → ALU operand `A` |
| `[16:11]` | `DRAM` | RAM address → ALU operand `B` |
| `[10]` | `WE` | RAM write enable (`1` = write, `0` = read) |
| `[9:4]` | `DataIn` | 6-bit value written to RAM (zero-extended to 32 bits) |
| `[3:0]` | `OP` | ALU operation (`0` AND, `1` OR, `2` ADD, `6` SUB, `7` SLT, `12` NOR) |

Modules:

- `ROM.v` / `RAM.v`: 64×32-bit memories initialized from `memrom` and `memram`.
- `ROM_INSTRUCCIONES.v`: 16×23-bit instruction memory loaded from `mem_instrucciones`.
- `RARO.v`: first version, with the control signals as separate inputs.
- `RARO_SUPREME.v`: decodes the instruction fields (`RARO_SUPREME`) and wires the instruction ROM to it (`SISTEMA_RARO`).

> The memory files are loaded with `$readmemb` using relative paths, so run the simulation from `Activities/05_Datapath/`.

## Testbenches

Each testbench, with the activity it belongs to and the module it tests:

| Activity | Testbench | Module | What it checks |
|----------|-----------|--------|----------------|
| 02 | `Mario_TB.v` | `FA` (`FA.v`) | 1-bit Full Adder with several combinations of `X`, `Y` and `C_in`. |
| 02 | `Raul_TB.v` | `S4B` (`4BFA.v`) | 4-bit adder with several sums (3+5, 6+1, 2+2, 3+3, 5+6). |
| 02 | `Victor_TB.v` | `S16B` (`16BFA.v`) | 16-bit adder with negative values and overflow cases (`32767 + 1`, `65535 + 1`). |
| 03 | `Mux6_1_TB.v` | `Mux6_1` (`Mux6_1.v`) | All 6 `Sel` values with random inputs (`$random`) over 5 iterations. |
| 04 | `MIPSALU_TB.v` | `MIPSALU` (`MIPSALU.v`) | Every ALU operation with three operand pairs, including `0xFFFFFFFF + 1`, to check the `ZF` flag. |
| 05 | `RARO_SUPREME_TB.v` | `SISTEMA_RARO` (`RARO_SUPREME.v`) | Sweeps the 16 instructions of `mem_instrucciones` (`selector` 0–15), printing the instruction, `DD` and `ZF`, and dumps `raro_supreme.vcd`. |

## Tools

- **Language:** Verilog HDL
- **Simulation:** ModelSim

## Reports

The [`Reports/`](Reports/) folder contains the report for each activity, with the design explanation and simulation results.

## Author

[@Rxjaz](https://github.com/Rxjaz) — Student at CUCEI, Universidad de Guadalajara.

---

*Academic project.*