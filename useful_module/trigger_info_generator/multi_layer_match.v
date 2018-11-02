//==================================================================================================
//  Filename      : multi_layer_match.v
//  Created On    : 2018-10-29 14:19:50
//  Last Modified : 2018-11-01 18:24:04
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module multi_layer_match(
	input [3:0] pad_data,
	input [15:0] pad_matched_map,
	output pad_matched_out
	);
reg pad_matched;
always @(*) begin
	case(pad_data)
	4'd0 : pad_matched <= pad_matched_map[0];
	4'd1 : pad_matched <= pad_matched_map[1];
	4'd2 : pad_matched <= pad_matched_map[2];
	4'd3 : pad_matched <= pad_matched_map[3];
	4'd4 : pad_matched <= pad_matched_map[4];
	4'd5 : pad_matched <= pad_matched_map[5];
	4'd6 : pad_matched <= pad_matched_map[6];
	4'd7 : pad_matched <= pad_matched_map[7];
	4'd8 : pad_matched <= pad_matched_map[8];
	4'd9 : pad_matched <= pad_matched_map[9];
	4'd10: pad_matched <= pad_matched_map[10];
	4'd11: pad_matched <= pad_matched_map[11];
	4'd12: pad_matched <= pad_matched_map[12];
	4'd13: pad_matched <= pad_matched_map[13];
	4'd14: pad_matched <= pad_matched_map[14];
	4'd15: pad_matched <= pad_matched_map[15];
	default: pad_matched <= 1'b0;
	endcase
end
assign pad_matched_out = pad_matched;
endmodule