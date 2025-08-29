


module state_machine_3 (

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
	
	
	
	
	
	
	
	
	
	
	
	
	reg [7:0] state;
	
	always @(posedge CLKOUT)	
	begin
		
		if (!RESET) 
		begin

			state <= STATE_IDLE;
		end

		case (state)
		
		
		
			// [2D 00 10]
			PID_SETUP_WAIT: // waiting for a PID SETUP packet
			begin

				
				if (indata == 8'h2D)
					state <= PID_SETUP_DETECT_ADDRESS;
				else
					state <= PID_SETUP_WAIT;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			PID_SETUP_DETECT_ADDRESS:
			begin
				// check if the message is directed at this device
				if (indata == 8'h00)
				begin					
					state <= PID_SETUP_DETECT_CRC;
				end
				else
					state <= PID_SETUP_DETECT_ADDRESS;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			PID_SETUP_DETECT_CRC:
			begin
				state <= PID_DATA_WAIT; // wait for a data packet
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
		
		
		
		
			PID_DATA_WAIT:
			begin
				
				// 0xC3 == PID DATA 0
				if (indata == 8'hC3) // this is PID DATA 0. It is followed by the entire request payload
				begin
					state <= PARSE_REQUEST;
				end
				// I think the host will never send DATA 1 since the device needs to answer with DATA 1 !!!
				else
					state <= PID_DATA_WAIT;
					
				outdata <= 8'h00;
				STP <= 1'b0;
			end
		
			PARSE_REQUEST:
			begin
				
				if (indata == 8'h80)
					begin					
						state <= DEVICE_DESCRIPTOR_REQUEST;
						dev_desc_idx <= 8'h00;
					end
				else if (indata == 8'h00)
					begin					
						state <= SET_ADDRESS_REQUEST;
						dev_desc_idx <= 8'h00;
					end
				else
					begin
						state <= PARSE_REQUEST;
					end
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			// <C3> [00 05 03 00 00 00 00 00] <EA 7C>
			SET_ADDRESS_REQUEST:
			begin
				
				if ((dev_desc_idx == 8'h00) && (indata == 8'h05)) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h01) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h02) && (indata == 8'h00)) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h03) && (indata == 8'h00)) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h04) && (indata == 8'h00)) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h05) && (indata == 8'h00)) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h06) && (indata == 8'h00)) begin
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h07) begin
					// CRC 1
					state <= SET_ADDRESS_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h08) begin
					// CRC 2
					state <= SET_ADDRESS_SEND_ACK_1;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
		
			// 80 06 00 01 00 00 40 00 <DD 94>
			DEVICE_DESCRIPTOR_REQUEST:
			begin

				
				if ((dev_desc_idx == 8'h00) && (indata == 8'h06)) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h01) && (indata == 8'h00)) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h02) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h03) && (indata == 8'h00)) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h04) && (indata == 8'h00)) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				//else if ((dev_desc_idx == 8'h05) && (indata == 8'h40)) begin
				else if (dev_desc_idx == 8'h05) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if ((dev_desc_idx == 8'h06) && (indata == 8'h00)) begin
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h07)	begin
					// CRC 1
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h08)	begin
					// CRC 2
					state <= DEVICE_DESCRIPTOR_REQUEST;
					dev_desc_idx <= dev_desc_idx + 8'h01;
				end
				else if (dev_desc_idx == 8'h09)	begin
					// DONE
					state <= DEVICE_DESCRIPTOR_SEND_ACK;
					dev_desc_idx <= dev_desc_idx + 8'h00;
				end
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			
			
			
			
			

			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			SET_ADDRESS_SEND_ACK_1:
			begin

			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= SET_ADDRESS_SEND_ACK_1; // remain
				end
				else 
				begin
					outdata <= 8'h42; // ack
					STP <= 8'h00;
					
					state <= SET_ADDRESS_SEND_ACK_2;
				end				
			end			
			SET_ADDRESS_SEND_ACK_2:
			begin


				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SET_ADDRESS_SEND_ACK_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= SET_ADDRESS_SEND_ACK_3;
					end
					else 
						state <= state;
			end			
			SET_ADDRESS_SEND_ACK_3:
			begin


				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= SET_ADDRESS_PID_IN_WAIT;
			end
			
			
			
			
			
			
			// here, the host wants to receive the device address so it sends a PID IN to the device
			// [69 00 CRC] 
			SET_ADDRESS_PID_IN_WAIT:
			begin

				
				if (indata == 8'h69)
				begin
					state <= SET_ADDRESS_PID_IN_DETECT_ADDRESS;
				end
				// I think the host will never send DATA 1 since the device needs to answer with DATA 1 !!!
				else
					state <= SET_ADDRESS_PID_IN_WAIT;
					
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			SET_ADDRESS_PID_IN_DETECT_ADDRESS:
			begin				
				if (indata == 8'h00)
				begin
					state <= SET_ADDRESS_PID_IN_DETECT_CRC;
				end
				else
					state <= SET_ADDRESS_PID_IN_DETECT_ADDRESS;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			SET_ADDRESS_PID_IN_DETECT_CRC:
			begin

				
				state <= MSG_DEV_SEND_OLD_ADDRESS; // wait for a data packet
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			
			MSG_DEV_SEND_OLD_ADDRESS:
			begin

				
				state <= MSG_DEV_SEND_OLD_ADDRESS_1;
			
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			
			
			
			//
			// SEND old address
			//
			
			MSG_DEV_SEND_OLD_ADDRESS_1:
			begin

				
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_SEND_OLD_ADDRESS_1; // remain
				end
				else 
				begin
					// 0x4B == 01 00 1011
					outdata <= 8'h4B; // <[4B] 12 01 00 02 FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
					STP <= 1'b0;					
					//state <= MSG_DEV_SEND_OLD_ADDRESS_2; // next state
					state <= MSG_DEV_SEND_OLD_ADDRESS_4; // directly send CRC
				end		
			end
			MSG_DEV_SEND_OLD_ADDRESS_4:
			begin
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_SEND_OLD_ADDRESS_4; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// CRC 1
						//outdata <= 8'hFE;
						outdata <= 8'h00;
						STP <= 1'b0;					
						state <= MSG_DEV_SEND_OLD_ADDRESS_5; // next state
					end
					else 
						state <= state;
				end						
			end
			MSG_DEV_SEND_OLD_ADDRESS_5:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_SEND_OLD_ADDRESS_5; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// CRC 2
						//outdata <= 8'h4F;
						outdata <= 8'h00;
						STP <= 1'b0;					
						state <= MSG_DEV_SEND_OLD_ADDRESS_6; // next state
					end
					else 
						state <= state;
				end						
			end
			
			// SET STOP BIT
			MSG_DEV_SEND_OLD_ADDRESS_6:
			begin

				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_SEND_OLD_ADDRESS_6;
				else 
					if (NXT == 1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;						
						state <= MSG_DEV_SEND_OLD_ADDRESS_7;
					end
					else 
						state <= MSG_DEV_SEND_OLD_ADDRESS_6;
			end
			
			// REMOVE the stop bit
			MSG_DEV_SEND_OLD_ADDRESS_7:
			begin		
				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= MSG_DEV_SEND_OLD_ADDRESS_WAIT_HOST_ACK;
			end
			
			
			
			MSG_DEV_SEND_OLD_ADDRESS_WAIT_HOST_ACK:
			begin
				if (indata == 8'hD2) begin
					state <= PID_SETUP_WAIT;
				end else begin
					state <= MSG_DEV_SEND_OLD_ADDRESS_WAIT_HOST_ACK;
				end
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			
			
			
			
			
			DEVICE_DESCRIPTOR_SEND_ACK:
			begin
				state <= DEVICE_DESCRIPTOR_SEND_ACK_1;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			DEVICE_DESCRIPTOR_SEND_ACK_1:
			begin
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= DEVICE_DESCRIPTOR_SEND_ACK_1; // remain
				end
				else 
				begin
					outdata <= 8'h42; // ack
					STP <= 8'h00;
					
					state <= DEVICE_DESCRIPTOR_SEND_ACK_2;
				end				
			end			
			DEVICE_DESCRIPTOR_SEND_ACK_2:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= DEVICE_DESCRIPTOR_SEND_ACK_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= DEVICE_DESCRIPTOR_SEND_ACK_3;
					end
					else 
						state <= state;
			end			
			DEVICE_DESCRIPTOR_SEND_ACK_3:
			begin
				outdata <= 8'h00;
				STP <= 1'b0;
				
				//state <= DEVICE_DESCRIPTOR_SEND_ACK_3;
				state <= DEVICE_DESCRIPTOR_PID_IN_WAIT;
			end
			
			// here, the host wants to receive the device descriptor so it sends a PID IN to the device
			// [69 00 CRC] 
			DEVICE_DESCRIPTOR_PID_IN_WAIT:
			begin
				if (indata == 8'h69)
				begin
					state <= DEVICE_DESCRIPTOR_PID_IN_DETECT_ADDRESS;
				end
				// I think the host will never send DATA 1 since the device needs to answer with DATA 1 !!!
				else
					state <= DEVICE_DESCRIPTOR_PID_IN_WAIT;
					
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			DEVICE_DESCRIPTOR_PID_IN_DETECT_ADDRESS:
			begin
				
				if (indata == 8'h00)
				begin
					state <= DEVICE_DESCRIPTOR_PID_IN_DETECT_CRC;
				end
				else
					state <= DEVICE_DESCRIPTOR_PID_IN_DETECT_ADDRESS;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			DEVICE_DESCRIPTOR_PID_IN_DETECT_CRC:
			begin
	
				
				state <= MSG_DEV_DESC_17; // wait for a data packet
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end
			
			
			
			
			
			
			
			
			
			
			//
			// SEND device descriptor
			//
			
			MSG_DEV_DESC_17:
			begin			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= MSG_DEV_DESC_17; // remain
				end
				else 
				begin
					// 0x4B == 01 00 1011
					outdata <= 8'h4B; // <[4B] 12 01 00 02 FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
					STP <= 1'b0;					
					state <= MSG_DEV_DESC_18; // next state
				end		
			end
			MSG_DEV_DESC_18:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_18; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// length of descriptor
						outdata <= 8'h12; // <4B [12] 01 00 02 FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_19; // next state
					end
					else 
						state <= state;
				end				
			end
			MSG_DEV_DESC_19:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_19; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// descriptor type 
						outdata <= 8'h01; // <4B 12 [01] 00 02 FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_20; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_20:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_20; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// usb version
						//outdata <= 8'h00; // <4B 12 01 [00] 02 FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						outdata <= 8'h10; // <4B 12 01 [10] 02 FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_21; // next state
					end
					else 
						state <= state;
				end						
			end
			MSG_DEV_DESC_21:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_21; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// usb version
						
						//outdata <= 8'h02; // <4B 12 01 00 [02] FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						outdata <= 8'h01; // <4B 12 01 10 [01] FF FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_22; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_22:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_22; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// device Class
						
						//outdata <= 8'hFF; // <4B 12 01 00 02 [FF] FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						outdata <= 8'h00;   // <4B 12 01 10 01 [00] FF FF 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_23; // next state
					end
					else 
						state <= state;
				end				
			end
			MSG_DEV_DESC_23:
			begin
			
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_23; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// device subclass
						
						//outdata <= 8'hFF;  // <4B 12 01 00 02 FF [FF] FF 40 DE AD BE EF 01 00 00 00 00 01>
						outdata <= 8'h00;		// <4B 12 01 10 01 00 [00] FF 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_24; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_24:
			begin
		
				// Wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_24; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// device protocol
						//outdata <= 8'hFF; 	// <4B 12 01 00 02 FF FF [FF] 40 DE AD BE EF 01 00 00 00 00 01>
						outdata <= 8'h00;		// <4B 12 01 10 01 00 00 [00] 40 DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_25; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_25:
			begin
			
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
						outdata <= 8'h40; 	// <4B 12 01 00 02 FF FF FF [40] DE AD BE EF 01 00 00 00 00 01>
						STP <= 1'b0;			// <4B 12 01 10 01 00 00 00 [40] DE AD BE EF 01 00 00 00 00 01>

						state <= MSG_DEV_DESC_26;
					end
					else 
						state <= state;
				end					
			end

			MSG_DEV_DESC_26:
			begin
	
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_26; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// id vendor 1
						//outdata <= 8'hDE; 	// <4B 12 01 00 02 FF FF FF 40 [DE] AD BE EF 01 00 00 00 00 01>
						outdata <= 8'hC4;		// <4B 12 01 10 01 00 00 00 40 [C4] 10 60 EA 00 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_27; // next state
					end
					else 
						state <= state;
				end			
			end			
			MSG_DEV_DESC_27:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_27; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// id vendor 2
						//outdata <= 8'hAD; 	// <4B 12 01 00 02 FF FF FF 40 DE [AD] BE EF 01 00 00 00 00 01>
						outdata <= 8'h10; 	// <4B 12 01 10 01 00 00 00 40 C4 [10] 60 EA 00 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_28; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_28:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_28; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// id product 1
						//outdata <= 8'hBE; 	// <4B 12 01 00 02 FF FF FF 40 DE AD [BE] EF 01 00 00 00 00 01>
						outdata <= 8'h60;		// <4B 12 01 10 01 00 00 00 40 C4 10 [60] EA 00 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_29; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_29:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_29; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// id product 2
						//outdata <= 8'hEF; 	// <4B 12 01 00 02 FF FF FF 40 DE AD BE [EF] 01 00 00 00 00 01>
						outdata <= 8'hEA;		// <4B 12 01 10 01 00 00 00 40 C4 10 60 [EA] 00 00 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_30; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_30:
			begin
		
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_30; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// bcdDevice (1/2)
						outdata <= 8'h00; // <4B 12 01 10 01 00 00 00 40 C4 10 60 EA [00] 00 00 00 00 01>
						STP <= 1'b0;	
						state <= MSG_DEV_DESC_31; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_31:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_31; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// bcdDevice (2/2)
						outdata <= 8'h01; // <4B 12 01 10 01 00 00 00 40 C4 10 60 EA 00 [01] 00 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_32; // next state
					end
					else 
						state <= state;
				end					
			end			
			MSG_DEV_DESC_32:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_32; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// string descriptor 1
						outdata <= 8'h00; // <4B 12 01 10 01 00 00 00 40 C4 10 60 EA 00 01 [00] 00 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_33; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_33:
			begin			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_33; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// string descriptor 2
						outdata <= 8'h00; // <4B 12 01 10 01 00 00 00 40 C4 10 60 EA 00 01 00 [00] 00 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_34; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_34:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_34; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// string descriptor 3
						outdata <= 8'h00; // <4B 12 01 10 01 00 00 00 40 C4 10 60 EA 00 01 00 00 [00] 01>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_35; // next state
					end
					else 
						state <= state;
				end					
			end
			MSG_DEV_DESC_35:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_35; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// bNumConfigurations
						outdata <= 8'h01; // <4B 12 01 10 01 00 00 00 40 C4 10 60 EA 00 01 00 00 00 [01]>
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_36; // next state
					end
					else 
						state <= state;
				end					
			end


			MSG_DEV_DESC_36:
			begin			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_36; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// CRC 1
						//outdata <= 8'hC0; // <4B 12 01 00 02 FF FF FF 08 33 16> THE CRC IS PROVIDED IN REVERSE!!!! 16 first
						outdata <= 8'hDB;
						
						// for the first eight byte only
						//outdata <= 8'h11;
						
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_37; // next state
					end
					else 
						state <= state;
				end
			end
			MSG_DEV_DESC_37:
			begin
			
				// wait for the line to be free
				if (DIR == 1)
				begin
					state <= MSG_DEV_DESC_37; // remain
				end
				else 
				begin
					if (NXT == 1)
					begin
						// CRC 2
						//outdata <= 8'hCE; // <4B 12 01 00 02 FF FF FF 08 33 16> THE CRC IS PROVIDED IN REVERSE!!!! 33 last
						outdata <= 8'h34;
						
						// for the first eight byte only
						//outdata <= 8'h41;
						
						STP <= 1'b0;					
						state <= MSG_DEV_DESC_38; // next state
					end
					else 
						state <= state;
				end			
			end


			// SET STOP BIT
			MSG_DEV_DESC_38:
			begin

				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1)
					state <= MSG_DEV_DESC_38;
				else 
					if (NXT == 1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;						
						state <= MSG_DEV_DESC_39;
					end
					else 
						state <= MSG_DEV_DESC_38;
			end
			
			// REMOVE the stop bit
			MSG_DEV_DESC_39:
			begin
		
				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_ACK;
			end
			
			
			
			DEVICE_DESCRIPTOR_8_WAIT_HOST_ACK:
			begin

				state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT;
			end
			
			// OUT PACKET is COMPLETELY IGNORED!!!!!
			
			// [4B 00 00]
			DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT: // THIS WILL NOT PROCESS OUT BUT DATA1 FROM THE HOST!
			begin				
				if (indata == 8'h4B)
					state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_ADDR;
				else
					state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_ADDR:
			begin				
				// check if the message is directed at this device
				//if (indata == 8'h00)
				//begin
					state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_CRC;
				//end
				//else
				//	state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_ADDR;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_CRC:
			begin			
				state <= DEVICE_DESCRIPTOR_8_SEND_ACK_1; // wait for a data packet
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			
			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			DEVICE_DESCRIPTOR_8_SEND_ACK_1:
			begin

			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= DEVICE_DESCRIPTOR_8_SEND_ACK_1; // remain
				end
				else 
				begin
					outdata <= 8'h42; // ack
					STP <= 8'h00;
					
					state <= DEVICE_DESCRIPTOR_8_SEND_ACK_2;
				end				
			end			
			DEVICE_DESCRIPTOR_8_SEND_ACK_2:
			begin


				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= DEVICE_DESCRIPTOR_8_SEND_ACK_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= DEVICE_DESCRIPTOR_8_SEND_ACK_3;
					end
					else 
						state <= state;
			end			
			DEVICE_DESCRIPTOR_8_SEND_ACK_3:
			begin


				outdata <= 8'h00;
				STP <= 1'b0;
				
				//state <= DEVICE_DESCRIPTOR_SEND_ACK_3;
				//state <= DEVICE_DESCRIPTOR_PID_IN_WAIT;
				state <= PID_SETUP_WAIT;
			end
			
			
			//TODO: send 8 byte of device descriptor
			
		
		
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
	localparam MSG_DEV_DESC_14		= 8'd34; // PID IN detection starts here
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
	
	localparam MSG_DEV_DESC_70		= 8'd90;
	localparam MSG_DEV_DESC_71		= 8'd91;
	localparam MSG_DEV_DESC_72		= 8'd92;
	localparam MSG_DEV_DESC_73		= 8'd93;
	localparam MSG_DEV_DESC_74		= 8'd94;
	localparam MSG_DEV_DESC_75		= 8'd95;
	localparam MSG_DEV_DESC_76		= 8'd96;
	localparam MSG_DEV_DESC_77		= 8'd97;
	localparam MSG_DEV_DESC_78		= 8'd98;
	localparam MSG_DEV_DESC_79		= 8'd99;
	
	localparam MSG_DEV_DESC_80		= 8'd100;
	localparam MSG_DEV_DESC_81		= 8'd101;
	localparam MSG_DEV_DESC_82		= 8'd102;
	localparam MSG_DEV_DESC_83		= 8'd103;
	localparam MSG_DEV_DESC_84		= 8'd104;
	localparam MSG_DEV_DESC_85		= 8'd105;
	localparam MSG_DEV_DESC_86		= 8'd106;
	localparam MSG_DEV_DESC_87		= 8'd107;
	localparam MSG_DEV_DESC_88		= 8'd108;
	localparam MSG_DEV_DESC_89		= 8'd109;
	
	localparam MSG_DEV_DESC_90		= 8'd110;
	localparam MSG_DEV_DESC_91		= 8'd111;
	localparam MSG_DEV_DESC_92		= 8'd112;
	localparam MSG_DEV_DESC_93		= 8'd113;
	localparam MSG_DEV_DESC_94		= 8'd114;
	localparam MSG_DEV_DESC_95		= 8'd115;
	localparam MSG_DEV_DESC_96		= 8'd116;
	localparam MSG_DEV_DESC_97		= 8'd117;
	localparam MSG_DEV_DESC_98		= 8'd118;
	localparam MSG_DEV_DESC_99		= 8'd119;
	
	localparam MSG_DEV_DESC_100		= 8'd120;
	localparam MSG_DEV_DESC_101		= 8'd121;
	localparam MSG_DEV_DESC_102		= 8'd122;
	localparam MSG_DEV_DESC_103		= 8'd123;
	localparam MSG_DEV_DESC_104		= 8'd124;
	localparam MSG_DEV_DESC_105		= 8'd125;
	localparam MSG_DEV_DESC_106		= 8'd126;
	localparam MSG_DEV_DESC_107		= 8'd127;
	localparam MSG_DEV_DESC_108		= 8'd128;
	localparam MSG_DEV_DESC_109		= 8'd129;	
	
	localparam PID_SETUP_WAIT				= 8'd150;
	localparam PID_SETUP_DETECT_ADDRESS = 8'd151;
	localparam PID_SETUP_DETECT_CRC 		= 8'd152;
	
	localparam PID_DATA_WAIT			= 8'd160;
	localparam PARSE_REQUEST			= 8'd161;
	localparam DEVICE_DESCRIPTOR_REQUEST = 8'd162;
	localparam DEVICE_DESCRIPTOR_SEND_ACK = 8'd163;
	
	localparam DEVICE_DESCRIPTOR_SEND_ACK_1 = 8'd164;
	localparam DEVICE_DESCRIPTOR_SEND_ACK_2 = 8'd165;
	localparam DEVICE_DESCRIPTOR_SEND_ACK_3 = 8'd166;
	
	localparam DEVICE_DESCRIPTOR_PID_IN_WAIT 				= 8'd167;
	localparam DEVICE_DESCRIPTOR_PID_IN_DETECT_ADDRESS = 8'd168;
	localparam DEVICE_DESCRIPTOR_PID_IN_DETECT_CRC 		= 8'd169;
	localparam DEVICE_DESC_8_SEND 							= 8'd170;
	localparam DEVICE_DESC_8_RESPONSE 						= 8'd171;
	localparam DEVICE_DESC_8_STOP 							= 8'd172; 
	localparam DEVICE_DESC_8_RESUME 							= 8'd173;
	localparam DEVICE_DESCRIPTOR_8_WAIT_HOST_ACK 		= 8'd174;
	
	localparam DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT 			= 8'd175;
	localparam DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_ADDR		= 8'd176;
	localparam DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_CRC		= 8'd177;
	
	localparam DEVICE_DESCRIPTOR_8_SEND_ACK_1				= 8'd178;
	localparam DEVICE_DESCRIPTOR_8_SEND_ACK_2				= 8'd179;
	localparam DEVICE_DESCRIPTOR_8_SEND_ACK_3				= 8'd180;
	
	localparam SET_ADDRESS_REQUEST							= 8'd181;
	localparam SET_ADDRESS_SEND_ACK							= 8'd182;
	localparam SET_ADDRESS_SEND_ACK_1						= 8'd183;
	localparam SET_ADDRESS_SEND_ACK_2						= 8'd184;
	localparam SET_ADDRESS_SEND_ACK_3						= 8'd185;
	
	localparam SET_ADDRESS_PID_IN_WAIT						= 8'd186;
	localparam SET_ADDRESS_PID_IN_DETECT_ADDRESS			= 8'd187;
	localparam SET_ADDRESS_PID_IN_DETECT_CRC				= 8'd188;
	
	localparam MSG_DEV_SEND_OLD_ADDRESS						= 8'd189;
	localparam MSG_DEV_SEND_OLD_ADDRESS_1					= 8'd190;
	localparam MSG_DEV_SEND_OLD_ADDRESS_2					= 8'd191;
	localparam MSG_DEV_SEND_OLD_ADDRESS_3					= 8'd192;
	localparam MSG_DEV_SEND_OLD_ADDRESS_4					= 8'd193;
	localparam MSG_DEV_SEND_OLD_ADDRESS_5					= 8'd194;
	localparam MSG_DEV_SEND_OLD_ADDRESS_6					= 8'd195;
	localparam MSG_DEV_SEND_OLD_ADDRESS_7					= 8'd196;
	
	localparam MSG_DEV_SEND_OLD_ADDRESS_WAIT_HOST_ACK 	= 8'd197;
	
	localparam MSG_DEV_DESC_CENTER		= 8'hFE;
	
	localparam STATE_IDLE 			= 8'd255;
	
endmodule