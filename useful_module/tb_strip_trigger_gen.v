
`timescale 1ns/1ps

module tb_strip_trigger_gen (); /* this is automatically generated */
	reg clk_slow;
	reg clk_320M;
	reg reset;
	reg load;
	// clock
	initial begin
		clk_slow = 0;
		forever #10 clk_slow = ~clk_slow;
	end
	initial begin
		clk_320M = 0;
		forever #5 clk_320M = ~clk_320M;
	end
	// reset
	initial begin
		reset = 1'b0;
		load =1'b0;
		#1;
		reset = 1'b1;
		#55;
		reset = 1'b0;
		repeat (5) @(posedge clk_slow);
		load =1'b1;
		repeat (1) @(posedge clk_slow);
		load =1'b0;
	end

	// (*NOTE*) replace reset, clock, others


	wire         ready;

	wire        trig_clk_p;
	wire        trig_clk_n;
	wire        trig_en_p;
	wire        trig_en_n;
	wire        trig_d0_p;
	wire        trig_d0_n;
	wire        trig_d1_p;
	wire        trig_d1_n;

	strip_trigger_gen inst_strip_trigger_gen
		(
			.clk_slow                   (clk_slow),
			.clk_320M                   (clk_320M),
			.reset                      (reset),
			.load_input                 (load),
			.ready                      (ready),
			.trigger_content_BCID_input (12'b1010_1100_0101),
			.phi_id_input               (5'b1_1111),
			.bandid_input               (8'b1111_1111),
			.trig_clk_p                 (trig_clk_p),
			.trig_clk_n                 (trig_clk_n),
			.trig_en_p                  (trig_en_p),
			.trig_en_n                  (trig_en_n),
			.trig_d0_p                  (trig_d0_p),
			.trig_d0_n                  (trig_d0_n),
			.trig_d1_p                  (trig_d1_p),
			.trig_d1_n                  (trig_d1_n)
		);



endmodule
