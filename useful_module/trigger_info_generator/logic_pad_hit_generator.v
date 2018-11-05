//==================================================================================================
//  Filename      : logic_pad_hit_generator.v
//  Created On    : 2018-10-29 13:22:04
//  Last Modified : 2018-11-05 16:16:19
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module logic_pad_hit_generator(
	input clk,

	input [15:0] pad_matched_map,

	input data_valid_in,

	input [103:0] pad_data_0,
	input [7:0] pad_data_mask_0,
	
	input [103:0] pad_data_1,
	input [7:0] pad_data_mask_1,
	
	input [103:0] pad_data_2,
	input [7:0] pad_data_mask_2,
	
	input [103:0] pad_data_3,
	input [7:0] pad_data_mask_3,

	output  pad_hited,
	output pad_hited_clear
	);

wire [3:0] pad_data_out;
reg  data_valid_out;
pad_data_select pad_data_select_inst[3:0](
	.clk(clk),
	.pad_data({pad_data_3,pad_data_2,pad_data_1,pad_data_0}),
	.pad_data_mask({pad_data_mask_3[6:0],pad_data_mask_2[6:0],pad_data_mask_1[6:0],pad_data_mask_0[6:0]}),
	.pad_data_out(pad_data_out)
	);
always @(posedge clk ) begin
	data_valid_out <= data_valid_in;
end


multi_layer_match multi_layer_match_inst(
	.pad_data(pad_data_out),
	.pad_matched_map(pad_matched_map),
	.pad_matched_out(pad_hited)
	);

assign  pad_hited_clear = pad_hited & data_valid_out;

ila_pad_hit_generator ila_pad_hit_generator_inst (
	.clk(clk), // input wire clk


	.probe0(pad_matched_map), // input wire [15:0]  probe0  
	.probe1(data_valid_in), // input wire [0:0]  probe1 
	.probe2(pad_data_mask_0), // input wire [6:0]  probe2 
	.probe3(pad_data_mask_1), // input wire [6:0]  probe3 
	.probe4(pad_data_mask_2), // input wire [6:0]  probe4
	.probe5(pad_data_mask_3), // input wire [6:0]  probe4
	.probe6(pad_data_0), // input wire [103:0]  probe4
	.probe7(pad_data_1), // input wire [103:0]  probe4
	.probe8(pad_data_2), // input wire [103:0]  probe4
	.probe9(pad_data_3), // input wire [103:0]  probe4
	.probe10(pad_data_out), // input wire [3:0]  probe4
	.probe11(pad_hited), // input wire [0:0]  probe4
	.probe12(pad_hited_clear), // input wire [0:0]  probe4
    .probe13(data_valid_out) // input wire [0:0]  probe4
);
endmodule
