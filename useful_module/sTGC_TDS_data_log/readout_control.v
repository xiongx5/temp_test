//==================================================================================================
//  Filename      : readout_control.v
//  Created On    : 2018-10-03 18:16:19
//  Last Modified : 2018-10-10 21:31:30
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
module readout_control(
	input clk,
	input reset,
	input mac_clk,

	input [47:0] D_MAC_add,
	input [47:0] S_MAC_add,
	
	input [11:0] counter_th,
	input [15:0] idle_counter_number_th, 
	input debug_enable,

	input [7:0] channel_linked,

    output [7:0]  tx_axis_fifo_tdata,
    output reg tx_axis_fifo_tvalid,
    input  tx_axis_fifo_tready,
    output reg tx_axis_fifo_tlast,

	output channel_fifo_s_reset_0,
	output data_tran_stop_0,
	output channel_data_read_0,
	input [119:0] channel_data_0,
	input [9:0]   channel_data_counter_0,
	input channel_fifo_empty_0,

	output channel_fifo_s_reset_1,
	output data_tran_stop_1,
	output channel_data_read_1,
	input [119:0] channel_data_1,
	input [9:0]   channel_data_counter_1,
	input channel_fifo_empty_1,

	output channel_fifo_s_reset_2,
	output data_tran_stop_2,
	output channel_data_read_2,
	input [119:0] channel_data_2,
	input [9:0]   channel_data_counter_2,
	input channel_fifo_empty_2,

	output channel_fifo_s_reset_3,
	output data_tran_stop_3,
	output channel_data_read_3,
	input [119:0] channel_data_3,
	input [9:0]   channel_data_counter_3,
	input channel_fifo_empty_3,

	output channel_fifo_s_reset_4,
	output data_tran_stop_4,
	output channel_data_read_4,
	input [119:0] channel_data_4,
	input [9:0]   channel_data_counter_4,
	input channel_fifo_empty_4,

	output channel_fifo_s_reset_5,
	output data_tran_stop_5,
	output channel_data_read_5,
	input [119:0] channel_data_5,
	input [9:0]   channel_data_counter_5,
	input channel_fifo_empty_5,

	output channel_fifo_s_reset_6,
	output data_tran_stop_6,
	output channel_data_read_6,
	input [119:0] channel_data_6,
	input [9:0]   channel_data_counter_6,
	input channel_fifo_empty_6,

	output channel_fifo_s_reset_7,
	output data_tran_stop_7,
	output channel_data_read_7,
	input [119:0] channel_data_7,
	input [9:0]   channel_data_counter_7,
	input channel_fifo_empty_7
);

reg [11:0] sample_cycle_counter = 12'h0;
always @(posedge clk) begin
	if (reset) begin
		// reset
		sample_cycle_counter <= 12'b0;
	end	begin
		sample_cycle_counter <= (sample_cycle_counter == counter_th) ? 12'b0 : (sample_cycle_counter + 12'b1); 
	end
end

reg [11:0] cycle_counter = 12'h0;
wire cycle_counter_pasue ;
always @(posedge clk) begin
	if (reset) begin
		// reset
		cycle_counter <= 12'b0;
	end	begin
		if(sample_cycle_counter == counter_th)begin
			cycle_counter <= 12'b0;
		end else begin
			cycle_counter <= cycle_counter_pasue ? cycle_counter : cycle_counter +12'b1;
		end
	end
end

reg [7:0] packet_count = 8'h0;


wire [11:0] start_point; assign start_point = counter_th >> 1;

reg readout_processing = 1'b0;
always @(posedge clk ) begin
	if (reset) begin
		readout_processing <= 1'b0;		
	end	else if (cycle_counter == start_point) begin
		readout_processing <= (|channel_not_empty) | idle_cylce;
	end else if(cycle_counter == start_point + 12'h012)begin
		readout_processing <= 1'b0;
	end
end


reg [7:0] channel_not_empty_r = 8'b0000_0000;
wire [7:0] channel_not_empty;
reg [7:0] channel_not_empty_r_one_hot;
reg idle_cylce_r;

assign channel_not_empty = ~{channel_fifo_empty_7,channel_fifo_empty_6,channel_fifo_empty_5,channel_fifo_empty_4,
							 channel_fifo_empty_3,channel_fifo_empty_2,channel_fifo_empty_1,channel_fifo_empty_0};
always @(posedge clk) begin
	if (reset) begin
		// reset
		channel_not_empty_r <= 8'b0000_0000;
	end else if(cycle_counter == start_point) begin
		channel_not_empty_r <= channel_not_empty;
	end else if((cycle_counter <= start_point + 12'h00f) & (cycle_counter > start_point) &(~idle_cylce_r) )begin
		channel_not_empty_r <= (~|channel_not_empty_r)? channel_not_empty : (channel_not_empty_r & (~channel_not_empty_r_one_hot)) ;
	end else begin
		channel_not_empty_r <= 8'b0000_0000;
	end
end

assign cycle_counter_pasue = (channel_not_empty_r ==  channel_not_empty_r_one_hot) & (|channel_not_empty_r);
reg cycle_counter_pasue_r;
always @(posedge clk) begin
	if (reset) begin
		// reset
		cycle_counter_pasue_r <= 1'b0;
	end else begin
		cycle_counter_pasue_r <= cycle_counter_pasue;
	end
end

always @(*) begin
	case(channel_not_empty_r)
		8'b1???????: channel_not_empty_r_one_hot = 8'b1000_0000;
		8'b01??????: channel_not_empty_r_one_hot = 8'b0100_0000;
		8'b001?????: channel_not_empty_r_one_hot = 8'b0010_0000;
		8'b0001????: channel_not_empty_r_one_hot = 8'b0001_0000;
		8'b00001???: channel_not_empty_r_one_hot = 8'b0000_1000;
		8'b000001??: channel_not_empty_r_one_hot = 8'b0000_0100;
		8'b0000001?: channel_not_empty_r_one_hot = 8'b0000_0010;
		8'b00000001: channel_not_empty_r_one_hot = 8'b0000_0001;
		8'b00000000: channel_not_empty_r_one_hot = 8'b0000_0000;
		default:     channel_not_empty_r_one_hot = 8'b0000_0000;
	endcase
end

reg [15:0] idle_cyle_num;
wire  idle_cylce; assign  idle_cylce =  (idle_cyle_num == idle_counter_number_th) & debug_enable;
always @(posedge clk ) begin
	if (reset) begin
		idle_cyle_num <= 16'b0;		
	end	else if(cycle_counter == start_point)begin
		idle_cyle_num <= ((|channel_not_empty) | idle_cylce) ? 16'b0 : idle_cyle_num + 16'b1;
	end 
end


always @(posedge clk)begin
	if(cycle_counter == start_point)begin
		idle_cylce_r <= idle_cylce & (~|channel_not_empty);
	end
end

wire [119:0] effictive_data_7;assign  effictive_data_7 = channel_not_empty_r_one_hot[7] ?  {1'b1,3'b111,channel_data_7[115:0]} : 120'b0;
wire [119:0] effictive_data_6;assign  effictive_data_6 = channel_not_empty_r_one_hot[6] ?  {1'b1,3'b110,channel_data_6[115:0]} : 120'b0;
wire [119:0] effictive_data_5;assign  effictive_data_5 = channel_not_empty_r_one_hot[5] ?  {1'b1,3'b101,channel_data_5[115:0]} : 120'b0;
wire [119:0] effictive_data_4;assign  effictive_data_4 = channel_not_empty_r_one_hot[4] ?  {1'b1,3'b100,channel_data_4[115:0]} : 120'b0;
wire [119:0] effictive_data_3;assign  effictive_data_3 = channel_not_empty_r_one_hot[3] ?  {1'b1,3'b011,channel_data_3[115:0]} : 120'b0;
wire [119:0] effictive_data_2;assign  effictive_data_2 = channel_not_empty_r_one_hot[2] ?  {1'b1,3'b010,channel_data_2[115:0]} : 120'b0;
wire [119:0] effictive_data_1;assign  effictive_data_1 = channel_not_empty_r_one_hot[1] ?  {1'b1,3'b001,channel_data_1[115:0]} : 120'b0;
wire [119:0] effictive_data_0;assign  effictive_data_0 = channel_not_empty_r_one_hot[0] ?  {1'b1,3'b000,channel_data_0[115:0]} : 120'b0;
wire [119:0] effictive_data; 
assign effictive_data = effictive_data_7 |
						effictive_data_6 |
						effictive_data_5 |
						effictive_data_4 |
						effictive_data_3 |
						effictive_data_2 |
						effictive_data_1 |
						effictive_data_0 ;



reg [119:0] eth_fifo_data;
reg eth_fifo_write;
always @(posedge clk ) begin
	if (reset) begin
		eth_fifo_data  <= 120'b0;	
		eth_fifo_write <= 1'b0;	
		packet_count <= 8'b0;
	end	else if (cycle_counter == start_point) begin
		eth_fifo_data  <= {D_MAC_add,S_MAC_add,packet_count,8'h00,8'hff};
		eth_fifo_write <= |channel_not_empty |idle_cylce;	
		packet_count <= (|channel_not_empty |idle_cylce) ? (packet_count + 8'b1) : packet_count;
	end else if((cycle_counter <= start_point + 12'h0010)&(cycle_counter >= start_point+12'h001))begin
		eth_fifo_data  <= (idle_cylce_r | (~|channel_not_empty_r_one_hot))? {104'b0,4'b1111,4'b000,channel_linked} : effictive_data;
		eth_fifo_write <= readout_processing & ~cycle_counter_pasue_r;	
	end else if(cycle_counter == start_point + 12'h0011) begin
		eth_fifo_data  <= {channel_data_counter_7,channel_data_counter_6,channel_data_counter_5,channel_data_counter_4,
							channel_data_counter_3,channel_data_counter_2,channel_data_counter_1,channel_data_counter_0,40'hffffffffff};
		eth_fifo_write <= readout_processing;
	end else if(cycle_counter == start_point + 12'h0012)begin
		eth_fifo_data  <= 120'b0; 
		eth_fifo_write <= readout_processing;
	end else begin
		eth_fifo_data  <= 120'b0; 
		eth_fifo_write <= 1'b0;
	end
end

assign {channel_data_read_7,channel_data_read_6,channel_data_read_5,channel_data_read_4,
		channel_data_read_3,channel_data_read_2,channel_data_read_1,channel_data_read_0} = channel_not_empty_r_one_hot;



reg data_tran_stop;
assign data_tran_stop_0 = data_tran_stop;
assign data_tran_stop_1 = data_tran_stop;
assign data_tran_stop_2 = data_tran_stop;
assign data_tran_stop_3 = data_tran_stop;
assign data_tran_stop_4 = data_tran_stop;
assign data_tran_stop_5 = data_tran_stop;
assign data_tran_stop_6 = data_tran_stop;
assign data_tran_stop_7 = data_tran_stop;

always @(posedge clk) begin
	if (reset) begin
		// reset
		data_tran_stop <= 1'b0;
	end	else if ((cycle_counter >= start_point + 12'h0010)&(cycle_counter <= start_point + 12'h0017)) begin
		data_tran_stop <= ~idle_cylce_r;//1'b1;
	end else begin
		data_tran_stop <= 1'b0;
	end
end

reg channel_fifo_s_reset;
assign channel_fifo_s_reset_0 = channel_fifo_s_reset;
assign channel_fifo_s_reset_1 = channel_fifo_s_reset;
assign channel_fifo_s_reset_2 = channel_fifo_s_reset;
assign channel_fifo_s_reset_3 = channel_fifo_s_reset;
assign channel_fifo_s_reset_4 = channel_fifo_s_reset;
assign channel_fifo_s_reset_5 = channel_fifo_s_reset;
assign channel_fifo_s_reset_6 = channel_fifo_s_reset;
assign channel_fifo_s_reset_7 = channel_fifo_s_reset;

always @(posedge clk) begin
	if (reset) begin
		// reset
		channel_fifo_s_reset <= 1'b0;
	end	else if ((cycle_counter >= start_point + 12'h0011)&(cycle_counter <= start_point + 12'h0013)) begin
		channel_fifo_s_reset <= ~idle_cylce_r;//1'b1;
	end else begin
		channel_fifo_s_reset <= 1'b0;
	end
end

reg eth_bridge_fifo_rd;
wire [119:0] eth_bridge_fifo_reg_data;
reg [119:0] eth_bridge_fifo_reg_data_r;assign tx_axis_fifo_tdata = eth_bridge_fifo_reg_data_r[119:112];
wire eth_bridge_fifo_reg_data_empty;
reg[9:0] byte_set=10'b0;
eth_bridge_fifo eth_bridge_fifo_inst (
  .rst(reset),        // input wire rst
  .wr_clk(clk),  // input wire wr_clk
  .rd_clk(mac_clk),  // input wire rd_clk
  .din(eth_fifo_data),        // input wire [119 : 0] din
  .wr_en(eth_fifo_write),    // input wire wr_en
  .rd_en(eth_bridge_fifo_rd),    // input wire rd_en
  .dout(eth_bridge_fifo_reg_data),      // output wire [119 : 0] dout
  .full(),      // output wire full
  .empty(eth_bridge_fifo_reg_data_empty)    // output wire empty
);


always @(posedge mac_clk) begin
	if (reset) begin
		// reset
		byte_set <= 12'b0;
		eth_bridge_fifo_reg_data_r <= 120'b0;
		eth_bridge_fifo_rd <= 1'b0;
		tx_axis_fifo_tvalid <= 1'b0;
		tx_axis_fifo_tlast <= 1'b0;
	end	else if ((~eth_bridge_fifo_reg_data_empty)&
				 ((byte_set == 12'd0)|
				  (byte_set == 12'd14)|
				  (byte_set == 12'd30)|
				  (byte_set == 12'd46)|
				  (byte_set == 12'd62)|
				  (byte_set == 12'd78)|
				  (byte_set == 12'd94)|
				  (byte_set == 12'd110)|
				  (byte_set == 12'd126)|
				  (byte_set == 12'd142)|
				  (byte_set == 12'd158)|
				  (byte_set == 12'd174)|
				  (byte_set == 12'd190)|
				  (byte_set == 12'd206)|
				  (byte_set == 12'd222)|
				  (byte_set == 12'd238)|
				  (byte_set == 12'd254)|
				  (byte_set == 12'd270)|
				  (byte_set == 12'd281))
				 ) begin
		if(|eth_bridge_fifo_reg_data)begin
			byte_set <=byte_set + 12'b1;
			eth_bridge_fifo_reg_data_r <= eth_bridge_fifo_reg_data;
			eth_bridge_fifo_rd <= 1'b1;
			tx_axis_fifo_tvalid <= 1'b1;
			tx_axis_fifo_tlast <= 1'b0;
		end else begin
			byte_set <=byte_set + 12'b1;
			eth_bridge_fifo_rd <= 1'b1;
			tx_axis_fifo_tvalid <= (byte_set != 12'd281);
			tx_axis_fifo_tlast <= (byte_set != 12'd281);
		end
	end else if(
		((byte_set >= 12'd1)  &(byte_set <= 12'd13 ))|//13
		((byte_set >= 12'd15) &(byte_set <= 12'd29 ))|//15 1
		((byte_set >= 12'd31) &(byte_set <= 12'd45 ))|//15 2
		((byte_set >= 12'd47) &(byte_set <= 12'd61 ))|//15 3
		((byte_set >= 12'd63) &(byte_set <= 12'd77 ))|//15 4
		((byte_set >= 12'd79) &(byte_set <= 12'd93 ))|//15 5
		((byte_set >= 12'd95) &(byte_set <= 12'd109))|//15 6
		((byte_set >= 12'd111)&(byte_set <= 12'd125))|//15 7
		((byte_set >= 12'd127)&(byte_set <= 12'd141))|//15 8
		((byte_set >= 12'd143)&(byte_set <= 12'd157))|//15 9
		((byte_set >= 12'd159)&(byte_set <= 12'd173))|//15 10
		((byte_set >= 12'd175)&(byte_set <= 12'd189))|//15 11
		((byte_set >= 12'd191)&(byte_set <= 12'd205))|//15 12
		((byte_set >= 12'd207)&(byte_set <= 12'd221))|//15 13
		((byte_set >= 12'd223)&(byte_set <= 12'd237))|//15 14
		((byte_set >= 12'd239)&(byte_set <= 12'd253))|//15 15
		((byte_set >= 12'd255)&(byte_set <= 12'd269))|//15 16
		((byte_set >= 12'd271)&(byte_set <= 12'd278))
		)begin
		eth_bridge_fifo_rd <= 1'b0;
		tx_axis_fifo_tvalid <= 1'b1;
		tx_axis_fifo_tlast <= 1'b0;
		if(tx_axis_fifo_tready)begin
			byte_set <= byte_set + 10'b1;
			eth_bridge_fifo_reg_data_r <= eth_bridge_fifo_reg_data_r << 8;
			tx_axis_fifo_tvalid <=~((byte_set == 12'd13 )|
								   (byte_set == 12'd29 )|
								   (byte_set == 12'd45 )|
								   (byte_set == 12'd61 )|
								   (byte_set == 12'd77 )|
								   (byte_set == 12'd93 )|
								   (byte_set == 12'd109)|
								   (byte_set == 12'd125)|
								   (byte_set == 12'd141)|
								   (byte_set == 12'd157)|
								   (byte_set == 12'd173)|
								   (byte_set == 12'd189)|
								   (byte_set == 12'd205)|
								   (byte_set == 12'd221)|
								   (byte_set == 12'd237)|
								   (byte_set == 12'd253)|
								   (byte_set == 12'd269));
		end 
	end else if(byte_set == 12'd279)begin
		eth_bridge_fifo_rd <= 1'b0;
		tx_axis_fifo_tvalid <= 1'b1;
		tx_axis_fifo_tlast <= 1'b0;
		if(tx_axis_fifo_tready)begin
			byte_set <= byte_set + 10'b1;
			eth_bridge_fifo_reg_data_r <= eth_bridge_fifo_reg_data_r << 8;
			tx_axis_fifo_tlast <= 1'b1;
		end 
	end else if(byte_set == 12'd280) begin
		eth_bridge_fifo_rd <= 1'b0;
		tx_axis_fifo_tvalid <= 1'b1;
		tx_axis_fifo_tlast <= 1'b1;
		if(tx_axis_fifo_tready)begin
			byte_set <= byte_set + 10'b1;
			eth_bridge_fifo_reg_data_r <= eth_bridge_fifo_reg_data_r << 8;
			tx_axis_fifo_tvalid <= 1'b0;
			tx_axis_fifo_tlast <= 1'b0;
		end 
	end else begin
		byte_set <= 12'b0;
		eth_bridge_fifo_reg_data_r <= 120'b0;
		eth_bridge_fifo_rd <= 1'b0;
		tx_axis_fifo_tvalid <= 1'b0;
		tx_axis_fifo_tlast <= 1'b0;
	end
end

  readout_control_ila readout_control_ila_inst (
    .clk(clk), // input wire clk

    .probe0(cycle_counter), // input wire [11:0] probe0
    .probe1(sample_cycle_counter),//input wire [11:0] probe1
    .probe2(cycle_counter_pasue),//input wire [0:0] probe2
    .probe3(packet_count), // input wire [7:0] probe3
    .probe4(counter_th), // input wire [11:0] probe4
    .probe5(start_point), // input wire [11:0] probe5
    .probe6(readout_processing), // input wire [0:0] probe6
    .probe7(channel_not_empty_r), // input wire [7:0] probe7
    .probe8(channel_not_empty), // input wire [7:0] probe8
    .probe9(channel_not_empty_r_one_hot), // input wire [7:0] probe9
    .probe10(idle_cyle_num), // input wire [15:0] probe10
    .probe11(idle_counter_number_th), // input wire [15:0] probe11
    .probe12(idle_cylce), // input wire [0:0] prob12
    .probe13(idle_cylce_r), // input wire [0:0] probe13

    .probe14(eth_fifo_data), // input wire [119:0] probe14
    .probe15(eth_fifo_write), // input wire [0:0] probe15
    .probe16(data_tran_stop), // input wire [0:0] probe16  
    .probe17(channel_fifo_s_reset) // input wire [0:0] probe17
  );
  readout_control_mac_ila readout_control_mac_ila_inst (
    .clk(mac_clk), // input wire clk

    .probe0(byte_set), // input wire [9:0] probe0
    .probe1(eth_bridge_fifo_reg_data_r), // input wire [119:0] probe1
    .probe2(eth_bridge_fifo_rd), // input wire [0:0] probe2
    .probe3(tx_axis_fifo_tvalid), // input wire [0:0] probe3
    .probe4(tx_axis_fifo_tlast), // input wire [0:0] probe4
    .probe5(eth_bridge_fifo_reg_data), // input wire [119:0] probe5
    .probe6(tx_axis_fifo_tready), // input wire [0:0] probe6
    .probe7(tx_axis_fifo_tdata),// input wire [7:0] probe7
    .probe8(eth_bridge_fifo_reg_data_empty)// input wire [0:0] probe8
  );

endmodule