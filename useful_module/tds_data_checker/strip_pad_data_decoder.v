//==================================================================================================
//  Filename      : strip_pad_data_decoder.v
//  Created On    : 2018-10-01 10:28:08
//  Last Modified : 2018-10-01 11:26:11
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
`timescale 1ns / 1ps
module strip_pad_data_decoder(
    input [19:0] GTP_data_in,
    input data_clk,
    input data_reset,
    input clk_readout,
    input reset,

    output strip_linked,
    output pad_linked
    );


wire [3:0] strip_state;
wire [9:0] strip_syn_cnt;
wire [4:0] strip_err_cnt;
wire [29:0]strip_data;
wire [18:0] strip_link_message;
deserial_strip_data  deserial_strip_data_inst(
    // User Interface
    .RX_DATA_IN(GTP_data_in),
    // System Interface
    .clk160(clk_readout),
    .USER_CLK(data_clk),
    .SYSTEM_RESET(data_reset),
    .reset_160M(reset),
    .data_out(strip_data),
    .link_message(strip_link_message)
);

check_strip_data   check_strip_data_inst(
    .clk160(clk_readout),
    .strip_data_in(strip_data),
    .link_message(strip_link_message),

    .linked(strip_linked),
    .state(strip_state),
    .syn_cnt(strip_syn_cnt),
    .err_cnt(strip_err_cnt)
);



wire [115:0]pad_data;
wire pad_data_valid;
wire [18:0] pad_link_message;

wire [3:0] pad_state;
wire [9:0] pad_syn_cnt;
wire [4:0] pad_err_cnt;

deserial_pad_data  deserial_pad_data_inst(
    // User Interface
    .RX_DATA_IN(GTP_data_in),
    // System Interface
    .clk160(clk_readout),
    .USER_CLK(data_clk),
    .SYSTEM_RESET(data_reset),
    .reset_160M(reset),
    .data_out(pad_data),
    .data_valid(pad_data_valid),
    .link_message(pad_link_message) 
);

check_pad_data  check_pad_data_inst(
    .clk160(clk_readout),

    .pad_data_in(pad_data),
    .pad_data_valid(pad_data_valid),
    .link_message(pad_link_message),

    .linked(pad_linked),
    .state(pad_state),
    .syn_cnt(pad_syn_cnt),
    .err_cnt(pad_err_cnt)
);
endmodule