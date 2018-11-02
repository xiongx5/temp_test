//==================================================================================================
//  Filename      : bram_data_serial.v
//  Created On    : 2018-10-30 17:05:01
//  Last Modified : 2018-11-02 15:13:21
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module bram_data_serial
#(parameter DATA_WIDTH = 8,REAL_DEPTH = 128 )
(
	input clk,
	input start,
	
	input  [DATA_WIDTH-1:0] data_in,
	output [8:0] adder,
	output reg [DATA_WIDTH*REAL_DEPTH-1:0] data_out,
	output  busy
);
reg [1:0] start_r;
always @(posedge clk) begin
	start_r <= {start_r[0],start};
end

reg busy_r = 1'b0;
assign busy = busy_r;

wire start_inner;
assign start_inner = start_r[0] & ~start_r[1] & ~busy_r & (&count);

reg [8:0] count = 9'h1ff;assign adder = count;
always @(posedge clk) begin
	if(start_inner)begin
		count <= count - 9'b1;
		busy_r <= 1'b1;
	end else if(~&count) begin
		count <= count - 9'b1;
		busy_r <= 1'b1;
	end else begin
		count <= count;
		busy_r <= 1'b0;
	end
end


always @(posedge clk) begin
	if(busy_r)begin
		data_out <= {data_out[DATA_WIDTH*(REAL_DEPTH-1)-1:0],data_in};
	end
end

ila_bram ila_bram_inst (
	.clk(clk), // input wire clk


	.probe0(start_r), // input wire [1:0]  probe0  
	.probe1(busy_r), // input wire [0:0]  probe1 
	.probe2(start_inner), // input wire [0:0]  probe2 
	.probe3(count), // input wire [8:0]  probe3 
	.probe4(data_out[15:0]) // input wire [1023:0]  probe4
);


endmodule