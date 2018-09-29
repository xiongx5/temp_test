//==================================================================================================
//  Filename      : strip_trigger_gen.v
//  Created On    : 2018-09-29 15:09:43
//  Last Modified : 2018-09-29 20:29:52
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

module strip_trigger_gen(
    input clk_slow,
    input clk_320M,
    input reset,
    input load_input,
    output reg ready,

    input [11:0]  trigger_content_BCID_input,
    input [4:0]   phi_id_input,
    input [7:0]   bandid_input,

    output trig_clk_p,trig_clk_n,
    output trig_en_p, trig_en_n,
    output trig_d0_p,trig_d0_n,
    output trig_d1_p,trig_d1_n
    );


wire [11:0] trigger_content_BCID; reg [11:0] trigger_content_BCID_r;
wire [7:0] bandid; reg [7:0] bandid_r;
wire [4:0] phi_id; reg [7:0] phi_id_r;
wire load;

wire enable_VIO;
wire [11:0] trigger_content_BCID_VIO;
wire [4:0] phi_id_VIO;
wire [7:0] bandid_VIO;
wire load_VIO;
// assign  trigger_content_BCID  = enable_VIO ? trigger_content_BCID_VIO : trigger_content_BCID_input;
// assign  phi_id                = enable_VIO ? phi_id_VIO               : phi_id_input;
// assign  bandid                = enable_VIO ? bandid_VIO               : bandid_input;
// assign  load                  = enable_VIO ? load_VIO                 : load_input;
assign  trigger_content_BCID  = trigger_content_BCID_input;
assign  phi_id                = phi_id_input;
assign  bandid                = bandid_input;
assign  load                  = load_input;

reg [1:0] load_r;
always @(posedge clk_slow or posedge reset) begin
  if (reset) begin
    // reset
    load_r <= 2'b00;
  end else begin
    load_r <= {load_r[0],load};
  end
end
wire start; assign start = ~load_r[1]&load_r[0];
always @(posedge clk_slow) begin
  if(start)begin
    bandid_r <= bandid;
    phi_id_r <= phi_id;
    trigger_content_BCID_r <= trigger_content_BCID;
  end
end


wire  [12:0] band_phi_id ;assign  band_phi_id = {phi_id_r,bandid_r};
wire  [12:0] bcid_extend ;assign  bcid_extend = {trigger_content_BCID_r, 1'b0};
reg [6:0] band_phi_id_even, band_phi_id_odd;
reg [6:0] bcid_extend_even, bcid_extend_odd;
reg [6:0] en_flag_even, en_flag_odd;
reg [1:0]fast_load_r;
always @(posedge clk_320M or posedge reset) begin
  if (reset) begin
    // reset
    fast_load_r <= 2'b00;
  end else begin
    fast_load_r <= {fast_load_r[0],load_r[1]};
  end
end
wire fast_start; assign fast_start = ~fast_load_r[1]&fast_load_r[0];

always @(posedge clk_320M) begin
    if(fast_start) begin
      band_phi_id_even  <= {band_phi_id[12],band_phi_id[10],band_phi_id[8],band_phi_id[6],band_phi_id[4],band_phi_id[2],band_phi_id[0]};
      band_phi_id_odd   <= {band_phi_id[11],band_phi_id[ 9],band_phi_id[7],band_phi_id[5],band_phi_id[3],band_phi_id[1],1'b0};
      bcid_extend_even  <= {bcid_extend[12],bcid_extend[10],bcid_extend[8],bcid_extend[6],bcid_extend[4],bcid_extend[2],bcid_extend[0]};
      bcid_extend_odd   <= {bcid_extend[11],bcid_extend[ 9],bcid_extend[7],bcid_extend[5],bcid_extend[3],bcid_extend[1],1'b0};
      en_flag_even      <= {7'b111_1111};
      en_flag_odd       <= {7'b111_1110};
    end else begin
      band_phi_id_even  <= {band_phi_id_even[5:0],1'b0};
      band_phi_id_odd   <= {band_phi_id_odd[5:0],1'b0};
      bcid_extend_even  <= {bcid_extend_even[5:0],1'b0};
      bcid_extend_odd   <= {bcid_extend_odd[5:0],1'b0}; 
      en_flag_even      <= {en_flag_even[5:0],1'b0};   
      en_flag_odd       <= {en_flag_odd[5:0],1'b0};
    end
  end

always @(posedge clk_320M or posedge reset) begin
  if (reset) begin
    // reset
    ready <= 1'b1;
  end  else if (load_input) begin
    ready <= 1'b0;
  end else if(~en_flag_odd[5]&en_flag_odd[6]) begin
    ready <= 1'b1;
  end
end

ODDR_bus ODDR_bus_trig(
    .clk_320M(clk_320M),
    .en_flag_even(en_flag_even[6]),.en_flag_odd(en_flag_odd[6]),
    .band_phi_id_even(band_phi_id_even[6]),.band_phi_id_odd(band_phi_id_odd[6]),
    .bcid_extend_even(bcid_extend_even[6]), .bcid_extend_odd(bcid_extend_odd[6]),

    .trig_clk_p(trig_clk_p),.trig_clk_n(trig_clk_n),
    .trig_en_p(trig_en_p), .trig_en_n(trig_en_n),
    .trig_d0_p(trig_d0_p),.trig_d0_n(trig_d0_n),
    .trig_d1_p(trig_d1_p),.trig_d1_n(trig_d1_n)
    );


// vio_strip_trigger_gen vio_strip_trigger_gen_inst(
//     .clk(clk_slow),
//     .probe_out0(enable_VIO),//1
//     .probe_out1(trigger_content_BCID_VIO),//12
//     .probe_out2(bandid_VIO),//8
//     .probe_out3(phi_id_VIO),//5
//     .probe_out4(load_VIO)//1
//     );

endmodule
