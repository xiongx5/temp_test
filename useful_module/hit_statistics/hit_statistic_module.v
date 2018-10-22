//==================================================================================================
//  Filename      : hit_statistic_module.v
//  Created On    : 2018-10-18 17:53:33
//  Last Modified : 2018-10-18 21:23:02
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module hit_statistic_module(
	input clk40M,
	input reset,
	input tick,
	input hit,
	input start,

	output reg ready,
	output reg [19:0] count_out,
	output debug
	);

reg start_r=1'b0;
reg start_inner;
always @(posedge clk40M)begin
	start_r <= start;
	start_inner <= start & (~start_r);
end


reg start_inner_r = 1'b0;
always @(posedge clk40M ) begin
	if (reset) begin
		// reset
		start_inner_r <= 1'b0;
	end	else if (start_inner & ~start_inner_r) begin
		start_inner_r <= 1'b1;
	end else if(start_inner_r & tick) begin
		start_inner_r <= 1'b0;
	end
end

reg counter_enbale =1'b0;
always @(posedge clk40M ) begin
	if (reset) begin
		// reset
		counter_enbale <= 1'b0;
	end	else if (start_inner_r & ~counter_enbale & tick) begin
		counter_enbale <= 1'b1;
	end else if (counter_enbale & tick) begin
		counter_enbale <= 1'b0;
	end
end

reg hit_r=1'b0;
always @(posedge clk40M)begin
	hit_r <= hit;
end

always @(posedge clk40M ) begin
	if (reset | start_inner_r) begin
		// reset
		count_out <= 20'b0;
	end	else if (counter_enbale) begin
		count_out <= ~hit_r ? count_out : 
							(&count_out ? count_out : count_out + 20'b1);
	end
end

always @(posedge clk40M ) begin
	if (reset | start_inner_r) begin
		// reset
		ready <= 1'b0;
	end	else if (counter_enbale & tick) begin
		ready <= 1'b1;
	end
end
assign debug = counter_enbale;
   hit_stastic_ila hit_stastic_inst (
    .clk(clk40M), // input wire clk

    .probe0(start_r), // input wire [0:0] probe0
    .probe1(start_inner), // input wire [0:0] probe1
    .probe2(start_inner_r), // input wire [0:0] probe2
    .probe3(counter_enbale), // input wire [0:0] probe3
    .probe4(hit_r), // input wire [0:0] probe4
    .probe5(count_out), // input wire [19:0] probe5
    .probe6(ready), // input wire [0:0] probe6
    .probe7(tick), // input wire [0:0] probe7
    .probe8(hit) // input wire [0:0] probe7
  );

endmodule



