create_clock -name slow_clock -period 25600 [get_pins -hierarchical -filter {NAME =~ *counter_for_slow_reg[9]/Q}]
set_false_path -from [get_clocks slow_clock] -to [get_clocks clk_out1_clock_master]
set_false_path -from [get_clocks clk_out1_clock_master] -to [get_clocks slow_clock]