// adapted from neorv32/sw/example/blink_led and twi_demo

// #################################################################################################
// # << NEORV32 - Blinking LED Demo Program >>                                                     #
// # ********************************************************************************************* #
// # BSD 3-Clause License                                                                          #
// #                                                                                               #
// # Copyright (c) 2021, Stephan Nolting. All rights reserved.                                     #
// #                                                                                               #
// # Redistribution and use in source and binary forms, with or without modification, are          #
// # permitted provided that the following conditions are met:                                     #
// #                                                                                               #
// # 1. Redistributions of source code must retain the above copyright notice, this list of        #
// #    conditions and the following disclaimer.                                                   #
// #                                                                                               #
// # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
// #    conditions and the following disclaimer in the documentation and/or other materials        #
// #    provided with the distribution.                                                            #
// #                                                                                               #
// # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
// #    endorse or promote products derived from this software without specific prior written      #
// #    permission.                                                                                #
// #                                                                                               #
// # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
// # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
// # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
// # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
// # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
// # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
// # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
// # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
// # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
// # ********************************************************************************************* #
// # The NEORV32 Processor - https://github.com/stnolting/neorv32              (c) Stephan Nolting #
// #################################################################################################


/**********************************************************************//**
 * @file test01_riscv_blinky/main.c
 * @author Mike Ng
 * @brief Fancier blinky for 4 LEDs on SQRL Acorn / RHS NiteFury
 **************************************************************************/

#include <neorv32.h>

#define BAUD_RATE 19200

#define XADC_TEMP   (*((volatile uint32_t*) (0x40000000UL)))
#define XADC_VCCINT (*((volatile uint32_t*) (0x40000004UL)))
#define XADC_VCCAUX (*((volatile uint32_t*) (0x40000008UL)))
#define XADC_LTC    (*((volatile uint32_t*) (0x40000078UL)))

#define FBUF_PIX0   (*((volatile uint32_t*) (0x40001000UL)))
#define FBUF_PIX1   (*((volatile uint32_t*) (0x40001004UL)))
#define FBUF_PIX2   (*((volatile uint32_t*) (0x40001008UL)))
#define FBUF_PIX3   (*((volatile uint32_t*) (0x4000100cUL)))
#define FBUF_CMD    (*((volatile uint32_t*) (0x40001014UL)))
#define FBUF_STATUS (*((volatile uint32_t*) (0x40001018UL)))

enum FBUF_CMD_enum {
    FBUF_CMD_WRITE_PIXELS    = 0,
    FBUF_CMD_FLIP_BUFFERS    = 4,
    FBUF_CMD_MIG_ON          = 8
};

enum FBUF_STATUS_enum {
    FBUF_STATUS_WRITE_ACK       = 0,
    FBUF_STATUS_ACTIVE_BUFFER   = 4,
    FBUF_STATUS_MIG_CAL_DONE    = 8,
    FBUF_STATUS_FIFO_OVERFLOW   = 10,
    FBUF_STATUS_FIFO_UNDERFLOW  = 11
};

#define PCA9534_I2C_ADDR    0x40 // 0x40 write / 0x41 read
#define I2C_WRITE           0
#define I2C_READ            1
#define PCA9534_REG_INPUT   0x00
#define PCA9534_REG_OUTPUT  0x01
#define PCA9534_REG_INVERT  0x02
#define PCA9534_REG_CONFIG  0x03
#define HDMI_LED            5
#define HDMI_OE_N           2
#define HDMI_HOTPLUG_DET    3   //input
#define HDMI_PREEMPH0       0
#define HDMI_PREEMPH1       1
#define HDMI_DONGLE_DET     7
#define HDMI_DDC_SHIFT_EN   6
#define HDMI_CEC            4   //inout

void write_PCA9534_reg(uint8_t reg, uint8_t val);

/**********************************************************************//**
 * Main function; shows an incrementing 4-bit counter on GPIO.output(7:0).
 * Reboots when 'r' received, if GPIO 7 connected as reset.
 *
 * @note This program requires the GPIO controller 
 *
 * @return 0 if execution was successful
 **************************************************************************/
int 
main() 
{

    neorv32_gpio_port_set(0); // clear gpio output

    // check if UART unit is implemented at all
    if (neorv32_uart0_available() == 0) {
        return 1;
    }
    // init UART at default baud rate, no parity bits, ho hw flow control
    neorv32_uart0_setup(BAUD_RATE, PARITY_NONE, FLOW_CONTROL_NONE);
    // capture all exceptions and give debug info via UART
    // this is not required, but keeps us safe
    neorv32_rte_setup();
    // check available hardware extensions and compare with compiler flags
    neorv32_rte_check_isa(0); // silent = 0 -> show message if isa mismatch
    // intro
    neorv32_uart0_printf("\n--- hullo world ---\n");
    
    // f = fmain / 4 / PRSC = 100e6 / 4 / 2048 = ~12.2 kHz
    neorv32_twi_setup(CLK_PRSC_2048);
    neorv32_cpu_delay_ms(100);
    // set default outputs
    uint8_t pca_output =    (0 << HDMI_LED) +
                            (1 << HDMI_OE_N) +
                            (1 << HDMI_HOTPLUG_DET) +
                            (0 << HDMI_PREEMPH0) +
                            (0 << HDMI_PREEMPH1) +
                            (0 << HDMI_DONGLE_DET) +
                            (0 << HDMI_DDC_SHIFT_EN) +
                            (1 << HDMI_CEC);
    write_PCA9534_reg(PCA9534_REG_OUTPUT, pca_output);
    // set all pins to out except
    write_PCA9534_reg( PCA9534_REG_CONFIG, (1 << HDMI_HOTPLUG_DET) + (1 << HDMI_CEC) );

    uint8_t timeout = 0;
    uint8_t acorn_LEDs = 0;
    char rx = 0;
    // Main menu
    for (;;) {
        if (neorv32_uart0_char_received()) {
            rx = neorv32_uart0_char_received_get();
            if (rx=='r') {
                neorv32_uart0_printf("r received, rebooting!\n");
                neorv32_gpio_port_set(0xFF); // bit 7 to reset
            } else if (rx=='s') {
                neorv32_uart0_printf("status: %x\n", FBUF_STATUS);
            } else if (rx=='m') {
                if (FBUF_STATUS & (1 << FBUF_STATUS_MIG_CAL_DONE)) {
                    neorv32_uart0_printf("MIG is already active\n");
                } else {
                    neorv32_uart0_printf("Turning MIG on");
                    FBUF_CMD |= (1 << FBUF_CMD_MIG_ON);
                    timeout = 1;
                    while ( (0==(FBUF_STATUS & (1 << FBUF_STATUS_MIG_CAL_DONE))) | (timeout != 0)) {
                        timeout++;
                        neorv32_cpu_delay_ms(100);
                        neorv32_uart0_printf(".");
                    }
                    if (FBUF_STATUS & (1 << FBUF_STATUS_MIG_CAL_DONE)) {
                        neorv32_uart0_printf("\ndone\n");
                    } else {
                        neorv32_uart0_printf("\nERROR: timed out\n");
                    }
                }
            } else if (rx=='o') {
                pca_output ^= (1 << HDMI_LED);
                write_PCA9534_reg(PCA9534_REG_OUTPUT, pca_output);
                neorv32_uart0_printf("HDMI buffer turned ");
                pca_output ^= (1 << HDMI_OE_N);
                write_PCA9534_reg(PCA9534_REG_OUTPUT, pca_output);
                if (pca_output & (1 << HDMI_OE_N)) {
                    neorv32_uart0_printf("OFF\n");
                } else {
                    neorv32_uart0_printf("ON\n");
                }
        /*    } else if (rx=='x') {
                neorv32_uart0_printf("temp: %x\n", XADC_TEMP);
                neorv32_uart0_printf("vint: %x\n", XADC_VCCINT);
                neorv32_uart0_printf("vaux: %x\n", XADC_VCCAUX);
                neorv32_uart0_printf("vLTC: %x\n", XADC_LTC);       */
            } else {
                neorv32_uart0_printf("Menu: enter 'r' to reboot\n");
            }
            acorn_LEDs ^= 1;
            neorv32_gpio_port_set(acorn_LEDs);
        }

    }

    return 0;
}

void 
write_PCA9534_reg(uint8_t reg, uint8_t val) 
{
    int res = 0;
    res |= neorv32_twi_start_trans(PCA9534_I2C_ADDR+I2C_WRITE); 
    // these functions all poll busy
    // for the moment, don't check ACK in program but maybe in future
    res |= neorv32_twi_trans(reg);
    res |= neorv32_twi_trans(val);
    neorv32_twi_generate_stop();
}
