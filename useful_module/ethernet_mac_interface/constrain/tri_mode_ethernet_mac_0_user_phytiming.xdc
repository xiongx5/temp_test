


## If the interface timing constraints cannot be met then these can be relaxed by adjusting the values in this
## xdc file which is set to be processed after all other xdc files
## this also allows for the IODELAY tap delay setting to be adjusted without needing to modify the xdc's
## provided with the core
## All commands in this file can be used directly in the tcl command window if the synthesized or implemented design is open.

# The RGMII receive interface requirement allows a 1ns setup and 1ns hold - this is met but only just so constraints are relaxed
#set_input_delay -clock [get_clocks {trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/U0_rgmii_rx_clk}] -max -1.5 [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
#set_input_delay -clock [get_clocks {trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/U0_rgmii_rx_clk}] -min -2.8 [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
#set_input_delay -clock [get_clocks {trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/U0_rgmii_rx_clk}] -clock_fall -max -1.5 -add_delay [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
#set_input_delay -clock [get_clocks {trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/U0_rgmii_rx_clk}] -clock_fall -min -2.8 -add_delay [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]

# the following properties can be adjusted if requried to adjuct the IO timing
# the value shown is the default used by the IP
# increasing this value will improve the hold timing but will also add jitter.
#set_property IDELAY_VALUE 12 [get_cells {trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/*/rgmii_interface/delay_rgmii_rx* trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/*/rgmii_interface/rxdata_bus[*].delay_rgmii_rx*}]



set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk40]
