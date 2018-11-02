//==================================================================================================
//  Filename      : priority_encoder.v
//  Created On    : 2018-10-30 20:35:32
//  Last Modified : 2018-10-31 14:18:28
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module priority_encoder(
	input clk,
	input [127:0] data_in,
	output reg [8:0] data_out,
	output reg data_ready
	);
always @(posedge clk) begin
	if     (data_in[0]  ) begin data_out <= 9'd0  ;end 
	else if(data_in[1]  ) begin data_out <= 9'd1  ;end 
	else if(data_in[2]  ) begin data_out <= 9'd2  ;end
	else if(data_in[3]  ) begin data_out <= 9'd3  ;end
	else if(data_in[4]  ) begin data_out <= 9'd4  ;end
	else if(data_in[5]  ) begin data_out <= 9'd5  ;end
	else if(data_in[6]  ) begin data_out <= 9'd6  ;end
	else if(data_in[7]  ) begin data_out <= 9'd7  ;end
	else if(data_in[8]  ) begin data_out <= 9'd8  ;end
	else if(data_in[9]  ) begin data_out <= 9'd9  ;end
	else if(data_in[10] ) begin data_out <= 9'd10 ;end
	else if(data_in[11] ) begin data_out <= 9'd11 ;end
	else if(data_in[12] ) begin data_out <= 9'd12 ;end
	else if(data_in[13] ) begin data_out <= 9'd13 ;end
	else if(data_in[14] ) begin data_out <= 9'd14 ;end
	else if(data_in[15] ) begin data_out <= 9'd15 ;end
	else if(data_in[16] ) begin data_out <= 9'd16 ;end
	else if(data_in[17] ) begin data_out <= 9'd17 ;end
	else if(data_in[18] ) begin data_out <= 9'd18 ;end
	else if(data_in[19] ) begin data_out <= 9'd19 ;end
	else if(data_in[20] ) begin data_out <= 9'd20 ;end
	else if(data_in[21] ) begin data_out <= 9'd21 ;end
	else if(data_in[22] ) begin data_out <= 9'd22 ;end
	else if(data_in[23] ) begin data_out <= 9'd23 ;end
	else if(data_in[24] ) begin data_out <= 9'd24 ;end
	else if(data_in[25] ) begin data_out <= 9'd25 ;end
	else if(data_in[26] ) begin data_out <= 9'd26 ;end
	else if(data_in[27] ) begin data_out <= 9'd27 ;end
	else if(data_in[28] ) begin data_out <= 9'd28 ;end
	else if(data_in[29] ) begin data_out <= 9'd29 ;end
	else if(data_in[30] ) begin data_out <= 9'd30 ;end
	else if(data_in[31] ) begin data_out <= 9'd31 ;end
	else if(data_in[32] ) begin data_out <= 9'd32 ;end
	else if(data_in[33] ) begin data_out <= 9'd33 ;end
	else if(data_in[34] ) begin data_out <= 9'd34 ;end
	else if(data_in[35] ) begin data_out <= 9'd35 ;end
	else if(data_in[36] ) begin data_out <= 9'd36 ;end
	else if(data_in[37] ) begin data_out <= 9'd37 ;end
	else if(data_in[38] ) begin data_out <= 9'd38 ;end
	else if(data_in[39] ) begin data_out <= 9'd39 ;end
	else if(data_in[40] ) begin data_out <= 9'd40 ;end
	else if(data_in[41] ) begin data_out <= 9'd41 ;end
	else if(data_in[42] ) begin data_out <= 9'd42 ;end
	else if(data_in[43] ) begin data_out <= 9'd43 ;end
	else if(data_in[44] ) begin data_out <= 9'd44 ;end
	else if(data_in[45] ) begin data_out <= 9'd45 ;end
	else if(data_in[46] ) begin data_out <= 9'd46 ;end
	else if(data_in[47] ) begin data_out <= 9'd47 ;end
	else if(data_in[48] ) begin data_out <= 9'd48 ;end
	else if(data_in[49] ) begin data_out <= 9'd49 ;end
	else if(data_in[50] ) begin data_out <= 9'd50 ;end
	else if(data_in[51] ) begin data_out <= 9'd51 ;end
	else if(data_in[52] ) begin data_out <= 9'd52 ;end
	else if(data_in[53] ) begin data_out <= 9'd53 ;end
	else if(data_in[54] ) begin data_out <= 9'd54 ;end
	else if(data_in[55] ) begin data_out <= 9'd55 ;end
	else if(data_in[56] ) begin data_out <= 9'd56 ;end
	else if(data_in[57] ) begin data_out <= 9'd57 ;end
	else if(data_in[58] ) begin data_out <= 9'd58 ;end
	else if(data_in[59] ) begin data_out <= 9'd59 ;end
	else if(data_in[60] ) begin data_out <= 9'd60 ;end
	else if(data_in[61] ) begin data_out <= 9'd61 ;end
	else if(data_in[62] ) begin data_out <= 9'd62 ;end
	else if(data_in[63] ) begin data_out <= 9'd63 ;end
	else if(data_in[64] ) begin data_out <= 9'd64 ;end
	else if(data_in[65] ) begin data_out <= 9'd65 ;end
	else if(data_in[66] ) begin data_out <= 9'd66 ;end
	else if(data_in[67] ) begin data_out <= 9'd67 ;end
	else if(data_in[68] ) begin data_out <= 9'd68 ;end
	else if(data_in[69] ) begin data_out <= 9'd69 ;end
	else if(data_in[70] ) begin data_out <= 9'd70 ;end
	else if(data_in[71] ) begin data_out <= 9'd71 ;end
	else if(data_in[72] ) begin data_out <= 9'd72 ;end
	else if(data_in[73] ) begin data_out <= 9'd73 ;end
	else if(data_in[74] ) begin data_out <= 9'd74 ;end
	else if(data_in[75] ) begin data_out <= 9'd75 ;end
	else if(data_in[76] ) begin data_out <= 9'd76 ;end
	else if(data_in[77] ) begin data_out <= 9'd77 ;end
	else if(data_in[78] ) begin data_out <= 9'd78 ;end
	else if(data_in[79] ) begin data_out <= 9'd79 ;end
	else if(data_in[80] ) begin data_out <= 9'd80 ;end
	else if(data_in[81] ) begin data_out <= 9'd81 ;end
	else if(data_in[82] ) begin data_out <= 9'd82 ;end
	else if(data_in[83] ) begin data_out <= 9'd83 ;end
	else if(data_in[84] ) begin data_out <= 9'd84 ;end
	else if(data_in[85] ) begin data_out <= 9'd85 ;end
	else if(data_in[86] ) begin data_out <= 9'd86 ;end
	else if(data_in[87] ) begin data_out <= 9'd87 ;end
	else if(data_in[88] ) begin data_out <= 9'd88 ;end
	else if(data_in[89] ) begin data_out <= 9'd89 ;end
	else if(data_in[90] ) begin data_out <= 9'd90 ;end
	else if(data_in[91] ) begin data_out <= 9'd91 ;end
	else if(data_in[92] ) begin data_out <= 9'd92 ;end
	else if(data_in[93] ) begin data_out <= 9'd93 ;end
	else if(data_in[94] ) begin data_out <= 9'd94 ;end
	else if(data_in[95] ) begin data_out <= 9'd95 ;end
	else if(data_in[96] ) begin data_out <= 9'd96 ;end
	else if(data_in[97] ) begin data_out <= 9'd97 ;end
	else if(data_in[98] ) begin data_out <= 9'd98 ;end
	else if(data_in[99] ) begin data_out <= 9'd99 ;end
	else if(data_in[100]) begin data_out <= 9'd100;end
	else if(data_in[101]) begin data_out <= 9'd101;end
	else if(data_in[102]) begin data_out <= 9'd102;end
	else if(data_in[103]) begin data_out <= 9'd103;end
	else if(data_in[104]) begin data_out <= 9'd104;end
	else if(data_in[105]) begin data_out <= 9'd105;end
	else if(data_in[106]) begin data_out <= 9'd106;end
	else if(data_in[107]) begin data_out <= 9'd107;end
	else if(data_in[108]) begin data_out <= 9'd108;end
	else if(data_in[109]) begin data_out <= 9'd109;end
	else if(data_in[110]) begin data_out <= 9'd110;end
	else if(data_in[111]) begin data_out <= 9'd111;end
	else if(data_in[112]) begin data_out <= 9'd112;end
	else if(data_in[113]) begin data_out <= 9'd113;end
	else if(data_in[114]) begin data_out <= 9'd114;end
	else if(data_in[115]) begin data_out <= 9'd115;end
	else if(data_in[116]) begin data_out <= 9'd116;end
	else if(data_in[117]) begin data_out <= 9'd117;end
	else if(data_in[118]) begin data_out <= 9'd118;end
	else if(data_in[119]) begin data_out <= 9'd119;end
	else if(data_in[120]) begin data_out <= 9'd120;end
	else if(data_in[121]) begin data_out <= 9'd121;end
	else if(data_in[122]) begin data_out <= 9'd122;end
	else if(data_in[123]) begin data_out <= 9'd123;end
	else if(data_in[124]) begin data_out <= 9'd124;end
	else if(data_in[125]) begin data_out <= 9'd125;end
	else if(data_in[126]) begin data_out <= 9'd126;end
	else if(data_in[127]) begin data_out <= 9'd127;end
	else                  begin data_out <= 9'd0  ;end
end

always @(posedge clk) begin
	data_ready <= |data_in;
end

endmodule