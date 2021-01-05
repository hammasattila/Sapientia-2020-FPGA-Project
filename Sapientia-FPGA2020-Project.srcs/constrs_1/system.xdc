set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { sys_clock }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { sys_clock }];

set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports mosi]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports miso]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports cs]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports clk]