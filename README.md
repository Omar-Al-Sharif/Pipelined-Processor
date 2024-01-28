# 6-Stage Pipelined Processor with RISC-like ISA (VHDL Implementation)

## Overview

This repository contains the VHDL implementation of a 6-stage pipelined processor featuring a RISC-like Instruction Set Architecture (ISA). The processor design emphasizes simplicity and efficiency, following the principles of Reduced Instruction Set Computing (RISC).

## Architechture

Please refer to our architecture and connections below to visualize the pipelined processor.
![design_page-0001](https://github.com/Omar-Al-Sharif/Pipelined-Processor/assets/68480294/1b505920-67e4-47c4-9665-873d1c0fd00d)

## Features

- **6-Stage Pipeline:**
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
  - Hazard Detection and Resolution

- **RISC-like ISA:**
  - The processor supports a reduced set of instructions, promoting simplicity and efficiency.
  - Instructions are designed to execute in a single clock cycle wherever possible.

- **Efficient Hazard Handling:**
  - The processor employs hazard detection and resolution mechanisms to handle data hazards and control hazards efficiently.

## Getting Started

1. **Prerequisites:**
   - Ensure that you have a VHDL simulation and synthesis tool installed (e.g., ModelSim, Xilinx Vivado, or Altera Quartus).

2. **Simulation:**
   - Open the VHDL project in your preferred simulation tool.
   - Simulate the testbench to observe the processor's behavior under various instructions.

Feel free to explore the code and documentation to gain a deeper understanding of the 6-stage pipelined processor with a RISC-like ISA.
