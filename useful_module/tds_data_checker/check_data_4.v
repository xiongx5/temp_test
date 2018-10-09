//==================================================================================================
//  Filename      : check_data_4.v
//  Created On    : 2018-10-01 10:22:29
//  Last Modified : 2018-10-03 17:43:43
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

module check_data_4(
    input clk_in_40M_p,
    input clk_in_40M_n,
    input GTP_CLK_p,
    input GTP_CLK_n,
    //input GTX_reset,
    input serial_data_in_p_0,
    input serial_data_in_n_0,

    input serial_data_in_p_1,
    input serial_data_in_n_1,

    input serial_data_in_p_2,
    input serial_data_in_n_2,

    input serial_data_in_p_3,
    input serial_data_in_n_3,
	//output linked,
	//output [3:0] state,
	//output [9:0] syn_cnt,
	//output [4:0] err_cnt

    input channel_fifo_s_reset_0,
    input data_tran_stop_0,
    input channel_data_read_0,
    output [119:0] channel_data_0,    
    output [9:0] channel_data_counter_0,

    input channel_fifo_s_reset_1,
    input data_tran_stop_1,
    input channel_data_read_1,
    output [119:0] channel_data_1,    
    output [9:0] channel_data_counter_1,

    input channel_fifo_s_reset_2,
    input data_tran_stop_2,
    input channel_data_read_2,
    output [119:0] channel_data_2,    
    output [9:0] channel_data_counter_2,

    input channel_fifo_s_reset_3,
    input data_tran_stop_3,
    input channel_data_read_3,
    output [119:0] channel_data_3,    
    output [9:0] channel_data_counter_3
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




wire [19:0] GTP_data_out_0,GTP_data_out_1,GTP_data_out_2,GTP_data_out_3;
wire gt0_rx_system_reset_c, gt1_rx_system_reset_c, gt2_rx_system_reset_c, gt3_rx_system_reset_c;
wire data_clk_0,data_clk_1,data_clk_2,data_clk_3;


    GTP_Wrapper_4 GTP_Wrapper_4_inst(
            .GTP_CLK_p             (GTP_CLK_p),
            .GTP_CLK_n             (GTP_CLK_n),

            .serial_data_in_p_0    (serial_data_in_p_0),
            .serial_data_in_n_0    (serial_data_in_n_0),
            .data_clk_0            (data_clk_0),
            .GTP_data_out_0        (GTP_data_out_0),
            
            .serial_data_in_p_1    (serial_data_in_p_1),
            .serial_data_in_n_1    (serial_data_in_n_1),
            .data_clk_1            (data_clk_1),
            .GTP_data_out_1        (GTP_data_out_1),
            
            .serial_data_in_p_2    (serial_data_in_p_2),
            .serial_data_in_n_2    (serial_data_in_n_2),
            .data_clk_2            (data_clk_2),
            .GTP_data_out_2        (GTP_data_out_2),
            
            .serial_data_in_p_3    (serial_data_in_p_3),
            .serial_data_in_n_3    (serial_data_in_n_3),
            .data_clk_3            (data_clk_3),
            .GTP_data_out_3        (GTP_data_out_3),

            .system_clk            (clk40),
            
            .GTX_soft_reset_in     (1'b0),
            
            .gt0_rx_system_reset_c (gt0_rx_system_reset_c),
            .gt1_rx_system_reset_c (gt1_rx_system_reset_c),
            .gt2_rx_system_reset_c (gt2_rx_system_reset_c),
            .gt3_rx_system_reset_c (gt3_rx_system_reset_c)
        );


// wire [3:0] strip_linked,pad_linked;
// wire [119:0] strip_data_3,strip_data_2,strip_data_1,strip_data_0;
// wire strip_empty_3,strip_empty_2,strip_empty_1,strip_empty_0;
// wire [119:0] pad_data_3,pad_data_2,pad_data_1,pad_data_0;
// wire pad_empty_3,pad_empty_2,pad_empty_1,pad_empty_0;
// wire data_read_enable_3,data_read_enable_2,data_read_enable_1,data_read_enable_0;


strip_pad_data_decoder strip_pad_data_decoder_inst[3:0](
    .GTP_data_in({GTP_data_out_3,GTP_data_out_2,GTP_data_out_1,GTP_data_out_0}),
    .data_clk({data_clk_3,data_clk_2,data_clk_1,data_clk_0}),
    .data_reset({gt3_rx_system_reset_c,gt2_rx_system_reset_c,gt1_rx_system_reset_c,gt0_rx_system_reset_c}),
    .clk_readout(clk160),
    .reset(reset),

    .strip_linked(strip_linked),
    .pad_linked(pad_linked),

    // .strip_data_out({strip_data_3,strip_data_2,strip_data_1,strip_data_0}),
    // .strip_empty({strip_empty_3,strip_empty_2,strip_empty_1,strip_empty_0}),
    // .pad_data_out({pad_data_3,pad_data_2,pad_data_1,pad_data_0}),
    // .pad_empty({pad_empty_3,pad_empty_2,pad_empty_1,pad_empty_0}),
    // .data_read_enable({data_read_enable_3,data_read_enable_2,data_read_enable_1,data_read_enable_0}),

    .channel_fifo_s_reset({channel_fifo_s_reset_3,channel_fifo_s_reset_2,channel_fifo_s_reset_1,channel_fifo_s_reset_0}),
    .data_tran_stop({data_tran_stop_3,data_tran_stop_2,data_tran_stop_1,data_tran_stop_0}),
    .channel_data({channel_data_3,channel_data_2,channel_data_1,channel_data_0}),
    .channel_data_read({channel_data_read_3,channel_data_read_2,channel_data_read_1,channel_data_read_0}),
    .channel_data_counter({channel_data_counter_3,channel_data_counter_2,channel_data_counter_1,channel_data_counter_0})


    );


reset_VIO reset_VIO_top (
  .clk(clk160),                // input wire clk
  .probe_out0(reset)  // output wire [0 : 0] probe_out0
);

endmodule