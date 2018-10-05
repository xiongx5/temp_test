//==================================================================================================
//  Filename      : GTP_Wrapper_4.v
//  Created On    : 2018-10-01 10:07:07
//  Last Modified : 2018-10-01 10:24:42
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

module GTP_Wrapper_4(    
    input GTP_CLK_p,
    input GTP_CLK_n,

    input serial_data_in_p_0,
    input serial_data_in_n_0,
    output data_clk_0,
    output [19:0] GTP_data_out_0,

    input serial_data_in_p_1,
    input serial_data_in_n_1,
    output data_clk_1,
    output [19:0] GTP_data_out_1,    

    input serial_data_in_p_2,
    input serial_data_in_n_2,
    output data_clk_2,
    output [19:0] GTP_data_out_2,

    input serial_data_in_p_3,
    input serial_data_in_n_3,
    output data_clk_3,
    output [19:0] GTP_data_out_3,

//    output [3:0] data_k,
    input system_clk,
    input GTX_soft_reset_in,
    output gt0_rx_system_reset_c,
    output gt1_rx_system_reset_c,
    output gt2_rx_system_reset_c,
    output gt3_rx_system_reset_c
    );
      
       wire softe_reset,soft_reset_tx_in,soft_reset_rx_in;
    assign soft_reset_tx_in=softe_reset|GTX_soft_reset_in;
    assign soft_reset_rx_in=softe_reset|GTX_soft_reset_in;
    
    wire dont_reset_on_data_error_in;
    assign dont_reset_on_data_error_in=1'b0;
    
    wire q3_clk1_gtrefclk_pad_n_in,q3_clk1_gtrefclk_pad_p_in;
    assign q3_clk1_gtrefclk_pad_n_in = GTP_CLK_n;
    assign q3_clk1_gtrefclk_pad_p_in = GTP_CLK_p;
//########################CH0#####################################################   
   wire gt0_tx_fsm_reset_done_out,gt0_rx_fsm_reset_done_out;
   
   wire gt0_data_valid_in;
   
   wire gt0_txusrclk_out,gt0_txusrclk2_out,gt0_rxusrclk_out,gt0_rxusrclk2_out;
   //assign data_clk=gt0_txusrclk2_out;
   assign data_clk_0=gt0_rxusrclk2_out;
   
   wire gt0_cpllfbclklost_out,gt0_cplllock_out;
   wire gt0_cpllreset_in; assign gt0_cpllreset_in=1'b0;
   
   wire [8:0] gt0_drpaddr_in; assign gt0_drpaddr_in = 9'd0;
   wire [15:0] gt0_drpdi_in; assign gt0_drpdi_in = 16'd0;
   wire [15:0] gt0_drpdo_out; 
   wire gt0_drpen_in; assign gt0_drpen_in = 1'b0;
   wire gt0_drprdy_out; 
   wire gt0_drpwe_in; assign gt0_drpwe_in = 1'b0;
   
   wire [7:0] gt0_dmonitorout_out;
   
   wire gt0_eyescanreset_in; assign gt0_eyescanreset_in = 1'b0;
   wire gt0_rxuserrdy_in; assign gt0_rxuserrdy_in = 1'b0;
   wire gt0_eyescandataerror_out;
   wire gt0_eyescantrigger_in; assign gt0_eyescantrigger_in = 1'b0;
   
   wire [19:0] gt0_rxdata_out; assign GTP_data_out_0 = gt0_rxdata_out;
   wire [3:0] gt0_rxcharisk_out; assign data_k_0=gt0_rxcharisk_out;
   wire [3:0] gt0_rxdisperr_out,gt0_rxnotintable_out;
   
   wire gt0_gtxrxn_in; assign gt0_gtxrxn_in = serial_data_in_n_0;
   wire gt0_gtxrxp_in; assign gt0_gtxrxp_in = serial_data_in_p_0;
   
   wire [4:0] gt0_rxphmonitor_out;
   wire [4:0] gt0_rxphslipmonitor_out;
   
   wire gt0_rxdfelpmreset_in; assign gt0_rxdfelpmreset_in = 1'b0;
   wire [6:0] gt0_rxmonitorout_out;
   wire [1:0] gt0_rxmonitorsel_in; assign gt0_rxmonitorsel_in = 2'b00;
   
   wire gt0_rxoutclkfabric_out;
   
   wire gt0_gtrxreset_in; assign gt0_gtrxreset_in = 1'b0;
   wire gt0_rxpmareset_in; assign gt0_rxpmareset_in = 1'b0;
   
    wire gt0_rxresetdone_out;  
   
   wire gt0_gttxreset_in; assign gt0_gttxreset_in = 1'b0;
   wire gt0_txuserrdy_in; assign gt0_txuserrdy_in =1'b0;
   
//   wire debug_source;
//   wire [31:0] debug_data_in;
//   wire [3:0] debug_k;
   wire [19:0] gt0_txdata_in; assign gt0_txdata_in = 20'h00000; //assign gt0_txdata_in = debug_source ? debug_data_in : data_in; 
   wire [3:0] gt0_txcharisk_in;assign gt0_txcharisk_in = 4'b1111;// assign gt0_txcharisk_in=debug_source ? debug_k : data_k; 
   
   wire gt0_gtptxn_out; //assign  serial_data_out_n = gt0_gtptxn_out;
   wire gt0_gtptxp_out; //assign  serial_data_out_p = gt0_gtptxp_out;
   
   wire gt0_txoutclkfabric_out,gt0_txoutclkpcs_out;
   
   wire gt0_txresetdone_out;
   
   wire gt0_qplloutclk_out,gt0_qplloutrefclk_out;
   
//########################CH1#####################################################   
   wire gt1_tx_fsm_reset_done_out,gt1_rx_fsm_reset_done_out;
   
   wire gt1_data_valid_in;
   
   wire gt1_txusrclk_out,gt1_txusrclk2_out,gt1_rxusrclk_out,gt1_rxusrclk2_out;
   //assign data_clk=gt0_txusrclk2_out;
   assign data_clk_1=gt1_rxusrclk2_out;
   
   wire gt1_cpllfbclklost_out,gt1_cplllock_out;
   wire gt1_cpllreset_in; assign gt1_cpllreset_in=1'b0;
   
   wire [8:0] gt1_drpaddr_in; assign gt1_drpaddr_in = 9'd0;
   wire [15:0] gt1_drpdi_in; assign gt1_drpdi_in = 16'd0;
   wire [15:0] gt1_drpdo_out; 
   wire gt1_drpen_in; assign gt1_drpen_in = 1'b0;
   wire gt1_drprdy_out; 
   wire gt1_drpwe_in; assign gt1_drpwe_in = 1'b0;
   
   wire [7:0] gt1_dmonitorout_out;
   
   wire gt1_eyescanreset_in; assign gt1_eyescanreset_in = 1'b0;
   wire gt1_rxuserrdy_in; assign gt1_rxuserrdy_in = 1'b0;
   wire gt1_eyescandataerror_out;
   wire gt1_eyescantrigger_in; assign gt1_eyescantrigger_in = 1'b0;
   
   wire [19:0] gt1_rxdata_out; assign GTP_data_out_1 = gt1_rxdata_out;
   wire [3:0] gt1_rxcharisk_out; assign data_k_1=gt1_rxcharisk_out;
   wire [3:0] gt1_rxdisperr_out,gt1_rxnotintable_out;
   
   wire gt1_gtxrxn_in; assign gt1_gtxrxn_in = serial_data_in_n_1;
   wire gt1_gtxrxp_in; assign gt1_gtxrxp_in = serial_data_in_p_1;
   
   wire [4:0] gt1_rxphmonitor_out;
   wire [4:0] gt1_rxphslipmonitor_out;
   
   wire gt1_rxdfelpmreset_in; assign gt1_rxdfelpmreset_in = 1'b0;
   wire [6:0] gt1_rxmonitorout_out;
   wire [1:0] gt1_rxmonitorsel_in; assign gt1_rxmonitorsel_in = 2'b00;
   
   wire gt1_rxoutclkfabric_out;
   
   wire gt1_gtrxreset_in; assign gt1_gtrxreset_in = 1'b0;
   wire gt1_rxpmareset_in; assign gt1_rxpmareset_in = 1'b0;
   
    wire gt1_rxresetdone_out;  
   
   wire gt1_gttxreset_in; assign gt1_gttxreset_in = 1'b0;
   wire gt1_txuserrdy_in; assign gt1_txuserrdy_in =1'b0;
   
//   wire debug_source;
//   wire [31:0] debug_data_in;
//   wire [3:0] debug_k;
   wire [19:0] gt1_txdata_in; assign gt1_txdata_in = 20'h00000; //assign gt0_txdata_in = debug_source ? debug_data_in : data_in; 
   wire [3:0] gt1_txcharisk_in;assign gt1_txcharisk_in = 4'b1111;// assign gt0_txcharisk_in=debug_source ? debug_k : data_k; 
   
   wire gt1_gtptxn_out; //assign  serial_data_out_n = gt0_gtptxn_out;
   wire gt1_gtptxp_out; //assign  serial_data_out_p = gt0_gtptxp_out;
   
   wire gt1_txoutclkfabric_out,gt1_txoutclkpcs_out;
   
   wire gt1_txresetdone_out;
   
   wire gt1_qplloutclk_out,gt1_qplloutrefclk_out;
//########################CH2#####################################################   
   wire gt2_tx_fsm_reset_done_out,gt2_rx_fsm_reset_done_out;
   
   wire gt2_data_valid_in;
   
   wire gt2_txusrclk_out,gt2_txusrclk2_out,gt2_rxusrclk_out,gt2_rxusrclk2_out;
   //assign data_clk=gt0_txusrclk2_out;
   assign data_clk_2=gt2_rxusrclk2_out;
   
   wire gt2_cpllfbclklost_out,gt2_cplllock_out;
   wire gt2_cpllreset_in; assign gt2_cpllreset_in=1'b0;
   
   wire [8:0] gt2_drpaddr_in; assign gt2_drpaddr_in = 9'd0;
   wire [15:0] gt2_drpdi_in; assign gt2_drpdi_in = 16'd0;
   wire [15:0] gt2_drpdo_out; 
   wire gt2_drpen_in; assign gt2_drpen_in = 1'b0;
   wire gt2_drprdy_out; 
   wire gt2_drpwe_in; assign gt2_drpwe_in = 1'b0;
   
   wire [7:0] gt2_dmonitorout_out;
   
   wire gt2_eyescanreset_in; assign gt2_eyescanreset_in = 1'b0;
   wire gt2_rxuserrdy_in; assign gt2_rxuserrdy_in = 1'b0;
   wire gt2_eyescandataerror_out;
   wire gt2_eyescantrigger_in; assign gt2_eyescantrigger_in = 1'b0;
   
   wire [19:0] gt2_rxdata_out; assign GTP_data_out_2 = gt2_rxdata_out;
   wire [3:0] gt2_rxcharisk_out; assign data_k_2=gt0_rxcharisk_out;
   wire [3:0] gt2_rxdisperr_out,gt2_rxnotintable_out;
   
   wire gt2_gtxrxn_in; assign gt2_gtxrxn_in = serial_data_in_n_2;
   wire gt2_gtxrxp_in; assign gt2_gtxrxp_in = serial_data_in_p_2;
   
   wire [4:0] gt2_rxphmonitor_out;
   wire [4:0] gt2_rxphslipmonitor_out;
   
   wire gt2_rxdfelpmreset_in; assign gt2_rxdfelpmreset_in = 1'b0;
   wire [6:0] gt2_rxmonitorout_out;
   wire [1:0] gt2_rxmonitorsel_in; assign gt2_rxmonitorsel_in = 2'b00;
   
   wire gt2_rxoutclkfabric_out;
   
   wire gt2_gtrxreset_in; assign gt2_gtrxreset_in = 1'b0;
   wire gt2_rxpmareset_in; assign gt2_rxpmareset_in = 1'b0;
   
    wire gt2_rxresetdone_out;  
   
   wire gt2_gttxreset_in; assign gt2_gttxreset_in = 1'b0;
   wire gt2_txuserrdy_in; assign gt2_txuserrdy_in =1'b0;
   
//   wire debug_source;
//   wire [31:0] debug_data_in;
//   wire [3:0] debug_k;
   wire [19:0] gt2_txdata_in; assign gt2_txdata_in = 20'h00000; //assign gt0_txdata_in = debug_source ? debug_data_in : data_in; 
   wire [3:0] gt2_txcharisk_in;assign gt2_txcharisk_in = 4'b1111;// assign gt0_txcharisk_in=debug_source ? debug_k : data_k; 
   
   wire gt2_gtptxn_out; //assign  serial_data_out_n = gt0_gtptxn_out;
   wire gt2_gtptxp_out; //assign  serial_data_out_p = gt0_gtptxp_out;
   
   wire gt2_txoutclkfabric_out,gt2_txoutclkpcs_out;
   
   wire gt2_txresetdone_out;
   
   wire gt2_qplloutclk_out,gt2_qplloutrefclk_out;
//########################CH3#####################################################   
   wire gt3_tx_fsm_reset_done_out,gt3_rx_fsm_reset_done_out;
   
   wire gt3_data_valid_in;
   
   wire gt3_txusrclk_out,gt3_txusrclk2_out,gt3_rxusrclk_out,gt3_rxusrclk2_out;
   //assign data_clk=gt0_txusrclk2_out;
   assign data_clk_3=gt3_rxusrclk2_out;
   
   wire gt3_cpllfbclklost_out,gt3_cplllock_out;
   wire gt3_cpllreset_in; assign gt3_cpllreset_in=1'b0;
   
   wire [8:0] gt3_drpaddr_in; assign gt3_drpaddr_in = 9'd0;
   wire [15:0] gt3_drpdi_in; assign gt3_drpdi_in = 16'd0;
   wire [15:0] gt3_drpdo_out; 
   wire gt3_drpen_in; assign gt3_drpen_in = 1'b0;
   wire gt3_drprdy_out; 
   wire gt3_drpwe_in; assign gt3_drpwe_in = 1'b0;
   
   wire [7:0] gt3_dmonitorout_out;
   
   wire gt3_eyescanreset_in; assign gt3_eyescanreset_in = 1'b0;
   wire gt3_rxuserrdy_in; assign gt3_rxuserrdy_in = 1'b0;
   wire gt3_eyescandataerror_out;
   wire gt3_eyescantrigger_in; assign gt3_eyescantrigger_in = 1'b0;
   
   wire [19:0] gt3_rxdata_out; assign GTP_data_out_3 = gt3_rxdata_out;
   wire [3:0] gt3_rxcharisk_out; assign data_k_3=gt3_rxcharisk_out;
   wire [3:0] gt3_rxdisperr_out,gt3_rxnotintable_out;
   
   wire gt3_gtxrxn_in; assign gt3_gtxrxn_in = serial_data_in_n_3;
   wire gt3_gtxrxp_in; assign gt3_gtxrxp_in = serial_data_in_p_3;
   
   wire [4:0] gt3_rxphmonitor_out;
   wire [4:0] gt3_rxphslipmonitor_out;
   
   wire gt3_rxdfelpmreset_in; assign gt3_rxdfelpmreset_in = 1'b0;
   wire [6:0] gt3_rxmonitorout_out;
   wire [1:0] gt3_rxmonitorsel_in; assign gt3_rxmonitorsel_in = 2'b00;
   
   wire gt3_rxoutclkfabric_out;
   
   wire gt3_gtrxreset_in; assign gt3_gtrxreset_in = 1'b0;
   wire gt3_rxpmareset_in; assign gt3_rxpmareset_in = 1'b0;
   
    wire gt3_rxresetdone_out;  
   
   wire gt3_gttxreset_in; assign gt3_gttxreset_in = 1'b0;
   wire gt3_txuserrdy_in; assign gt3_txuserrdy_in =1'b0;
   
//   wire debug_source;
//   wire [31:0] debug_data_in;
//   wire [3:0] debug_k;
   wire [19:0] gt3_txdata_in; assign gt3_txdata_in = 20'h00000; //assign gt0_txdata_in = debug_source ? debug_data_in : data_in; 
   wire [3:0] gt3_txcharisk_in;assign gt3_txcharisk_in = 4'b1111;// assign gt0_txcharisk_in=debug_source ? debug_k : data_k; 
   
   wire gt3_gtptxn_out; //assign  serial_data_out_n = gt0_gtptxn_out;
   wire gt3_gtptxp_out; //assign  serial_data_out_p = gt0_gtptxp_out;
   
   wire gt3_txoutclkfabric_out,gt3_txoutclkpcs_out;
   
   wire gt3_txresetdone_out;
   
   wire gt3_qplloutclk_out,gt3_qplloutrefclk_out;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

   wire sysclk_in; assign sysclk_in = system_clk;
   
   vio_GTX_4 vio_GTX_inst (
     .clk(sysclk_in),                // input wire clk
     .probe_in0(gt0_rx_fsm_reset_done_out),    // input wire [0 : 0] probe_in0
     .probe_in1(gt1_rx_fsm_reset_done_out),    // input wire [0 : 0] probe_in0
     .probe_in2(gt2_rx_fsm_reset_done_out),    // input wire [0 : 0] probe_in0
     .probe_in3(gt3_rx_fsm_reset_done_out),    // input wire [0 : 0] probe_in0

     .probe_out0(softe_reset),      // output wire [0 : 0] probe_out0
     .probe_out1(gt0_data_valid_in),  // output wire [0 : 0] probe_out1
     .probe_out2(gt1_data_valid_in),  // output wire [0 : 0] probe_out1
     .probe_out3(gt2_data_valid_in),  // output wire [0 : 0] probe_out1
     .probe_out4(gt3_data_valid_in)   // output wire [0 : 0] probe_out1
   );
//   vio_1 your_instance_name (
//     .clk(gt0_txusrclk2_out),                // input wire clk
//     .probe_out0(debug_source),  // output wire [0 : 0] probe_out0
//     .probe_out1(debug_data_in),  // output wire [31 : 0] probe_out1
//     .probe_out2(debug_k)  // output wire [3 : 0] probe_out2
//   );
//   ila_GTX_4 ila_GTX_inst (
//       .clk(gt0_rxusrclk2_out), // input wire clk
   
   
//       .probe0(gt0_rxdata_out), // input wire [19:0]  probe0  
//       .probe1(gt1_rxdata_out), // input wire [19:0]  probe0  
//       .probe2(gt2_rxdata_out), // input wire [19:0]  probe0  
//       .probe3(gt3_rxdata_out) // input wire [19:0]  probe0  
////       .probe1(gt0_rxcharisk_out), // input wire [3:0]  probe1 
////       .probe2(gt0_rxdisperr_out), // input wire [3:0]  probe2 
////       .probe3(gt0_rxnotintable_out) // input wire [3:0]  probe3 
//   );

   wire gt0_tx_mmcm_lock_out,gt1_tx_mmcm_lock_out, gt2_tx_mmcm_lock_out, gt3_tx_mmcm_lock_out;

        
    gtx_tds_4p8G  gtx_tds_4p8G_inst
    (
     .soft_reset_tx_in(soft_reset_tx_in), // input wire soft_reset_tx_in
     .soft_reset_rx_in(soft_reset_rx_in), // input wire soft_reset_rx_in
     .dont_reset_on_data_error_in(dont_reset_on_data_error_in), // input wire dont_reset_on_data_error_in
    .q3_clk1_gtrefclk_pad_n_in(q3_clk1_gtrefclk_pad_n_in), // input wire q2_clk1_gtrefclk_pad_n_in
    .q3_clk1_gtrefclk_pad_p_in(q3_clk1_gtrefclk_pad_p_in), // input wire q2_clk1_gtrefclk_pad_p_in
 
     .gt0_tx_mmcm_lock_out(gt0_tx_mmcm_lock_out), // output wire gt0_tx_mmcm_lock_out
     .gt0_tx_fsm_reset_done_out(gt0_tx_fsm_reset_done_out), // output wire gt0_tx_fsm_reset_done_out
     .gt0_rx_fsm_reset_done_out(gt0_rx_fsm_reset_done_out), // output wire gt0_rx_fsm_reset_done_out
     .gt0_data_valid_in(gt0_data_valid_in), // input wire gt0_data_valid_in
 
     .gt1_tx_mmcm_lock_out(gt1_tx_mmcm_lock_out), // output wire gt1_tx_mmcm_lock_out
     .gt1_tx_fsm_reset_done_out(gt1_tx_fsm_reset_done_out), // output wire gt1_tx_fsm_reset_done_out
     .gt1_rx_fsm_reset_done_out(gt1_rx_fsm_reset_done_out), // output wire gt1_rx_fsm_reset_done_out
     .gt1_data_valid_in(gt1_data_valid_in), // input wire gt1_data_valid_in

     .gt2_tx_mmcm_lock_out(gt2_tx_mmcm_lock_out), // output wire gt2_tx_mmcm_lock_out
     .gt2_tx_fsm_reset_done_out(gt2_tx_fsm_reset_done_out), // output wire gt2_tx_fsm_reset_done_out
     .gt2_rx_fsm_reset_done_out(gt2_rx_fsm_reset_done_out), // output wire gt2_rx_fsm_reset_done_out
     .gt2_data_valid_in(gt2_data_valid_in), // input wire gt2_data_valid_in

      .gt3_tx_mmcm_lock_out(gt3_tx_mmcm_lock_out), // output wire gt3_tx_mmcm_lock_out
     .gt3_tx_fsm_reset_done_out(gt3_tx_fsm_reset_done_out), // output wire gt3_tx_fsm_reset_done_out
     .gt3_rx_fsm_reset_done_out(gt3_rx_fsm_reset_done_out), // output wire gt3_rx_fsm_reset_done_out
     .gt3_data_valid_in(gt3_data_valid_in), // input wire gt3_data_valid_in


    .gt0_txusrclk_out(gt0_txusrclk_out), // output wire gt0_txusrclk_out
    .gt0_txusrclk2_out(gt0_txusrclk2_out), // output wire gt0_txusrclk2_out
    .gt0_rxusrclk_out(gt0_rxusrclk_out), // output wire gt0_rxusrclk_out
    .gt0_rxusrclk2_out(gt0_rxusrclk2_out), // output wire gt0_rxusrclk2_out

    .gt1_txusrclk_out(gt1_txusrclk_out), // output wire gt1_txusrclk_out
    .gt1_txusrclk2_out(gt1_txusrclk2_out), // output wire gt1_txusrclk2_out
    .gt1_rxusrclk_out(gt1_rxusrclk_out), // output wire gt1_rxusrclk_out
    .gt1_rxusrclk2_out(gt1_rxusrclk2_out), // output wire gt1_rxusrclk2_out

    .gt2_txusrclk_out(gt2_txusrclk_out), // output wire gt2_txusrclk_out
    .gt2_txusrclk2_out(gt2_txusrclk2_out), // output wire gt2_txusrclk2_out
    .gt2_rxusrclk_out(gt2_rxusrclk_out), // output wire gt2_rxusrclk_out
    .gt2_rxusrclk2_out(gt2_rxusrclk2_out), // output wire gt2_rxusrclk2_out

    .gt3_txusrclk_out(gt3_txusrclk_out), // output wire gt3_txusrclk_out
    .gt3_txusrclk2_out(gt3_txusrclk2_out), // output wire gt3_txusrclk2_out
    .gt3_rxusrclk_out(gt3_rxusrclk_out), // output wire gt3_rxusrclk_out
    .gt3_rxusrclk2_out(gt3_rxusrclk2_out), // output wire gt3_rxusrclk2_out    


    //_________________________________________________________________________
    //GT0  (X0Y12)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
        .gt0_cpllfbclklost_out          (gt0_cpllfbclklost_out), // output wire gt0_cpllfbclklost_out
        .gt0_cplllock_out               (gt0_cplllock_out), // output wire gt0_cplllock_out
        .gt0_cpllreset_in               (gt0_cpllreset_in), // input wire gt0_cpllreset_in
    //-------------------------- Channel - DRP Ports  --------------------------
        .gt0_drpaddr_in                 (gt0_drpaddr_in), // input wire [8:0] gt0_drpaddr_in
        .gt0_drpdi_in                   (gt0_drpdi_in), // input wire [15:0] gt0_drpdi_in
        .gt0_drpdo_out                  (gt0_drpdo_out), // output wire [15:0] gt0_drpdo_out
        .gt0_drpen_in                   (gt0_drpen_in), // input wire gt0_drpen_in
        .gt0_drprdy_out                 (gt0_drprdy_out), // output wire gt0_drprdy_out
        .gt0_drpwe_in                   (gt0_drpwe_in), // input wire gt0_drpwe_in
    //------------------------- Digital Monitor Ports --------------------------
        .gt0_dmonitorout_out            (gt0_dmonitorout_out), // output wire [7:0] gt0_dmonitorout_out
    //------------------- RX Initialization and Reset Ports --------------------
        .gt0_eyescanreset_in            (gt0_eyescanreset_in), // input wire gt0_eyescanreset_in
        .gt0_rxuserrdy_in               (gt0_rxuserrdy_in), // input wire gt0_rxuserrdy_in
    //------------------------ RX Margin Analysis Ports ------------------------
        .gt0_eyescandataerror_out       (gt0_eyescandataerror_out), // output wire gt0_eyescandataerror_out
        .gt0_eyescantrigger_in          (gt0_eyescantrigger_in), // input wire gt0_eyescantrigger_in
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt0_rxdata_out                 (gt0_rxdata_out), // output wire [31:0] gt0_rxdata_out
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
   //     .gt0_rxdisperr_out              (gt0_rxdisperr_out), // output wire [3:0] gt0_rxdisperr_out
   //     .gt0_rxnotintable_out           (gt0_rxnotintable_out), // output wire [3:0] gt0_rxnotintable_out
    //------------------------- Receive Ports - RX AFE -------------------------
        .gt0_gtxrxp_in                  (gt0_gtxrxp_in), // input wire gt0_gtxrxp_in
    //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt0_gtxrxn_in                  (gt0_gtxrxn_in), // input wire gt0_gtxrxn_in
        
   //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt0_rxphmonitor_out            (gt0_rxphmonitor_out), // output wire [4:0] gt0_rxphmonitor_out
        .gt0_rxphslipmonitor_out        (gt0_rxphslipmonitor_out), // output wire [4:0] gt0_rxphslipmonitor_out
    
    
    //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt0_rxdfelpmreset_in           (gt0_rxdfelpmreset_in), // input wire gt0_rxdfelpmreset_in
        .gt0_rxmonitorout_out           (gt0_rxmonitorout_out), // output wire [6:0] gt0_rxmonitorout_out
        .gt0_rxmonitorsel_in            (gt0_rxmonitorsel_in), // input wire [1:0] gt0_rxmonitorsel_in
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt0_rxoutclkfabric_out         (gt0_rxoutclkfabric_out), // output wire gt0_rxoutclkfabric_out
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt0_gtrxreset_in               (gt0_gtrxreset_in), // input wire gt0_gtrxreset_in
        .gt0_rxpmareset_in              (gt0_rxpmareset_in), // input wire gt0_rxpmareset_in
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    //    .gt0_rxcharisk_out              (gt0_rxcharisk_out), // output wire [3:0] gt0_rxcharisk_out
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt0_rxresetdone_out            (gt0_rxresetdone_out), // output wire gt0_rxresetdone_out
    //------------------- TX Initialization and Reset Ports --------------------
        .gt0_gttxreset_in               (gt0_gttxreset_in), // input wire gt0_gttxreset_in
        .gt0_txuserrdy_in               (gt0_txuserrdy_in), // input wire gt0_txuserrdy_in
    //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt0_txdata_in                  (gt0_txdata_in), // input wire [31:0] gt0_txdata_in
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt0_gtxtxn_out                 (gt0_gtxtxn_out), // output wire gt0_gtxtxn_out
        .gt0_gtxtxp_out                 (gt0_gtxtxp_out), // output wire gt0_gtxtxp_out
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt0_txoutclkfabric_out         (gt0_txoutclkfabric_out), // output wire gt0_txoutclkfabric_out
        .gt0_txoutclkpcs_out            (gt0_txoutclkpcs_out), // output wire gt0_txoutclkpcs_out
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
//        .gt0_txcharisk_in               (gt0_txcharisk_in), // input wire [3:0] gt0_txcharisk_in
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt0_txresetdone_out            (gt0_txresetdone_out), // output wire gt0_txresetdone_out
    //GT1  (X0Y13)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
        .gt1_cpllfbclklost_out          (gt1_cpllfbclklost_out), // output wire gt1_cpllfbclklost_out
        .gt1_cplllock_out               (gt1_cplllock_out), // output wire gt1_cplllock_out
        .gt1_cpllreset_in               (gt1_cpllreset_in), // input wire gt1_cpllreset_in
    //-------------------------- Channel - DRP Ports  --------------------------
        .gt1_drpaddr_in                 (gt1_drpaddr_in), // input wire [8:0] gt1_drpaddr_in
        .gt1_drpdi_in                   (gt1_drpdi_in), // input wire [15:0] gt1_drpdi_in
        .gt1_drpdo_out                  (gt1_drpdo_out), // output wire [15:0] gt1_drpdo_out
        .gt1_drpen_in                   (gt1_drpen_in), // input wire gt1_drpen_in
        .gt1_drprdy_out                 (gt1_drprdy_out), // output wire gt1_drprdy_out
        .gt1_drpwe_in                   (gt1_drpwe_in), // input wire gt1_drpwe_in
    //------------------------- Digital Monitor Ports --------------------------
        .gt1_dmonitorout_out            (gt1_dmonitorout_out), // output wire [7:0] gt1_dmonitorout_out
    //------------------- RX Initialization and Reset Ports --------------------
        .gt1_eyescanreset_in            (gt1_eyescanreset_in), // input wire gt1_eyescanreset_in
        .gt1_rxuserrdy_in               (gt1_rxuserrdy_in), // input wire gt1_rxuserrdy_in
    //------------------------ RX Margin Analysis Ports ------------------------
        .gt1_eyescandataerror_out       (gt1_eyescandataerror_out), // output wire gt1_eyescandataerror_out
        .gt1_eyescantrigger_in          (gt1_eyescantrigger_in), // input wire gt1_eyescantrigger_in
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt1_rxdata_out                 (gt1_rxdata_out), // output wire [19:0] gt1_rxdata_out
    //------------------------- Receive Ports - RX AFE -------------------------
        .gt1_gtxrxp_in                  (gt1_gtxrxp_in), // input wire gt1_gtxrxp_in
    //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt1_gtxrxn_in                  (gt1_gtxrxn_in), // input wire gt1_gtxrxn_in
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt1_rxphmonitor_out            (gt1_rxphmonitor_out), // output wire [4:0] gt1_rxphmonitor_out
        .gt1_rxphslipmonitor_out        (gt1_rxphslipmonitor_out), // output wire [4:0] gt1_rxphslipmonitor_out
    //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt1_rxdfelpmreset_in           (gt1_rxdfelpmreset_in), // input wire gt1_rxdfelpmreset_in
        .gt1_rxmonitorout_out           (gt1_rxmonitorout_out), // output wire [6:0] gt1_rxmonitorout_out
        .gt1_rxmonitorsel_in            (gt1_rxmonitorsel_in), // input wire [1:0] gt1_rxmonitorsel_in
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt1_rxoutclkfabric_out         (gt1_rxoutclkfabric_out), // output wire gt1_rxoutclkfabric_out
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt1_gtrxreset_in               (gt1_gtrxreset_in), // input wire gt1_gtrxreset_in
        .gt1_rxpmareset_in              (gt1_rxpmareset_in), // input wire gt1_rxpmareset_in
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt1_rxresetdone_out            (gt1_rxresetdone_out), // output wire gt1_rxresetdone_out
    //------------------- TX Initialization and Reset Ports --------------------
        .gt1_gttxreset_in               (gt1_gttxreset_in), // input wire gt1_gttxreset_in
        .gt1_txuserrdy_in               (gt1_txuserrdy_in), // input wire gt1_txuserrdy_in
    //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt1_txdata_in                  (gt1_txdata_in), // input wire [19:0] gt1_txdata_in
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt1_gtxtxn_out                 (gt1_gtxtxn_out), // output wire gt1_gtxtxn_out
        .gt1_gtxtxp_out                 (gt1_gtxtxp_out), // output wire gt1_gtxtxp_out
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt1_txoutclkfabric_out         (gt1_txoutclkfabric_out), // output wire gt1_txoutclkfabric_out
        .gt1_txoutclkpcs_out            (gt1_txoutclkpcs_out), // output wire gt1_txoutclkpcs_out
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt1_txresetdone_out            (gt1_txresetdone_out), // output wire gt1_txresetdone_out

    //GT2  (X0Y14)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
        .gt2_cpllfbclklost_out          (gt2_cpllfbclklost_out), // output wire gt2_cpllfbclklost_out
        .gt2_cplllock_out               (gt2_cplllock_out), // output wire gt2_cplllock_out
        .gt2_cpllreset_in               (gt2_cpllreset_in), // input wire gt2_cpllreset_in
    //-------------------------- Channel - DRP Ports  --------------------------
        .gt2_drpaddr_in                 (gt2_drpaddr_in), // input wire [8:0] gt2_drpaddr_in
        .gt2_drpdi_in                   (gt2_drpdi_in), // input wire [15:0] gt2_drpdi_in
        .gt2_drpdo_out                  (gt2_drpdo_out), // output wire [15:0] gt2_drpdo_out
        .gt2_drpen_in                   (gt2_drpen_in), // input wire gt2_drpen_in
        .gt2_drprdy_out                 (gt2_drprdy_out), // output wire gt2_drprdy_out
        .gt2_drpwe_in                   (gt2_drpwe_in), // input wire gt2_drpwe_in
    //------------------------- Digital Monitor Ports --------------------------
        .gt2_dmonitorout_out            (gt2_dmonitorout_out), // output wire [7:0] gt2_dmonitorout_out
    //------------------- RX Initialization and Reset Ports --------------------
        .gt2_eyescanreset_in            (gt2_eyescanreset_in), // input wire gt2_eyescanreset_in
        .gt2_rxuserrdy_in               (gt2_rxuserrdy_in), // input wire gt2_rxuserrdy_in
    //------------------------ RX Margin Analysis Ports ------------------------
        .gt2_eyescandataerror_out       (gt2_eyescandataerror_out), // output wire gt2_eyescandataerror_out
        .gt2_eyescantrigger_in          (gt2_eyescantrigger_in), // input wire gt2_eyescantrigger_in
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt2_rxdata_out                 (gt2_rxdata_out), // output wire [19:0] gt2_rxdata_out
    //------------------------- Receive Ports - RX AFE -------------------------
        .gt2_gtxrxp_in                  (gt2_gtxrxp_in), // input wire gt2_gtxrxp_in
    //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt2_gtxrxn_in                  (gt2_gtxrxn_in), // input wire gt2_gtxrxn_in
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt2_rxphmonitor_out            (gt2_rxphmonitor_out), // output wire [4:0] gt2_rxphmonitor_out
        .gt2_rxphslipmonitor_out        (gt2_rxphslipmonitor_out), // output wire [4:0] gt2_rxphslipmonitor_out
    //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt2_rxdfelpmreset_in           (gt2_rxdfelpmreset_in), // input wire gt2_rxdfelpmreset_in
        .gt2_rxmonitorout_out           (gt2_rxmonitorout_out), // output wire [6:0] gt2_rxmonitorout_out
        .gt2_rxmonitorsel_in            (gt2_rxmonitorsel_in), // input wire [1:0] gt2_rxmonitorsel_in
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt2_rxoutclkfabric_out         (gt2_rxoutclkfabric_out), // output wire gt2_rxoutclkfabric_out
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt2_gtrxreset_in               (gt2_gtrxreset_in), // input wire gt2_gtrxreset_in
        .gt2_rxpmareset_in              (gt2_rxpmareset_in), // input wire gt2_rxpmareset_in
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt2_rxresetdone_out            (gt2_rxresetdone_out), // output wire gt2_rxresetdone_out
    //------------------- TX Initialization and Reset Ports --------------------
        .gt2_gttxreset_in               (gt2_gttxreset_in), // input wire gt2_gttxreset_in
        .gt2_txuserrdy_in               (gt2_txuserrdy_in), // input wire gt2_txuserrdy_in
    //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt2_txdata_in                  (gt2_txdata_in), // input wire [19:0] gt2_txdata_in
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt2_gtxtxn_out                 (gt2_gtxtxn_out), // output wire gt2_gtxtxn_out
        .gt2_gtxtxp_out                 (gt2_gtxtxp_out), // output wire gt2_gtxtxp_out
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt2_txoutclkfabric_out         (gt2_txoutclkfabric_out), // output wire gt2_txoutclkfabric_out
        .gt2_txoutclkpcs_out            (gt2_txoutclkpcs_out), // output wire gt2_txoutclkpcs_out
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt2_txresetdone_out            (gt2_txresetdone_out), // output wire gt2_txresetdone_out

    //GT3  (X0Y15)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
        .gt3_cpllfbclklost_out          (gt3_cpllfbclklost_out), // output wire gt3_cpllfbclklost_out
        .gt3_cplllock_out               (gt3_cplllock_out), // output wire gt3_cplllock_out
        .gt3_cpllreset_in               (gt3_cpllreset_in), // input wire gt3_cpllreset_in
    //-------------------------- Channel - DRP Ports  --------------------------
        .gt3_drpaddr_in                 (gt3_drpaddr_in), // input wire [8:0] gt3_drpaddr_in
        .gt3_drpdi_in                   (gt3_drpdi_in), // input wire [15:0] gt3_drpdi_in
        .gt3_drpdo_out                  (gt3_drpdo_out), // output wire [15:0] gt3_drpdo_out
        .gt3_drpen_in                   (gt3_drpen_in), // input wire gt3_drpen_in
        .gt3_drprdy_out                 (gt3_drprdy_out), // output wire gt3_drprdy_out
        .gt3_drpwe_in                   (gt3_drpwe_in), // input wire gt3_drpwe_in
    //------------------------- Digital Monitor Ports --------------------------
        .gt3_dmonitorout_out            (gt3_dmonitorout_out), // output wire [7:0] gt3_dmonitorout_out
    //------------------- RX Initialization and Reset Ports --------------------
        .gt3_eyescanreset_in            (gt3_eyescanreset_in), // input wire gt3_eyescanreset_in
        .gt3_rxuserrdy_in               (gt3_rxuserrdy_in), // input wire gt3_rxuserrdy_in
    //------------------------ RX Margin Analysis Ports ------------------------
        .gt3_eyescandataerror_out       (gt3_eyescandataerror_out), // output wire gt3_eyescandataerror_out
        .gt3_eyescantrigger_in          (gt3_eyescantrigger_in), // input wire gt3_eyescantrigger_in
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .gt3_rxdata_out                 (gt3_rxdata_out), // output wire [19:0] gt3_rxdata_out
    //------------------------- Receive Ports - RX AFE -------------------------
        .gt3_gtxrxp_in                  (gt3_gtxrxp_in), // input wire gt3_gtxrxp_in
    //---------------------- Receive Ports - RX AFE Ports ----------------------
        .gt3_gtxrxn_in                  (gt3_gtxrxn_in), // input wire gt3_gtxrxn_in
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .gt3_rxphmonitor_out            (gt3_rxphmonitor_out), // output wire [4:0] gt3_rxphmonitor_out
        .gt3_rxphslipmonitor_out        (gt3_rxphslipmonitor_out), // output wire [4:0] gt3_rxphslipmonitor_out
    //------------------- Receive Ports - RX Equalizer Ports -------------------
        .gt3_rxdfelpmreset_in           (gt3_rxdfelpmreset_in), // input wire gt3_rxdfelpmreset_in
        .gt3_rxmonitorout_out           (gt3_rxmonitorout_out), // output wire [6:0] gt3_rxmonitorout_out
        .gt3_rxmonitorsel_in            (gt3_rxmonitorsel_in), // input wire [1:0] gt3_rxmonitorsel_in
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .gt3_rxoutclkfabric_out         (gt3_rxoutclkfabric_out), // output wire gt3_rxoutclkfabric_out
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .gt3_gtrxreset_in               (gt3_gtrxreset_in), // input wire gt3_gtrxreset_in
        .gt3_rxpmareset_in              (gt3_rxpmareset_in), // input wire gt3_rxpmareset_in
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .gt3_rxresetdone_out            (gt3_rxresetdone_out), // output wire gt3_rxresetdone_out
    //------------------- TX Initialization and Reset Ports --------------------
        .gt3_gttxreset_in               (gt3_gttxreset_in), // input wire gt3_gttxreset_in
        .gt3_txuserrdy_in               (gt3_txuserrdy_in), // input wire gt3_txuserrdy_in
    //---------------- Transmit Ports - TX Data Path interface -----------------
        .gt3_txdata_in                  (gt3_txdata_in), // input wire [19:0] gt3_txdata_in
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .gt3_gtxtxn_out                 (gt3_gtxtxn_out), // output wire gt3_gtxtxn_out
        .gt3_gtxtxp_out                 (gt3_gtxtxp_out), // output wire gt3_gtxtxp_out
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .gt3_txoutclkfabric_out         (gt3_txoutclkfabric_out), // output wire gt3_txoutclkfabric_out
        .gt3_txoutclkpcs_out            (gt3_txoutclkpcs_out), // output wire gt3_txoutclkpcs_out
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .gt3_txresetdone_out            (gt3_txresetdone_out), // output wire gt3_txresetdone_out

    //____________________________COMMON PORTS________________________________
    .gt0_qplloutclk_out(gt0_qplloutclk_out), // output wire gt0_qplloutclk_out 
    .gt0_qplloutrefclk_out(gt0_qplloutrefclk_out), // output wire gt0_qplloutrefclk_out
     .sysclk_in(sysclk_in) // input wire sysclk_in

);

    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt0_rxresetdone_r3;

always @(posedge gt0_rxusrclk2_out or negedge gt0_rxresetdone_out)

    begin
        if (!gt0_rxresetdone_out)
        begin
            gt0_rxresetdone_r    <=    1'b0;
            gt0_rxresetdone_r2   <=    1'b0;
            gt0_rxresetdone_r3   <=    1'b0;
        end
        else
        begin
            gt0_rxresetdone_r    <=    gt0_rxresetdone_out;
            gt0_rxresetdone_r2   <=    gt0_rxresetdone_r;
            gt0_rxresetdone_r3   <=    gt0_rxresetdone_r2;
        end
    end

assign gt0_rx_system_reset_c = !gt0_rxresetdone_r3;



    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt1_rxresetdone_r3;

always @(posedge gt1_rxusrclk2_out or negedge gt1_rxresetdone_out)

    begin
        if (!gt1_rxresetdone_out)
        begin
            gt1_rxresetdone_r    <=    1'b0;
            gt1_rxresetdone_r2   <=    1'b0;
            gt1_rxresetdone_r3   <=    1'b0;
        end
        else
        begin
            gt1_rxresetdone_r    <=    gt1_rxresetdone_out;
            gt1_rxresetdone_r2   <=    gt1_rxresetdone_r;
            gt1_rxresetdone_r3   <=    gt1_rxresetdone_r2;
        end
    end

assign gt1_rx_system_reset_c = !gt1_rxresetdone_r3;



    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt2_rxresetdone_r3;

always @(posedge gt2_rxusrclk2_out or negedge gt2_rxresetdone_out)

    begin
        if (!gt2_rxresetdone_out)
        begin
            gt2_rxresetdone_r    <=    1'b0;
            gt2_rxresetdone_r2   <=    1'b0;
            gt2_rxresetdone_r3   <=    1'b0;
        end
        else
        begin
            gt2_rxresetdone_r    <=    gt2_rxresetdone_out;
            gt2_rxresetdone_r2   <=    gt2_rxresetdone_r;
            gt2_rxresetdone_r3   <=    gt2_rxresetdone_r2;
        end
    end

assign gt2_rx_system_reset_c = !gt2_rxresetdone_r3;


    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r2;
    (* ASYNC_REG = "TRUE" *)reg             gt3_rxresetdone_r3;

always @(posedge gt3_rxusrclk2_out or negedge gt3_rxresetdone_out)

    begin
        if (!gt3_rxresetdone_out)
        begin
            gt3_rxresetdone_r    <=    1'b0;
            gt3_rxresetdone_r2   <=    1'b0;
            gt3_rxresetdone_r3   <=    1'b0;
        end
        else
        begin
            gt3_rxresetdone_r    <=    gt3_rxresetdone_out;
            gt3_rxresetdone_r2   <=    gt3_rxresetdone_r;
            gt3_rxresetdone_r3   <=    gt3_rxresetdone_r2;
        end
    end

assign gt3_rx_system_reset_c = !gt3_rxresetdone_r3;    
endmodule
