//==================================================================================================
//  Filename      : pad_data_window_syn.v
//  Created On    : 2018-10-29 13:00:57
//  Last Modified : 2018-11-01 11:00:43
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module pad_data_window_syn(
	input clk,
	input [7:0] match_window,
	input [103:0] pad_data,
	input pad_data_valid,
	output reg [103:0] pad_data_syn,
	output reg pad_data_valid_out,
	input pad_hit_clear
	);

reg [103:0] pad_data_r_0,pad_data_r_1,pad_data_r_2,pad_data_r_3;
reg [103:0] pad_data_r_4,pad_data_r_5,pad_data_r_6,pad_data_r_7;

always @(posedge clk ) begin
	if(pad_hit_clear)begin
		pad_data_r_7 <= 104'b0;
		pad_data_r_6 <= 104'b0;
		pad_data_r_5 <= 104'b0;
		pad_data_r_4 <= 104'b0;
		pad_data_r_3 <= 104'b0;
		pad_data_r_2 <= 104'b0;
		pad_data_r_1 <= 104'b0;		
	end else if (pad_data_valid) begin
		pad_data_r_7 <= pad_data_r_6;
		pad_data_r_6 <= pad_data_r_5;
		pad_data_r_5 <= pad_data_r_4;
		pad_data_r_4 <= pad_data_r_3;
		pad_data_r_3 <= pad_data_r_2;
		pad_data_r_2 <= pad_data_r_1;
		pad_data_r_1 <= pad_data_r_0;
		pad_data_r_0 <= pad_data;
	end
end

always @(posedge clk ) begin	
	if(pad_data_valid)begin
		pad_data_syn <= (pad_data_r_7 & {104{match_window[7]}}) | 
						(pad_data_r_6 & {104{match_window[6]}}) | 
						(pad_data_r_5 & {104{match_window[5]}}) | 
						(pad_data_r_4 & {104{match_window[4]}}) | 
						(pad_data_r_3 & {104{match_window[3]}}) | 
						(pad_data_r_2 & {104{match_window[2]}}) | 
						(pad_data_r_1 & {104{match_window[1]}}) | 
						(pad_data_r_0 & {104{match_window[0]}}) ;
	end
end
always @(posedge clk)begin
	pad_data_valid_out <= pad_data_valid;
end

ila_pad_data_window_syn ila_pad_data_window_syn_inst (
	.clk(clk), // input wire clk


	.probe0(pad_data), // input wire [1:0]  probe0  
	.probe1(pad_data_valid), // input wire [0:0]  probe1 
	.probe2(match_window), // input wire [0:0]  probe2 
	.probe3(pad_data_syn), // input wire [8:0]  probe3 
	.probe4(pad_data_valid_out), // input wire [1023:0]  probe4
	.probe5(pad_hit_clear), // input wire [1023:0]  probe4
	.probe6(pad_data_r_0), // input wire [1023:0]  probe4
	.probe7(pad_data_r_1), // input wire [1023:0]  probe4
	.probe8(pad_data_r_2), // input wire [1023:0]  probe4
	.probe9(pad_data_r_3), // input wire [1023:0]  probe4
	.probe10(pad_data_r_4), // input wire [1023:0]  probe4
	.probe11(pad_data_r_5), // input wire [1023:0]  probe4
	.probe12(pad_data_r_6), // input wire [1023:0]  probe4
    .probe13(pad_data_r_7) // input wire [1023:0]  probe4
);

endmodule