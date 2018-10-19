//==================================================================================================
//  Filename      : slow_clock_generator.v
//  Created On    : 2018-10-18 17:28:49
//  Last Modified : 2018-10-18 17:33:23
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module slow_clock_generator(
	input clk40M,
	output clk40K
	);
	reg [9:0] counter_for_slow=10'b0;
	always @(posedge clk40M) begin
		counter_for_slow <= counter_for_slow + 10'b1;
	end
	assign  clk40K= counter_for_slow[9];
endmodule