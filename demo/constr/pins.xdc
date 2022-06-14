# constraints for SQRL Acorn CLE-215+
# MIG and PCIe IPs take care of their own stuff

# 200 MHz LVDS clock
# Bank 15 is 1.5V so externally terminated
# see AR43989 for details
set_property PACKAGE_PIN J19 [get_ports CLK200_P]
set_property IOSTANDARD LVDS_25 [get_ports CLK200_P]
set_property PACKAGE_PIN H19 [get_ports CLK200_N]
set_property IOSTANDARD LVDS_25 [get_ports CLK200_N]

# Bank 34, 2.5V
set_property PACKAGE_PIN V9 [get_ports HDMI_CK_P]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_CK_P]
set_property PACKAGE_PIN V8 [get_ports HDMI_CK_N]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_CK_N]
set_property PACKAGE_PIN Y8 [get_ports HDMI_D0_P]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_D0_P]
set_property PACKAGE_PIN Y7 [get_ports HDMI_D0_N]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_D0_N]
set_property PACKAGE_PIN Y9 [get_ports HDMI_D1_P]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_D1_P]
set_property PACKAGE_PIN W9 [get_ports HDMI_D1_N]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_D1_N]
set_property PACKAGE_PIN AB8 [get_ports HDMI_D2_P]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_D2_P]
set_property PACKAGE_PIN AA8 [get_ports HDMI_D2_N]
set_property IOSTANDARD LVDS_25 [get_ports HDMI_D2_N]

# Bank 35, 3.3V
set_property PACKAGE_PIN G3 [get_ports LEDn[1]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDn[1]]
set_property PACKAGE_PIN H3 [get_ports LEDn[2]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDn[2]]
set_property PACKAGE_PIN G4 [get_ports LEDn[3]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDn[3]]
set_property PACKAGE_PIN H4 [get_ports LEDn[4]]
set_property IOSTANDARD LVCMOS33 [get_ports LEDn[4]]
set_property DRIVE 4 [get_ports LEDn[*]]
set_property PACKAGE_PIN J1 [get_ports PERSTn]
set_property IOSTANDARD LVCMOS33 [get_ports PERSTn]
set_property PACKAGE_PIN M1 [get_ports M2_LEDn]
set_property IOSTANDARD LVCMOS33 [get_ports M2_LEDn]
set_property DRIVE 4 [get_ports M2_LEDn]
set_property PACKAGE_PIN G1 [get_ports CLKREQn]
set_property IOSTANDARD LVCMOS33 [get_ports CLKREQn]
set_property PACKAGE_PIN H2 [get_ports temp_LTC_P]
set_property IOSTANDARD LVCMOS33 [get_ports temp_LTC_P]
set_property PACKAGE_PIN G2 [get_ports temp_LTC_N]
set_property IOSTANDARD LVCMOS33 [get_ports temp_LTC_N]
set_property PACKAGE_PIN J5 [get_ports DVI_SDA]
set_property IOSTANDARD LVCMOS33 [get_ports DVI_SDA]
set_property PACKAGE_PIN J2 [get_ports DVI_SCL]
set_property IOSTANDARD LVCMOS33 [get_ports DVI_SCL]

# PCIe refclk, 100 MHz
set_property PACKAGE_PIN F6 [get_ports REFCLKp]
set_property PACKAGE_PIN E6 [get_ports REFCLKn]

