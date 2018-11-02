//==================================================================================================
//  Filename      : pad_data_select.v
//  Created On    : 2018-10-29 13:45:39
//  Last Modified : 2018-11-01 18:01:08
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module pad_data_select(
	input clk,
	input [103:0] pad_data,
	input [6:0] pad_data_mask,
	output reg pad_data_out
	);

always @(posedge clk) begin
	case(pad_data_mask)
		7'd0  : pad_data_out <= pad_data[0];
		7'd1  : pad_data_out <= pad_data[1];
		7'd2  : pad_data_out <= pad_data[2];
		7'd3  : pad_data_out <= pad_data[3];
		7'd4  : pad_data_out <= pad_data[4];
		7'd5  : pad_data_out <= pad_data[5];
		7'd6  : pad_data_out <= pad_data[6];
		7'd7  : pad_data_out <= pad_data[7];
		7'd8  : pad_data_out <= pad_data[8];
		7'd9  : pad_data_out <= pad_data[9];
		7'd10 : pad_data_out <= pad_data[10];
		7'd11 : pad_data_out <= pad_data[11];
		7'd12 : pad_data_out <= pad_data[12];
		7'd13 : pad_data_out <= pad_data[13];
		7'd14 : pad_data_out <= pad_data[14];
		7'd15 : pad_data_out <= pad_data[15];
		7'd16 : pad_data_out <= pad_data[16];
		7'd17 : pad_data_out <= pad_data[17];
		7'd18 : pad_data_out <= pad_data[18];
		7'd19 : pad_data_out <= pad_data[19];
		7'd20 : pad_data_out <= pad_data[20];
		7'd21 : pad_data_out <= pad_data[21];
		7'd22 : pad_data_out <= pad_data[22];
		7'd23 : pad_data_out <= pad_data[23];
		7'd24 : pad_data_out <= pad_data[24];
		7'd25 : pad_data_out <= pad_data[25];
		7'd26 : pad_data_out <= pad_data[26];
		7'd27 : pad_data_out <= pad_data[27];
		7'd28 : pad_data_out <= pad_data[28];
		7'd29 : pad_data_out <= pad_data[29];
		7'd30 : pad_data_out <= pad_data[30];
		7'd31 : pad_data_out <= pad_data[31];
		7'd32 : pad_data_out <= pad_data[32];
		7'd33 : pad_data_out <= pad_data[33];
		7'd34 : pad_data_out <= pad_data[34];
		7'd35 : pad_data_out <= pad_data[35];
		7'd36 : pad_data_out <= pad_data[36];
		7'd37 : pad_data_out <= pad_data[37];
		7'd38 : pad_data_out <= pad_data[38];
		7'd39 : pad_data_out <= pad_data[39];
		7'd40 : pad_data_out <= pad_data[40];
		7'd41 : pad_data_out <= pad_data[41];
		7'd42 : pad_data_out <= pad_data[42];
		7'd43 : pad_data_out <= pad_data[43];
		7'd44 : pad_data_out <= pad_data[44];
		7'd45 : pad_data_out <= pad_data[45];
		7'd46 : pad_data_out <= pad_data[46];
		7'd47 : pad_data_out <= pad_data[47];
		7'd48 : pad_data_out <= pad_data[48];
		7'd49 : pad_data_out <= pad_data[49];
		7'd50 : pad_data_out <= pad_data[50];
		7'd51 : pad_data_out <= pad_data[51];
		7'd52 : pad_data_out <= pad_data[52];
		7'd53 : pad_data_out <= pad_data[53];
		7'd54 : pad_data_out <= pad_data[54];
		7'd55 : pad_data_out <= pad_data[55];
		7'd56 : pad_data_out <= pad_data[56];
		7'd57 : pad_data_out <= pad_data[57];
		7'd58 : pad_data_out <= pad_data[58];
		7'd59 : pad_data_out <= pad_data[59];
		7'd60 : pad_data_out <= pad_data[60];
		7'd61 : pad_data_out <= pad_data[61];
		7'd62 : pad_data_out <= pad_data[62];
		7'd63 : pad_data_out <= pad_data[63];
		7'd64 : pad_data_out <= pad_data[64];
		7'd65 : pad_data_out <= pad_data[65];
		7'd66 : pad_data_out <= pad_data[66];
		7'd67 : pad_data_out <= pad_data[67];
		7'd68 : pad_data_out <= pad_data[68];
		7'd69 : pad_data_out <= pad_data[69];
		7'd70 : pad_data_out <= pad_data[70];
		7'd71 : pad_data_out <= pad_data[71];
		7'd72 : pad_data_out <= pad_data[72];
		7'd73 : pad_data_out <= pad_data[73];
		7'd74 : pad_data_out <= pad_data[74];
		7'd75 : pad_data_out <= pad_data[75];
		7'd76 : pad_data_out <= pad_data[76];
		7'd77 : pad_data_out <= pad_data[77];
		7'd78 : pad_data_out <= pad_data[78];
		7'd79 : pad_data_out <= pad_data[79];
		7'd80 : pad_data_out <= pad_data[80];
		7'd81 : pad_data_out <= pad_data[81];
		7'd82 : pad_data_out <= pad_data[82];
		7'd83 : pad_data_out <= pad_data[83];
		7'd84 : pad_data_out <= pad_data[84];
		7'd85 : pad_data_out <= pad_data[85];
		7'd86 : pad_data_out <= pad_data[86];
		7'd87 : pad_data_out <= pad_data[87];
		7'd88 : pad_data_out <= pad_data[88];
		7'd89 : pad_data_out <= pad_data[89];
		7'd90 : pad_data_out <= pad_data[90];
		7'd91 : pad_data_out <= pad_data[91];
		7'd92 : pad_data_out <= pad_data[92];
		7'd93 : pad_data_out <= pad_data[93];
		7'd94 : pad_data_out <= pad_data[94];
		7'd95 : pad_data_out <= pad_data[95];
		7'd96 : pad_data_out <= pad_data[96];
		7'd97 : pad_data_out <= pad_data[97];
		7'd98 : pad_data_out <= pad_data[98];
		7'd99 : pad_data_out <= pad_data[99];
		7'd100: pad_data_out <= pad_data[100];
		7'd101: pad_data_out <= pad_data[101];
		7'd102: pad_data_out <= pad_data[102];
		7'd103: pad_data_out <= pad_data[103];
		7'd127: pad_data_out <= 1'b1;
		default: pad_data_out <= 1'b0;
	endcase
end
endmodule