/* 
       _________   ________     _______       
      / U OF M  \ | LSA    \   /Physics\
      \__ATLAS__/ |   ___   | |   _____/
         |   |    |  |   \  | |  |____
         |   |    |  |___/  | \_____   \   
         |   |    |         |  _____\   | 
         \___/    |________/  |________/  
*/
//  File Name  : check_strip_data.v
//  Author     : Jinhong Wang
//  Revision   : V0.01, created Jan. 13, 2017
//               Top-warp of pad mode check: check each pad channel, and its delay compensation circuit


`timescale 1ns / 1ps
`define DLY #1

//***********************************Entity Declaration************************
(* DowngradeIPIdentifiedWarnings="yes" *)
module check_strip_data                           
(
    input   clk160,
    input [29:0] strip_data_in,
    input [18:0] link_message,


    output reg linked,
    output reg [3:0]  state,
    output reg [9:0]  syn_cnt,
    output reg [4:0]  err_cnt

//    output [103:0] frame_data,
//    output frame_data_valid
);

always @(posedge clk160) begin
  err_cnt <= link_message[4:0];
  syn_cnt <= link_message[13:5];
  linked <= link_message[14];
  state <= link_message[18:15];
end

   reg [103:0] frmdata=104'b0;
    always @(posedge clk160) begin
      if(strip_data_in[29:26] == 4'b1010) begin
        frmdata[25:0] <= strip_data_in[25:0];
        frmdata[103 :26] <= frmdata[77:0];
      end
    end

    reg [3:0] head_before;
    always @(posedge clk160) begin
        head_before <= strip_data_in[29:26];
    end

    reg [1:0] counter = 2'b0;
    always @(posedge clk160) begin
      counter <= counter + 2'b01;
    end

    reg [1:0] counter_position;
    
    always @(posedge clk160) begin
      if(strip_data_in[29:26] == 4'b1100 && head_before != 4'b1100) begin
          counter_position <= counter;
      end
    end    

    reg [103:0] frmdata_r=104'b0;
    reg data_valid=1'b0;
    always @(posedge clk160) begin
        if(counter== counter_position+2'b01) begin
            frmdata_r <= frmdata;
            data_valid <= 1'b1;
        end else begin
            data_valid <=1'b0;
        end
    end
//assign frame_data = frmdata_r;
//assign frame_data_valid = data_valid;

ila_strip_data_check ila_strip_data_check_inst (
  .clk(clk160), // input wire clk
  .probe0(strip_data_in), // input wire 30 probe0
  .probe1(link_message), // input wire 19 probe1
  .probe2(frmdata),//104
  .probe3(head_before),//4
  .probe4(counter),//2
  .probe5(counter_position),//2
  .probe6(data_valid),//1
  .probe7(frmdata_r)//104
);

// wire clear_link_error;
// wire clear_link_error_VIO;
// assign  clear_link_error =  clear_link_error_VIO ;
// reg link_r=1'b0;

// always @(posedge clk40 ) begin
//     link_r <= linked;
// end
// wire link_break;
// assign  link_break = link_r&(~linked);

// reg clear_link_error_r=1'b0;
// always @(posedge clk40 ) begin
//     clear_link_error_r <= clear_link_error;
// end
// wire clear_link_error_r_risng;
// assign  clear_link_error_r_risng = (~clear_link_error_r)&(clear_link_error);
// reg [15:0] linked_break_counter = 16'b0;
// always @(posedge clk40) begin
//     if (reset) begin
//         // reset
//         linked_break_counter <= 16'b0;
//     end
//     else if (clear_link_error_r_risng) begin
//         linked_break_counter <= 16'b0;
//     end else if(link_break)begin
//         linked_break_counter <= (linked_break_counter==16'hffff)?16'hffff:linked_break_counter+16'b1;
//     end
// end
// assign linked_break_counter_out = linked_break_counter;


// vio_strip_data_check vio_strip_data_check_inst (
//   .clk(clk40), // input wire clk
//   .probe_in0(clear_link_error_VIO)//1
// );


endmodule   
