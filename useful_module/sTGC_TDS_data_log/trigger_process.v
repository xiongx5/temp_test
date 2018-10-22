//==================================================================================================
//  Filename      : trigger_process.v
//  Created On    : 2018-10-10 21:41:12
//  Last Modified : 2018-10-22 11:58:14
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module trigger_process(
	input clk,
	input trigger_in_p,
	input trigger_in_n,
	input [9:0] trigger_width,
	input enbale_trigger,
	output  trigger,
  output  [7:0] trigger_index,
  input cycle_tick,
  output debug_enable
	);
   wire trigger_inner;
   IBUFDS #(
      .DIFF_TERM("FALSE"),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(trigger_inner),  // Buffer output
      .I(trigger_in_p),  // Diff_p buffer input (connect directly to top-level port)
      .IB(trigger_in_n) // Diff_n buffer input (connect directly to top-level port)
   );
   wire trigger_start;
   reg  enable=1'b1;
   reg enable_1=1'b0;
   always @(posedge clk) begin
        if(trigger_start)begin
          enable <= 1'b0;
          enable_1 <= 1'b0; 
        end else if(cycle_tick & ~enable) begin
          enable_1 <= 1'b1;
        end  else if(cycle_tick & enable_1) begin
          enable <= 1'b1; 
          enable_1 <= 1'b0;
        end
   end
   assign  debug_enable = enbale_trigger ? enable_1 : 1'b1;

   reg [2:0] trigger_r0;
   always @(posedge clk ) begin
		trigger_r0 <= {trigger_r0[1:0],trigger_inner};
   end
   
   assign trigger_start = ~trigger_r0[2] & trigger_r0[1] & enable;
   reg [9:0] trigger_count;
   always @(posedge clk) begin
	if(trigger_start)begin
   		trigger_count <= trigger_width;
   	end else begin
   		trigger_count <= |trigger_count ? (trigger_count - 10'b1) : 10'b0;
   	end
   end
   assign  trigger = enbale_trigger ? (|trigger_count) : 1'b1;


   reg [7:0] trigger_index_r=8'b0;
   always @(posedge clk)begin
    if(trigger_start)begin
        trigger_index_r <= trigger_index_r + 8'b1;
    end
     
   end
   assign  trigger_index = trigger_index_r;

   trigger_process_ila trigger_process_ila_inst (
    .clk(clk), // input wire clk

    .probe0(trigger_r0), // input wire [2:0] probe0
    .probe1(trigger_start), // input wire [0:0] probe1
    .probe2(trigger_count), // input wire [9:0] probe2
    .probe3(trigger), // input wire [0:0] probe3
    .probe4(enbale_trigger), // input wire [0:0] probe4
    .probe5({enable,enable_1}), // input wire [0:0] probe5
    .probe6(trigger_index), // input wire [0:0] probe6
    .probe7(cycle_tick) // input wire [0:0] probe7
  );
endmodule
