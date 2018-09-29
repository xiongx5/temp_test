//==================================================================================================
//  Filename      : ODDR_bus.v
//  Created On    : 2018-09-29 17:29:38
//  Last Modified : 2018-09-29 17:40:23
//  Revision      : 
//  Author        : Yu Liang
//  Company       : University of Michigan
//  Email         : liangum@umich.edu
//
//  Description   : 
//
//
//==================================================================================================
`timescale 1ns / 1ps

module ODDR_bus(
    input clk_320M,
    input  en_flag_even,en_flag_odd,
    input  band_phi_id_even,band_phi_id_odd,
    input  bcid_extend_even, bcid_extend_odd,

    output trig_clk_p,trig_clk_n,
    output trig_en_p, trig_en_n,
    output trig_d0_p,trig_d0_n,
    output trig_d1_p,trig_d1_n
    );



  wire clk_out_inner;
  ODDR
  #(.DDR_CLK_EDGE   ("SAME_EDGE"), //"OPPOSITE_EDGE" "SAME_EDGE"
    .INIT           (1'b0),
    .SRTYPE         ("ASYNC"))
  oddr_clk
      (.D1             (1'b1),
       .D2             (1'b0),
       .C              (clk_320M),
       .CE             (1'b1),
       .Q              (clk_out_inner),
       .R              (1'b0),
       .S              (1'b0));
// Clock Output Buffer
  OBUFDS
  #(.IOSTANDARD ("LVDS_25"))
  obuf_clk
    (.O          (trig_clk_p),
     .OB         (trig_clk_n),  
     .I          (clk_out_inner));

  wire en_inner;
  ODDR
  #(.DDR_CLK_EDGE   ("SAME_EDGE"), //"OPPOSITE_EDGE" "SAME_EDGE"
    .INIT           (1'b0),
    .SRTYPE         ("ASYNC"))
  oddr_en
    (.D1             (en_flag_even),
     .D2             (en_flag_odd),
     .C              (clk_320M),
     .CE             (1'b1),
     .Q              (en_inner),
     .R              (1'b0),
     .S              (1'b0));
// Clock Output Buffer
    OBUFDS
    #(.IOSTANDARD ("LVDS_25"))
    obuf_en
      (.O          (trig_en_p),
       .OB         (trig_en_n),
       .I          (en_inner));

  wire band_phi_id_inner;
  ODDR
  #(.DDR_CLK_EDGE   ("SAME_EDGE"), //"OPPOSITE_EDGE" "SAME_EDGE"
    .INIT           (1'b0),
    .SRTYPE         ("ASYNC"))
  oddr_d1
    (.D1             (band_phi_id_even),
     .D2             (band_phi_id_odd),
     .C              (clk_320M),
     .CE             (1'b1),
     .Q              (band_phi_id_inner),
     .R              (1'b0),
     .S              (1'b0));
// Clock Output Buffer
    OBUFDS
    #(.IOSTANDARD ("LVDS_25"))
    obuf_d1
      (.O          (trig_d1_p),
       .OB         (trig_d1_n),
       .I          (band_phi_id_inner));

  wire bcid_extend_inner;
  ODDR
  #(.DDR_CLK_EDGE   ("SAME_EDGE"), //"OPPOSITE_EDGE" "SAME_EDGE"
    .INIT           (1'b0),
    .SRTYPE         ("ASYNC"))
  oddr_d0
    (.D1             (bcid_extend_even),
     .D2             (bcid_extend_odd),
     .C              (clk_320M),
     .CE             (1'b1),
     .Q              (bcid_extend_inner),
     .R              (1'b0),
     .S              (1'b0));
// Clock Output Buffer
    OBUFDS
    #(.IOSTANDARD ("LVDS_25"))
    obuf_d0
      (.O          (trig_d0_p),
       .OB         (trig_d0_n),
       .I          (bcid_extend_inner));  
       
endmodule