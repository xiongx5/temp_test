`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2017 01:10:43 PM
// Design Name: 
// Module Name: strip_trigger_gen
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


module strip_trigger_gen(
    input clk40,
    input reset,
    input TDS_mode,
    input [11:0] BCID_counter,

    input [11:0] trigger_position_input,
    
    input [11:0] trigger_content_BCID_input,
    input [4:0] phi_id_input,

    output trig_clk,
    output trig_en,
    output trig_d0, trig_d1
    );
wire clk200;
wire locked1,locked2;
  clk_wiz_0 clk_200
   (
   // Clock in ports
    .clk_in1(clk40),      // input clk_in1
    // Clock out ports
    .clk_out1(clk200),     // output clk_out1
    // Status and control signals
    .locked(locked1));      // output locked

  clk_high_speed clk_320_640
   (
   // Clock in ports
    .clk_in1(clk40),      // input clk_in1
    // Clock out ports
    .clk_out1(clk320),     // output clk_out1
    .clk_out2(clk640),     // output clk_out2
    // Status and control signals
    .locked(locked2));      // output locked

wire [11:0] trigger_position;
wire [11:0] trigger_content_BCID;
(* ASYNC_REG = "TRUE" *)(* keep = "TRUE" *) reg [11:0] trigger_content_BCID_r;
wire [7:0] bandid;
(* ASYNC_REG = "TRUE" *)(* keep = "TRUE" *) reg [7:0] bandid_r;
wire [4:0] phi_id;
(* ASYNC_REG = "TRUE" *)(* keep = "TRUE" *) reg [7:0] phi_id_r;
reg [7:0] bandid_inner;

wire load_VIO;
wire [4:0] delay_for_trig_en_VIO;
wire [4:0] delay_for_trig_clk_VIO;
wire [4:0] delay_for_trig_d0_VIO;
wire [4:0] delay_for_trig_d1_VIO;

wire enable_VIO;
wire [11:0] trigger_position_VIO;
wire [11:0] trigger_content_BCID_VIO;
wire [7:0] bandid_VIO;
wire [4:0] phi_id_VIO;
wire bandid_chose_VIO;
assign  trigger_position = enable_VIO ? trigger_position_VIO : trigger_position_input;
assign  trigger_content_BCID = enable_VIO ? trigger_content_BCID_VIO : trigger_content_BCID_input;
assign  phi_id = enable_VIO ? phi_id_VIO : phi_id_input;
assign  bandid = bandid_chose_VIO ?  bandid_VIO : bandid_inner;

reg [3:0] trigcnt =4'b0;
  always @(posedge clk40) begin
    if(BCID_counter == trigger_position)
        trigcnt <= trigcnt + 1'b1;
  end


  always @(posedge clk40) begin
      bandid_inner  <= {4'b0, trigcnt};
  end



wire load_40M;
reg[7:0] load_40M_r;
always @(posedge clk40) begin
    load_40M_r <= {load_40M_r[6:0],((BCID_counter==trigger_position)&TDS_mode)};
end
assign load_40M = load_40M_r[7];

always @(posedge clk640) begin
  bandid_r <= bandid;
  phi_id_r <= phi_id;
  trigger_content_BCID_r <= trigger_content_BCID;
end


(* ASYNC_REG = "TRUE" *)(* keep = "TRUE" *) reg [3:0] load_r = 4'b0;



reg  load_rising_r = 1'b0;
always @(posedge clk640) begin
      load_r <= {load_r[2:0],load_40M};
      load_rising_r <= (~load_r[3])&load_r[2];

end

reg [12:0] band_phi_id = 13'b0;
reg [12:0] bcid_extend = 13'b0;
always @(posedge clk640) begin
    if(load_rising_r) begin
      band_phi_id <= {phi_id_r,bandid_r}; //phi ID 5'b10101
      bcid_extend <= {trigger_content_BCID_r, 1'b0}; end
    else begin
      band_phi_id <= {band_phi_id[11:0], 1'b0};
      bcid_extend <= {bcid_extend[11:0], 1'b0}; end
  end

reg [3:0] cnt_clk640=4'b0;
always @(posedge clk640) begin
   if(load_rising_r) 
     cnt_clk640 <= 4'b0;
   else if(cnt_clk640!=4'b1111)
     cnt_clk640 <= cnt_clk640 + 1'b1;
  end


reg trig_d1_inner,trig_d0_inner,trig_en_inner;
wire trig_clk_inner;
always @(posedge clk640) begin
  begin
    trig_d1_inner <= band_phi_id[12];
    trig_d0_inner <= bcid_extend[12];
    trig_en_inner <=(cnt_clk640<4'b1101 )?1'b1 : 1'b0;
  end
end
wire trigger_clock_priorty_VIO;
wire trig_clk_inner_0;
assign trig_clk_inner_0 = trigger_clock_priorty_VIO ? clk320 : ~clk320;
 BUFG BUFG_inst (
   .O(trig_clk_inner), // 1-bit output: Clock output
   .I(trig_clk_inner_0)  // 1-bit input: Clock input
);


wire odelay_reset;
wire idelay_ctrl_rdy;

IDELAYCTRL IDELAYCTRL_inst (
      .RDY(idelay_ctrl_rdy),       // 1-bit output: Ready output
      .REFCLK(clk200), // 1-bit input: Reference clock input
      .RST(reset)        // 1-bit input: Active high reset input
   );
assign odelay_reset = ~idelay_ctrl_rdy;



   ODELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("ODATAIN"),           // Delay input (ODATAIN, CLKIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .ODELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .ODELAY_VALUE(0),                // Output delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   ODELAYE2_trig_en (
      .CNTVALUEOUT(), // 5-bit output: Counter value output
      .DATAOUT(trig_en),         // 1-bit output: Delayed data/clock output
      .C(clk40),                     // 1-bit input: Clock input
      .CE(1'b0),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CLKIN(1'b0),             // 1-bit input: Clock delay input
      .CNTVALUEIN(delay_for_trig_en_VIO),   // 5-bit input: Counter value input
      .INC(1'b1),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(load_VIO),                   // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or
                                 // VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN

      .LDPIPEEN(1'b0),       // 1-bit input: Enables the pipeline register to load data
      .ODATAIN(trig_en_inner),         // 1-bit input: Output delay data input
      .REGRST(odelay_reset)            // 1-bit input: Active-high reset tap-delay input
   );

   ODELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("ODATAIN"),           // Delay input (ODATAIN, CLKIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .ODELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .ODELAY_VALUE(0),                // Output delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   ODELAYE2_trig_clk (
      .CNTVALUEOUT(), // 5-bit output: Counter value output
      .DATAOUT(trig_clk),         // 1-bit output: Delayed data/clock output
      .C(clk40),                     // 1-bit input: Clock input
      .CE(1'b0),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CLKIN(1'b0),             // 1-bit input: Clock delay input
      .CNTVALUEIN(delay_for_trig_clk_VIO),   // 5-bit input: Counter value input
      .INC(1'b1),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(load_VIO),                   // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or
                                 // VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN

      .LDPIPEEN(1'b0),       // 1-bit input: Enables the pipeline register to load data
      .ODATAIN(trig_clk_inner),         // 1-bit input: Output delay data input
      .REGRST(odelay_reset)            // 1-bit input: Active-high reset tap-delay input
   );

   ODELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("ODATAIN"),           // Delay input (ODATAIN, CLKIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .ODELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .ODELAY_VALUE(0),                // Output delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   ODELAYE2_trig_d0 (
      .CNTVALUEOUT(), // 5-bit output: Counter value output
      .DATAOUT(trig_d0),         // 1-bit output: Delayed data/clock output
      .C(clk40),                     // 1-bit input: Clock input
      .CE(1'b0),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CLKIN(1'b0),             // 1-bit input: Clock delay input
      .CNTVALUEIN(delay_for_trig_d0_VIO),   // 5-bit input: Counter value input
      .INC(1'b1),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(load_VIO),                   // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or
                                 // VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN

      .LDPIPEEN(1'b0),       // 1-bit input: Enables the pipeline register to load data
      .ODATAIN(trig_d0_inner),         // 1-bit input: Output delay data input
      .REGRST(odelay_reset)            // 1-bit input: Active-high reset tap-delay input
   );

   ODELAYE2 #(
      .CINVCTRL_SEL("FALSE"),          // Enable dynamic clock inversion (FALSE, TRUE)
      .DELAY_SRC("ODATAIN"),           // Delay input (ODATAIN, CLKIN)
      .HIGH_PERFORMANCE_MODE("TRUE"), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
      .ODELAY_TYPE("VAR_LOAD"),           // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
      .ODELAY_VALUE(0),                // Output delay tap setting (0-31)
      .PIPE_SEL("FALSE"),              // Select pipelined mode, FALSE, TRUE
      .REFCLK_FREQUENCY(200.0),        // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
      .SIGNAL_PATTERN("DATA")          // DATA, CLOCK input signal
   )
   ODELAYE2_trig_d1 (
      .CNTVALUEOUT(), // 5-bit output: Counter value output
      .DATAOUT(trig_d1),         // 1-bit output: Delayed data/clock output
      .C(clk40),                     // 1-bit input: Clock input
      .CE(1'b0),                   // 1-bit input: Active high enable increment/decrement input
      .CINVCTRL(1'b0),       // 1-bit input: Dynamic clock inversion input
      .CLKIN(1'b0),             // 1-bit input: Clock delay input
      .CNTVALUEIN(delay_for_trig_d1_VIO),   // 5-bit input: Counter value input
      .INC(1'b1),                 // 1-bit input: Increment / Decrement tap delay input
      .LD(load_VIO),                   // 1-bit input: Loads ODELAY_VALUE tap delay in VARIABLE mode, in VAR_LOAD or
                                 // VAR_LOAD_PIPE mode, loads the value of CNTVALUEIN

      .LDPIPEEN(1'b0),       // 1-bit input: Enables the pipeline register to load data
      .ODATAIN(trig_d1_inner),         // 1-bit input: Output delay data input
      .REGRST(odelay_reset)            // 1-bit input: Active-high reset tap-delay input
   );





//ila_strip_trigger_gen ila_strip_trigger_gen_inst(
//    .clk(clk320),
//    .probe0(trigcnt),//4
//    .probe1(bandid_inner),//8
//    .probe2(bandid),//8
//    .probe3(phi_id),//5
//    .probe4(load_rising_r),//1
//    .probe5(band_phi_id),//13
//    .probe6(bcid_extend),//13
//    .probe7(cnt_clk640),//4
//    .probe8(trig_d1_inner),//1
//    .probe9(trig_d0_inner),//1
//    .probe10(trig_clk_inner),//1
//    .probe11(trig_en_inner)//1
//    );


vio_strip_trigger_gen vio_strip_trigger_gen_inst(
    .clk(clk40),
    .probe_in0(idelay_ctrl_rdy),
    .probe_in1(trigger_position),
    .probe_in2(trigger_content_BCID),
    .probe_in3(bandid),
    .probe_in4(phi_id),
    .probe_out0(enable_VIO),//1
    .probe_out1(trigger_position_VIO),//12
    .probe_out2(trigger_content_BCID_VIO),//12
    .probe_out3(bandid_VIO),//8
    .probe_out4(phi_id_VIO),//5
    .probe_out5(load_VIO),//1
    .probe_out6(delay_for_trig_en_VIO),//5
    .probe_out7(delay_for_trig_clk_VIO),//5
    .probe_out8(delay_for_trig_d0_VIO),//5
    .probe_out9(delay_for_trig_d1_VIO),//5
    .probe_out10(trigger_clock_priorty_VIO),
    .probe_out11(bandid_chose_VIO)
    );

endmodule
