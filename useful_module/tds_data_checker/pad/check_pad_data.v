/* 
       _________   ________     _______       
      / U OF M  \ | LSA    \   /Physics\
      \__ATLAS__/ |   ___   | |   _____/
         |   |    |  |   \  | |  |____
         |   |    |  |___/  | \_____   \   
         |   |    |         |  _____\   | 
         \___/    |________/  |________/  
*/
//  File Name  : check_pad_data.v
//  Author     : Jinhong Wang
//  Revision   : V0.01, created Jan. 13, 2017
//               Top-warp of pad mode check: check each pad channel, and its delay compensation circuit


`timescale 1ns / 1ps
`define DLY #1

//***********************************Entity Declaration************************
(* DowngradeIPIdentifiedWarnings="yes" *)
module check_pad_data                           
(
    input   clk160,
    input [115:0] pad_data_in,
    input pad_data_valid,
    input [18:0] link_message,

    output linked,
    output [3:0] state,
    output [9:0] syn_cnt,
    output [4:0] err_cnt,

    output data_valid,
    output [115:0] data_out
);

assign err_cnt = link_message[4:0];
assign syn_cnt = link_message[13:5];
assign linked = link_message[14];
assign state = link_message[18:15];
wire hit_flag;
assign hit_flag = |pad_data_in[103:0];
wire [11:0] BCID;
assign BCID= pad_data_in[115:104];
assign  data_valid = hit_flag&pad_data_valid;
assign  data_out= pad_data_in;
ila_pad_data_check ila_pad_data_check_inst (
 .clk(clk160), // input wire clk
 .probe0(pad_data_in), // input wire 116 probe0
 .probe1(link_message), // input wire 19 probe1
 .probe2(hit_flag),//1
 .probe3(BCID),//12
 .probe4(pad_data_valid)
);



// wire clear_link_error;
// wire clear_link_error_VIO;
// assign  clear_link_error =  clear_link_error_VIO ;

// reg link_r=1'b0;

// always @(posedge clk160 ) begin
//     link_r <= linked;
// end
// wire link_break;
// assign  link_break = link_r&(~linked);

// reg clear_link_error_r=1'b0;
// always @(posedge clk160 ) begin
//     clear_link_error_r <= clear_link_error;
// end
// wire clear_link_error_r_risng;
// assign  clear_link_error_r_risng = (~clear_link_error_r)&(clear_link_error);
// reg [15:0] linked_break_counter = 16'b0;
// always @(posedge clk160) begin
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


// vio_pad_data_check vio_pad_data_check_inst (
//   .clk(clk160), // input wire clk
//   .probe_in0(clear_link_error_VIO)//1
// );

endmodule   
