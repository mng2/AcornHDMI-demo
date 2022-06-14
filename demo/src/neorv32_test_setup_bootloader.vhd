-- #################################################################################################
-- # << NEORV32 - Test Setup using the UART-Bootloader to upload and run executables >>            #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2021, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32                           #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_bootloader_200 is
  generic (
    -- adapt these for your setup --
    CLOCK_FREQUENCY   : natural := 100000000; -- clock frequency of clk_i in Hz
    MEM_INT_IMEM_SIZE : natural := 16*1024;   -- size of processor-internal instruction memory in bytes
    MEM_INT_DMEM_SIZE : natural := 8*1024     -- size of processor-internal data memory in bytes
  );
  port (
    -- Global control --
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    clk_neo     : in  std_ulogic;
    -- GPIO --
    gpio_o      : out std_ulogic_vector(7 downto 0); -- parallel output
    -- Wishbone bus --
    wb_tag_o       : out std_ulogic_vector(02 downto 0); -- request tag
    wb_adr_o       : out std_ulogic_vector(31 downto 0); -- address
    wb_dat_i       : in  std_ulogic_vector(31 downto 0) := (others => 'U'); -- read data
    wb_dat_o       : out std_ulogic_vector(31 downto 0); -- write data
    wb_we_o        : out std_ulogic; -- read/write
    wb_sel_o       : out std_ulogic_vector(03 downto 0); -- byte enable
    wb_stb_o       : out std_ulogic; -- strobe
    wb_cyc_o       : out std_ulogic; -- valid cycle
    wb_lock_o      : out std_ulogic; -- exclusive access request
    wb_ack_i       : in  std_ulogic := 'L'; -- transfer acknowledge
    wb_err_i       : in  std_ulogic := 'L'; -- transfer error
    -- TWI --
    twi_sda_io  : inout std_logic;
    twi_scl_io  : inout std_logic;
    -- UART0 --
    brt0_txd_o  : out std_ulogic_vector(7 downto 0); -- UART0 send data
    brt0_rxd_i  : in  std_ulogic_vector(7 downto 0); -- UART0 receive data
    brt0_txd_valid  : out std_ulogic;
    brt0_rxd_valid  : in  std_ulogic
  );
end entity;

architecture neorv32_test_setup_bootloader_rtl of neorv32_bootloader_200 is

    signal con_gpio_o   : std_ulogic_vector(63 downto 0);
    signal neo_rstn     : std_ulogic;

begin
    
  -- The Core Of The Problem ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  neorv32_top_inst: entity neorv32.neorv32_top
  generic map (
    -- General --
    CLOCK_FREQUENCY              => CLOCK_FREQUENCY,   -- clock frequency of clk_i in Hz
    INT_BOOTLOADER_EN            => true,              -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
    -- RISC-V CPU Extensions --
    CPU_EXTENSION_RISCV_C        => true,              -- implement compressed extension?
    CPU_EXTENSION_RISCV_M        => true,              -- implement mul/div extension?
    CPU_EXTENSION_RISCV_Zicsr    => true,              -- implement CSR system?
    CPU_EXTENSION_RISCV_Zicntr   => true,              -- implement base counters?
    -- Internal Instruction memory --
    MEM_INT_IMEM_EN              => true,              -- implement processor-internal instruction memory
    MEM_INT_IMEM_SIZE            => MEM_INT_IMEM_SIZE, -- size of processor-internal instruction memory in bytes
    -- Internal Data memory --
    MEM_INT_DMEM_EN              => true,              -- implement processor-internal data memory
    MEM_INT_DMEM_SIZE            => MEM_INT_DMEM_SIZE, -- size of processor-internal data memory in bytes
    -- External memory interface (WISHBONE) --
    MEM_EXT_EN                   => true,             -- implement external memory bus interface?
    MEM_EXT_TIMEOUT              => 255,              -- cycles after a pending bus access auto-terminates (0 = disabled)
    MEM_EXT_PIPE_MODE            => false,            -- protocol: false=classic/standard wishbone mode, true=pipelined wishbone mode
    MEM_EXT_BIG_ENDIAN           => false,             -- byte order: true=big-endian, false=little-endian
    MEM_EXT_ASYNC_RX             => false,            -- use register buffer for RX data when false
    -- Processor peripherals --
    IO_GPIO_EN                   => true,              -- implement general purpose input/output port unit (GPIO)?
    IO_MTIME_EN                  => true,              -- implement machine system timer (MTIME)?
    IO_TWI_EN                    => true,              -- implement two-wire interface
    IO_BRT0_EN                   => true               -- implement primary byte receiver/transmitter (as UART0)?
  )
  port map (
    -- Global control --
    clk_i       => clk_neo,       -- global clock, rising edge
    rstn_i      => neo_rstn,  -- global reset, low-active, async
    -- GPIO (available if IO_GPIO_EN = true) --
    gpio_o      => con_gpio_o,  -- parallel output
    -- wishbone interface --
    wb_tag_o  => wb_tag_o,                      -- request tag
    wb_adr_o  => wb_adr_o,                      -- address
    wb_dat_i  => wb_dat_i,                      -- read data
    wb_dat_o  => wb_dat_o,                      -- write data
    wb_we_o   => wb_we_o,                       -- read/write
    wb_sel_o  => wb_sel_o,                      -- byte enable
    wb_stb_o  => wb_stb_o,                      -- strobe
    wb_cyc_o  => wb_cyc_o,                      -- valid cycle
    wb_lock_o => wb_lock_o,                     -- exclusive access request
    wb_ack_i  => wb_ack_i,                      -- transfer acknowledge
    wb_err_i  => wb_err_i,                      -- transfer error
    -- Two-Wire Interface --
    twi_sda_io => twi_sda_io,
    twi_scl_io => twi_scl_io,
    -- primary BRT0 (available if IO_BRT0_EN = true) --
    brt0_txd_o => brt0_txd_o, -- UART0 send data
    brt0_rxd_i => brt0_rxd_i, -- UART0 receive data
    brt0_txd_valid => brt0_txd_valid,
    brt0_rxd_valid => brt0_rxd_valid
  );
  neo_rstn <= rstn_i;

  gpio_o <= con_gpio_o(7 downto 0);

end architecture;
