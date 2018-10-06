`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2017 01:13:22 PM
// Design Name: 
// Module Name: check_data
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module check_data(
    input clk_in_40M_p,
    input clk_in_40M_n,
    input GTP_CLK_p,
    input GTP_CLK_n,
    //input GTX_reset,
    input serial_data_in_p,
    input serial_data_in_n

	//output linked,
	//output [3:0] state,
	//output [9:0] syn_cnt,
	//output [4:0] err_cnt

    );
wire clk160;
wire clk40;

  clock_master clock_master_inst
   (
   // Clock in ports
    .clk_in1_p(clk_in_40M_p),    // input clk_in1_p
    .clk_in1_n(clk_in_40M_n),    // input clk_in1_n
    // Clock out ports
    .clk_out1(clk40),     // output clk_out1
    .clk_out2(clk160));    // output clk_out2




wire [19:0] GTP_data_out;
wire gt0_rx_system_reset_c;
wire data_clk;
 GTP_Wrapper_X0Y13 GTP_Wrapper_inst(    
    .GTP_CLK_p(GTP_CLK_p),
    .GTP_CLK_n(GTP_CLK_n),
    .serial_data_in_p(serial_data_in_p),
    .serial_data_in_n(serial_data_in_n),
    .data_clk(data_clk),
    .GTP_data_out(GTP_data_out),
    .system_clk(clk40),
    .GTX_soft_reset_in(1'b0),
    .gt0_rx_system_reset_c(gt0_rx_system_reset_c)
    );


wire [29:0]strip_data;
wire [18:0] strip_link_message;
deserial_strip_data  deserial_strip_data_inst(
    // User Interface
    .RX_DATA_IN(GTP_data_out),
    // System Interface
    .clk160(clk160),
    .USER_CLK(data_clk),
    .SYSTEM_RESET(gt0_rx_system_reset_c),
    .reset_160M(reset),
    .data_out(strip_data),
    .link_message(strip_link_message)
);

check_strip_data   check_strip_data_inst(
    .clk160(clk160),
    .strip_data_in(strip_data),
    .link_message(strip_link_message),

    .linked(),
    .state(),
    .syn_cnt(),
    .err_cnt(),

    .data_valid(),
    .data_out()

);



wire [115:0]pad_data;
wire pad_data_valid;
wire [18:0] pad_link_message;


deserial_pad_data  deserial_pad_data_inst(
    // User Interface
    .RX_DATA_IN(GTP_data_out),
    // System Interface
    .clk160(clk160),
    .USER_CLK(data_clk),
    .SYSTEM_RESET(gt0_rx_system_reset_c),
    .reset_160M(reset),
    .data_out(pad_data),
    .data_valid(pad_data_valid),
    .link_message(pad_link_message) 
);

check_pad_data  check_pad_data_inst(
    .clk160(clk160),

    .pad_data_in(pad_data),
    .pad_data_valid(pad_data_valid),
    .link_message(pad_link_message),

    .linked(),
    .state(),
    .syn_cnt(),
    .err_cnt(),

    .data_valid(),
    .data_out()

);

reset_VIO reset_VIO_top (
  .clk(clk160),                // input wire clk
  .probe_out0(reset)  // output wire [0 : 0] probe_out0
);

endmodule
