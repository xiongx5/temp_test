//==================================================================================================
//  Filename      : trigger_process.v
//  Created On    : 2018-10-10 21:41:12
//  Last Modified : 2018-10-11 22:36:58
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
	output  trigger
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

   reg [3:0] trigger_r0;
   always @(posedge clk ) begin
		trigger_r0 <= {trigger_r0[2:0],trigger_inner};
   end
   wire trigger_start;
   assign trigger_start = ~trigger_r0[3] & trigger_r0[2];
   reg [9:0] trigger_count;
   always @(posedge clk) begin
	if(trigger_start)begin
   		trigger_count <= trigger_width;
   	end else begin
   		trigger_count <= |trigger_count ? (trigger_count - 10'b1) : 10'b0;
   	end
   end
   assign  trigger = enbale_trigger ? (|trigger_count|trigger_start) : 1'b1;


   trigger_process_ila trigger_process_ila_inst (
    .clk(clk), // input wire clk

    .probe0(trigger_r0), // input wire [3:0] probe0
    .probe1(trigger_start), // input wire [0:0] probe1
    .probe2(trigger_count), // input wire [9:0] probe2
    .probe3(trigger), // input wire [0:0] probe3
    .probe4(enbale_trigger) // input wire [0:0] probe4
  );
endmodule
