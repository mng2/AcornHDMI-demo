
create_clock -name clk200 -period 5 [get_ports CLK200_P]

create_clock -period 10.000 -name pcie_refclk [get_ports REFCLKp]

# these mess up the timing
# while proper, are not strictly necessary
#set_max_delay 20 -from userclk2 -to [get_ports LEDn[*]]
#set_max_delay 20 -from userclk2 -to [get_ports M2_LED]

connect_debug_port u_ila_0/probe0 [get_nets [list {my_gpio/s_axi_rdata[0]} {my_gpio/s_axi_rdata[1]} {my_gpio/s_axi_rdata[2]} {my_gpio/s_axi_rdata[3]} {my_gpio/s_axi_rdata[4]} {my_gpio/s_axi_rdata[5]} {my_gpio/s_axi_rdata[6]} {my_gpio/s_axi_rdata[7]} {my_gpio/s_axi_rdata[8]} {my_gpio/s_axi_rdata[9]} {my_gpio/s_axi_rdata[10]} {my_gpio/s_axi_rdata[11]} {my_gpio/s_axi_rdata[12]} {my_gpio/s_axi_rdata[13]} {my_gpio/s_axi_rdata[14]} {my_gpio/s_axi_rdata[15]} {my_gpio/s_axi_rdata[16]} {my_gpio/s_axi_rdata[17]} {my_gpio/s_axi_rdata[18]} {my_gpio/s_axi_rdata[19]} {my_gpio/s_axi_rdata[20]} {my_gpio/s_axi_rdata[21]} {my_gpio/s_axi_rdata[22]} {my_gpio/s_axi_rdata[23]} {my_gpio/s_axi_rdata[24]} {my_gpio/s_axi_rdata[25]} {my_gpio/s_axi_rdata[26]} {my_gpio/s_axi_rdata[27]} {my_gpio/s_axi_rdata[28]} {my_gpio/s_axi_rdata[29]} {my_gpio/s_axi_rdata[30]} {my_gpio/s_axi_rdata[31]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {my_gpio/m_axi_awaddr[0]} {my_gpio/m_axi_awaddr[1]} {my_gpio/m_axi_awaddr[2]} {my_gpio/m_axi_awaddr[3]} {my_gpio/m_axi_awaddr[4]} {my_gpio/m_axi_awaddr[5]} {my_gpio/m_axi_awaddr[6]} {my_gpio/m_axi_awaddr[7]} {my_gpio/m_axi_awaddr[8]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {my_gpio/m_axi_wdata[0]} {my_gpio/m_axi_wdata[1]} {my_gpio/m_axi_wdata[2]} {my_gpio/m_axi_wdata[3]} {my_gpio/m_axi_wdata[4]} {my_gpio/m_axi_wdata[5]} {my_gpio/m_axi_wdata[6]} {my_gpio/m_axi_wdata[7]} {my_gpio/m_axi_wdata[8]} {my_gpio/m_axi_wdata[9]} {my_gpio/m_axi_wdata[10]} {my_gpio/m_axi_wdata[11]} {my_gpio/m_axi_wdata[12]} {my_gpio/m_axi_wdata[13]} {my_gpio/m_axi_wdata[14]} {my_gpio/m_axi_wdata[15]} {my_gpio/m_axi_wdata[16]} {my_gpio/m_axi_wdata[17]} {my_gpio/m_axi_wdata[18]} {my_gpio/m_axi_wdata[19]} {my_gpio/m_axi_wdata[20]} {my_gpio/m_axi_wdata[21]} {my_gpio/m_axi_wdata[22]} {my_gpio/m_axi_wdata[23]} {my_gpio/m_axi_wdata[24]} {my_gpio/m_axi_wdata[25]} {my_gpio/m_axi_wdata[26]} {my_gpio/m_axi_wdata[27]} {my_gpio/m_axi_wdata[28]} {my_gpio/m_axi_wdata[29]} {my_gpio/m_axi_wdata[30]} {my_gpio/m_axi_wdata[31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {my_gpio/m_axi_wstrb[0]} {my_gpio/m_axi_wstrb[1]} {my_gpio/m_axi_wstrb[2]} {my_gpio/m_axi_wstrb[3]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {my_gpio/m_axi_araddr[0]} {my_gpio/m_axi_araddr[1]} {my_gpio/m_axi_araddr[2]} {my_gpio/m_axi_araddr[3]} {my_gpio/m_axi_araddr[4]} {my_gpio/m_axi_araddr[5]} {my_gpio/m_axi_araddr[6]} {my_gpio/m_axi_araddr[7]} {my_gpio/m_axi_araddr[8]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list my_gpio/m_axi_arvalid]]
connect_debug_port u_ila_0/probe6 [get_nets [list my_gpio/m_axi_awvalid]]
connect_debug_port u_ila_0/probe7 [get_nets [list my_gpio/m_axi_bready]]
connect_debug_port u_ila_0/probe8 [get_nets [list my_gpio/m_axi_rready]]
connect_debug_port u_ila_0/probe9 [get_nets [list my_gpio/m_axi_wvalid]]
connect_debug_port u_ila_0/probe10 [get_nets [list my_gpio/s_axi_arready]]
connect_debug_port u_ila_0/probe11 [get_nets [list my_gpio/s_axi_awready]]
connect_debug_port u_ila_0/probe12 [get_nets [list my_gpio/s_axi_bvalid]]
connect_debug_port u_ila_0/probe13 [get_nets [list my_gpio/s_axi_rvalid]]
connect_debug_port u_ila_0/probe14 [get_nets [list my_gpio/s_axi_wready]]








set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[0]}]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[1]}]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[2]}]
set_property MARK_DEBUG true [get_nets {my_axi_to_axilite/axilite_if\\.wstrb[3]}]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk100_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 7 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {xadc_inst/wb\\.data_o_reg[0]_1[0]} {xadc_inst/wb\\.data_o_reg[0]_1[1]} {xadc_inst/wb\\.data_o_reg[0]_1[2]} {xadc_inst/wb\\.data_o_reg[0]_1[3]} {xadc_inst/wb\\.data_o_reg[0]_1[4]} {xadc_inst/wb\\.data_o_reg[0]_1[5]} {xadc_inst/wb\\.data_o_reg[0]_1[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {xadc_inst/DO[0]} {xadc_inst/DO[1]} {xadc_inst/DO[2]} {xadc_inst/DO[3]} {xadc_inst/DO[4]} {xadc_inst/DO[5]} {xadc_inst/DO[6]} {xadc_inst/DO[7]} {xadc_inst/DO[8]} {xadc_inst/DO[9]} {xadc_inst/DO[10]} {xadc_inst/DO[11]} {xadc_inst/DO[12]} {xadc_inst/DO[13]} {xadc_inst/DO[14]} {xadc_inst/DO[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list xadc_inst/DEN]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list xadc_inst/DRDY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list xadc_inst/DWE]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk100_BUFG]
