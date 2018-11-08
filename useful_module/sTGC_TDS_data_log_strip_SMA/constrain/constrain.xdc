################################# RefClk master Location constraints #####################

set_property PACKAGE_PIN K25 [get_ports clk_in_40M_n]
set_property PACKAGE_PIN L25 [get_ports clk_in_40M_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_in_40M_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_in_40M_p]

# J9 miniSAS as alternative for one FEB connection
set_property IOSTANDARD LVCMOS25 [get_ports {debug_port[0]}]
set_property PACKAGE_PIN AF22 [get_ports {debug_port[0]}]

set_property IOSTANDARD LVCMOS25 [get_ports {debug_port[1]}]
set_property PACKAGE_PIN AG25 [get_ports {debug_port[1]}]

set_property IOSTANDARD LVCMOS25 [get_ports {debug_port[2]}]
set_property PACKAGE_PIN AJ22 [get_ports {debug_port[2]}]

set_property IOSTANDARD LVCMOS25 [get_ports {debug_port[3]}]
set_property PACKAGE_PIN AE25 [get_ports {debug_port[3]}]

set_property IOSTANDARD LVCMOS25 [get_ports {debug_port[4]}]
set_property PACKAGE_PIN AA20 [get_ports {debug_port[4]}]


set_false_path -through [get_nets -hierarchical -filter {NAME =~ *VIO*}]
set_false_path -through [get_nets -hierarchical -filter {NAME =~ *VIO*}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *vio*/C}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *vio*/D}]



####################### GT reference clock constraints #########################
create_clock -period 6.250 [get_ports GTP_CLK_p]

################################# RefClk Location constraints #####################
# 160 MHz MGT Ref. Clock from mSAS_FMC4S board
##X0Y8
set_property LOC J7 [get_ports  GTP_CLK_n ]
set_property LOC J8 [get_ports  GTP_CLK_p ]

set_property LOC K5 [get_ports  serial_data_in_n_0 ]
set_property LOC K6 [get_ports  serial_data_in_p_0 ]

