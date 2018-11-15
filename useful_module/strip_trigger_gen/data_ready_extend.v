`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 09:16:18 AM
// Design Name: 
// Module Name: data_ready_extend
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_ready_extend(
  input clk,
  input data_ready,    
  output reg data_ready_extend
    );
    wire[1:0] extend_cycle_VIO;
    reg data_ready_r;
    always@(posedge clk)begin
        data_ready_r <= data_ready;
    end
    reg [3:0] counter;
    always@(posedge clk)begin
        if(~data_ready_r&data_ready)begin
            counter <= {extend_cycle_VIO,2'b11};
        end else begin
            counter <= |counter ? (counter - 4'b1) : 4'b0000;
        end
    end
    always@(posedge clk)begin
        data_ready_extend <= (~data_ready_r&data_ready) | counter;
    end
    data_ready_extend_VIO data_ready_extend_VIO_inst(
    .clk(clk),                // input wire clk
    .probe_out0(extend_cycle_VIO)  // output wire [1 : 0] probe_out0
    
    );
    
    ila_data_ready_extend ila_data_ready_extend_inst (
        .clk(clk), // input wire clk
    
    
        .probe0(data_ready), // input wire [11:0]  probe0  
        .probe1(data_ready_r), // input wire [7:0]  probe1 
        .probe2(counter), // input wire [0:0]  probe2
        .probe3(data_ready_extend)  
    );
endmodule
