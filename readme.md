# Acorn HDMI/DVI demo

This project is for demonstrating usage of a [HDMI/DVI adapter board](https://github.com/mng2/AcornHDMI) 
for the SQRL Acorn / RHS Nitefury.
It uses the NEORV32 RISC-V core for interacting with the I2C I/O expander.
Current status: I2C communication achieved.

## Design overview

In short, the adapter board has an I2C I/O expander which needs to be talked to 
in order to turn on and configure the DVI buffer chip.
See the hardware project for further details.

At present the design is approaching what I vaguely think of as "1.0".
There are several main parts to the design:
* NEORV32 RISC-V processor, with GPIO, TWI, not-exactly-UART peripherals, and a Wishbone bus.
* PCIe endpoint with not-quite-16450 UART, to provide a `tty` bootloader interface to the NEORV32.
* XADC Wishbone module for temperature and voltage readout.
* Framebuffer for display, and Wishbone memory access arbiter. (in progress)
* DVI signal generator, 1080p. (in progress)

To interact with the demo, the PCIe `tty` connection will be required.
The memory and NEORV32 will run off the 200 MHz oscillator,
allowing for an autonomous demo mode.

To build the project, several additional pieces of software are required.
* The first is the [NEORV32 project](https://github.com/stnolting/neorv32), 
which contains the RISC-V softcore used in this design.
The project expects to find the `neorv32` repository in the `../ip` directory.
The version at present is git tag `v1.7.1`.
* The second, which you only need if you want to modify the C code, is a
RISC-V toolchain. On Ubuntu 21.04 supposedly the `gcc-riscv64-unknown-elf` package
is what you need, but on Ubuntu 20.04 it doesn't seem to work.
It may be simplest to manually install the [binary package](https://github.com/stnolting/riscv-gcc-prebuilt).

## Build Process
To build with the default program in the softcore,
use the TCL console in Vivado. 
Navigate to the `demo` directory and run the command `source ./proj_demo_dvi.tcl`.
Run synthesis, implementation, and generate the bitstream.

To rebuild or modify the software, enter the `sw` directory.
The program is in `main.c`.
To compile and generate the VHDL file containing the binary, run `make image`.
Then the FPGA tools can be run.

### Utilization
Part: xc7a200tfbg484-3

Resource | Used/Total | Percentage
--- | --- | ---
LUT | ?/133800 | 
FF | ?/267600 | 
BRAM | ?/365 | 
