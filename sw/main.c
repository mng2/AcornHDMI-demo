// adapted from neorv32/sw/example/demo_twi

// #################################################################################################
// # << NEORV32 - TWI Bus Explorer Demo Program >>                                                 #
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
 * @file AcornHDMI-demo/sw/main.c
 * @author Mike Ng
 * @brief Software for RISC-V core on SQRL Acorn / RHS NiteFury for DVI demo
 **************************************************************************/

#include <neorv32.h>

#define PCA9534_I2C_ADDR    0x40 // 0x40 write / 0x41 read
#define I2C_WRITE           0
#define I2C_READ            1
#define PCA9534_REG_INPUT   0x00
#define PCA9534_REG_OUTPUT  0x01
#define PCA9534_REG_INVERT  0x02
#define PCA9534_REG_CONFIG  0x03

void write_PCA9534_reg(uint8_t reg, uint8_t val);

/**********************************************************************//**
 * Main function; blinks LED #1 and also amber LED on DVI board.
 *
 * @note This program requires the GPIO controller 
 *
 * @return 0 if execution was successful
 **************************************************************************/
int 
main() 
{

    // f = fmain / 4 / PRSC = 100e6 / 4 / 2048 = ~12.2 kHz
    neorv32_twi_setup(CLK_PRSC_2048);
    
    neorv32_cpu_delay_ms(100);
    
    //set amber LED to output
    write_PCA9534_reg( PCA9534_REG_CONFIG, (0xFF ^ (1 << 5)));
    
    uint8_t pca_output  = 0xFF;
    uint8_t led_output  = 0x01;
    
    while(1)
    {
        neorv32_cpu_delay_ms(500);
        pca_output ^= (1 << 5);
        led_output ^= 0x01;
        neorv32_gpio_port_set(led_output);
        write_PCA9534_reg(PCA9534_REG_OUTPUT, pca_output);
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


