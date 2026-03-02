//`include "ethernet_define.v"
//
//module EthernetRMII(
//	input nrst,
//	input clk,
//	inout reg [3:0] led,
//	//output wire pinIO2_2
//	//input wire pinIO2_2 // 50 Mhz clock coming from the breakout board
//	
//	input  wire 		i_clock, // 50 Mhz clock coming from the breakout board
//	output wire [1:0] o_data_out,
//	//output wire      	o_clock_out,
//	output wire     	o_TX_enab
//);
//
//	reg [31:0] counter;
//	reg clk2;
//	reg toggle_reg;
//	reg [7:0] i;
//	//reg [3:0] led_reg;
//	
//	//assign led[0] = nrst;
//
//	//always @(posedge i_clock)
//	always @(posedge clk)
//	begin
//
//		if (!nrst)
//		begin
//			led[0] = 1'b0; // 0 turns the LEDs on
//			counter <= 32'd0;
//			led <= 4'd0;
//		end
//
//		if (counter == 50000000)
//		begin
//			counter <= 0;
//			led <= ~led;
//			toggle_reg <= ~toggle_reg;
//		end
//		else
//		begin
//			counter <= counter + 32'd1;
//		end
//
//	end
//	
//	//assign pinIO2_2 = toggle_reg;
//
//endmodule