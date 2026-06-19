
set_property -dict { PACKAGE_PIN N11   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports { clk }];

set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports { rst }]; #Button-center
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports { start }];  #Button-top
set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports { cancel }];  #Button-bottom


set_property -dict { PACKAGE_PIN L5    IOSTANDARD LVCMOS33 } [get_ports { lid_closed }]; #sw[0]
set_property -dict { PACKAGE_PIN L4    IOSTANDARD LVCMOS33 } [get_ports { water_full }]; #sw[1]
set_property -dict { PACKAGE_PIN M4    IOSTANDARD LVCMOS33 } [get_ports { wash_done }];  #sw[2]
set_property -dict { PACKAGE_PIN M2    IOSTANDARD LVCMOS33 } [get_ports { rinse_done }]; #sw[3]
set_property -dict { PACKAGE_PIN M1    IOSTANDARD LVCMOS33 } [get_ports { spin_done }];  #sw[4]

set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { fill_valve }]; #led[0]
set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports { wash_motor }]; #led[1]
set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports { drain_pump }]; #led[2]
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { spin_motor }]; #led[3]
set_property -dict { PACKAGE_PIN L3    IOSTANDARD LVCMOS33 } [get_ports { done }];        #led[4]
set_property -dict { PACKAGE_PIN L2    IOSTANDARD LVCMOS33 } [get_ports { locked }];      #led[5]

set_property -dict { PACKAGE_PIN K3    IOSTANDARD LVCMOS33 } [get_ports { state_dbg[0] }]; #led[6]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { state_dbg[1] }]; #led[7]
set_property -dict { PACKAGE_PIN K5    IOSTANDARD LVCMOS33 } [get_ports { state_dbg[2] }]; #led[8]
set_property -dict { PACKAGE_PIN P6    IOSTANDARD LVCMOS33 } [get_ports { state_dbg[3] }]; #led[9]