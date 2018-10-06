/* 
       _________   ________     _______       
      / U OF M  \ | LSA    \   /Physics\
      \__ATLAS__/ |   ___   | |   _____/
         |   |    |  |   \  | |  |____
         |   |    |  |___/  | \_____   \   
         |   |    |         |  _____\   | 
         \___/    |________/  |________/  
*/
//  File Name  : deserial_pad_data.v
//  Author     : Jinhong Wang modify by ly in Aug 12th 2017
//  Revision   : V0.01, created Jan. 13, 2017
//               Top-warp of pad mode check: check each pad channel, and its delay compensation circuit


`timescale 1ns / 1ps
`define DLY #1

//***********************************Entity Declaration************************
(* DowngradeIPIdentifiedWarnings="yes" *)
module deserial_pad_data                           
(
    // User Interface
    input  wire [19:0] RX_DATA_IN,


    // System Interface
    input           clk160,
    input           USER_CLK,
    input           SYSTEM_RESET,
    input           reset_160M,

    output reg [115:0]    data_out,
    output data_valid,
    output [18:0] link_message 
);

reg [1:0] count_160M_40M = 2'b00;
always @(posedge clk160) begin
    count_160M_40M <= count_160M_40M +2'b01;
end
assign data_valid = &count_160M_40M;

parameter RX_DATA_WIDTH=20;

//***************************Internal Register Declarations******************** 

(* ASYNC_REG = "TRUE" *) (* keep = "true" *)reg             system_reset_r;
(* ASYNC_REG = "TRUE" *) (* keep = "true" *)reg             system_reset_r2;

 (* keep = "TRUE" *)   reg     [19:0] rx_data_r1;
 (* keep = "TRUE" *)   reg     [19:0] rx_data_r2;
  (* keep = "TRUE" *)  reg     [19:0] rx_data_r3;
 (* keep = "TRUE" *)   reg     [19:0] rx_data_r4;
 (* keep = "TRUE" *)   reg     [19:0] rx_data_r5;
 (* keep = "TRUE" *)   reg     [19:0] rx_data_r6,RX_DATA_IN_r;
 
reg [19:0] rx_data_r1_r,rx_data_r2_r,rx_data_r3_r,rx_data_r4_r,rx_data_r5_r,rx_data_r6_r;
wire [6:0] chnlnum;

parameter idle =4'b0, st0=4'b1,st1=4'b10,st2=4'b11,st3=4'b100,st4=4'b101,st5=4'b110,st6=4'b111,st7=4'b1000,st8=4'b1001,st_rxrst=4'b1010;
reg     [3 :0] state;

reg     [4:0] err_cnt;
(* keep = "TRUE" *)  reg     [8:0] syn_cnt;
     
reg gtp_rx_rst_r,gtp_rx_rst_start,gtp_rx_rst_r1;
reg [2:0] rxrstcnt;

reg [2:0] s_cnt;
 
(* keep = "TRUE" *) wire [119 :0] padtds_d0;
(* keep = "TRUE" *) reg [119 :0]  padtds_d1,padtds_d2;
 
(* keep = "TRUE" *) wire [119:0] padtds_d;
 
reg [28 :0] descr_din;
wire [28 :0] des_dout;
(* keep = "TRUE" *)    reg [115 :0] des_pdata,des_padata_r;
(* keep = "TRUE" *)    wire des_framein;

     
reg [11 :0] cnt4bcid1,cnt4bcid2;  
(* keep = "TRUE" *) reg [11:0]  bcid_r0,bcid_r1,bcid_r2;
reg [11:0] bcid_chk0,bcid_chk1;
wire rst_chk_cnt;
    
    
wire hit_flag;
reg hit_flag_r;
reg [1:0] hit_flag_rr;
reg [6:0] pos;
    
        ///------------
parameter vio_s0=4'b0,vio_s01=4'b101,vio_s02=4'b110, vio_s03=4'b111, vio_s1=4'b1, vio_s2=4'b10,vio_s3=4'b100;
reg [3:0] vio_state;
wire  vio_st_rst;
//    wire vio_div_clk;
reg  [8:0] vio_err_cnt;
reg  [11:0] vio_syn_cnt0,vio_syn_cnt1;
reg vio_syn_locked;

(* keep = "TRUE" *) reg  [11:0] bcid_locked,bcid_locked_r1,bcid_locked_r2;
//*********************************Main Body of Code***************************


function [119:0] p_data(input [119:0] padtds_d1,padtds_d0,input [6:0] pos);
  begin
    if(pos==7'b1110111)
        p_data =padtds_d1[119:0];
    else if(pos==7'b1110110)
        p_data ={padtds_d1[118:0],padtds_d0[119]};
    else if(pos==7'b1110101)
        p_data ={padtds_d1[117:0],padtds_d0[119:118]};
    else if(pos==7'b1110100)
        p_data ={padtds_d1[116:0],padtds_d0[119:117]};
    else if(pos==7'b1110011)
        p_data ={padtds_d1[115:0],padtds_d0[119:116]};
    else if(pos==7'b1110010)
        p_data ={padtds_d1[114:0],padtds_d0[119:115]};
    else if(pos==7'b1110001)
        p_data ={padtds_d1[113:0],padtds_d0[119:114]};
    else if(pos==7'b1110000)
        p_data ={padtds_d1[112:0],padtds_d0[119:113]};
    else if(pos==7'b1101111)
        p_data ={padtds_d1[111:0],padtds_d0[119:112]};
    else if(pos==7'b1101110)
        p_data ={padtds_d1[110:0],padtds_d0[119:111]};
    else if(pos==7'b1101101)
        p_data ={padtds_d1[109:0],padtds_d0[119:110]};
    else if(pos==7'b1101100)
        p_data ={padtds_d1[108:0],padtds_d0[119:109]};
    else if(pos==7'b1101011)
        p_data ={padtds_d1[107:0],padtds_d0[119:108]};
    else if(pos==7'b1101010)
        p_data ={padtds_d1[106:0],padtds_d0[119:107]};
    else if(pos==7'b1101001)
        p_data ={padtds_d1[105:0],padtds_d0[119:106]};
    else if(pos==7'b1101000)
        p_data ={padtds_d1[104:0],padtds_d0[119:105]};
    else if(pos==7'b1100111)
        p_data ={padtds_d1[103:0],padtds_d0[119:104]};
    else if(pos==7'b1100110)
        p_data ={padtds_d1[102:0],padtds_d0[119:103]};
    else if(pos==7'b1100101)
        p_data ={padtds_d1[101:0],padtds_d0[119:102]};
    else if(pos==7'b1100100)
        p_data ={padtds_d1[100:0],padtds_d0[119:101]};
    else if(pos==7'b1100011)
        p_data ={padtds_d1[99:0],padtds_d0[119:100]};
    else if(pos==7'b1100010)
        p_data ={padtds_d1[98:0],padtds_d0[119:99]};
    else if(pos==7'b1100001)
        p_data ={padtds_d1[97:0],padtds_d0[119:98]};
    else if(pos==7'b1100000)
        p_data ={padtds_d1[96:0],padtds_d0[119:97]};
    else if(pos==7'b1011111)
        p_data ={padtds_d1[95:0],padtds_d0[119:96]};
    else if(pos==7'b1011110)
        p_data ={padtds_d1[94:0],padtds_d0[119:95]};
    else if(pos==7'b1011101)
        p_data ={padtds_d1[93:0],padtds_d0[119:94]};
    else if(pos==7'b1011100)
        p_data ={padtds_d1[92:0],padtds_d0[119:93]};
    else if(pos==7'b1011011)
        p_data ={padtds_d1[91:0],padtds_d0[119:92]};
    else if(pos==7'b1011010)
        p_data ={padtds_d1[90:0],padtds_d0[119:91]};
    else if(pos==7'b1011001)
        p_data ={padtds_d1[89:0],padtds_d0[119:90]};
    else if(pos==7'b1011000)
        p_data ={padtds_d1[88:0],padtds_d0[119:89]};
    else if(pos==7'b1010111)
        p_data ={padtds_d1[87:0],padtds_d0[119:88]};
    else if(pos==7'b1010110)
        p_data ={padtds_d1[86:0],padtds_d0[119:87]};
    else if(pos==7'b1010101)
        p_data ={padtds_d1[85:0],padtds_d0[119:86]};
    else if(pos==7'b1010100)
        p_data ={padtds_d1[84:0],padtds_d0[119:85]};
    else if(pos==7'b1010011)
        p_data ={padtds_d1[83:0],padtds_d0[119:84]};
    else if(pos==7'b1010010)
        p_data ={padtds_d1[82:0],padtds_d0[119:83]};
    else if(pos==7'b1010001)
        p_data ={padtds_d1[81:0],padtds_d0[119:82]};
    else if(pos==7'b1010000)
        p_data ={padtds_d1[80:0],padtds_d0[119:81]};
    else if(pos==7'b1001111)
        p_data ={padtds_d1[79:0],padtds_d0[119:80]};
    else if(pos==7'b1001110)
        p_data ={padtds_d1[78:0],padtds_d0[119:79]};
    else if(pos==7'b1001101)
        p_data ={padtds_d1[77:0],padtds_d0[119:78]};
    else if(pos==7'b1001100)
        p_data ={padtds_d1[76:0],padtds_d0[119:77]};
    else if(pos==7'b1001011)
        p_data ={padtds_d1[75:0],padtds_d0[119:76]};
    else if(pos==7'b1001010)
        p_data ={padtds_d1[74:0],padtds_d0[119:75]};
    else if(pos==7'b1001001)
        p_data ={padtds_d1[73:0],padtds_d0[119:74]};
    else if(pos==7'b1001000)
        p_data ={padtds_d1[72:0],padtds_d0[119:73]};
    else if(pos==7'b1000111)
        p_data ={padtds_d1[71:0],padtds_d0[119:72]};
    else if(pos==7'b1000110)
        p_data ={padtds_d1[70:0],padtds_d0[119:71]};
    else if(pos==7'b1000101)
        p_data ={padtds_d1[69:0],padtds_d0[119:70]};
    else if(pos==7'b1000100)
        p_data ={padtds_d1[68:0],padtds_d0[119:69]};
    else if(pos==7'b1000011)
        p_data ={padtds_d1[67:0],padtds_d0[119:68]};
    else if(pos==7'b1000010)
        p_data ={padtds_d1[66:0],padtds_d0[119:67]};
    else if(pos==7'b1000001)
        p_data ={padtds_d1[65:0],padtds_d0[119:66]};
    else if(pos==7'b1000000)
        p_data ={padtds_d1[64:0],padtds_d0[119:65]};
    else if(pos==7'b111111)
        p_data ={padtds_d1[63:0],padtds_d0[119:64]};
    else if(pos==7'b111110)
        p_data ={padtds_d1[62:0],padtds_d0[119:63]};
    else if(pos==7'b111101)
        p_data ={padtds_d1[61:0],padtds_d0[119:62]};
    else if(pos==7'b111100)
        p_data ={padtds_d1[60:0],padtds_d0[119:61]};
    else if(pos==7'b111011)
        p_data ={padtds_d1[59:0],padtds_d0[119:60]};
    else if(pos==7'b111010)
        p_data ={padtds_d1[58:0],padtds_d0[119:59]};
    else if(pos==7'b111001)
        p_data ={padtds_d1[57:0],padtds_d0[119:58]};
    else if(pos==7'b111000)
        p_data ={padtds_d1[56:0],padtds_d0[119:57]};
    else if(pos==7'b110111)
        p_data ={padtds_d1[55:0],padtds_d0[119:56]};
    else if(pos==7'b110110)
        p_data ={padtds_d1[54:0],padtds_d0[119:55]};
    else if(pos==7'b110101)
        p_data ={padtds_d1[53:0],padtds_d0[119:54]};
    else if(pos==7'b110100)
        p_data ={padtds_d1[52:0],padtds_d0[119:53]};
    else if(pos==7'b110011)
        p_data ={padtds_d1[51:0],padtds_d0[119:52]};
    else if(pos==7'b110010)
        p_data ={padtds_d1[50:0],padtds_d0[119:51]};
    else if(pos==7'b110001)
        p_data ={padtds_d1[49:0],padtds_d0[119:50]};
    else if(pos==7'b110000)
        p_data ={padtds_d1[48:0],padtds_d0[119:49]};
    else if(pos==7'b101111)
        p_data ={padtds_d1[47:0],padtds_d0[119:48]};
    else if(pos==7'b101110)
        p_data ={padtds_d1[46:0],padtds_d0[119:47]};
    else if(pos==7'b101101)
        p_data ={padtds_d1[45:0],padtds_d0[119:46]};
    else if(pos==7'b101100)
        p_data ={padtds_d1[44:0],padtds_d0[119:45]};
    else if(pos==7'b101011)
        p_data ={padtds_d1[43:0],padtds_d0[119:44]};
    else if(pos==7'b101010)
        p_data ={padtds_d1[42:0],padtds_d0[119:43]};
    else if(pos==7'b101001)
        p_data ={padtds_d1[41:0],padtds_d0[119:42]};
    else if(pos==7'b101000)
        p_data ={padtds_d1[40:0],padtds_d0[119:41]};
    else if(pos==7'b100111)
        p_data ={padtds_d1[39:0],padtds_d0[119:40]};
    else if(pos==7'b100110)
        p_data ={padtds_d1[38:0],padtds_d0[119:39]};
    else if(pos==7'b100101)
        p_data ={padtds_d1[37:0],padtds_d0[119:38]};
    else if(pos==7'b100100)
        p_data ={padtds_d1[36:0],padtds_d0[119:37]};
    else if(pos==7'b100011)
        p_data ={padtds_d1[35:0],padtds_d0[119:36]};
    else if(pos==7'b100010)
        p_data ={padtds_d1[34:0],padtds_d0[119:35]};
    else if(pos==7'b100001)
        p_data ={padtds_d1[33:0],padtds_d0[119:34]};
    else if(pos==7'b100000)
        p_data ={padtds_d1[32:0],padtds_d0[119:33]};
    else if(pos==7'b11111)
        p_data ={padtds_d1[31:0],padtds_d0[119:32]};
    else if(pos==7'b11110)
        p_data ={padtds_d1[30:0],padtds_d0[119:31]};
    else if(pos==7'b11101)
        p_data ={padtds_d1[29:0],padtds_d0[119:30]};
    else if(pos==7'b11100)
        p_data ={padtds_d1[28:0],padtds_d0[119:29]};
    else if(pos==7'b11011)
        p_data ={padtds_d1[27:0],padtds_d0[119:28]};
    else if(pos==7'b11010)
        p_data ={padtds_d1[26:0],padtds_d0[119:27]};
    else if(pos==7'b11001)
        p_data ={padtds_d1[25:0],padtds_d0[119:26]};
    else if(pos==7'b11000)
        p_data ={padtds_d1[24:0],padtds_d0[119:25]};
    else if(pos==7'b10111)
        p_data ={padtds_d1[23:0],padtds_d0[119:24]};
    else if(pos==7'b10110)
        p_data ={padtds_d1[22:0],padtds_d0[119:23]};
    else if(pos==7'b10101)
        p_data ={padtds_d1[21:0],padtds_d0[119:22]};
    else if(pos==7'b10100)
        p_data ={padtds_d1[20:0],padtds_d0[119:21]};
    else if(pos==7'b10011)
        p_data ={padtds_d1[19:0],padtds_d0[119:20]};
    else if(pos==7'b10010)
        p_data ={padtds_d1[18:0],padtds_d0[119:19]};
    else if(pos==7'b10001)
        p_data ={padtds_d1[17:0],padtds_d0[119:18]};
    else if(pos==7'b10000)
        p_data ={padtds_d1[16:0],padtds_d0[119:17]};
    else if(pos==7'b1111)
        p_data ={padtds_d1[15:0],padtds_d0[119:16]};
    else if(pos==7'b1110)
        p_data ={padtds_d1[14:0],padtds_d0[119:15]};
    else if(pos==7'b1101)
        p_data ={padtds_d1[13:0],padtds_d0[119:14]};
    else if(pos==7'b1100)
        p_data ={padtds_d1[12:0],padtds_d0[119:13]};
    else if(pos==7'b1011)
        p_data ={padtds_d1[11:0],padtds_d0[119:12]};
    else if(pos==7'b1010)
        p_data ={padtds_d1[10:0],padtds_d0[119:11]};
    else if(pos==7'b1001)
        p_data ={padtds_d1[9:0],padtds_d0[119:10]};
    else if(pos==7'b1000)
        p_data ={padtds_d1[8:0],padtds_d0[119:9]};
    else if(pos==7'b111)
        p_data ={padtds_d1[7:0],padtds_d0[119:8]};
    else if(pos==7'b110)
        p_data ={padtds_d1[6:0],padtds_d0[119:7]};
    else if(pos==7'b101)
        p_data ={padtds_d1[5:0],padtds_d0[119:6]};
    else if(pos==7'b100)
        p_data ={padtds_d1[4:0],padtds_d0[119:5]};
    else if(pos==7'b11)
        p_data ={padtds_d1[3:0],padtds_d0[119:4]};
    else if(pos==7'b10)
        p_data ={padtds_d1[2:0],padtds_d0[119:3]};
    else if(pos==7'b1)
        p_data ={padtds_d1[1:0],padtds_d0[119:2]};
    else if(pos==7'b0)
        p_data ={padtds_d1[0:0],padtds_d0[119:1]};
  end 
endfunction



 //___________ synchronizing the async reset for ease of timing simulation ________
    always@(posedge USER_CLK)
      begin
       system_reset_r <= SYSTEM_RESET;    
       system_reset_r2 <= system_reset_r; 
     end   
     

     
     
    always @(posedge USER_CLK) begin
    if(system_reset_r2 == 1'b1)
      s_cnt <= 3'b0;
    else if(s_cnt == 3'b101)
      s_cnt <= 3'b0;
    else 
      s_cnt <= s_cnt + 1'b1;
    end

         //buffer input data 
         always @(posedge USER_CLK )
         begin
         if(system_reset_r== 1'b1) begin
            rx_data_r1 <= 'b0;
            rx_data_r2 <= 'b0;
            rx_data_r3 <= 'b0;
            rx_data_r4 <= 'b0;
            rx_data_r5 <= 'b0;
            rx_data_r6 <= 'b0; end
          else begin
            rx_data_r1 <= RX_DATA_IN; //RX_DATA_IN_r;
            rx_data_r2 <= rx_data_r1;
            rx_data_r3 <= rx_data_r2;
            rx_data_r4 <= rx_data_r3;
            rx_data_r5 <= rx_data_r4;
            rx_data_r6 <= rx_data_r5; end
          end
          
          always@(posedge USER_CLK)begin
          if(s_cnt == 3'b10) begin
            rx_data_r1_r <= rx_data_r1;
            rx_data_r2_r <= rx_data_r2;
            rx_data_r3_r <= rx_data_r3;
            rx_data_r4_r <= rx_data_r4;
            rx_data_r5_r <= rx_data_r5;
            rx_data_r6_r <= rx_data_r6;
          end
          end
          
    assign padtds_d0 ={rx_data_r6_r,rx_data_r5_r,rx_data_r4_r,rx_data_r3_r,rx_data_r2_r,rx_data_r1_r};    
    
    always @(posedge USER_CLK) begin
     if(s_cnt == 3'b11) begin
      padtds_d1 <= padtds_d0;
      padtds_d2 <= padtds_d1; end
    end
    
    assign padtds_d = p_data(padtds_d2,padtds_d1,pos);

     //state machine for synchronization
     reg locked = 1'b0;


     always @(posedge USER_CLK)
     begin
     if(system_reset_r2 ==1'b1) begin
        state <= idle;
        syn_cnt <= 'b0;
        err_cnt <= 'b0;
        pos <= 7'b0;
        gtp_rx_rst_start <= 1'b0;
        rxrstcnt <= 3'b0;
        locked <= 1'b0;
        end
     else begin
        locked <= 1'b0;
        case(state)
        idle: begin
              if(s_cnt == 3'b101 ) begin // when pll0 is locked

               state <= st2;
               syn_cnt <= 'b0;
               err_cnt <= 'b0;
               end
              end

        st1:  begin
              if(s_cnt == 3'b101 ) begin 
               state <= st2;
               end
              end
        st2:  begin
              if(padtds_d[119:116]==4'b1010)
               syn_cnt <= syn_cnt + 1'b1;
              else
               err_cnt <= err_cnt + 1'b1;
              
              state <= st3;
              end
        st3:  begin
              if(syn_cnt > 9'b111111100 && err_cnt < 5'b11) begin // syn established
                state <= st4;
                end
              else if (err_cnt > 5'b100) begin // to many errors established
                pos <= pos +1'b1;
                state <= idle;               // ------>> got some errors at the very beginning
                end
              else begin
                state <= st1;//->>
                end
              end
        st4:  begin // begin to align the phase of user clock,calculate the amount of phase shift
                locked <= 1'b1;
                if(s_cnt == 3'b101 ) begin // when pll0 is locked
                    state <= st5;end
            end
            
            
        st5 : begin
            locked <= 1'b1;
             if(padtds_d[119:116]!=4'b1010)
                err_cnt <= err_cnt + 1'b1;
             if(err_cnt[4] ==1'b1)begin
                   state <= idle;
                   locked <= 1'b0;    
              end else 
                   state <= st4;
              end

        default:  state <= idle;
      endcase;
     end
     end
     
    wire [18:0] monitor_meesage;
    assign monitor_meesage = {state,locked,syn_cnt,err_cnt};//[3:0],[0:0],[8:0],[4:0]

    fifo_pad_error_syn fifo_pad_error_syn_inst (
        .rst(reset_160M),        // input wire rst
        .wr_clk(USER_CLK),  // input wire wr_clk
        .rd_clk(clk160),  // input wire rd_clk
        .din(monitor_meesage),        // input wire [115 : 0] din
        .wr_en(s_cnt == 3'b0),    // input wire wr_en
        .rd_en(data_valid),    // input wire rd_en
        .dout(link_message),      // output wire [115 : 0] dout
        .full(),      // output wire full
        .empty()    // output wire empty
    );


     always @(posedge USER_CLK) begin
     if(s_cnt == 3'b100)
        descr_din = padtds_d[115 : 87];//{padtds_d[62:60],padtds_d[115:90]};
     else if(s_cnt == 3'b101)
        descr_din = padtds_d[86:58]; //{padtds_d[31:30],padtds_d[89:63]};
     else if(s_cnt == 3'b0)
        descr_din = padtds_d[57:29];//{padtds_d[0],padtds_d[59:32]};
     else if(s_cnt == 3'b1)
        descr_din = padtds_d[28:0];
     end
     
     assign des_framein=( s_cnt==3'b101 ||  s_cnt==3'b0 || s_cnt==3'b1 || s_cnt==3'b10) ? 1'b1 : 1'b0;  
    descrambler4pad descr_inst( .datain(descr_din), .clk(USER_CLK), .bypass(1'b0),  .rst(1'b0), .framein(des_framein),
                             .dataout(des_dout) );
     
     always @(posedge USER_CLK)begin
     if(s_cnt == 3'b0)
           des_pdata[115:87] <= des_dout;
     else if(s_cnt == 3'b1)
           des_pdata[86:58] <= des_dout;   
     else if(s_cnt == 3'b10)
           des_pdata[57:29] <= des_dout;
     else if(s_cnt == 3'b11)
           des_pdata[28:0] <= des_dout;  
     end     
     
     always @(posedge USER_CLK)begin
     if(s_cnt == 3'b100)
        des_padata_r <= des_pdata;
     end 
     
     reg [115:0] des_padata_locked; 

   
   assign hit_flag = |des_padata_r[103:0];


    always @(posedge USER_CLK) begin
       if (s_cnt == 3'b11) begin
          des_padata_locked <= des_padata_r;
          bcid_locked <= des_padata_r[115:104];
          hit_flag_r <= hit_flag;
       end
    end

wire [115:0] des_padata_locked_160M;
wire syn_fifo_empty;
fifo_pad_data_syn fifo_pad_data_syn_inst (
  .rst(reset_160M),        // input wire rst
  .wr_clk(USER_CLK),  // input wire wr_clk
  .rd_clk(clk160),  // input wire rd_clk
  .din(des_padata_locked),        // input wire [115 : 0] din
  .wr_en(s_cnt == 3'b0),    // input wire wr_en
  .rd_en(data_valid),    // input wire rd_en
  .dout(des_padata_locked_160M),      // output wire [115 : 0] dout
  .full(),      // output wire full
  .empty(syn_fifo_empty)    // output wire empty
);

always @(posedge clk160) begin
    data_out <= des_padata_locked_160M;
end





// ila_pad_data_160M ila_pad_data_160M_inst (
//   .clk(clk160), // input wire clk
//   .probe0(des_padata_locked_160M), // input wire [115:0] probe0
//   .probe1(syn_fifo_empty) // input wire [0:0] probe1
// );
//wire [11:0] raw_BCID;
//wire [103:0] raw_data;
//assign raw_BCID =des_padata_locked[115:104];
//assign raw_data=des_padata_locked[103:0];
//ila_pad_data_240M ila_pad_data_240M_inst (
//  .clk(USER_CLK), // input wire clk
//  .probe0(pos), // input wire [6:0] probe0
//  .probe1(syn_cnt), // input wire [8:0] probe1
//  .probe2(err_cnt),//input wire [4:0] probe1
//  .probe3(s_cnt),//[2:0]
//  .probe4(state),//[3:0]
//  .probe5(padtds_d2),//[119:0]
//  .probe6(padtds_d1),//[119:0]
//  .probe7(padtds_d),//[119:0]
//  .probe8(des_pdata),//[115:0]
//  .probe9(raw_BCID),//[11:0]
//  .probe10(raw_data),//[103:0]
//  .probe11(des_padata_locked_160M)//115:0  
//);

endmodule   