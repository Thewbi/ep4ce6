module state_machine_4 (

	// clock and reset
	input 					RESET,
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
	
	reg ulpi_register_write_reg;
	
	reg [7:0] dev_desc_idx;
	reg [7:0] dev_desc_8_out_idx;
	
	reg [7:0] state;
	
	
	reg [3:0] idx;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	always @(posedge CLKOUT)	
	begin
		
		if (!RESET) 
		begin
			state <= STATE_IDLE;
		end

		case (state)
		
			//
			// PID SETUP - is the start of a transaction
			//
		
			// [2D 00 10]
			PID_SETUP_WAIT: // waiting for a PID SETUP packet
			begin
				idx = 4'b0000;
				led = ~4'b0000;
				
				if (indata == 8'h2D)
					state <= PID_SETUP_DETECT_ADDRESS;
				else
					state <= PID_SETUP_WAIT; // remain
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			PID_SETUP_DETECT_ADDRESS:
			begin
				state <= PID_SETUP_DETECT_CRC;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			PID_SETUP_DETECT_CRC:
			begin
				state <= PID_DATA_0_WAIT; // wait for a data packet
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
		
		
			//
			// DATA 0 means the HOST sends a request to the DEVICE
			//
		
			PID_DATA_0_WAIT:
			begin				
				// 0xC3 == PID DATA 0
				if (indata == 8'hC3) // this is PID DATA 0. It is followed by the entire request payload
				begin
					state <= STORE_REQUEST;
				end
				// I think the host will never send DATA 1 since the device needs to answer with DATA 1 !!!
				else
					state <= PID_DATA_0_WAIT; // remain
					
				outdata <= 8'h00;
				STP <= 1'b0;
			end
		
			STORE_REQUEST:
			begin				
				// wait for the payload of the request to be received!!!
				if (DIR || NXT)
				begin
					idx = idx + 4'b0001;
					state <= STORE_REQUEST;
				end
				else 
				begin					
					state <= SEND_ACK_1; // acknowledge DATA 0		
				end			
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			
			//
			// PID IN
			//
			// here, the host wants to receive the device address so it sends a PID IN to the device
			// [69 00 CRC] 
			//
			
			PID_IN_1:
			begin				
				if (indata == 8'h69)
				begin
					state <= PID_IN_2;
				end
				else
					state <= PID_IN_1; // remain
					
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			PID_IN_2:
			begin				
				state <= PID_IN_3;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			PID_IN_3:
			begin				
				state <= SEND_NACK_1;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			//
			// NACK
			//
			
			SEND_NACK_1:
			begin			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= SEND_NACK_1; // remain
				end
				else 
				begin
					led = ~idx;
					
					//outdata <= 8'h42; // ACK
					outdata <= 8'h5A; // NAK
					STP <= 8'h00;
					
					state <= SEND_NACK_2;
				end				
			end			
			SEND_NACK_2:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_NACK_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= SEND_NACK_3;
					end
					else 
						state <= state;
			end			
			SEND_NACK_3:
			begin
				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= PID_IN_1;
			end
			
			
			
			
			
			

			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			SEND_ACK_1:
			begin			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= SEND_ACK_1; // remain
				end
				else 
				begin
					outdata <= 8'h42; // ack
					STP <= 8'h00;
					
					state <= SEND_ACK_2;
				end				
			end			
			SEND_ACK_2:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_ACK_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= SEND_ACK_3;
					end
					else 
						state <= state;
			end			
			SEND_ACK_3:
			begin
				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= PID_IN_1;
			end
			
			
			
			
			
			
			
			
			
			
			
		
		
			//
			// PHY CONFIGURATION
			//
 
			CONFIG_STATE_0: 
			begin			


				// LINK needs to pull STP low otherwise nothing works at all
				STP = 1'b0;

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
				end
			end

			CONFIG_STATE_1:
			begin

				outdata <= 8'h8a; // [10][0x0A]
				
				state <= CONFIG_STATE_2; // next state
			end
			
			CONFIG_STATE_2:
			begin

				// write to the OTG register
				outdata <= 8'h8a; // [10][0x0A]
				
				state <= CONFIG_STATE_3; // next state
			end
			
			CONFIG_STATE_3:
			begin

				outdata <= 8'h00; // data byte to write into the register
				
				state <= CONFIG_STATE_4; // next state
			end
			
			CONFIG_STATE_4:
			begin

				// write 0x00 to the OTG register to disable OTG and enable peripheral mode
				outdata <= 8'h00;
				STP <= 1'b1; // send STP to tell the PHY that the command is sent completely and no more bytes follow
			
				state <= CONFIG_STATE_5; // next state
			end
			
			CONFIG_STATE_5:
			begin

				outdata <= 8'h00;
				STP <= 1'b0;
			
				state <= CONFIG_STATE_6; // next state
			end
			
			CONFIG_STATE_6:
			begin

				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				state <= CONFIG_STATE_7; // next state
			end 
			
			CONFIG_STATE_7:
			begin

				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				state <= CONFIG_STATE_8; // next state
			end
			
			CONFIG_STATE_8:
			begin

				// Write to the FUNC_CTRL register (Goal: enable Fast Speed (FS) mode)
				outdata <= 8'h84; // [10][0x04] write the function control register
					
				state <= CONFIG_STATE_9; // next state
			end
			
			CONFIG_STATE_9:
			begin

				// write the value 0x45 into the FUNC_CTRL register to enable Fast Speed (FS) mode.
				outdata <= 8'h45; // data byte to write into the register (0100 0101)
					
				state <= CONFIG_STATE_10; // next state
			end
			
			CONFIG_STATE_10:
			begin

				outdata <= 8'h00;
				STP <= 1'b0;
				
				// The PHY should respond with a RXCMD showing a LineState of J ("01", FS Idle).
				// 10001010
					
				state <= CONFIG_STATE_11; // next state
			end
			
			CONFIG_STATE_11:
			begin

				outdata <= 8'h00;
				STP <= 1'b1; // send STP to tell the PHY that the command is sent completely and no more bytes follow
					
				state <= CONFIG_STATE_12; // next state
			end
			
			CONFIG_STATE_12:
			begin

				outdata <= 8'h00;
				STP <= 1'b0;
					
				state <= CONFIG_STATE_13; // next state
			end
			
			CONFIG_STATE_13:
			begin

				//outdata = 8'b01000000; // Transmit on D+/D- (See Table 6.4, page 24) [01]
				//STP = 8'h00;
				
				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= CONFIG_STATE_14; // next state
			end
			
			CONFIG_STATE_14:
			begin			

				outdata <= 8'h00;
				STP <= 1'b0;
					
				state <= PID_SETUP_WAIT;
			end
			
			
			
			
			
			
			
			
			
			
			
			
			STATE_IDLE: 
			begin

				// LINK needs to pull STP low otherwise nothing works at all
				STP <= 1'b0;
				
				// next state
				if (ulpi_register_write_reg == 1'b1)
				begin
					state <= CONFIG_STATE_0;
					//state <= MSG_DEV_DESC_CENTER;
				end
				else
					state <= STATE_IDLE;
			end
			
			default:
				state <= STATE_IDLE;
			
		endcase
		
	end
	
	
	
	
	
	//
	// ULPI soft reset logic
	//
	
	// UPLI, Perform RESET
	always @(posedge CLKOUT)
	begin
	
		if (!RESET)
		begin

			// reset counter
			phy_reset_counter <= 32'd0;
			
			// no reset performed yet
			phy_reset_performed <= 0;
			
			// assert the reset pin to trigger a reset of the PHY
			RST_reg <= 1;
			
			// do not register write while the PHY resets
			ulpi_register_write_reg <= 0;
		end
		
		//if (phy_reset_counter == 60000000)
		//if (phy_reset_counter == 10000000)
		if (phy_reset_counter == 100000)
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
	
	//
	// USB Protocol processing
	//
	
	localparam PID_SETUP_WAIT				= 8'd20;
	localparam PID_SETUP_DETECT_ADDRESS	= 8'd21;
	localparam PID_SETUP_DETECT_CRC		= 8'd22;
	
	localparam PID_DATA_0_WAIT				= 8'd23;
	localparam STORE_REQUEST				= 8'd24;
	
	localparam SEND_ACK_1					= 8'd25;
	localparam SEND_ACK_2					= 8'd26;
	localparam SEND_ACK_3					= 8'd27;
	
	localparam SEND_NACK_1					= 8'd28;
	localparam SEND_NACK_2					= 8'd29;
	localparam SEND_NACK_3					= 8'd30;
	
	localparam PID_IN_1						= 8'd31;
	localparam PID_IN_2						= 8'd32;
	localparam PID_IN_3						= 8'd33;
	
	localparam STATE_IDLE 					= 8'd255;
	
endmodule