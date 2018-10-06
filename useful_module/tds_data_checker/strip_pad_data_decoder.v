//==================================================================================================
//  Filename      : strip_pad_data_decoder.v
//  Created On    : 2018-10-01 10:28:08
//  Last Modified : 2018-10-06 11:23:18
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
    input tds_mode, //0 for pad mode, 1 for srtrip mode
    input enable,

    output strip_linked,
    output pad_linked,

    // output [119:0] strip_data_out,
    // output strip_empty,
    // output [119:0] pad_data_out,
    // output pad_empty,
    // output data_read_enable,

    input channel_fifo_s_reset,
    input data_tran_stop,
    output [119:0] channel_data,
    input channel_data_read,
    output [9:0] channel_data_counter,
    output channel_fifo_empty
    );


  wire [3:0] strip_state;
  wire [9:0] strip_syn_cnt;
  wire [4:0] strip_err_cnt;
  wire [29:0]strip_data;
  wire [18:0] strip_link_message;
  wire strip_data_valid_inner;
  wire [103:0] strip_data_inner;
  wire [119:0] strip_data_bridge;
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

  check_strip_data check_strip_data_inst(
      .clk160(clk_readout),
      .strip_data_in(strip_data),
      .link_message(strip_link_message),

      .linked(strip_linked),
      .state(strip_state),
      .syn_cnt(strip_syn_cnt),
      .err_cnt(strip_err_cnt),

      .data_valid(strip_data_valid_inner),
      .data_out(strip_data_inner)
  );

  bridge_fifo strip_bridge_fifo (
    .clk(clk_readout),      // input wire clk
    .srst(reset&tds_mode),    // input wire srst
    .din({16'hffff,strip_data_inner}),      // input wire [119 : 0] din
    .wr_en(strip_data_valid_inner&strip_linked&enable),  // input wire wr_en
    .rd_en(~data_tran_stop),  // input wire rd_en
    .dout(strip_data_bridge),    // output wire [119 : 0] dout
    .full(),    // output wire full
    .empty(strip_empty)  // output wire empty
  );


  wire [115:0]pad_data;
  wire pad_data_valid;
  wire [18:0] pad_link_message;

  wire [3:0] pad_state;
  wire [9:0] pad_syn_cnt;
  wire [4:0] pad_err_cnt;

  wire pad_data_valid_inner;
  wire [115:0] pad_data_inner;
  wire [119:0] pad_data_bridge;
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
      .err_cnt(pad_err_cnt),

      .data_valid(pad_data_valid_inner),
      .data_out(pad_data_inner)
  );

  bridge_fifo pad_bridge_fifo (
    .clk(clk_readout),      // input wire clk
    .srst(reset&~tds_mode),    // input wire srst
    .din({4'b0000,pad_data_inner}),      // input wire [119 : 0] din
    .wr_en(pad_data_valid_inner&pad_linked&enable),  // input wire wr_en
    .rd_en(~data_tran_stop),  // input wire rd_en
    .dout(pad_data_bridge),    // output wire [119 : 0] dout
    .full(),    // output wire full
    .empty(pad_empty)  // output wire empty
  );

  wire bridge_fifo_empty;assign bridge_fifo_empty = tds_mode ? strip_empty : pad_empty;
  wire [119:0] bridge_fifo_data;assign  bridge_fifo_data = tds_mode ? strip_data_bridge : pad_data_bridge;
  wire channel_fifo_write;
  assign channel_fifo_write = ~bridge_fifo_empty & ~data_tran_stop;

  wire channel_data_counter_idle;
  channel_fifo channel_fifo_inst (
    .clk(clk_readout),                // input wire clk
    .srst(channel_fifo_s_reset),              // input wire srst
    .din(bridge_fifo_data),                // input wire [119 : 0] din
    .wr_en(channel_fifo_write),            // input wire wr_en
    .rd_en(channel_data_read),            // input wire rd_en
    .dout(channel_data),              // output wire [119 : 0] dout
    .full(),              // output wire full
    .empty(channel_fifo_empty),            // output wire empty
    .data_count({channel_data_counter_idle,channel_data_counter})  // output wire [10 : 0] data_count
  );


  strip_pad_data_decoder_ila strip_pad_data_decoder_ila_inst (
    .clk(clk_readout), // input wire clk

    .probe0(pad_linked), // input wire [0:0] probe0
    .probe1(pad_data_valid), // input wire [0:0] probe1
    .probe2(pad_data_valid_inner), // input wire [0:0] probe2
    .probe3(data_tran_stop), // input wire [0:0] probe3
    .probe4(pad_empty), // input wire [0:0] probe4
    .probe5(pad_linked), // input wire [0:0] probe5
    .probe6(bridge_fifo_empty), // input wire [0:0] probe6
    .probe7(channel_fifo_write), // input wire [0:0] probe7
    .probe8(channel_data_read), // input wire [0:0] probe8
    .probe9(channel_fifo_empty), // input wire [0:0] probe9
    .probe10(channel_data_counter), // input wire [9:0] prob10
    .probe11(channel_data_read), // input wire [0:0] probe11

    .probe12(pad_data), // input wire [115:0] probe12
    .probe13(pad_data_inner), // input wire [115:0] probe13
    .probe14(bridge_fifo_data), // input wire [119:0] probe14  
    .probe15(channel_data) // input wire [119:0] probe15
  );

endmodule