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