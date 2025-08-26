//`define USE_LED_FOR_COMM_BLOCK 1
`undef USE_LED_FOR_COMM_BLOCK

//`define USE_LED_FOR_CONFIG_BLOCK 1
`undef USE_LED_FOR_CONFIG_BLOCK

module write_register(

	// clock and reset
	input 					reset,
	input 					clk, 		// 50 MHz (see https://www.waveshare.com/wiki/OpenEP4CE6-C_User_Manual#Clock_Circuit)
	
	// LEDs
	inout 	reg [3:0]	led,
	
	// ULPI
	input  	wire 			CLKOUT, 	// PIN 50
	input  	wire 			DIR,    	// PIN 52
	input 	wire 			NXT, 		// PIN 54
	output 	wire 			RST,    	// PIN 46	
	output 	wire 			STP, 		// PIN 58	
	inout 	wire [7:0] 	data,
	
	// UART
	output 	wire 			uart_tx_pin, // PIN 
	
	// test
	output 	wire 			TESTPIN

);

	wire 	[7:0] indata;
	reg 	[7:0] outdata;
	
	assign indata = data;
	assign data = DIR ? 8'bz : outdata;

	//assign RST = !reset;

	// this ack will trigger the config state machine
	// to continue because the config state machine
	// is the only one that is allowed to write to
	// dataout
	reg ack = 0;
	
	
	reg start_found = 0;
	reg data_found = 0;
	
	//reg [7:0] message [0:7];
	
	localparam MSG_STATE_0	= 8'd0;
	localparam MSG_STATE_1	= 8'd1;	
	localparam MSG_STATE_2	= 8'd2;	
	localparam MSG_STATE_3	= 8'd3;
	localparam MSG_STATE_4	= 8'd4;
	localparam MSG_STATE_5	= 8'd5;
	localparam MSG_STATE_6	= 8'd6;
	localparam MSG_STATE_7	= 8'd7;
	localparam MSG_STATE_8	= 8'd8;
	localparam MSG_STATE_9	= 8'd9;
	
	reg [7:0] msg_state = MSG_STATE_0;
	
	always @(posedge CLKOUT)
	begin
	
		if (!reset)
		begin
			msg_state = MSG_STATE_0;
		end
	
		case (msg_state)
		
			MSG_STATE_0:
			begin
				led = 4'b1111;
				if (data == 8'hc3)
					msg_state = MSG_STATE_1;
				else
					msg_state = MSG_STATE_0;
			end
			
			MSG_STATE_1:
			begin
				led = 4'b1110;
				if (data == 8'h80)
					msg_state = MSG_STATE_2;
				else
					msg_state = MSG_STATE_1;
			end
			
			MSG_STATE_2:
			begin
				led = 4'b1101;
				if (data == 8'h06)
					msg_state = MSG_STATE_3;
				else
					msg_state = MSG_STATE_2;
			end
			
			MSG_STATE_3:
			begin
				led = 4'b1100; // [L1][L2][L3][L4]
				if (data == 8'h00)	
					msg_state = MSG_STATE_4;
				else
					msg_state = MSG_STATE_3;
			end
			
			MSG_STATE_4:
			begin
				led = 4'b1011; // [L1][L2][L3][L4]
				if (data == 8'h01)	
					msg_state = MSG_STATE_5;
				else
					msg_state = MSG_STATE_4;
			end
			
			MSG_STATE_5:
			begin
				led = 4'b1010; // [L1][L2][L3][L4]
				if (data == 8'h00)	
					msg_state = MSG_STATE_6;
				else
					msg_state = MSG_STATE_5;
			end
			
			MSG_STATE_6:
			begin
				led = 4'b1001; // [L1][L2][L3][L4]
				if (data == 8'h00)	
					msg_state = MSG_STATE_7;
				else
					msg_state = MSG_STATE_6;
			end
			
			MSG_STATE_7:
			begin
				led = 4'b1000; // [L1][L2][L3][L4]
				if (data == 8'h40)	
					msg_state = MSG_STATE_8;
				else
					msg_state = MSG_STATE_7;
			end
			
			MSG_STATE_8:
			begin
				led = 4'b0111; // [L1][L2][L3][L4]
				if (data == 8'h00)	
					msg_state = MSG_STATE_9;
				else
					msg_state = MSG_STATE_8;
			end
			
			MSG_STATE_9:
			begin
				led = 4'b0110; // [L1][L2][L3][L4]
				msg_state = MSG_STATE_9;

				//outdata = 8'h42;
				ack = 1;
			end
			
			default:
				msg_state = MSG_STATE_0;
			
		endcase
		
	end
	
	
	
	
	
	
	
	



	// when reset is asserted, the phy resets
	reg [31:0] phy_reset_counter;
	reg phy_reset_performed;
	
	reg RST_reg;
	assign RST = RST_reg;

	reg stp_reg;
	assign STP = stp_reg;
	
	reg ulpi_register_write_reg;
	
	reg [3:0] led_reg;
	
	reg [7:0] latched_data_reg;
	
	//
	// Communications state machine
	//
	
	localparam COMM_STATE_IDLE		= 8'd0;
	localparam COMM_STATE_ABORT	= 8'd1;	
	localparam COMM_STATE_RXSTART	= 8'd2;	
	localparam COMM_STATE_DATA0	= 8'd3;
	
	reg [7:0] comm_cur_state = COMM_STATE_IDLE;
	
	
	

/*
	always @(posedge CLKOUT)
	begin
		if (!reset)
		begin
//`ifdef USE_LED_FOR_COMM_BLOCK
//			led_reg <= ~4'b0000;
//			led <= led_reg;
//`endif
			comm_cur_state <= COMM_STATE_IDLE;
		end
		else
		begin
		
			case (comm_cur_state)
		
			COMM_STATE_IDLE:
			begin
			
`ifdef USE_LED_FOR_COMM_BLOCK
				led_reg <= ~4'b1000; // [L1][L2][L3][L4]
				led <= led_reg;
`endif
				
				//if (DIR && NXT && (data[5:4] == 2'b01))
				if ((DIR == 1) && (NXT == 1))
				begin
					//latched_data_reg <= data;
					comm_cur_state <= COMM_STATE_RXSTART;
				end
				else
				begin
					comm_cur_state <= COMM_STATE_IDLE;
				end
			end
		
			COMM_STATE_RXSTART:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led_reg <= ~4'b0001; // [L1][L2][L3][L4]
				led <= led_reg;
`endif

				if (DIR == 0)
				begin
					comm_cur_state <= COMM_STATE_IDLE;
				end
				else
				begin

					//if (latched_data_reg == 8'hc3)
					if (indata == 8'hc3)
					begin
						comm_cur_state <= COMM_STATE_DATA0;
					end
					else
					begin
						comm_cur_state <= COMM_STATE_IDLE;
					end
					
				end

				
				//if (DIR == 0)
				//	// when the PHY has detected the EOP, it will pull DIR low to tell
				//	// the LINK that there will be no more data. The machine goes back to idle.
				//	comm_cur_state <= COMM_STATE_IDLE;
				//else 
				//	// if the PHY pulls NXT high, another byte has been received on the 
				//	// D+, D- input stream ready for the LINK to consume.
				//	if (NXT)
				//		case (data)
				//			//8'h2d: comm_cur_state <= COMM_STATE_SETUP;
				//			//8'h69: comm_cur_state <= COMM_STATE_IN;
				//			//8'he1: comm_cur_state <= COMM_STATE_OUT;
				//			8'hc3: comm_cur_state <= COMM_STATE_DATA0; // 0xC3 == 1100|0011 PID: DATA0
				//			//8'h4b: comm_cur_state <= COMM_STATE_DATA1;
				//			default: comm_cur_state <= COMM_STATE_ABORT;
				//		endcase
				//	else
				//		comm_cur_state <= comm_cur_state;
				
			end
			
			COMM_STATE_DATA0:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led_reg <= ~4'b0010; // [L1][L2][L3][L4]
				led <= led_reg;
`endif
				//comm_cur_state <= COMM_STATE_IDLE;
				comm_cur_state <= comm_cur_state;
			end
			
			COMM_STATE_ABORT:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led_reg <= ~4'b0011;
				led <= led_reg;
`endif
				if (DIR == 0)
					comm_cur_state <= COMM_STATE_IDLE;
				else 
					comm_cur_state <= comm_cur_state;
			end
			
			default:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led_reg <= ~4'b0100;
				led <= led_reg;
`endif
				comm_cur_state <= COMM_STATE_IDLE;
			end
			
			endcase
					
		end
	end
*/
	
	//
	// ULPI soft reset logic
	//
	
	// UPLI, Perform RESET
	always @(posedge CLKOUT)
	begin
	
		if (!reset)
		begin
			// reset counter
			phy_reset_counter <= 32'd0;
			
			// no reset performed yet
			phy_reset_performed <= 0;
			
			// assert the reset pin to trigger a reset of the PHY
			RST_reg <= 1;
			
			// do not register write while the PHY resets
			ulpi_register_write_reg <= 0;
			
			//led <= ~4'b0000;
			//outdata <= 8'h8a;
		end
		
		//if (phy_reset_counter == 60000000)
		//if (phy_reset_counter == 10000000)
		if (phy_reset_counter == 1000000)
		begin
		
			phy_reset_counter <= 0;
			
			// YORO - you only reset once
			if (phy_reset_performed == 0)
			begin
			
				// PHY reset has been performed
				phy_reset_performed <= 1;
				
				// do not reset any more
				RST_reg <= 0;
				
				// start register write
				ulpi_register_write_reg <= 1;
			end
			
		end
		else
		begin			
			phy_reset_counter <= phy_reset_counter + 32'd1;
		end		
		
	end
	
	//
	// Config State Machine 
	// - disables OTG activating peripheral mode
	// - enable Fast Speed (FS) mode by writing 0x45 into the FUNC_CTRL register
	//
	
	localparam CONFIG_STATE_0 		= 5'b00000;
	localparam CONFIG_STATE_1 		= 5'b00001;
	localparam CONFIG_STATE_2 		= 5'b00010;
	localparam CONFIG_STATE_3 		= 5'b00011;
	localparam CONFIG_STATE_4 		= 5'b00100;
	localparam CONFIG_STATE_5 		= 5'b00101;
	localparam CONFIG_STATE_6 		= 5'b00110;
	localparam CONFIG_STATE_7 		= 5'b00111;
	localparam CONFIG_STATE_8 		= 5'b01000;
	localparam CONFIG_STATE_9 		= 5'b01001;
	localparam CONFIG_STATE_10 	= 5'b01010;
	localparam CONFIG_STATE_11		= 5'b01011;
	localparam CONFIG_STATE_12		= 5'b01100;
	localparam CONFIG_STATE_13		= 5'b01101;
	localparam CONFIG_STATE_14		= 5'b01110;
	localparam CONFIG_STATE_15		= 5'b01111;
	localparam CONFIG_STATE_16		= 5'b10000;
	localparam CONFIG_IDLE 			= 5'b11111;
	
	reg [4:0] config_cur_state;
	reg [4:0] config_next_state;
	
	// apply next state
	always @(posedge CLKOUT) 
	begin	
		if (!reset) 
		begin
			config_cur_state = CONFIG_IDLE;
		end
		else 
		begin
			config_cur_state = config_next_state;
		end
	end
	
	// combinational always block for next state logic
	always @(config_cur_state) 
	begin
	
		// default next state assignment
		config_next_state = CONFIG_IDLE;

		case (config_cur_state)

			CONFIG_STATE_0: 
			begin
			
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0000;
				led <= led_reg;
`endif

				// LINK needs to pull STP low otherwise nothing works at all
				stp_reg = 0;

				if (DIR == 1)
				begin
					config_next_state <= CONFIG_STATE_0;
				end
				else
				begin

					// A ULPI READ is described by 11xxxxxx in binary. The xxxxxx contains the address. 
					// To read Vendor ID Low, the address is 0x00. So combining the CMD BITS with the address 
					// 0x00 yields 11000000b = 0xC0.
					// 11000000bin = 0xC0
					
					//outdata = 8'hC0; 	// vendor id low  	(0x24, 00100100) (ULPI register READ: address 0x00)
					//outdata = 8'hC1; 	// vendor id high 	(0x04, 00000100) (ULPI register READ: address 0x01)
					
					//outdata = 8'hC2; 		// product id low  	(0x04, 00000100) (ULPI register READ: address 0x02)
					//outdata = 8'hC3; 	// product id high 	(0x00, 00000000) (ULPI register READ: address 0x03)
					
					//outdata = 8'hC4; // function control
					
					//outdata = 8'hCD; // USB Interrupt Enable Rising
					
					//outdata = 8'hD3;
					
					// A ULPI WRITE 
					
					// https://cross-hair.co.uk/tech-articles/ULPI%20interface.html
					// First we must disable OTG features by writing x"00" to the OTG_CTRL (x"0a") register.
					// A TXCMD byte of x"8a" is sent then a data byte of x"00" as per Figure 1.
					
					outdata = 8'h8a; // [10][0x0A]
					
					config_next_state = CONFIG_STATE_1; // next state
				end
			end

			CONFIG_STATE_1:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0001;
				led <= led_reg;
`endif
				outdata <= 8'h8a; // [10][0x0A]
				
				config_next_state <= CONFIG_STATE_2; // next state
			end
			
			CONFIG_STATE_2:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0010;
				led <= led_reg;
`endif
				// write to the OTG register
				outdata <= 8'h8a; // [10][0x0A]
				
				config_next_state <= CONFIG_STATE_3; // next state
			end
			
			CONFIG_STATE_3:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0011;
				led <= led_reg;
`endif
				outdata <= 8'h00; // data byte to write into the register
				
				config_next_state <= CONFIG_STATE_4; // next state
			end
			
			CONFIG_STATE_4:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0100;
				led <= led_reg;
`endif
				// write 0x00 to the OTG register to disable OTG and enable peripheral mode
				outdata <= 8'h00;
				stp_reg <= 8'h01; // send STP to tell the PHY that the command is sent completely and no more bytes follow
			
				config_next_state <= CONFIG_STATE_5; // next state
			end
			
			CONFIG_STATE_5:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK	
				led_reg <= ~4'b0101;
				led <= led_reg;
`endif
				outdata <= 8'h00;
				stp_reg <= 8'h00;
			
				config_next_state <= CONFIG_STATE_6; // next state
			end
			
			CONFIG_STATE_6:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0110;
				led <= led_reg;
`endif
				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				config_next_state <= CONFIG_STATE_7; // next state
			end 
			
			CONFIG_STATE_7:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b0111;
				led <= led_reg;
`endif
				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				config_next_state <= CONFIG_STATE_8; // next state
			end
			
			CONFIG_STATE_8:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1000;
				led <= led_reg;
`endif
				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				config_next_state <= CONFIG_STATE_9; // next state
			end
			
			CONFIG_STATE_9:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1001;
				led <= led_reg;
`endif
				// write the value 0x45 into the FUNC_CTRL register to enable Fast Speed (FS) mode.
				outdata <= 8'h45; // data byte to write into the register (0100 0101)
					
				config_next_state <= CONFIG_STATE_10; // next state
			end
			
			CONFIG_STATE_10:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1010;
				led <= led_reg;
`endif
				outdata <= 8'h00;
				stp_reg <= 8'h00;
				
				// The PHY should respond with a RXCMD showing a LineState of J ("01", FS Idle).
				// 10001010
					
				config_next_state <= CONFIG_STATE_11; // next state
			end
			
			CONFIG_STATE_11:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1011;
				led <= led_reg;
`endif
				outdata <= 8'h00;
				stp_reg <= 8'h01; // send STP to tell the PHY that the command is sent completely and no more bytes follow
					
				config_next_state <= CONFIG_STATE_12; // next state
			end
			
			CONFIG_STATE_12:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1100;
				led <= led_reg;
`endif
				outdata <= 8'h00;
				stp_reg <= 8'h00;
					
				config_next_state <= CONFIG_STATE_13; // next state
			end
			
			CONFIG_STATE_13:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1101;
				led <= led_reg;
`endif
				//outdata = 8'b01000000; // Transmit on D+/D- (See Table 6.4, page 24) [01]
				//stp_reg = 8'h00;
				
				outdata <= 8'h00;
				stp_reg <= 8'h00;
				
				config_next_state <= CONFIG_STATE_14; // next state
			end
			
			CONFIG_STATE_14:
			begin
			
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1110;
				led <= led_reg;
`endif
				//outdata <= 8'h42; // Transmit on D+/D- ACK == 0x42
				//stp_reg <= 8'h00;
				
				outdata = 8'h00;
				stp_reg = 8'h00;
					
				config_next_state = CONFIG_STATE_14;
				
				if (ack == 1)
				begin
					config_next_state = CONFIG_STATE_15;
				end
				
			end
			
			CONFIG_STATE_15:
			begin
				if (DIR || NXT)
				begin
					config_next_state = CONFIG_STATE_15;
				end
				else 
				begin
					outdata = 8'h42; // ack
					stp_reg = 8'h00;
					
					config_next_state = CONFIG_STATE_16;
				end
			end
			
			CONFIG_STATE_16:
			begin
				config_next_state = CONFIG_STATE_16;
			end
			
			CONFIG_IDLE: 
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led_reg <= ~4'b1111;
				led <= led_reg;
`endif
				// LINK needs to pull STP low otherwise nothing works at all
				stp_reg <= 0;
				
				// next state
				if (ulpi_register_write_reg == 1)
				begin
					config_next_state <= CONFIG_STATE_0;
				end
			end
			
			default:
			begin				
				// next state
				config_next_state <= CONFIG_IDLE; // Fallback to default state
				
				// LINK needs to pull STP low otherwise nothing works at all
				stp_reg <= 0;
			end			
			
		endcase

	end

endmodule