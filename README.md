# Simple CPU Implementation using Verilog

## Overview
This project implements a simple Central Processing Unit (CPU) using the Verilog hardware description language. The CPU is designed to execute basic instructions and demonstrate fundamental concepts of CPU architecture.

## Note
This repository has been discontinued during the project, the final files are stored locally, yet we will present a demo video on the CPU below.

## Features
- Arithmetic Logic Unit (ALU) supporting basic arithmetic and logical operations.
- Instruction Register (IR) for storing the current instruction being executed.
- Control Unit for decoding instructions and controlling the CPU operation.
- Program Counter (PC) for keeping track of the memory address of the next instruction to be executed.
- Registers for storing data temporarily during computation.
- Memory for storing instructions and data.

## Implementation Details
The CPU is implemented in Verilog, a hardware description language commonly used for designing digital circuits. The implementation consists of multiple modules interconnected to form the complete CPU architecture.

### Modules
1. **ALU**: Implements arithmetic and logical operations such as addition, subtraction, AND, OR, etc.
2. **Control Unit**: Decodes instructions and generates control signals for various CPU components.
3. **Instruction Register (IR)**: Stores the current instruction being executed.
4. **Program Counter (PC)**: Keeps track of the memory address of the next instruction.
5. **Registers**: Temporary storage for data during computation.
6. **Memory**: Stores instructions and data.

### Instruction Set
The CPU supports a basic instruction set including:
- Arithmetic instructions: ADD, SUB, etc.
- Logical instructions: AND, OR, XOR, etc.
- Load and Store instructions.
- Control flow instructions: Jump, Branch, etc.

## Usage
1. **Simulation**: The CPU design can be simulated using Verilog simulation tools such as ModelSim or Icarus Verilog. Simply compile the Verilog files and run the simulation to observe CPU behavior.
2. **FPGA Implementation**: The Verilog code can be synthesized and implemented on FPGA (Field-Programmable Gate Array) boards for hardware testing and demonstration.

## Dependencies
- Verilog simulation tools (e.g., ModelSim, Icarus Verilog)
- FPGA synthesis tools (if implementing on hardware)

## Demo Video


https://github.com/ryantang247/CPU_Project/assets/84262952/cbd2d1cf-ccee-4811-a971-0da4aa47e937


