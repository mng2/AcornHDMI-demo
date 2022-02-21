# Acorn HDMI/DVI demo

This project is for demonstrating usage of a [HDMI/DVI adapter board](https://github.com/mng2/AcornHDMI) 
for the SQRL Acorn / RHS Nitefury.
It uses the NEORV32 RISC-V core for interacting with the I2C I/O expander.
Current status: I2C communication achieved.

## Design overview

See the hardware readme for details. 
In short, the adapter board has an I2C I/O expander which needs to be talked to 
in order to turn on and configure the DVI buffer chip.

At present the design consists solely of a basic NEORV32,
with GPIO and TWI peripherals.
The oscillator used is the one feeding the memory bank, so no PCIe connection is required.
An MMCM is used to bring the 200 MHz down to the 100 MHz recommended for NEORV32.

To build the project, several additional pieces of software are required.
* The first is the [NEORV32 project](https://github.com/stnolting/neorv32), 
which contains the RISC-V softcore used in this design.
At present the project expects to find the `neorv32` repository in the `..` directory.
The version I am using is git tag `v1.6.5`.
* The second, which you only need if you want to modify the C code, is a
RISC-V toolchain. On Ubuntu 21.04 supposedly the `gcc-riscv64-unknown-elf` package
is what you need, but on Ubuntu 20.04 it doesn't seem to work.
It may be simplest to manually install the [binary package](https://github.com/stnolting/riscv-gcc-prebuilt).

## Build Process
To build with the default program in the softcore,
use the TCL console in Vivado. 
Navigate to this directory and run the command `source ./proj_demo_dvi.tcl`.
Run synthesis, implementation, and generate the bitstream.

To rebuild or modify the software, enter the `sw` directory.
The program is in `main.c`.
To compile and generate the VHDL file containing the binary, run `make image`.
Then the FPGA tools can be run.

### Utilization
Part: xc7a200tfbg484-3

Resource | Used/Total | Percentage
--- | --- | ---
LUT | 1878/133800 | 1.40%
FF | 1365/267600 | 0.51%
BRAM | 7/365 | 1.92%
