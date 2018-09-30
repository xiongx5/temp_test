
/* 
       _________   ________     _______       
      / U OF M  \ | LSA    \   /Physics\
      \__ATLAS__/ |   ___   | |   _____/
         |   |    |  |   \  | |  |____
         |   |    |  |___/  | \_____   \   
         |   |    |         |  _____\   | 
         \___/    |________/  |________/  
*/
//  File Name  : descrambler.v
//  Author     : Jinhong Wang
//  Revision   : 
//               Revision 0.01 : first created @ 05/21/2013
//  Function   : 
//               descrambler adapted from 10 G ethernet
//               use polynomial 1+x^39+x^58
// 
`timescale 1 ps /1 ps
module descrambler4pad(
input [28 :0] datain,
input clk,bypass,rst,framein,
output [28 :0] dataout
);

reg [57:0] l_lfsr_q;
reg [28 :0] l_dataout_r,l_dataout_r0;


assign dataout = l_dataout_r0;

always @(posedge clk)
begin
   // l_frameout_r <= framein;
    l_dataout_r0 <= l_dataout_r;
end

/*feed back loop*/
always @(posedge clk)
begin
    if(rst==1'b1)
    l_lfsr_q <='b0;
    else if(framein==1'b1)
    begin
    l_lfsr_q[57:29] <= l_lfsr_q[28:0];
    l_lfsr_q[28]  <= datain[0];
    l_lfsr_q[27]  <= datain[1];
    l_lfsr_q[26]  <= datain[2];
    l_lfsr_q[25]  <= datain[3];
    l_lfsr_q[24]  <= datain[4];
    l_lfsr_q[23]  <= datain[5];
    l_lfsr_q[22]  <= datain[6];
    l_lfsr_q[21]  <= datain[7];
    l_lfsr_q[20]  <= datain[8];
    l_lfsr_q[19]  <= datain[9];
    l_lfsr_q[18]  <= datain[10];
    l_lfsr_q[17]  <= datain[11];
    l_lfsr_q[16]  <= datain[12];
    l_lfsr_q[15]  <= datain[13];
    l_lfsr_q[14]  <= datain[14];
    l_lfsr_q[13]  <= datain[15];
    l_lfsr_q[12]  <= datain[16];
    l_lfsr_q[11]  <= datain[17];
    l_lfsr_q[10]  <= datain[18];
    l_lfsr_q[9]  <= datain[19];
    l_lfsr_q[8]  <= datain[20];
    l_lfsr_q[7]  <= datain[21];
    l_lfsr_q[6]  <= datain[22];
    l_lfsr_q[5]  <= datain[23];
    l_lfsr_q[4]  <= datain[24];
    l_lfsr_q[3]  <= datain[25];
    l_lfsr_q[2]  <= datain[26];
    l_lfsr_q[1]  <= datain[27];
    l_lfsr_q[0]  <= datain[28];
end
    
end

always@(*)
begin
    l_dataout_r[0]=(bypass==1'b0)?(l_lfsr_q[57]^l_lfsr_q[38]^datain[0]):datain[0];
    l_dataout_r[1]=(bypass==1'b0)?(l_lfsr_q[56]^l_lfsr_q[37]^datain[1]):datain[1];
    l_dataout_r[2]=(bypass==1'b0)?(l_lfsr_q[55]^l_lfsr_q[36]^datain[2]):datain[2];
    l_dataout_r[3]=(bypass==1'b0)?(l_lfsr_q[54]^l_lfsr_q[35]^datain[3]):datain[3];
    l_dataout_r[4]=(bypass==1'b0)?(l_lfsr_q[53]^l_lfsr_q[34]^datain[4]):datain[4];
    l_dataout_r[5]=(bypass==1'b0)?(l_lfsr_q[52]^l_lfsr_q[33]^datain[5]):datain[5];
    l_dataout_r[6]=(bypass==1'b0)?(l_lfsr_q[51]^l_lfsr_q[32]^datain[6]):datain[6];
    l_dataout_r[7]=(bypass==1'b0)?(l_lfsr_q[50]^l_lfsr_q[31]^datain[7]):datain[7];
    l_dataout_r[8]=(bypass==1'b0)?(l_lfsr_q[49]^l_lfsr_q[30]^datain[8]):datain[8];
    l_dataout_r[9]=(bypass==1'b0)?(l_lfsr_q[48]^l_lfsr_q[29]^datain[9]):datain[9];
    l_dataout_r[10]=(bypass==1'b0)?(l_lfsr_q[47]^l_lfsr_q[28]^datain[10]):datain[10];
    l_dataout_r[11]=(bypass==1'b0)?(l_lfsr_q[46]^l_lfsr_q[27]^datain[11]):datain[11];
    l_dataout_r[12]=(bypass==1'b0)?(l_lfsr_q[45]^l_lfsr_q[26]^datain[12]):datain[12];
    l_dataout_r[13]=(bypass==1'b0)?(l_lfsr_q[44]^l_lfsr_q[25]^datain[13]):datain[13];
    l_dataout_r[14]=(bypass==1'b0)?(l_lfsr_q[43]^l_lfsr_q[24]^datain[14]):datain[14];
    l_dataout_r[15]=(bypass==1'b0)?(l_lfsr_q[42]^l_lfsr_q[23]^datain[15]):datain[15];
    l_dataout_r[16]=(bypass==1'b0)?(l_lfsr_q[41]^l_lfsr_q[22]^datain[16]):datain[16];
    l_dataout_r[17]=(bypass==1'b0)?(l_lfsr_q[40]^l_lfsr_q[21]^datain[17]):datain[17];
    l_dataout_r[18]=(bypass==1'b0)?(l_lfsr_q[39]^l_lfsr_q[20]^datain[18]):datain[18];
    l_dataout_r[19]=(bypass==1'b0)?(l_lfsr_q[38]^l_lfsr_q[19]^datain[19]):datain[19];
    l_dataout_r[20]=(bypass==1'b0)?(l_lfsr_q[37]^l_lfsr_q[18]^datain[20]):datain[20];
    l_dataout_r[21]=(bypass==1'b0)?(l_lfsr_q[36]^l_lfsr_q[17]^datain[21]):datain[21];
    l_dataout_r[22]=(bypass==1'b0)?(l_lfsr_q[35]^l_lfsr_q[16]^datain[22]):datain[22];
    l_dataout_r[23]=(bypass==1'b0)?(l_lfsr_q[34]^l_lfsr_q[15]^datain[23]):datain[23];
    l_dataout_r[24]=(bypass==1'b0)?(l_lfsr_q[33]^l_lfsr_q[14]^datain[24]):datain[24];
    l_dataout_r[25]=(bypass==1'b0)?(l_lfsr_q[32]^l_lfsr_q[13]^datain[25]):datain[25];
    l_dataout_r[26]=(bypass==1'b0)?(l_lfsr_q[31]^l_lfsr_q[12]^datain[26]):datain[26];
    l_dataout_r[27]=(bypass==1'b0)?(l_lfsr_q[30]^l_lfsr_q[11]^datain[27]):datain[27];
    l_dataout_r[28]=(bypass==1'b0)?(l_lfsr_q[29]^l_lfsr_q[10]^datain[28]):datain[28];
end

endmodule
