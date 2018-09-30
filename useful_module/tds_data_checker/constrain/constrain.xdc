####################### GT reference clock constraints #########################
create_clock -period 6.250 [get_ports GTP_CLK_p]

################################# RefClk Location constraints #####################
# 160 MHz MGT Ref. Clock from mSAS_FMC4S board 
###X0Y8
#set_property LOC J7 [get_ports  GTP_CLK_n ] 
#set_property LOC J8 [get_ports  GTP_CLK_p ]

#set_property LOC K5 [get_ports  serial_data_in_n ] 
#set_property LOC K6 [get_ports  serial_data_in_p ]

###X0Y12
set_property LOC E7 [get_ports  GTP_CLK_n ] 
set_property LOC E8 [get_ports  GTP_CLK_p ]

set_property LOC E3 [get_ports  serial_data_in_n ] 
set_property LOC E4 [get_ports  serial_data_in_p ]

################################# RefClk master Location constraints #####################

set_property LOC D18 [get_ports  clk_in_40M_n ] 
set_property LOC D17 [get_ports  clk_in_40M_p ]
set_property IOSTANDARD LVDS_25 [get_ports  clk_in_40M_n ] 
set_property IOSTANDARD LVDS_25 [get_ports  clk_in_40M_p ]
 
#set_property LOC D18 [get_ports  clk_in_40M_n ] 
#set_property LOC D17 [get_ports  clk_in_40M_p ]



set_false_path -through [get_nets -hierarchical -filter {NAME =~ *VIO*}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *vio*/C}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *vio*/D}]

#set_false_path -from [get_pins -hierarchical -filter {NAME =~ *ila*/C}]
#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *ila*/D}]