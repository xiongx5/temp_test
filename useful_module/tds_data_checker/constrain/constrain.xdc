################################# RefClk master Location constraints #####################

set_property PACKAGE_PIN D18 [get_ports clk_in_40M_n]
set_property PACKAGE_PIN D17 [get_ports clk_in_40M_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_in_40M_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_in_40M_p]

#set_property LOC D18 [get_ports  clk_in_40M_n ]
#set_property LOC D17 [get_ports  clk_in_40M_p ]
set_property PACKAGE_PIN H22 [get_ports trigger_in_n]
set_property PACKAGE_PIN H21 [get_ports trigger_in_p]
set_property IOSTANDARD LVDS_25 [get_ports trigger_in_p]
set_property IOSTANDARD LVDS_25 [get_ports trigger_in_n]

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

#set_false_path -from [get_pins -hierarchical -filter {NAME =~ *ila*/C}]
#set_false_path -to [get_pins -hierarchical -filter {NAME =~ *ila*/D}]


# BCID information
set_property IOSTANDARD LVDS_25 [get_ports trig_d0_p]
set_property PACKAGE_PIN AB24 [get_ports trig_d0_p]
set_property PACKAGE_PIN AC25 [get_ports trig_d0_n]
set_property IOSTANDARD LVDS_25 [get_ports trig_d0_n]

## Band,Phi ID
#set_property IOSTANDARD LVDS_25 [get_ports to_TDS0_DATA1_P]
#set_property PACKAGE_PIN AK20 [get_ports to_TDS0_DATA1_P]
#set_property PACKAGE_PIN AK21 [get_ports to_TDS0_DATA1_N]
#set_property IOSTANDARD LVDS_25 [get_ports to_TDS0_DATA1_N]

# Band,Phi ID
set_property IOSTANDARD LVDS_25 [get_ports trig_d1_p]
set_property PACKAGE_PIN AC22 [get_ports trig_d1_p]
set_property PACKAGE_PIN AD22 [get_ports trig_d1_n]
set_property IOSTANDARD LVDS_25 [get_ports trig_d1_n]

# Pad Trigger Input Enable 
set_property IOSTANDARD LVDS_25 [get_ports  trig_en_p]
set_property PACKAGE_PIN AK23 [get_ports trig_en_p]
set_property PACKAGE_PIN AK24 [get_ports trig_en_n]
set_property IOSTANDARD LVDS_25 [get_ports trig_en_n]

# Pad Trigger 320 MHz CLK
set_property IOSTANDARD LVDS_25 [get_ports  trig_clk_p]
set_property PACKAGE_PIN AE23 [get_ports trig_clk_p]
set_property PACKAGE_PIN AF23 [get_ports trig_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports trig_clk_n]



