`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2017 07:36:29 PM
// Design Name: 
// Module Name: GTP_Wrapper
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


module GTP_Wrapper(    
    input GTP_CLK_p,
    input GTP_CLK_n,
    input serial_data_in_p,
    input serial_data_in_n,
    output data_clk,
    output [19:0] GTP_data_out,
//    output [3:0] data_k,
    input system_clk,
    input GTX_soft_reset_in,
    output gt0_rx_system_reset_c
    );
      
       wire softe_reset,soft_reset_tx_in,soft_reset_rx_in;
    assign soft_reset_tx_in=softe_reset|GTX_soft_reset_in;
    assign soft_reset_rx_in=softe_reset|GTX_soft_reset_in;
    
    wire dont_reset_on_data_error_in;
    assign dont_reset_on_data_error_in=1'b0;
    
    wire q2_clk1_gtrefclk_pad_n_in,q2_clk1_gtrefclk_pad_p_in;
    assign q2_clk1_gtrefclk_pad_n_in = GTP_CLK_n;
    assign q2_clk1_gtrefclk_pad_p_in = GTP_CLK_p;
   
   wire gt0_tx_fsm_reset_done_out,gt0_rx_fsm_reset_done_out;
   
   wire gt0_data_valid_in;
   
   wire gt0_txusrclk_out,gt0_txusrclk2_out,gt0_rxusrclk_out,gt0_rxusrclk2_out;
   //assign data_clk=gt0_txusrclk2_out;
   assign data_clk=gt0_rxusrclk2_out;
   
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
   
   wire [19:0] gt0_rxdata_out; assign GTP_data_out = gt0_rxdata_out;
   wire [3:0] gt0_rxcharisk_out; assign data_k=gt0_rxcharisk_out;
   wire [3:0] gt0_rxdisperr_out,gt0_rxnotintable_out;
   
   wire gt0_gtxrxn_in; assign gt0_gtxrxn_in = serial_data_in_n;
   wire gt0_gtxrxp_in; assign gt0_gtxrxp_in = serial_data_in_p;
   
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
   
   wire sysclk_in; assign sysclk_in = system_clk;
   
   vio_GTX vio_GTX_inst (
     .clk(sysclk_in),                // input wire clk
     .probe_in0(gt0_rx_fsm_reset_done_out),    // input wire [0 : 0] probe_in0
     .probe_out0(softe_reset),  // output wire [0 : 0] probe_out0
     .probe_out1(gt0_data_valid_in)  // output wire [0 : 0] probe_out1
   );
//   vio_1 your_instance_name (
//     .clk(gt0_txusrclk2_out),                // input wire clk
//     .probe_out0(debug_source),  // output wire [0 : 0] probe_out0
//     .probe_out1(debug_data_in),  // output wire [31 : 0] probe_out1
//     .probe_out2(debug_k)  // output wire [3 : 0] probe_out2
//   );
   ila_GTX ila_GTX_inst (
       .clk(gt0_rxusrclk2_out), // input wire clk
   
   
       .probe0(gt0_rxdata_out) // input wire [19:0]  probe0  
//       .probe1(gt0_rxcharisk_out), // input wire [3:0]  probe1 
//       .probe2(gt0_rxdisperr_out), // input wire [3:0]  probe2 
//       .probe3(gt0_rxnotintable_out) // input wire [3:0]  probe3 
   );
      
        
    gtx_tds_4p8G_X0Y8  gtx_tds_4p8G_inst
    (
     .soft_reset_tx_in(soft_reset_tx_in), // input wire soft_reset_tx_in
     .soft_reset_rx_in(soft_reset_rx_in), // input wire soft_reset_rx_in
     .dont_reset_on_data_error_in(dont_reset_on_data_error_in), // input wire dont_reset_on_data_error_in
    .q3_clk1_gtrefclk_pad_n_in(q2_clk1_gtrefclk_pad_n_in), // input wire q2_clk1_gtrefclk_pad_n_in
    .q3_clk1_gtrefclk_pad_p_in(q2_clk1_gtrefclk_pad_p_in), // input wire q2_clk1_gtrefclk_pad_p_in
     .gt0_tx_mmcm_lock_out(gt0_tx_mmcm_lock_out), // output wire gt0_tx_mmcm_lock_out
     //.gt0_rx_mmcm_lock_out(gt0_rx_mmcm_lock_out), // output wire gt0_rx_mmcm_lock_out
     .gt0_tx_fsm_reset_done_out(gt0_tx_fsm_reset_done_out), // output wire gt0_tx_fsm_reset_done_out
     .gt0_rx_fsm_reset_done_out(gt0_rx_fsm_reset_done_out), // output wire gt0_rx_fsm_reset_done_out
     .gt0_data_valid_in(gt0_data_valid_in), // input wire gt0_data_valid_in
 
    .gt0_txusrclk_out(gt0_txusrclk_out), // output wire gt0_txusrclk_out
    .gt0_txusrclk2_out(gt0_txusrclk2_out), // output wire gt0_txusrclk2_out
    .gt0_rxusrclk_out(gt0_rxusrclk_out), // output wire gt0_rxusrclk_out
    .gt0_rxusrclk2_out(gt0_rxusrclk2_out), // output wire gt0_rxusrclk2_out
    //_________________________________________________________________________
    //GT0  (X0Y8)
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

    
endmodule
