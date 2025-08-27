//`define USE_LED_FOR_RESET_BLOCK 1
`undef USE_LED_FOR_RESET_BLOCK

//`define USE_LED_FOR_CONFIG_BLOCK 1
`undef USE_LED_FOR_CONFIG_BLOCK

`define USE_LED_FOR_COMM_BLOCK 1
//`undef USE_LED_FOR_COMM_BLOCK



module state_machine_2 (

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
	output 	reg 			STP, 		// PIN 58	
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
	
	
	
	// when reset is asserted, the phy resets
	reg [31:0] phy_reset_counter;
	reg phy_reset_performed;
	
	reg RST_reg;
	assign RST = RST_reg;

	//reg stp_reg;
	//assign STP = stp_reg;
	
	reg ulpi_register_write_reg;
	
	//reg [3:0] led_reg;
	//assign led = led_reg;
	
	reg [7:0] latched_data_reg;
	
	
	
	reg [7:0] device_descriptor [0:17];
	reg [7:0] device_descriptor_idx;
	
	
	
	//
	// ULPI soft reset logic
	//
	
	// UPLI, Perform RESET
	always @(posedge CLKOUT)
	begin
	
		if (!reset)
		begin
`ifdef USE_LED_FOR_RESET_BLOCK
			led <= ~4'b1110;
`endif

			// reset counter
			phy_reset_counter <= 32'd0;
			
			// no reset performed yet
			phy_reset_performed <= 0;
			
			// assert the reset pin to trigger a reset of the PHY
			RST_reg <= 1;
			
			// do not register write while the PHY resets
			ulpi_register_write_reg <= 0;
			
			//led <= 4'b0000;
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
`ifdef USE_LED_FOR_RESET_BLOCK
				led <= ~4'b1100;
`endif
			
				// PHY reset has been performed
				phy_reset_performed <= 1;
				
				// do not reset any more
				RST_reg <= 0;
				
				// start register write
				ulpi_register_write_reg <= 1;
				
				
				
				
//				device_descriptor[0] = 8'h01;
//				device_descriptor[1] = 8'h02;
//				device_descriptor[2] = 8'h02;
//				device_descriptor[3] = 8'h03;
//				device_descriptor[4] = 8'h04;
//				device_descriptor[5] = 8'h05;
//				device_descriptor[6] = 8'h06;
//				device_descriptor[7] = 8'h07;
//				
//				device_descriptor[8] = 8'h08;
//				device_descriptor[9] = 8'h09;
//				device_descriptor[10] = 8'h0A;
//				device_descriptor[11] = 8'h0B;
//				device_descriptor[12] = 8'h0C;
//				device_descriptor[13] = 8'h0D;
//				device_descriptor[14] = 8'h0E;
//				device_descriptor[15] = 8'h0F;
//				
//				device_descriptor[16] = 8'h10;
//				device_descriptor[17] = 8'h11;
				
				// set index to 0
				//device_descriptor_idx = 8'h00;
				
				
				
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
	
	localparam CONFIG_STATE_0 		= 8'd0;
	localparam CONFIG_STATE_1 		= 8'd1;
	localparam CONFIG_STATE_2 		= 8'd2;
	localparam CONFIG_STATE_3 		= 8'd3;
	localparam CONFIG_STATE_4 		= 8'd4;
	localparam CONFIG_STATE_5 		= 8'd5;
	localparam CONFIG_STATE_6 		= 8'd6;
	localparam CONFIG_STATE_7 		= 8'd7;
	localparam CONFIG_STATE_8 		= 8'd8;
	localparam CONFIG_STATE_9 		= 8'd9;
	localparam CONFIG_STATE_10 	= 8'd10;
	localparam CONFIG_STATE_11		= 8'd11;
	localparam CONFIG_STATE_12		= 8'd12;
	localparam CONFIG_STATE_13		= 8'd13;
	localparam CONFIG_STATE_14		= 8'd14;
	localparam CONFIG_STATE_15		= 8'd15;
	localparam CONFIG_STATE_16		= 8'd16;	
	
	localparam MSG_DEV_DESC_0		= 8'd20;
	localparam MSG_DEV_DESC_1		= 8'd21;	
	localparam MSG_DEV_DESC_2		= 8'd22;	
	localparam MSG_DEV_DESC_3		= 8'd23;
	localparam MSG_DEV_DESC_4		= 8'd24;
	localparam MSG_DEV_DESC_5		= 8'd25;
	localparam MSG_DEV_DESC_6		= 8'd26;
	localparam MSG_DEV_DESC_7		= 8'd27;
	localparam MSG_DEV_DESC_8		= 8'd28;
	localparam MSG_DEV_DESC_9		= 8'd29;
	localparam MSG_DEV_DESC_10		= 8'd30;
	localparam MSG_DEV_DESC_11		= 8'd31;
	localparam MSG_DEV_DESC_12		= 8'd32;
	localparam MSG_DEV_DESC_13		= 8'd33;	
	
	// PID IN detection starts here
	localparam MSG_DEV_DESC_14		= 8'd34;
	localparam MSG_DEV_DESC_15		= 8'd35;
	localparam MSG_DEV_DESC_16		= 8'd36;
	localparam MSG_DEV_DESC_17		= 8'd37;
	localparam MSG_DEV_DESC_18		= 8'd38;
	localparam MSG_DEV_DESC_19		= 8'd39;
	localparam MSG_DEV_DESC_20		= 8'd40;
	localparam MSG_DEV_DESC_21		= 8'd41;
	localparam MSG_DEV_DESC_22		= 8'd42;
	localparam MSG_DEV_DESC_23		= 8'd43;
	localparam MSG_DEV_DESC_24		= 8'd44;
	localparam MSG_DEV_DESC_25		= 8'd45;
	localparam MSG_DEV_DESC_26		= 8'd46;
	localparam MSG_DEV_DESC_27		= 8'd47;
	localparam MSG_DEV_DESC_28		= 8'd48;
	localparam MSG_DEV_DESC_29		= 8'd49;
	
	localparam MSG_DEV_DESC_30		= 8'd50;
	localparam MSG_DEV_DESC_31		= 8'd51;
	localparam MSG_DEV_DESC_32		= 8'd52;
	localparam MSG_DEV_DESC_33		= 8'd53;
	localparam MSG_DEV_DESC_34		= 8'd54;
	localparam MSG_DEV_DESC_35		= 8'd55;
	localparam MSG_DEV_DESC_36		= 8'd56;
	localparam MSG_DEV_DESC_37		= 8'd57;
	localparam MSG_DEV_DESC_38		= 8'd58;
	localparam MSG_DEV_DESC_39		= 8'd59;
	
	localparam MSG_DEV_DESC_40		= 8'd60;
	localparam MSG_DEV_DESC_41		= 8'd61;
	localparam MSG_DEV_DESC_42		= 8'd62;
	localparam MSG_DEV_DESC_43		= 8'd63;
	localparam MSG_DEV_DESC_44		= 8'd64;
	localparam MSG_DEV_DESC_45		= 8'd65;
	localparam MSG_DEV_DESC_46		= 8'd66;
	localparam MSG_DEV_DESC_47		= 8'd67;
	localparam MSG_DEV_DESC_48		= 8'd68;
	localparam MSG_DEV_DESC_49		= 8'd69;
	
	localparam MSG_DEV_DESC_50		= 8'd70;
	localparam MSG_DEV_DESC_51		= 8'd71;
	localparam MSG_DEV_DESC_52		= 8'd72;
	localparam MSG_DEV_DESC_53		= 8'd73;
	localparam MSG_DEV_DESC_54		= 8'd74;
	localparam MSG_DEV_DESC_55		= 8'd75;
	localparam MSG_DEV_DESC_56		= 8'd76;
	localparam MSG_DEV_DESC_57		= 8'd77;
	localparam MSG_DEV_DESC_58		= 8'd78;
	localparam MSG_DEV_DESC_59		= 8'd79;
	
	localparam MSG_DEV_DESC_60		= 8'd80;
	localparam MSG_DEV_DESC_61		= 8'd81;
	localparam MSG_DEV_DESC_62		= 8'd82;
	localparam MSG_DEV_DESC_63		= 8'd83;
	localparam MSG_DEV_DESC_64		= 8'd84;
	localparam MSG_DEV_DESC_65		= 8'd85;
	localparam MSG_DEV_DESC_66		= 8'd86;
	localparam MSG_DEV_DESC_67		= 8'd87;
	localparam MSG_DEV_DESC_68		= 8'd88;
	localparam MSG_DEV_DESC_69		= 8'd89;
	
	localparam STATE_IDLE 			= 8'd255;
	
	reg [7:0] state;// <= STATE_IDLE;
	
	// combinational always block for next state logic
	//always @(config_cur_state)
	always @(posedge CLKOUT)	
	begin
	
		// default next state assignment
		//state = STATE_IDLE;
		
		if (!reset) 
		begin
			state = STATE_IDLE;
		end

		case (state)

			CONFIG_STATE_0: 
			begin
			
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0000;
				//led <= led_reg;
				led <= ~4'b0001;
`endif

				// LINK needs to pull STP low otherwise nothing works at all
				STP = 0;

				if (DIR == 1)
				begin
					state <= CONFIG_STATE_0;
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
					
					outdata <= 8'h8a; // [10][0x0A]
					
					state <= CONFIG_STATE_1; // next state
					
					
					
					device_descriptor[0] <= 8'h01;
					device_descriptor[1] <= 8'h02;
					device_descriptor[2] <= 8'h02;
					device_descriptor[3] <= 8'h03;
					device_descriptor[4] <= 8'h04;
					device_descriptor[5] <= 8'h05;
					device_descriptor[6] <= 8'h06;
					device_descriptor[7] <= 8'h07;
					
					device_descriptor[8] <= 8'h08;
					device_descriptor[9] <= 8'h09;
					device_descriptor[10] <= 8'h0A;
					device_descriptor[11] <= 8'h0B;
					device_descriptor[12] <= 8'h0C;
					device_descriptor[13] <= 8'h0D;
					device_descriptor[14] <= 8'h0E;
					device_descriptor[15] <= 8'h0F;
					
					device_descriptor[16] <= 8'h10;
					device_descriptor[17] <= 8'h11;
					
					// set index to 0
					device_descriptor_idx <= 8'h00;
				
				end
			end

			CONFIG_STATE_1:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0001;
				//led <= led_reg;
				led <= ~4'b0001;
`endif
				outdata <= 8'h8a; // [10][0x0A]
				
				state <= CONFIG_STATE_2; // next state
			end
			
			CONFIG_STATE_2:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0010;
				//led <= led_reg;
				led <= ~4'b0010;
`endif
				// write to the OTG register
				outdata <= 8'h8a; // [10][0x0A]
				
				state <= CONFIG_STATE_3; // next state
			end
			
			CONFIG_STATE_3:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0011;
				//led <= led_reg;
				led <= ~4'b0011;
`endif
				outdata <= 8'h00; // data byte to write into the register
				
				state <= CONFIG_STATE_4; // next state
			end
			
			CONFIG_STATE_4:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0100;
				//led <= led_reg;
				led <= ~4'b0100;
`endif
				// write 0x00 to the OTG register to disable OTG and enable peripheral mode
				outdata <= 8'h00;
				STP <= 8'h01; // send STP to tell the PHY that the command is sent completely and no more bytes follow
			
				state <= CONFIG_STATE_5; // next state
			end
			
			CONFIG_STATE_5:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK	
				//led_reg <= ~4'b0101;
				//led <= led_reg;
				led <= ~4'b0101;
`endif
				outdata <= 8'h00;
				STP <= 8'h00;
			
				state <= CONFIG_STATE_6; // next state
			end
			
			CONFIG_STATE_6:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0110;
				//led <= led_reg;
				led <= ~4'b0110;
`endif
				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				state <= CONFIG_STATE_7; // next state
			end 
			
			CONFIG_STATE_7:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0111;
				//led <= led_reg;
				led <= ~4'b0111;
`endif
				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				state <= CONFIG_STATE_8; // next state
			end
			
			CONFIG_STATE_8:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b1000;
				//led <= led_reg;
				led <= ~4'b1000;
`endif
				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				state <= CONFIG_STATE_9; // next state
			end
			
			CONFIG_STATE_9:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b1001;
				//led <= led_reg;
				led <= ~4'b0000;
`endif
				// write the value 0x45 into the FUNC_CTRL register to enable Fast Speed (FS) mode.
				outdata <= 8'h45; // data byte to write into the register (0100 0101)
					
				state <= CONFIG_STATE_10; // next state
			end
			
			CONFIG_STATE_10:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b1010;
				//led <= led_reg;
				led <= ~4'b1010;
`endif
				outdata <= 8'h00;
				STP <= 8'h00;
				
				// The PHY should respond with a RXCMD showing a LineState of J ("01", FS Idle).
				// 10001010
					
				state <= CONFIG_STATE_11; // next state
			end
			
			CONFIG_STATE_11:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led <= ~4'b0011;
`endif
				outdata <= 8'h00;
				STP <= 8'h01; // send STP to tell the PHY that the command is sent completely and no more bytes follow
					
				state <= CONFIG_STATE_12; // next state
			end
			
			CONFIG_STATE_12:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				led <= ~4'b0000;
`endif
				outdata <= 8'h00;
				STP <= 8'h00;
					
				state <= CONFIG_STATE_13; // next state
			end
			
			CONFIG_STATE_13:
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b1101;
				//led <= led_reg;
				led <= ~4'b1101;
`endif
				//outdata = 8'b01000000; // Transmit on D+/D- (See Table 6.4, page 24) [01]
				//STP = 8'h00;
				
				outdata <= 8'h00;
				STP <= 8'h00;
				
				state <= CONFIG_STATE_14; // next state
			end
			
			CONFIG_STATE_14:
			begin			
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b1110;
				//led <= led_reg;
				led <= ~4'b1110;
`endif
				//outdata <= 8'h42; // Transmit on D+/D- ACK == 0x42
				//STP <= 8'h00;
				
				outdata <= 8'h00;
				STP <= 8'h00;
					
				state <= MSG_DEV_DESC_0;
				//state <= CONFIG_STATE_16;			
			end
			
			
			
			CONFIG_STATE_16:
			begin
				state <= CONFIG_STATE_16;
			end
			
			
			
			//default:
			//begin				
				// next state
			//	state <= CONFIG_IDLE; // Fallback to default state
				
				// LINK needs to pull STP low otherwise nothing works at all
			//	STP <= 0;
			//end			
			
		//endcase

	//end	
	
	//always @(posedge CLKOUT)
	//begin
	
		//if (!reset)
		//begin
		//	state = MSG_DEV_DESC_0;
		//end
	
		//case (state)
		
			MSG_DEV_DESC_0:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				//led_reg <= 4'b1111;
				led <= ~4'b0001;
`endif
				if (data == 8'hc3)
					state <= MSG_DEV_DESC_1;
				else
					state <= MSG_DEV_DESC_0;
			end
			
			MSG_DEV_DESC_1:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001;
`endif
				if (data == 8'h80)
					state <= MSG_DEV_DESC_2;
				else
					state <= MSG_DEV_DESC_1;
			end
			
			MSG_DEV_DESC_2:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0010;
`endif
				if (data == 8'h06)
					state <= MSG_DEV_DESC_3;
				else
					state <= MSG_DEV_DESC_2;
			end
			
			MSG_DEV_DESC_3:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0011; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	
					state <= MSG_DEV_DESC_4;
				else
					state <= MSG_DEV_DESC_3;
			end
			
			MSG_DEV_DESC_4:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0100; // [L1][L2][L3][L4]
`endif
				if (data == 8'h01)	
					state <= MSG_DEV_DESC_5;
				else
					state <= MSG_DEV_DESC_4;
			end
			
			MSG_DEV_DESC_5:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0101; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	
					state <= MSG_DEV_DESC_6;
				else
					state <= MSG_DEV_DESC_5;
			end
			
			MSG_DEV_DESC_6:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0110; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	
					state <= MSG_DEV_DESC_7;
				else
					state <= MSG_DEV_DESC_6;
			end
			
			MSG_DEV_DESC_7:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0111; // [L1][L2][L3][L4]
`endif
				if (data == 8'h40)	
					state <= MSG_DEV_DESC_8;
				else
					state <= MSG_DEV_DESC_7;
			end
			
			MSG_DEV_DESC_8:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1000; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	
					state <= MSG_DEV_DESC_9; // entire DEVICE DESCRIPTOR REQUEST PACKET RECEIVED
				else
					state <= MSG_DEV_DESC_8;
			end
			
			//
			// CRC16 (2 Byte CRC) which we consume but skip checking validity
			//
			
			MSG_DEV_DESC_9:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif
				state <= MSG_DEV_DESC_10; // SKIP CRC BYTE 0
			end
			
			MSG_DEV_DESC_10:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1010; // [L1][L2][L3][L4]
`endif
				state <= MSG_DEV_DESC_11; // SKIP CRC BYTE 1
			end
			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			MSG_DEV_DESC_11:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0011; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_DESC_11;
				end
				else 
				begin
					outdata <= 8'h42; // ack
					STP <= 8'h00;
					
					state <= MSG_DEV_DESC_12;
				end
				
			end
			
			MSG_DEV_DESC_12:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1100; // [L1][L2][L3][L4]
`endif
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_DESC_12;
				else 
					if (NXT == 1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'b0;
						STP <= 1;
						state <= MSG_DEV_DESC_13;
					end
				else 
					state <= state;
			end
			
			MSG_DEV_DESC_13:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1101; // [L1][L2][L3][L4]
`endif
				outdata <= 8'h00;
				STP <= 8'h00;
				state <= MSG_DEV_DESC_14;
			end
			
			//
			// PID IN detection starts here. We expect the bytes <BYTES: 69 00 10>
			//
			
			MSG_DEV_DESC_14:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1110; // [L1][L2][L3][L4]
`endif
				if (data == 8'h69) // PID BYTE 0 - 0x69
					state <= MSG_DEV_DESC_15;
				else
					state <= MSG_DEV_DESC_14;
			end
			
			MSG_DEV_DESC_15:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1110; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 1 - 0x00
					state <= MSG_DEV_DESC_16;
				else
					state <= MSG_DEV_DESC_15;
			end
			
			MSG_DEV_DESC_16:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1110; // [L1][L2][L3][L4]
`endif
				if (data == 8'h10)	// PID BYTE 2 - 0x10
				begin
					state <= MSG_DEV_DESC_17;
					//device_descriptor_idx <= 0;
				end
				else
					state <= MSG_DEV_DESC_16;
			end
			
			//
			// SEND device descriptor
			//
			
			MSG_DEV_DESC_17:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif

				if (device_descriptor_idx >= 8'h12)
				begin
					state = MSG_DEV_DESC_28; // next state
				end
				else
				begin
					// Wait for the line to be free
					if (DIR || NXT)
					begin
						state = MSG_DEV_DESC_17; // remain
					end
					else 
					begin
						outdata = device_descriptor[device_descriptor_idx];
						device_descriptor_idx = device_descriptor_idx + 1;
						STP = 8'h00;
					end
					//state <= MSG_DEV_DESC_17; // remain
				end
				

			

			/*
			// Wait for the line to be free
			if (DIR == 1)
			begin
				state <= MSG_DEV_DESC_17; // remain
			end
			else 
			begin
				if (NXT == 1)
				begin
					outdata <= device_descriptor[device_descriptor_idx];
					device_descriptor_idx <= device_descriptor_idx + 1;
					
					STP <= 8'h00;
	
					if (device_descriptor_idx >= 8'h12)
					begin
						state <= MSG_DEV_DESC_28; // next state
					end
					else
					begin
						state <= MSG_DEV_DESC_17; // remain
					end
				end
			end
			*/
		end
			
			//
			// SEND device descriptor
			//
			
/*
			MSG_DEV_DESC_17:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_DESC_17; // remain
				end
				else 
				begin
					outdata <= 8'h4B; // <4B 12 01 00 02 FF FF FF 08 33 16>
					STP <= 8'h00;					
					state <= MSG_DEV_DESC_18; // next state
				end				
			end
			MSG_DEV_DESC_18:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_18; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'h12; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_19; // next state
					end
				end				
			end
			MSG_DEV_DESC_19:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_19; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'h01; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_20; // next state
					end
				end					
			end
			MSG_DEV_DESC_20:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_20; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'h00; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_21; // next state
					end
				end						
			end
			MSG_DEV_DESC_21:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_21; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'h02; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_22; // next state
					end
				end					
			end
			MSG_DEV_DESC_22:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_22; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'hFF; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_23; // next state
					end
				end				
			end
			MSG_DEV_DESC_23:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_23; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'hFF; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_24; // next state
					end
				end					
			end
			MSG_DEV_DESC_24:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_24; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'hFF; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_25; // next state
					end
				end					
			end
			MSG_DEV_DESC_25:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_25; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// bMaxPacketSize0 == 8 (8 bytes)
						outdata <= 8'h08; // <4B 12 01 00 02 FF FF FF 08 33 16>
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_26; // next state
					end
				end					
			end
			
			MSG_DEV_DESC_26:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_26; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'h16; // <4B 12 01 00 02 FF FF FF 08 33 16> THE CRC IS PROVIDED IN REVERSE!!!! 16 first
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_27; // next state
					end
				end
			end
			MSG_DEV_DESC_27:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_27; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						outdata <= 8'h33; // <4B 12 01 00 02 FF FF FF 08 33 16> THE CRC IS PROVIDED IN REVERSE!!!! 33 last
						STP <= 8'h00;					
						state <= MSG_DEV_DESC_28; // next state
					end
				end			
			end
*/
			
			// SET STOP BIT
			MSG_DEV_DESC_28:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1100; // [L1][L2][L3][L4]
`endif
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_DESC_28;
				else 
					if (NXT == 1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1;
						state <= MSG_DEV_DESC_29;
						//state <= MSG_DEV_DESC_30;
					end
				else 
					state <= state;
			end
			
			// REMOVE the stop bit
			MSG_DEV_DESC_29:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1111; // [L1][L2][L3][L4]
`endif
				STP <= 0;
				state <= MSG_DEV_DESC_30;
			end

			
			//
			// CONSUME: PID out <E1 00 10>
			//
			
			MSG_DEV_DESC_30:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif
				
				if (data == 8'hE1) // PID BYTE 0 - 0x69
					state <= MSG_DEV_DESC_31;
				else
					state <= MSG_DEV_DESC_30;
			end
			
			MSG_DEV_DESC_31:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0010; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 1 - 0x00
					state <= MSG_DEV_DESC_32;
				else
					state <= MSG_DEV_DESC_31;
			end
			
			MSG_DEV_DESC_32:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0011; // [L1][L2][L3][L4]
`endif
				if (data == 8'h10)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_33;
				else
					state <= MSG_DEV_DESC_32;
			end
			
			//
			// CONSUME: PID DATA 1 <4B 00 00>
			//
			
			MSG_DEV_DESC_33:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0100; // [L1][L2][L3][L4]
`endif
				if (data == 8'h4D) // PID BYTE 0 - 0x4B [01][00][1011]
					state <= MSG_DEV_DESC_34;
				else
					state <= MSG_DEV_DESC_33;
			end
			
			MSG_DEV_DESC_34:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0101; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 1 - 0x00
					state <= MSG_DEV_DESC_35;
				else
					state <= MSG_DEV_DESC_34;
			end
			
			MSG_DEV_DESC_35:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0110; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x00
					state <= MSG_DEV_DESC_36;
				else
					state <= MSG_DEV_DESC_35;
			end
			
			//
			// SEND: ACK <D2>
			// 
			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			MSG_DEV_DESC_36:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1111; // [L1][L2][L3][L4]
`endif			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_DESC_36;
				end
				else 
				begin
					outdata <= 8'h42; // ack (01000010)
					STP <= 8'h00;
					
					state <= MSG_DEV_DESC_37;
				end				
			end
			
			MSG_DEV_DESC_37:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1000; // [L1][L2][L3][L4]
`endif
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_DESC_37;
				else 
					if (NXT == 1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'b0;
						STP <= 1;
						state <= MSG_DEV_DESC_38;
						//state <= MSG_DEV_DESC_39;
					end
				else 
					state <= state;
			end
			
			// REMOVE the stop bit (SKIPPED)
			MSG_DEV_DESC_38:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif
				outdata <= 8'h00;
				STP <= 8'h00;
				state <= MSG_DEV_DESC_39;
			end
			
			//
			// process the mystery request that the internet does not know ???
			// [PID DATA: C3] [00 05 03 00 00 00 00 00] [CRC: C7EA]
			//
			
			MSG_DEV_DESC_39:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0000; // [L1][L2][L3][L4]
`endif
				if (data == 8'hC3)	// PID DATA0 - 0xC3 11000011
					state <= MSG_DEV_DESC_40;
				else
					state <= MSG_DEV_DESC_39;
			end
			
			MSG_DEV_DESC_40:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_41;
				else
					state <= MSG_DEV_DESC_40;
			end
			MSG_DEV_DESC_41:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif
				if (data == 8'h05)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_42;
				else
					state <= MSG_DEV_DESC_41;
			end
			MSG_DEV_DESC_42:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0010; // [L1][L2][L3][L4]
`endif
				if (data == 8'h03)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_43;
				else
					state <= MSG_DEV_DESC_42;
			end
			MSG_DEV_DESC_43:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0011; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_44;
				else
					state <= MSG_DEV_DESC_43;
			end
			MSG_DEV_DESC_44:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0100; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_45;
				else
					state <= MSG_DEV_DESC_44;
			end
			MSG_DEV_DESC_45:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0101; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_46;
				else
					state <= MSG_DEV_DESC_45;
			end
			MSG_DEV_DESC_46:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0110; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_47;
				else
					state <= MSG_DEV_DESC_46;
			end
			MSG_DEV_DESC_47:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1111; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_48;
				else
					state <= MSG_DEV_DESC_47;
			end
			
			//
			// Consume CRC
			//
/*
			MSG_DEV_DESC_47:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0111; // [L1][L2][L3][L4]
`endif
				if (data == 8'hEA)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_48;
				else
					state <= MSG_DEV_DESC_47;
			end
			MSG_DEV_DESC_48:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0111; // [L1][L2][L3][L4]
`endif
				if (data == 8'hC7)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_49;
				else
					state <= MSG_DEV_DESC_48;
			end
*/

			//
			// CRC16 (2 Byte CRC) which we consume but skip checking validity
			//
			
			MSG_DEV_DESC_48:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1001; // [L1][L2][L3][L4]
`endif
				state <= MSG_DEV_DESC_49; // SKIP CRC BYTE 0
			end
			
			MSG_DEV_DESC_49:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1010; // [L1][L2][L3][L4]
`endif
				state <= MSG_DEV_DESC_50; // SKIP CRC BYTE 1
			end
			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			MSG_DEV_DESC_50:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0111; // [L1][L2][L3][L4]
`endif		

				//outdata <= 8'hD2; // ack
				outdata <= 8'h42; // ack (READ: 6.1.7.6 Typical USB Transmit with ULPI in document: 00001783C.pdf)
				// a transmit command looks like this: [01][00][xxxx] whereas xxxx = 4 bit PID. The PID for
				// an acknowledge ACK is: 0010
				
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_DESC_50;
				end
				else 
				begin
					
					STP <= 8'h00;
					
					state <= MSG_DEV_DESC_51;
				end
			end
			
			MSG_DEV_DESC_51:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1000; // [L1][L2][L3][L4]
`endif
				outdata <= 8'b0;
				
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_DESC_51;
				else 
					if (NXT == 1)
					begin
						// tell the phy that the outgoing message is completely output
						
						STP <= 1;
						state <= MSG_DEV_DESC_52;
						//state <= MSG_DEV_DESC_51;
					end
				else 
					state <= state;
			end
			
			// PULL STOP LOW
			MSG_DEV_DESC_52:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1011; // [L1][L2][L3][L4]
`endif
				outdata <= 8'h00;
				STP <= 8'h00; // pull the STP signal low because it is high for a single cycle only
				state <= MSG_DEV_DESC_53;
			end
			
			//
			// CONSUME: (Host -> Device) PID IN <69 00 10>
			//
			
			MSG_DEV_DESC_53:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0001; // [L1][L2][L3][L4]
`endif
				if (data == 8'h69) // PID BYTE 0 - 0x69
					state <= MSG_DEV_DESC_54;
				else
					state <= MSG_DEV_DESC_53;
			end
			
			MSG_DEV_DESC_54:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0010; // [L1][L2][L3][L4]
`endif
				if (data == 8'h00)	// PID BYTE 1 - 0x00
					state <= MSG_DEV_DESC_55;
				else
					state <= MSG_DEV_DESC_54;
			end
			
			MSG_DEV_DESC_55:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b0100; // [L1][L2][L3][L4]
`endif
				if (data == 8'h10)	// PID BYTE 2 - 0x10
					state <= MSG_DEV_DESC_56;
				else
					state <= MSG_DEV_DESC_55;
			end
			
			//
			// SEND: PID DATA 1 <00 00>
			//
			// Wait for the PHY to release the lines and send 0x00 0x00
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			MSG_DEV_DESC_56:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1000; // [L1][L2][L3][L4]
`endif		

				//outdata <= 8'hD2; // ack 11 01 0010
				outdata <= 8'h4B; // ack (READ: 6.1.7.6 Typical USB Transmit with ULPI in document: 00001783C.pdf)
				// a transmit command looks like this: [01][00][xxxx] whereas xxxx = 4 bit PID. The PID for
				// an DATA 1 is: 1011
				//outdata <= 8'h4D; // ERROR Packet
				//outdata <= 8'h44;
				
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_DESC_56;
				end
				else 
				begin
					
					
				
					STP <= 8'h00;
					
					state <= MSG_DEV_DESC_57;
				end
			end
			
			MSG_DEV_DESC_57:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1001; // [L1][L2][L3][L4]
`endif		
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_DESC_57;
				else 
					if (NXT == 1)
					begin
						outdata <= 8'h00;
						// tell the phy that the outgoing message is completely output
						STP <= 0;
						state <= MSG_DEV_DESC_58;
					end
				else 
					state <= state;
			end
			
			// PULL STOP LOW
			MSG_DEV_DESC_58:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1010; // [L1][L2][L3][L4]
`endif
				outdata <= 8'h00;
				STP <= 8'h00; // pull the STP signal low because it is high for a single cycle only
				state <= MSG_DEV_DESC_59;
			end
			
			// PULL STOP HIGH
			MSG_DEV_DESC_59:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1010; // [L1][L2][L3][L4]
`endif
				outdata <= 8'h00;
				STP <= 8'h01; // pull the STP signal low because it is high for a single cycle only
				state <= MSG_DEV_DESC_60;
			end
			
			// PULL STOP LOW
			MSG_DEV_DESC_60:
			begin
`ifdef USE_LED_FOR_COMM_BLOCK
				led <= ~4'b1010; // [L1][L2][L3][L4]
`endif
				outdata <= 8'h00;
				STP <= 8'h00; // pull the STP signal low because it is high for a single cycle only
				state <= MSG_DEV_DESC_60;
			end
			
			STATE_IDLE: 
			begin
`ifdef USE_LED_FOR_CONFIG_BLOCK
				//led_reg <= ~4'b0111;
				//led <= led_reg;
				led <= ~4'b1000;
`endif
				// LINK needs to pull STP low otherwise nothing works at all
				STP <= 0;
				
				// next state
				//if (ulpi_register_write_reg == 1)
				//begin
					state <= CONFIG_STATE_0;
				//end
			end
			
			default:
				state <= STATE_IDLE;
			
		endcase
		
	end
	
endmodule