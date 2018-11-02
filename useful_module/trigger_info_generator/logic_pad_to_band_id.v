//==================================================================================================
//  Filename      : logic_pad_to_band_id.v
//  Created On    : 2018-10-30 20:29:22
//  Last Modified : 2018-11-01 18:07:44
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module logic_pad_to_band_id(
	input clk,
	input [127:0] logic_pad_hited,
	output [7:0] band_id,
	output reg data_ready
	);
wire [8:0] logic_pad_hited_encoded;
wire data_ready_inner;
priority_encoder priority_encoder_inst(
	.clk(clk),
	.data_in(logic_pad_hited),
	.data_out(logic_pad_hited_encoded),
	.data_ready(data_ready_inner)
	);
always @(posedge clk) begin
	data_ready <= data_ready_inner;
end 


wire wea_VIO;
wire [8:0]lut_addr_VIO;
wire [8:0] lut_addr;assign lut_addr = wea_VIO ? lut_addr_VIO : {1'b0,logic_pad_hited_encoded};
wire [7:0] lut_data_in_VIO;
band_id_lut band_id_lut_inst (
  .clka(clk),    // input wire clka
  .wea(wea_VIO),      // input wire [0 : 0] wea
  .addra(lut_addr),  // input wire [8 : 0] addra
  .dina(lut_data_in_VIO),    // input wire [7 : 0] dina
  .douta(band_id)  // output wire [7 : 0] douta
);
band_id_lut_VIO band_id_lut_VIO_inst (
  .clk(clk),                // input wire clk
  .probe_out0(wea_VIO),  // output wire [0 : 0] probe_out0
  .probe_out1(lut_data_in_VIO),  // output wire [7 : 0] probe_out1
  .probe_out2(lut_addr_VIO)  // output wire [8 : 0] probe_out2
);


endmodule      