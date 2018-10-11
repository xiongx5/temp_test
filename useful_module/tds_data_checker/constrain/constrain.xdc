################################# RefClk master Location constraints #####################

set_property LOC D18 [get_ports  clk_in_40M_n ] 
set_property LOC D17 [get_ports  clk_in_40M_p ]
set_property IOSTANDARD LVDS_25 [get_ports  clk_in_40M_n ] 
set_property IOSTANDARD LVDS_25 [get_ports  clk_in_40M_p ]
 
#set_property LOC D18 [get_ports  clk_in_40M_n ] 
#set_property LOC D17 [get_ports  clk_in_40M_p ]
set_property LOC H21 [get_ports  trigger_in_p ] 
set_property LOC H22 [get_ports  trigger_in_n ]
set_property IOSTANDARD LVDS_25 [get_ports  trigger_in_p ] 
set_property IOSTANDARD LVDS_25 [get_ports  trigger_in_n ]

# J9 miniSAS as alternative for one FEB connection
set_property IOSTANDARD LVCMOS25 [get_ports debug_port[0]]
set_property PACKAGE_PIN AE23 [get_ports debug_port[0]]

set_property IOSTANDARD LVCMOS25 [get_ports debug_port[1]]
set_property PACKAGE_PIN AD21 [get_ports debug_port[1]]

set_property IOSTANDARD LVCMOS25 [get_ports debug_port[2]]
set_property PACKAGE_PIN AK23 [get_ports debug_port[2]]

set_property IOSTANDARD LVCMOS25 [get_ports debug_port[3]]
set_property PACKAGE_PIN AB24 [get_ports debug_port[3]]

set_property IOSTANDARD LVCMOS25 [get_ports debug_port[4]]
set_property PACKAGE_PIN AG22 [get_ports debug_port[4]]


set_false_path -through [get_nets -hierarchical -filter {NAME =~ *VIO*}]
set_false_path -from [get_pins -hierarchical -filter {NAME =~ *vio*/C}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *vio*/D}]

#set_false_path -from [get_pins -hierarchical -filter {NAME =~ *ila*/C}]
#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *ila*/D}]