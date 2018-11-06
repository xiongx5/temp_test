//==================================================================================================
//  Filename      : strip_trigger_info_generator.v
//  Created On    : 2018-10-29 11:56:48
//  Last Modified : 2018-11-05 16:13:15
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module strip_trigger_info_generator(
	input clk,
	input clk320M,
	input reset,

	input [115:0] pad_data_3,
	input pad_data_valid_3,

	input [115:0] pad_data_2,
	input pad_data_valid_2,

	input [115:0] pad_data_1,
	input pad_data_valid_1,

	input [115:0] pad_data_0,
	input pad_data_valid_0,

    output trig_clk_p,trig_clk_n,
    output trig_en_p, trig_en_n,
    output trig_d0_p,trig_d0_n,
    output trig_d1_p,trig_d1_n
);

wire [115:0] pad_data_3_aligned,pad_data_2_aligned,pad_data_1_aligned,pad_data_0_aligned;
wire pad_data_valid;
wire [3:0] bcid_select_VIO;
wire [11:0] bcid;
	tds_link_latency_alignment inst_tds_link_latency_alignment
		(
			.clk                (clk),
			.pad_data_3         (pad_data_3),
			.pad_data_valid_3   (pad_data_valid_3),
			.pad_data_3_aligned (pad_data_3_aligned),
			.pad_data_2         (pad_data_2),
			.pad_data_valid_2   (pad_data_valid_2),
			.pad_data_2_aligned (pad_data_2_aligned),
			.pad_data_1         (pad_data_1),
			.pad_data_valid_1   (pad_data_valid_1),
			.pad_data_1_aligned (pad_data_1_aligned),
			.pad_data_0         (pad_data_0),
			.pad_data_valid_0   (pad_data_valid_0),
			.pad_data_0_aligned (pad_data_0_aligned),
			.pad_data_valid_out (pad_data_valid),

			.bcid_select        (bcid_select_VIO),
			.bcid               (bcid)
		);


wire [7:0] trigger_match_window_VIO;
wire [103:0] pad_data_syn_3,pad_data_syn_2,pad_data_syn_1,pad_data_syn_0;
wire [3:0] pad_data_valid_syn;
wire [127:0] pad_hit_clear;
	pad_data_window_syn inst_pad_data_window_syn[3:0]
		(
			.clk            (clk),
			.match_window   (trigger_match_window_VIO),
			.pad_data       ({pad_data_3_aligned[103:0],pad_data_2_aligned[103:0],pad_data_1_aligned[103:0],pad_data_0_aligned[103:0]}),
			.pad_data_valid (pad_data_valid),
			.pad_data_syn   ({pad_data_syn_3,pad_data_syn_2,pad_data_syn_1,pad_data_syn_0}),
			.pad_data_valid_out(pad_data_valid_syn),
			.pad_hit_clear(|pad_hit_clear)
		);

wire [127:0] logic_pad_hited;

wire [1023:0] pad_data_mask_3;
wire [1023:0] pad_data_mask_2;
wire [1023:0] pad_data_mask_1;
wire [1023:0] pad_data_mask_0;

wire [15:0] pad_matched_map_VIO;


//logic_pad_hit_generator logic_pad_hit_generator[127:0](
logic_pad_hit_generator logic_pad_hit_generator[1:0](
	.clk(clk),

	.pad_matched_map(pad_matched_map_VIO),

	.data_valid_in(|pad_data_valid_syn),

	.pad_data_0(pad_data_syn_0),
	.pad_data_mask_0(pad_data_mask_0[15:0]),
	
	.pad_data_1(pad_data_syn_1),
	.pad_data_mask_1(pad_data_mask_1[15:0]),
	
	.pad_data_2(pad_data_syn_2),
	.pad_data_mask_2(pad_data_mask_2[15:0]),
	
	.pad_data_3(pad_data_syn_3),
	.pad_data_mask_3(pad_data_mask_3[15:0]),

	.pad_hited(logic_pad_hited[1:0]),
	.pad_hited_clear(pad_hit_clear[1:0])
	);

wire [7:0] band_id;
wire data_ready;
logic_pad_to_band_id inst_logic_pad_to_band_id	(
			.clk             (clk),
			.logic_pad_hited (logic_pad_hited),
			.band_id         (band_id),
			.data_ready      (data_ready)
		);

wire [7:0] pad_mask_data_0_VIO,pad_mask_data_1_VIO,pad_mask_data_2_VIO,pad_mask_data_3_VIO;
wire wea_0_VIO,wea_1_VIO,wea_2_VIO,wea_3_VIO;
wire [8:0] addr_0,addr_1,addr_2,addr_3;
wire [7:0] ram_dout_0,ram_dout_1,ram_dout_2,ram_dout_3;
wire lut_ram_busy_0_VIO,lut_ram_busy_1_VIO,lut_ram_busy_2_VIO,lut_ram_busy_3_VIO;
wire start_0_VIO,start_1_VIO,start_2_VIO,start_3_VIO;
wire [8:0] addr_0_data_serial,addr_0_data_VIO; assign  addr_0 = wea_0_VIO ? addr_0_data_VIO : addr_0_data_serial;
wire [8:0] addr_1_data_serial,addr_1_data_VIO; assign  addr_1 = wea_1_VIO ? addr_1_data_VIO : addr_1_data_serial;
wire [8:0] addr_2_data_serial,addr_2_data_VIO; assign  addr_2 = wea_2_VIO ? addr_2_data_VIO : addr_2_data_serial;
wire [8:0] addr_3_data_serial,addr_3_data_VIO; assign  addr_3 = wea_3_VIO ? addr_3_data_VIO : addr_3_data_serial;


pad_mask_0 pad_mask_0_inst (
  .clka(clk),    // input wire clka
  .wea(wea_0_VIO),      // input wire [0 : 0] wea
  .addra(addr_0),  // input wire [8 : 0] addra
  .dina(pad_mask_data_0_VIO),    // input wire [7 : 0] dina
  .douta(ram_dout_0)  // output wire [7 : 0] douta
);

pad_mask_1 pad_mask_1_inst (
  .clka(clk),    // input wire clka
  .wea(wea_1_VIO),      // input wire [0 : 0] wea
  .addra(addr_1),  // input wire [8 : 0] addra
  .dina(pad_mask_data_1_VIO),    // input wire [7 : 0] dina
  .douta(ram_dout_1)  // output wire [7 : 0] douta
);

pad_mask_2 pad_mask_2_inst (
  .clka(clk),    // input wire clka
  .wea(wea_2_VIO),      // input wire [0 : 0] wea
  .addra(addr_2),  // input wire [8 : 0] addra
  .dina(pad_mask_data_2_VIO),    // input wire [7 : 0] dina
  .douta(ram_dout_2)  // output wire [7 : 0] douta
);

pad_mask_3 pad_mask_3_inst (
  .clka(clk),    // input wire clka
  .wea(wea_3_VIO),      // input wire [0 : 0] wea
  .addra(addr_3),  // input wire [8 : 0] addra
  .dina(pad_mask_data_3_VIO),    // input wire [7 : 0] dina
  .douta(ram_dout_3)  // output wire [7 : 0] douta
);

bram_data_serial
#(.DATA_WIDTH(8) , .REAL_DEPTH (128) )
bram_data_serial_inst[3:0]
(
	.clk(clk),
	.start({start_3_VIO,start_2_VIO,start_1_VIO,start_0_VIO}),
	
	.data_in({ram_dout_3,ram_dout_2,ram_dout_1,ram_dout_0}),
	.adder({addr_3_data_serial,addr_2_data_serial,addr_1_data_serial,addr_0_data_serial}),
	.data_out({pad_data_mask_3,pad_data_mask_2,pad_data_mask_1,pad_data_mask_0}),
	.busy({lut_ram_busy_3_VIO,lut_ram_busy_2_VIO,lut_ram_busy_1_VIO,lut_ram_busy_0_VIO})
);

pad_mask_VIO pad_mask_VIO_inst (  
  .clk(clk),                  // input wire clk

  .probe_in0(lut_ram_busy_0_VIO),      // input wire [255 : 0] probe_in3
  .probe_in1(lut_ram_busy_1_VIO),      // input wire [255 : 0] probe_in3
  .probe_in2(lut_ram_busy_2_VIO),      // input wire [255 : 0] probe_in3
  .probe_in3(lut_ram_busy_3_VIO),      // input wire [255 : 0] probe_in3

  .probe_out0(wea_0_VIO),    // output wire [0 : 0] probe_out0
  .probe_out1(addr_0_data_VIO),    // output wire [8 : 0] probe_out1
  .probe_out2(pad_mask_data_0_VIO),    // output wire [7 : 0] probe_out2
  .probe_out3(start_0_VIO),    // output wire [0 : 0] probe_out3


  .probe_out4(wea_1_VIO),    // output wire [0 : 0] probe_out4
  .probe_out5(addr_1_data_VIO),    // output wire [8 : 0] probe_out5
  .probe_out6(pad_mask_data_1_VIO),    // output wire [7 : 0] probe_out6
  .probe_out7(start_1_VIO),    // output wire [0 : 0] probe_out7


  .probe_out8(wea_2_VIO),  // output wire [0 : 0] probe_out8
  .probe_out9(addr_2_data_VIO),  // output wire [8 : 0] probe_out9
  .probe_out10(pad_mask_data_2_VIO),  // output wire [7 : 0] probe_out10
  .probe_out11(start_2_VIO),  // output wire [0 : 0] probe_out11


  .probe_out12(wea_3_VIO),  // output wire [0 : 0] probe_out12
  .probe_out13(addr_3_data_VIO),  // output wire [8 : 0] probe_out13
  .probe_out14(pad_mask_data_3_VIO),  // output wire [7 : 0] probe_out14
  .probe_out15(start_3_VIO)  // output wire [0 : 0] probe_out15

);

reg [1:0] count_for_160M = 2'b00;

always @(posedge clk) begin
	count_for_160M <= count_for_160M + 2'b1;
end

reg [11:0] bcid_r;
reg [7:0]  band_id_r;
reg load_r;
always @(posedge clk) begin
	if(&count_for_160M)begin
		bcid_r <= bcid;
		band_id_r <= band_id;
		load_r <= data_ready;
	end else begin
		load_r <= 1'b0;
	end
end
wire [4:0] phi_id_VIO;

	strip_trigger_gen inst_strip_trigger_gen
		(
			.clk_slow                   (clk),
			.clk_320M                   (clk320M),
			.reset                      (reset),
			.load_input                 (load_r),
			.ready                      (),
			.trigger_content_BCID_input (bcid_r),
			.phi_id_input               (phi_id_VIO),
			.bandid_input               (band_id_r),
			.trig_clk_p                 (trig_clk_p),
			.trig_clk_n                 (trig_clk_n),
			.trig_en_p                  (trig_en_p),
			.trig_en_n                  (trig_en_n),
			.trig_d0_p                  (trig_d0_p),
			.trig_d0_n                  (trig_d0_n),
			.trig_d1_p                  (trig_d1_p),
			.trig_d1_n                  (trig_d1_n)
		);

other_VIO other_VIO_inst (
  .clk(clk),                  // input wire clk
  .probe_out0(bcid_select_VIO),      // output wire [2 : 0] probe_out0
  .probe_out1(phi_id_VIO),      // output wire [5 : 0] probe_out1
  .probe_out2(trigger_match_window_VIO),
  .probe_out3(pad_matched_map_VIO)
);

ila_strip_info ila_strip_info_inst (
	.clk(clk), // input wire clk


	.probe0(bcid_r), // input wire [11:0]  probe0  
	.probe1(band_id_r), // input wire [7:0]  probe1 
	.probe2(load_r), // input wire [0:0]  probe2 
	.probe3(pad_data_0_aligned), // input wire [115:0]  probe3 
	.probe4(pad_data_1_aligned), // input wire [115:0]  probe3 
	.probe5(pad_data_2_aligned), // input wire [115:0]  probe3 
	.probe6(pad_data_3_aligned) // input wire [115:0]  probe3 	
);



endmodule 
