//==================================================================================================
//  Filename      : slow_tick_generator.v
//  Created On    : 2018-10-18 17:51:34
//  Last Modified : 2018-10-18 21:01:48
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module slow_tick_generator(
	input clk40M,
	input [19:0] windows,
	output tick
	);
wire clk40K;
slow_clock_generator inst_slow_clock_generator (.clk40M(clk40M), .clk40K(clk40K));

reg [19:0] counter=20'b0;
wire tick_inner;
wire tick_inner_40M;

always @(posedge clk40K) begin
	counter <= tick_inner ? counter - 20'b1 : windows ;
end
assign tick_inner = |counter;
	tri_mode_ethernet_mac_0_sync_block #(
			.INITIALISE(1'b0),
			.DEPTH(5)
		) inst_tri_mode_ethernet_mac_0_sync_block (
			.clk      (clk40M),
			.data_in  (~tick_inner),
			.data_out (tick_inner_40M)
		);
reg tick_inner_40M_r;
always @(posedge clk40M ) begin
	tick_inner_40M_r <= tick_inner_40M;
end
assign  tick = ~tick_inner_40M_r & tick_inner_40M;
endmodule 