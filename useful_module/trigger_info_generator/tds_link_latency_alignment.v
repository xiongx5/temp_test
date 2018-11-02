//==================================================================================================
//  Filename      : tds_link_latency_alignment.v
//  Created On    : 2018-10-31 18:07:20
//  Last Modified : 2018-11-01 17:58:40
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module tds_link_latency_alignment(
	input clk,

	input [115:0] pad_data_3,
	input pad_data_valid_3,
	output reg [115:0] pad_data_3_aligned,

	input [115:0] pad_data_2,
	input pad_data_valid_2,
	output reg [115:0] pad_data_2_aligned,

	input [115:0] pad_data_1,
	input pad_data_valid_1,
	output reg [115:0] pad_data_1_aligned,

	input [115:0] pad_data_0,
	input pad_data_valid_0,
	output reg [115:0] pad_data_0_aligned,

	output reg pad_data_valid_out,
	
	input [2:0] bcid_select,
	output reg [11:0] bcid

	);
reg [115:0] pad_data_0_0,pad_data_0_1,pad_data_0_2,pad_data_0_3,pad_data_0_4;
reg [115:0] pad_data_1_0,pad_data_1_1,pad_data_1_2,pad_data_1_3,pad_data_1_4;
reg [115:0] pad_data_2_0,pad_data_2_1,pad_data_2_2,pad_data_2_3,pad_data_2_4;
reg [115:0] pad_data_3_0,pad_data_3_1,pad_data_3_2,pad_data_3_3,pad_data_3_4;
reg [115:0] pad_data__0,pad_data__1,pad_data__2,pad_data__3,pad_data__4;

wire [1:0] ref_TDS_select_VIO;
reg pad_data_valid;
always @(*) begin
	case(ref_TDS_select_VIO)
		2'b00: pad_data_valid = pad_data_valid_0;
		2'b01: pad_data_valid = pad_data_valid_1; 
		2'b10: pad_data_valid = pad_data_valid_2; 
		2'b11: pad_data_valid = pad_data_valid_3; 
	endcase
end

always @(posedge clk ) begin
	pad_data_valid_out <= pad_data_valid;
end

always @(posedge clk) begin
	if(pad_data_valid)begin
		pad_data__4 <= pad_data__3;
		pad_data__3 <= pad_data__2;
		pad_data__2 <= pad_data__1;
		pad_data__1 <= pad_data__0;
		case(ref_TDS_select_VIO)
			2'b00: pad_data__0 <= pad_data_0; 
			2'b01: pad_data__0 <= pad_data_1;
			2'b10: pad_data__0 <= pad_data_2;
			2'b11: pad_data__0 <= pad_data_3;
		endcase
	end
end

always @(*) begin
	if (bcid_select == 3'd0) begin
		bcid = pad_data__0[115:104];
	end else if (bcid_select == 3'd1) begin
		bcid = pad_data__1[115:104];
	end else if (bcid_select == 3'd2) begin
		bcid = pad_data__2[115:104];
	end else if (bcid_select == 3'd3) begin
		bcid = pad_data__3[115:104];
	end else if (bcid_select == 3'd4) begin
		bcid = pad_data__4[115:104];
	end  else begin
		bcid = pad_data__2[115:104];
	end
end


always @(posedge clk) begin
	if(pad_data_valid) begin
		pad_data_0_4 <= pad_data_0_3;
		pad_data_0_3 <= pad_data_0_2;
		pad_data_0_2 <= pad_data_0_1;
		pad_data_0_1 <= pad_data_0_0;
		pad_data_0_0 <= pad_data_0;

		pad_data_1_4 <= pad_data_1_3;
		pad_data_1_3 <= pad_data_1_2;
		pad_data_1_2 <= pad_data_1_1;
		pad_data_1_1 <= pad_data_1_0;
		pad_data_1_0 <= pad_data_1;
	
		pad_data_2_4 <= pad_data_2_3;
		pad_data_2_3 <= pad_data_2_2;
		pad_data_2_2 <= pad_data_2_1;
		pad_data_2_1 <= pad_data_2_0;
		pad_data_2_0 <= pad_data_2;
	
		pad_data_3_4 <= pad_data_3_3;
		pad_data_3_3 <= pad_data_3_2;
		pad_data_3_2 <= pad_data_3_1;
		pad_data_3_1 <= pad_data_3_0;
		pad_data_3_0 <= pad_data_3;
	end
end

always @(posedge clk) begin
	if     (pad_data__2[115:104] == pad_data_0_2[115:104])begin pad_data_0_aligned <=  pad_data_0_2; end
	else if(pad_data__2[115:104] == pad_data_0_1[115:104])begin pad_data_0_aligned <=  pad_data_0_1; end
	else if(pad_data__2[115:104] == pad_data_0_3[115:104])begin pad_data_0_aligned <=  pad_data_0_3; end
	else if(pad_data__2[115:104] == pad_data_0_0[115:104])begin pad_data_0_aligned <=  pad_data_0_0; end
	else if(pad_data__2[115:104] == pad_data_0_4[115:104])begin pad_data_0_aligned <=  pad_data_0_4; end
	else begin pad_data_0_aligned <=  pad_data_0_2; end
end
always @(posedge clk) begin
	if     (pad_data__2[115:104] == pad_data_1_2[115:104])begin pad_data_1_aligned <=  pad_data_1_2; end
	else if(pad_data__2[115:104] == pad_data_1_1[115:104])begin pad_data_1_aligned <=  pad_data_1_1; end
	else if(pad_data__2[115:104] == pad_data_1_3[115:104])begin pad_data_1_aligned <=  pad_data_1_3; end
	else if(pad_data__2[115:104] == pad_data_1_0[115:104])begin pad_data_1_aligned <=  pad_data_1_0; end
	else if(pad_data__2[115:104] == pad_data_1_4[115:104])begin pad_data_1_aligned <=  pad_data_1_4; end
	else begin pad_data_1_aligned <=  pad_data_1_2; end
end
always @(posedge clk) begin
	if     (pad_data__2[115:104] == pad_data_2_2[115:104])begin pad_data_2_aligned <=  pad_data_2_2; end
	else if(pad_data__2[115:104] == pad_data_2_1[115:104])begin pad_data_2_aligned <=  pad_data_2_1; end
	else if(pad_data__2[115:104] == pad_data_2_3[115:104])begin pad_data_2_aligned <=  pad_data_2_3; end
	else if(pad_data__2[115:104] == pad_data_2_0[115:104])begin pad_data_2_aligned <=  pad_data_2_0; end
	else if(pad_data__2[115:104] == pad_data_2_4[115:104])begin pad_data_2_aligned <=  pad_data_2_4; end
	else begin pad_data_2_aligned <=  pad_data_2_2; end
end
always @(posedge clk) begin
	if     (pad_data__2[115:104] == pad_data_3_2[115:104])begin pad_data_3_aligned <=  pad_data_3_2; end
	else if(pad_data__2[115:104] == pad_data_3_1[115:104])begin pad_data_3_aligned <=  pad_data_3_1; end
	else if(pad_data__2[115:104] == pad_data_3_3[115:104])begin pad_data_3_aligned <=  pad_data_3_3; end
	else if(pad_data__2[115:104] == pad_data_3_0[115:104])begin pad_data_3_aligned <=  pad_data_3_0; end
	else if(pad_data__2[115:104] == pad_data_3_4[115:104])begin pad_data_3_aligned <=  pad_data_3_4; end
	else begin pad_data_3_aligned <=  pad_data_3_2; end
end
link_alignment_VIO link_alignment_VIO_inst (
  .clk(clk),                  // input wire clk
  .probe_out0(ref_TDS_select_VIO)     // output wire [2 : 0] probe_out0
);

endmodule

