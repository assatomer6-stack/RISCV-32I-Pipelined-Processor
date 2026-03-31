# RISC-V 32I Pipelined Processor
A 32-bit RISC-V processor implemented in Verilog, evolving from a single-cycle architecture to a high-performance **5-stage pipeline** (IF, ID, EXE, MEM, WB).

# Development Path
The project followed an evolutionary design process, beginning with the implementation of a functional Single-Cycle RISC-V processor. This served as the baseline for transitioning to a high-performance 5-stage pipeline (IF, ID, EXE, MEM, and WB).

# Verification Methodology
To ensure architectural integrity, a modular development strategy was employed. Each sub-module was verified through a dedicated testbench to guarantee functional correctness before being integrated into the top-level module.

# Reference & Design Logic
The architecture and implementation logic  based on: Computer Organization and Design: The Hardware/Software Interface (RISC-V Edition) by Patterson and Hennessy.

## Core Architecture & Features
* **5-Stage Pipeline:** Clean separation of processing stages to maximize instruction throughput.
* **Hazard Detection Unit (HDU):** Automatically manages pipeline stalls during Load-Use dependencies to prevent data corruption.
* **Forwarding Unit:** Implements **WB-to-EX** and **MEM-to-EX** data paths, resolving RAW dependencies without performance loss.
* **Register File with Internal Bypass:** Custom logic allows simultaneous read and write operations within the same clock cycle (Internal Forwarding), preventing stale data reads.
* **Branch Handling:** Supports conditional branches (BEQ) with a sign-extended Immediate Generator, enabling reliable backward jumps.

## Supported ISA
The processor supports a fundamental subset of the RISC-V instruction set:
* **R-type:** ADD , SUB, AND , OR, XOR , SLT
* **I-type:** 'ADDI', 'LW' , 'ANDI' , 'ORI' 
* **S-type:** `SW'
* **B-type:** `BEQ'

## Hardware Performance (Synthesis Results)
Based on static timing analysis using **Intel Quartus**:
* **Max Frequency:** 88.97 MHz


## Case Study: Fibonacci Sequence
To validate the full integration of the pipeline, a program calculating the first 10 Fibonacci numbers was executed.
* **The Challenge:** High-density Read-After-Write (RAW) dependencies and a tight loop with backward branching.
* **Final Result:** The value **34** (the 10th number) was successfully computed and stored in register **x1**.

## Engineering Lessons Learned
1. **Modular Design:** Writing and testing each module separately before integration is essential for complex hardware projects.
2. **Parallel Thinking:** Transitioning from procedural programming to Verilog required a deep understanding of concurrent hardware execution.
3. **Advanced Debugging:** Mastered waveform analysis using GTKWave and developed comprehensive testbenches to isolate pipeline hazards.

## Verification & Tools
* **HDL:** Verilog
* **Simulator:** Icarus Verilog
* **Waveform Viewer:** GTKWave
* **Synthesis & Timing:** Intel Quartus Prime
