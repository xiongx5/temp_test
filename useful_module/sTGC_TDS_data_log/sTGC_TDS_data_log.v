//==================================================================================================
//  Filename      : sTGC_TDS_data_log.v
//  Created On    : 2018-10-03 17:47:24
//  Last Modified : 2018-11-01 16:05:58
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module sTGC_TDS_data_log(
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


    //input         glbl_rst,

    // 200MHz clock input from board
    input         eth_clk_in_p,
    input         eth_clk_in_n,

    output        phy_resetn,
    // RGMII Interface
    //----------------
    output [3:0]  rgmii_txd,
    output        rgmii_tx_ctl,
    output        rgmii_txc,
    input  [3:0]  rgmii_rxd,
    input         rgmii_rx_ctl,
    input         rgmii_rxc,
    
     // MDIO Interface
    //---------------
    inout         mdio,
    output        mdc,

    input trigger_in_p,
    input trigger_in_n,

    output trig_clk_p,trig_clk_n,
    output trig_en_p, trig_en_n,
    output trig_d0_p,trig_d0_n,
    output trig_d1_p,trig_d1_n,

    output reg [4:0] debug_port
);




	wire clk320;
	wire clk160;
	wire clk40;
	
	wire [47:0] D_MAC_add_VIO;
	wire [47:0] S_MAC_add_VIO;
	wire [11:0] counter_th_VIO;
	wire [15:0] idle_counter_number_th_VIO;

	wire [3:0] data_valid_flag;
    wire trigger;

	
	clock_master clock_master_inst(
	 // Clock in ports
	  .clk_in1_p(clk_in_40M_p),    // input clk_in1_p
	  .clk_in1_n(clk_in_40M_n),    // input clk_in1_n
	  // Clock out ports
	  .clk_out1(clk40),     // output clk_out1
	  .clk_out2(clk160),// output clk_out2
	  .clk_out3(clk320)// output clk_out3
	  );    


	wire enable_trigger_VIO;
	wire [9:0] trigger_width_VIO;
	wire enbale_trigger_VIO;
	wire [7:0] trigger_index;
	wire cycle_tick;
	wire debug_enable_trigger;
	//wire trigger;
	trigger_process inst_trigger_process(
		.clk            (clk160),
		.trigger_in_p   (trigger_in_p),
		.trigger_in_n   (trigger_in_n),
		.trigger_width  (trigger_width_VIO),
		.enbale_trigger (enbale_trigger_VIO),
		.trigger        (trigger),
		.trigger_index  (trigger_index),
		.cycle_tick		(cycle_tick),
		.debug_enable   (debug_enable_trigger)
	);



	always @(posedge clk160) begin
		debug_port <= {trigger,data_valid_flag};
	end
    wire debug_for_enable;
	// always@(*)begin
	//    debug_port = {debug_for_enable,debug_for_enable,debug_for_enable,debug_for_enable,debug_for_enable};
	// end
	
	
	wire reset_VIO;
	wire TDS_mode_VIO; //0 for pad mode, 1 for srtrip mode
	wire [3:0] enable_VIO;
    wire channel_fifo_s_reset_0;
    wire data_tran_stop_0;
    wire channel_data_read_0;
    wire  [119:0] channel_data_0;
    wire  [9:0] channel_data_counter_0;

    wire channel_fifo_s_reset_1;
    wire data_tran_stop_1;
    wire channel_data_read_1;
    wire  [119:0] channel_data_1;
    wire  [9:0] channel_data_counter_1;

    wire channel_fifo_s_reset_2;
    wire data_tran_stop_2;
    wire channel_data_read_2;
    wire  [119:0] channel_data_2;
    wire  [9:0] channel_data_counter_2;

    wire channel_fifo_s_reset_3;
    wire data_tran_stop_3;
    wire channel_data_read_3;
    wire  [119:0] channel_data_3;
    wire  [9:0] channel_data_counter_3;

    wire [3:0] channel_linked;

    wire [119:0] debug_statistic_port_3,debug_statistic_port_2,debug_statistic_port_1,debug_statistic_port_0;

    wire [115:0] pad_data_3,pad_data_2,pad_data_1,pad_data_0;
    wire pad_data_valid_3,pad_data_valid_2,pad_data_valid_1,pad_data_valid_0;

	channel_data_4 inst_channel_data_4		(
			.GTP_CLK_p              (GTP_CLK_p),
			.GTP_CLK_n              (GTP_CLK_n),

			.clk40                  (clk40),
			.clk160                 (clk160),

			.reset                  (reset_VIO),

			.serial_data_in_p_0     (serial_data_in_p_0),
			.serial_data_in_n_0     (serial_data_in_n_0),
			.serial_data_in_p_1     (serial_data_in_p_1),
			.serial_data_in_n_1     (serial_data_in_n_1),
			.serial_data_in_p_2     (serial_data_in_p_2),
			.serial_data_in_n_2     (serial_data_in_n_2),
			.serial_data_in_p_3     (serial_data_in_p_3),
			.serial_data_in_n_3     (serial_data_in_n_3),

			.tds_mode               (TDS_mode_VIO),
			.enable					(enable_VIO&{4{trigger}}),

			.channel_linked         (channel_linked),
			.data_valid_flag		(data_valid_flag),

			.channel_fifo_s_reset_0 (channel_fifo_s_reset_0),
			.data_tran_stop_0       (data_tran_stop_0),
			.channel_data_read_0    (channel_data_read_0),
			.channel_data_0         (channel_data_0),
			.channel_data_counter_0 (channel_data_counter_0),
			.channel_fifo_empty_0   (channel_fifo_empty_0),
    		.pad_data_0             (pad_data_0),
    		.pad_data_valid_0		(pad_data_valid_0),
			.debug_statistic_port_0 (debug_statistic_port_0),

			.channel_fifo_s_reset_1 (channel_fifo_s_reset_1),
			.data_tran_stop_1       (data_tran_stop_1),
			.channel_data_read_1    (channel_data_read_1),
			.channel_data_1         (channel_data_1),
			.channel_data_counter_1 (channel_data_counter_1),
			.channel_fifo_empty_1   (channel_fifo_empty_1),
			.pad_data_1             (pad_data_1),
    		.pad_data_valid_1		(pad_data_valid_1),
			.debug_statistic_port_1 (debug_statistic_port_1),

			.channel_fifo_s_reset_2 (channel_fifo_s_reset_2),
			.data_tran_stop_2       (data_tran_stop_2),
			.channel_data_read_2    (channel_data_read_2),
			.channel_data_2         (channel_data_2),
			.channel_data_counter_2 (channel_data_counter_2),
			.channel_fifo_empty_2   (channel_fifo_empty_2),
			.pad_data_2             (pad_data_2),
    		.pad_data_valid_2		(pad_data_valid_2),
			.debug_statistic_port_2 (debug_statistic_port_2),

			.channel_fifo_s_reset_3 (channel_fifo_s_reset_3),
			.data_tran_stop_3       (data_tran_stop_3),
			.channel_data_read_3    (channel_data_read_3),
			.channel_data_3         (channel_data_3),
			.channel_data_counter_3 (channel_data_counter_3),
			.channel_fifo_empty_3   (channel_fifo_empty_3),
			.pad_data_3             (pad_data_3),
    		.pad_data_valid_3		(pad_data_valid_3),
			.debug_statistic_port_3 (debug_statistic_port_3)
		);





    wire [7:0]  tx_axis_fifo_tdata;
    wire 		tx_axis_fifo_tvalid;
    wire  		tx_axis_fifo_tready;
    wire  		tx_axis_fifo_tlast;

	wire [7:0] rx_axis_fifo_tdata;
	wire rx_axis_fifo_tvalid; 
	wire rx_axis_fifo_tready;assign rx_axis_fifo_tready = 1'b1;
	wire rx_axis_fifo_tlast;
	wire gtx_clk_bufg_out;

	wire debug_enable_VIO;
	readout_control inst_readout_control(
			.clk                    (clk160),
			.reset                  (reset_VIO),
			.mac_clk                (gtx_clk_bufg_out),

			.D_MAC_add              (D_MAC_add_VIO),
			.S_MAC_add              (S_MAC_add_VIO),

			.counter_th             (counter_th_VIO),
			.idle_counter_number_th (idle_counter_number_th_VIO),
			.debug_enable			(debug_enable_VIO&debug_enable_trigger),
			.cycle_tick				(cycle_tick),
			.trigger_index			(trigger_index),


			.channel_linked         ({4'b0000,channel_linked}),

			.tx_axis_fifo_tdata     (tx_axis_fifo_tdata),
			.tx_axis_fifo_tvalid    (tx_axis_fifo_tvalid),
			.tx_axis_fifo_tready    (tx_axis_fifo_tready),
			.tx_axis_fifo_tlast     (tx_axis_fifo_tlast),

			.channel_fifo_s_reset_0 (channel_fifo_s_reset_0),
			.data_tran_stop_0       (data_tran_stop_0),
			.channel_data_read_0    (channel_data_read_0),
			.channel_data_0         (channel_data_0),
			.channel_data_counter_0 (channel_data_counter_0),
			.channel_fifo_empty_0   (channel_fifo_empty_0),

			.channel_fifo_s_reset_1 (channel_fifo_s_reset_1),
			.data_tran_stop_1       (data_tran_stop_1),
			.channel_data_read_1    (channel_data_read_1),
			.channel_data_1         (channel_data_1),
			.channel_data_counter_1 (channel_data_counter_1),
			.channel_fifo_empty_1   (channel_fifo_empty_1),

			.channel_fifo_s_reset_2 (channel_fifo_s_reset_2),
			.data_tran_stop_2       (data_tran_stop_2),
			.channel_data_read_2    (channel_data_read_2),
			.channel_data_2         (channel_data_2),
			.channel_data_counter_2 (channel_data_counter_2),
			.channel_fifo_empty_2   (channel_fifo_empty_2),

			.channel_fifo_s_reset_3 (channel_fifo_s_reset_3),
			.data_tran_stop_3       (data_tran_stop_3),
			.channel_data_read_3    (channel_data_read_3),
			.channel_data_3         (channel_data_3),
			.channel_data_counter_3 (channel_data_counter_3),
			.channel_fifo_empty_3   (channel_fifo_empty_3),

			.channel_fifo_s_reset_4 (),
			.data_tran_stop_4       (),
			.channel_data_read_4    (),
			.channel_data_4         ('b0 ),
			.channel_data_counter_4 ('b0 ),
			.channel_fifo_empty_4   (1'b1),
			.channel_fifo_s_reset_5 (),
			.data_tran_stop_5       (),
			.channel_data_read_5    (),
			.channel_data_5         ('b0 ),
			.channel_data_counter_5 ('b0 ),
			.channel_fifo_empty_5   (1'b1),
			.channel_fifo_s_reset_6 (),
			.data_tran_stop_6       (),
			.channel_data_read_6    (),
			.channel_data_6         ('b0 ),
			.channel_data_counter_6 ('b0 ),
			.channel_fifo_empty_6   (1'b1),
			.channel_fifo_s_reset_7 (),
			.data_tran_stop_7       (),
			.channel_data_read_7    (),
			.channel_data_7         ('b0 ),
			.channel_data_counter_7 ('b0 ),
			.channel_fifo_empty_7   (1'b1)
		);



	ethernet_mac_interface ethernet_mac_interface_inst(
		.glbl_rst            (reset_VIO),
		.clk_in_p        (eth_clk_in_p),
		.clk_in_n        (eth_clk_in_n),
		.gtx_clk_bufg_out    (gtx_clk_bufg_out),
		.phy_resetn          (phy_resetn),
		.rgmii_txd           (rgmii_txd),
		.rgmii_tx_ctl        (rgmii_tx_ctl),
		.rgmii_txc           (rgmii_txc),
		.rgmii_rxd           (rgmii_rxd),
		.rgmii_rx_ctl        (rgmii_rx_ctl),
		.rgmii_rxc           (rgmii_rxc),
		
		.mdio(mdio),
        .mdc(mdc),
		.rx_axis_fifo_tdata  (rx_axis_fifo_tdata),
		.rx_axis_fifo_tvalid (rx_axis_fifo_tvalid),
		.rx_axis_fifo_tready (rx_axis_fifo_tready),
		.rx_axis_fifo_tlast  (rx_axis_fifo_tlast),
		.tx_axis_fifo_tdata  (tx_axis_fifo_tdata),
		.tx_axis_fifo_tvalid (tx_axis_fifo_tvalid),
		.tx_axis_fifo_tready (tx_axis_fifo_tready),
		.tx_axis_fifo_tlast  (tx_axis_fifo_tlast));



//	wire tick;
//	reg  hit_statistic;
//	wire hit_mask;
//	wire start_VIO;
//	wire reset_40_VIO;
//	wire statistic_ready_VIO;
//	wire [19:0] count_out_VIO;
//	wire [19:0] windows_VIO;
	
//	slow_tick_generator inst_slow_tick_generator (.clk40M(clk40), .windows(windows_VIO), .tick(tick));
//	hit_statistic_module inst_hit_statistic_module		(
//			.clk40M    (clk40),
//			.reset     (reset_40_VIO),
//			.tick      (tick),
//			.hit       (hit_statistic),
//			.start     (start_VIO),
//			.ready     (statistic_ready_VIO),
//			.count_out (count_out_VIO),
//			.debug     (debug_for_enable)
//		);
//	wire [3:0] tds_select_VIO;
//	wire [103:0] channel_select_VIO;
//	reg  [103:0] debug_statistic_port_3_r,debug_statistic_port_2_r,debug_statistic_port_1_r,debug_statistic_port_0_r;

//	always @(posedge clk40 ) begin
//		debug_statistic_port_3_r <= channel_select_VIO & debug_statistic_port_3[103:0] & {103{tds_select_VIO[3]}};
//		debug_statistic_port_2_r <= channel_select_VIO & debug_statistic_port_2[103:0] & {103{tds_select_VIO[2]}};
//		debug_statistic_port_1_r <= channel_select_VIO & debug_statistic_port_1[103:0] & {103{tds_select_VIO[1]}};
//		debug_statistic_port_0_r <= channel_select_VIO & debug_statistic_port_0[103:0] & {103{tds_select_VIO[0]}};
//		hit_statistic  <= (|debug_statistic_port_3_r)|(|debug_statistic_port_2_r)|(|debug_statistic_port_1_r)|(|debug_statistic_port_0_r);
//	end


	
	control_VIO control_VIO_top (
	  .clk(clk160),                // input wire clk
	  .probe_out0(reset_VIO),  // output wire [0 : 0] probe_out0
	  .probe_out1(TDS_mode_VIO), //output wire [0 : 0] probe_out1
	  .probe_out2(enable_VIO),//output wire [3 : 0] probe_out2
	  .probe_out3(D_MAC_add_VIO),//output wire [47 : 0] probe_out3
	  .probe_out4(S_MAC_add_VIO),//output wire [47 : 0] probe_out4
	  .probe_out5(counter_th_VIO),//output wire [11 : 0] probe_out5
	  .probe_out6(idle_counter_number_th_VIO),//output wire [15 : 0] probe_out6
	  .probe_out7(debug_enable_VIO),//output wire [0 : 0] probe_out7
	  .probe_out8(enbale_trigger_VIO),//output wire [0 : 0] probe_out8
	  .probe_out9(trigger_width_VIO)//output wire [9 : 0] probe_out9
	);

//	statistic_VIO statistic_VIO_top (
//	  .clk(clk40),                // input wire clk
//	  .probe_in0(statistic_ready_VIO),//input wire [0 : 0] probe_in0
//	  .probe_in1(count_out_VIO),//input wire [19 : 0] probe_in1
//	  .probe_out0(start_VIO),  // output wire [0 : 0] probe_out0
//	  .probe_out1(reset_40_VIO), //output wire [0 : 0] probe_out1
//	  .probe_out2(windows_VIO), //output wire [19 : 0] probe_out2
//	  .probe_out3(tds_select_VIO),//output wire [3 : 0] probe_out3
//	  .probe_out4(channel_select_VIO)//output wire [115: 0] probe_out4
//	);


	trigger_match_monitor trigger_match_monitor_inst (
		.clk(clk160), // input wire clk
	
	
		.probe0(trigger), // input wire [0:0]  probe0  
		.probe1(data_valid_flag) // input wire [3:0]  probe1 
	);

	strip_trigger_info_generator inst_strip_trigger_info_generator(
			.clk              (clk160),
			.clk320M          (clk320),
			.reset            (reset_VIO),
			.pad_data_3       (pad_data_3 & {120{channel_linked[3]}}),
			.pad_data_valid_3 (pad_data_valid_3),
			.pad_data_2       (pad_data_2),
			.pad_data_valid_2 (pad_data_valid_2 & {120{channel_linked[2]}}),
			.pad_data_1       (pad_data_1),
			.pad_data_valid_1 (pad_data_valid_1 & {120{channel_linked[1]}}),
			.pad_data_0       (pad_data_0),
			.pad_data_valid_0 (pad_data_valid_0 & {120{channel_linked[0]}}),
			.trig_clk_p       (trig_clk_p),
			.trig_clk_n       (trig_clk_n),
			.trig_en_p        (trig_en_p),
			.trig_en_n        (trig_en_n),
			.trig_d0_p        (trig_d0_p),
			.trig_d0_n        (trig_d0_n),
			.trig_d1_p        (trig_d1_p),
			.trig_d1_n        (trig_d1_n)
		);



endmodule