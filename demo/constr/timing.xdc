
create_clock -name clk200 -period 5 [get_ports CLK200_P]

create_clock -period 10.000 -name pcie_refclk [get_ports REFCLKp]

# these mess up the timing
# while proper, are not strictly necessary
#set_max_delay 20 -from userclk2 -to [get_ports LEDn[*]]
#set_max_delay 20 -from userclk2 -to [get_ports M2_LED]

set_property LOC MMCME2_ADV_X1Y2 [get_cells clock_wrapper_inst/MMCME2_ADV_inst]

# CDC
set_max_delay -from [get_pins {framebuffer_inst/pixel_buffer_reg[*][*]/C}] \
                -to [get_pins {framebuffer_inst/pixel_buffer_cdc_reg[*]/D}]     10.0
set_max_delay -from [get_pins {framebuffer_inst/pointer_reg_reg[*]/C}] \
                -to [get_pins {framebuffer_inst/pointer_reg_cdc_reg[*]/D}]      10.0
