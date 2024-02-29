# Large Integer Arithmetic Accelerator

## Overview
This project implements a 512-bit arithmetic accelerator designed for performing arithmetic operations on large integers. The accelerator receives input numbers along with commands specifying the operation to perform and computes the result, which is then sent back to the requesting device. The communication is done via UART (Universal Asynchronous Receiver-Transmitter) protocol.

## Features & Resources
- Supports arithmetic operations on 512-bit integers.
- Commands specify the operation to perform.
- Operations have a latency of only **6 clock cycles**.
- Total area of 1307 LUTs and 1571 FFs.

## Usage
### Input Format
The input format consists of:
- Two 512-bit integers representing the operands.
- A command specifying the operation to perform.

### Supported Operations
The accelerator currently supports the following operations:
- Addition
- Subtraction
  
Future plans include to expand the list of supported operations to comparison, multiplication, division...

## Implementation
The accelerator is implemented in Verilog. The design combines carry select adder (CSA) with carry lookahead adder (CLA) in order to optimize the trade off between speed and area. 

## Setup
1. Clone the repository:
   ```bash
   git clone git@github.com:HassinJalap/arithmetic-accelerator.git
   ```
2. Open Vivado and from the tcl console, go to the Arithmetic-accelerator folder
   ```bash
   cd Arithmetic-accelerator
   ```
3. Run the build.tcl script from the console:
   ```bash
   source build.tcl
   ```
4. Navigate to the bd folder in the src directory and run the design_1.tcl script:
   ```bash
   cd src/bd
   source design_1.tcl

The project should be set up in Vivado with the source files and the block design
