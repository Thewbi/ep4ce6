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
	reg [7:0] recv_byte [0:15];
	reg recv_ready;
	
	reg [7:0] tx_len;	
	reg [7:0] tx_byte [0:64];
	reg tx_ready;
	reg [7:0] tx_transmitted;
	
	reg no_out;
	
	
	always @(posedge clk)	
	begin
	
		if (recv_ready == 1'b1)
		begin
			//led <= ~idx; // [L1 L2 L3 L4]			
			
			// GetDescriptor (1) -- DeviceDescriptor
			// REQUEST: 80 06 00 01 00 00 40 00
			if (
				(recv_byte[0] == 8'h80) &&
				(recv_byte[1] == 8'h06) &&
				(recv_byte[3] == 8'h01)
			)
			begin
			
				led <= ~4'b1111;
				
				// RESPONSE
				// 4B -- 12 01 10 01 00 00 00 40 C4 10 60 EA 00 01 00 00 00 01 -- DB 34
				
				// DATA 1
				tx_byte[0] = 8'h4B;
				
				// PAYLOAD
				tx_byte[1] = 8'h12;
				tx_byte[2] = 8'h01;
				tx_byte[3] = 8'h10;
				tx_byte[4] = 8'h01;
				tx_byte[5] = 8'h00;
				tx_byte[6] = 8'h00;
				tx_byte[7] = 8'h00;
				tx_byte[8] = 8'h40;
				tx_byte[9] = 8'hC4;
				tx_byte[10] = 8'h10;
				tx_byte[11] = 8'h60;
				tx_byte[12] = 8'hEA;
				tx_byte[13] = 8'h00;
				tx_byte[14] = 8'h01;
				tx_byte[15] = 8'h00;
				tx_byte[16] = 8'h00;
				tx_byte[17] = 8'h00;
				tx_byte[18] = 8'h01;
				
				// CRC16
				tx_byte[19] = 8'hDB;
				tx_byte[20] = 8'h34;
				
				tx_len = 8'd21; // size(PID DATA 1) + size(PAYLOAD) + size(CRC16) = 1 + 18 + 2 = 21
				
				tx_ready = 1;
				
				// this transaction contains an OUT part
				no_out = 0;
				
			end
			
			
			// GetDescriptor (2) -- ConfigurationDescriptor -- (SHORT RESPONSE VERSION)
			// REQUEST: 80 06 00 02 00 00 20 00
			if (
				(recv_byte[0] == 8'h80) &&
				(recv_byte[1] == 8'h06) &&
				(recv_byte[3] == 8'h02) &&
				(recv_byte[6] == 8'h20)
			)
			begin
			
				led <= ~4'b1111;
				
				// RESPONSE
				// 4B -- 09 02 20 00 01 01 00 80 32 -- E3 6D
				
				// DATA 1
				tx_byte[0] = 8'h4B;
				
				// PAYLOAD
				tx_byte[1] = 8'h09;
				tx_byte[2] = 8'h02;
				tx_byte[3] = 8'h20;
				tx_byte[4] = 8'h00;
				tx_byte[5] = 8'h01;
				tx_byte[6] = 8'h01;
				tx_byte[7] = 8'h00;
				tx_byte[8] = 8'h80;
				tx_byte[9] = 8'h32;
				
				// CRC16
				tx_byte[10] = 8'hE3;
				tx_byte[11] = 8'h6D;
				
				tx_len = 8'd12; // size(PID DATA 1) + size(PAYLOAD) + size(CRC16) = 1 + 9 + 2 = 12
				
				tx_ready = 1;
				
				// this transaction contains an OUT part
				no_out = 0;
				
			end
			
			// GetDescriptor (2) -- ConfigurationDescriptor (LONG RESPONSE VERSION)
			// REQUEST: 80 06 00 02 00 00 FF 00
			if (
				(recv_byte[0] == 8'h80) &&
				(recv_byte[1] == 8'h06) &&
				(recv_byte[3] == 8'h02) &&
				(recv_byte[6] == 8'hFF)
			)
			begin
			
				led <= ~4'b1111;
				
				// RESPONSE
				// 4B -- 09 02 20 00 01 01 00 80 32 -- E3 6D
				
				// DATA 1
				tx_byte[0] = 8'h4B;
				
				// PAYLOAD
				// 09 02 20 00 01 01 00 80 32 09 04 00 00 02 FF 00 00 02 07 05 81 02 40 00 00 07 05 01 02 40 00 00 <FE 64>
				tx_byte[1] = 8'h09;
				tx_byte[2] = 8'h02;
				tx_byte[3] = 8'h20;
				tx_byte[4] = 8'h00;
				// 01 01 00 80
				tx_byte[5] = 8'h01;
				tx_byte[6] = 8'h01;
				tx_byte[7] = 8'h00;
				tx_byte[8] = 8'h80;
				// 32 09 04 00
				tx_byte[9] = 8'h32;
				tx_byte[10] = 8'h09;
				tx_byte[11] = 8'h04;
				tx_byte[12] = 8'h00;
				// 00 02 FF 00
				tx_byte[13] = 8'h00;
				tx_byte[14] = 8'h02;
				tx_byte[15] = 8'hFF;
				tx_byte[16] = 8'h00;
				// 00 02 07 05
				tx_byte[17] = 8'h00;
				tx_byte[18] = 8'h02;
				tx_byte[19] = 8'h07;
				tx_byte[20] = 8'h05;
				// 81 02 40 00
				tx_byte[21] = 8'h81;
				tx_byte[22] = 8'h02;
				tx_byte[23] = 8'h40;
				tx_byte[24] = 8'h00;
				// 00 07 05 01
				tx_byte[25] = 8'h00;
				tx_byte[26] = 8'h07;
				tx_byte[27] = 8'h05;
				tx_byte[28] = 8'h01;
				// 02 40 00 00
				tx_byte[29] = 8'h02;
				tx_byte[30] = 8'h40;
				tx_byte[31] = 8'h00;
				tx_byte[32] = 8'h00;
				
				// CRC16
				tx_byte[33] = 8'hFE;
				tx_byte[34] = 8'h64;
				
				tx_len = 8'd35; // size(PID DATA 1) + size(PAYLOAD) + size(CRC16) = 1 + 32 + 2 = 35
				
				tx_ready = 1;
				
				// this transaction contains an OUT part
				no_out = 0;
				
			end
			
			
			// REQUEST: 
			// RESPONSE: 09 02 20 00 01 01 00 80 32 09 04 00 00 02 FF 00 00 02 07 05 81 02 40 00 00 07 05 01 02 40 00 00 <FE 64>
			
			
			// REQUEST: Set Address (00 05 03 00 00 00 00 00) 
			else if (
				(recv_byte[0] == 8'h00) &&
				(recv_byte[1] == 8'h05)
			)
			begin
			
				// DATA 1
				tx_byte[0] = 8'h4B;
				
				// CRC16
				tx_byte[1] = 8'h00;
				tx_byte[2] = 8'h00;
				
				tx_len = 8'd3; // size(PID DATA 1) + size(PAYLOAD) + size(CRC16) = 1 + 0 + 2 = 3
				 
				tx_ready = 1;
				
				// this transaction DOES NOT contain an OUT part
				no_out = 1;
				
			end
			
		end
		else
		begin
			led <= ~4'b0000;
			tx_ready = 0;
		end
	end
	
	
	
	
	
	
	
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
				idx <= 4'b0000;
//				led <= ~4'b0000;

				recv_ready <= 1'b0;
				
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
				//if (DIR || NXT)
				
				if (DIR)
				begin
					if (NXT)
					begin
						idx <= idx + 4'b0001;			// [L1 L2 L3 L4]
						//idx <= 4'b0001; 				// [L1 L2 L3 L4]
						
						recv_byte[idx] <= indata;
						
						state <= STORE_REQUEST;
					end
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
				if (tx_ready)
				begin					
					state <= SEND_RESPONSE_1;
				end
				else
				begin
					state <= SEND_NACK_1;
				end
				
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
//					led <= ~idx; // [L1 L2 L3 L4]
					recv_ready <= 1'b1;
					
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
			// SEND RESPONSE
			//
			
			SEND_RESPONSE_1:
			begin			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= SEND_RESPONSE_1; // remain
				end
				else 
				begin
					outdata <= tx_byte[0];
					STP <= 8'h00;
					state <= SEND_RESPONSE_2;
				end				
			end
			SEND_RESPONSE_2:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[1];
						STP <= 1'b0;
						state <= SEND_RESPONSE_3;
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_3:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_3; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[2];
						STP <= 1'b0;
						
						if (tx_len == 3)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_4;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_4:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_4; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[3];
						STP <= 1'b0;
						
						if (tx_len == 4)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_5;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_5:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_5; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[4];
						STP <= 1'b0;
						
						if (tx_len == 5)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_6;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_6:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_6; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[5];
						STP <= 1'b0;
						
						if (tx_len == 6)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_7;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_7:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_7; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[6];
						STP <= 1'b0;
						
						if (tx_len == 7)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_8;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_8:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_8; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[7];
						STP <= 1'b0;
						
						if (tx_len == 8)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_9;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_9:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_9; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[8];
						STP <= 1'b0;
						
						if (tx_len == 9)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_10;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_10:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_10; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[9];
						STP <= 1'b0;
						
						if (tx_len == 10)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_11;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_11:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_11; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[10];
						STP <= 1'b0;
						
						if (tx_len == 11)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_12;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_12:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_12; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[11];
						STP <= 1'b0;
						
						if (tx_len == 12)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_13;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_13:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_13; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[12];
						STP <= 1'b0;
						
						if (tx_len == 13)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_14;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_14:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_14; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[13];
						STP <= 1'b0;
						
						if (tx_len == 14)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_15;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_15:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_15; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[14];
						STP <= 1'b0;
						
						if (tx_len == 15)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_16;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_16:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_16; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[15];
						STP <= 1'b0;
						
						if (tx_len == 16)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_17;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_17:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_17; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[16];
						STP <= 1'b0;
						
						if (tx_len == 17)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_18;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_18:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_18; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[17];
						STP <= 1'b0;
						
						if (tx_len == 18)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_19;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_19:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_19; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[18];
						STP <= 1'b0;
						
						if (tx_len == 19)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_20;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_20:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_20; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[19];
						STP <= 1'b0;
						
						if (tx_len == 20)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_21;
						end
						
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_21:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_21; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= tx_byte[20];
						STP <= 1'b0;
						
						if (tx_len == 21)
						begin
							state <= SEND_RESPONSE_STOP_1;
						end
						else
						begin
							state <= SEND_RESPONSE_22;
						end
						
					end
					else 
						state <= state;
			end

			SEND_RESPONSE_STOP_1:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_RESPONSE_STOP_1; // remain
				else 
					if (NXT == 1'b1)
					begin
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= SEND_RESPONSE_STOP_2;
					end
					else 
						state <= state;
			end
			SEND_RESPONSE_STOP_2:
			begin
				outdata <= 8'h00;
				STP <= 1'b0;
				
				// perform the OUT part of a transaction or not
				if (no_out == 1'b1)
				begin
					// The SetAddress request does not terminate the transaction with a OUT part!
					// In that case return to the next SETUP PID immediately
					state <= PID_SETUP_WAIT;
				end
				else
				begin
					state <= OUT_WAIT_HOST_ACK;
				end
			end
			
			
			
			
			
			
			OUT_WAIT_HOST_ACK:
			begin
				state <= OUT_WAIT_HOST_PID;
			end
			
			// OUT PACKET is COMPLETELY IGNORED!!!!!
			
			// [4B 00 00]
			OUT_WAIT_HOST_PID: // THIS WILL NOT PROCESS OUT BUT DATA1 FROM THE HOST!
			begin				
				if (indata == 8'h4B)
					state <= OUT_WAIT_HOST_PID_ADDR;
				else
					state <= OUT_WAIT_HOST_PID;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			OUT_WAIT_HOST_PID_ADDR:
			begin				
				// check if the message is directed at this device
				//if (indata == 8'h00)
				//begin
					state <= OUT_WAIT_HOST_PID_CRC;
				//end
				//else
				//	state <= DEVICE_DESCRIPTOR_8_WAIT_HOST_PID_OUT_ADDR;
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end			
			OUT_WAIT_HOST_PID_CRC:
			begin			
				state <= SEND_ACK_RESP_1; // wait for a data packet
				
				outdata <= 8'h00;
				STP <= 1'b0;
			end	
			
			//
			// SEND ACK
			//
			// Wait for the PHY to release the lines and send ACK (0x42)
			// The PHY will produce the SYNC pattern and the EOP for us!!! THANK YOU!
			//
			
			SEND_ACK_RESP_1:
			begin			
				// Wait for the line to be free
				if (DIR || NXT)
				begin
					state <= SEND_ACK_RESP_1; // remain
				end
				else 
				begin
					outdata <= 8'h42; // ack
					STP <= 8'h00;
					
					state <= SEND_ACK_RESP_2;
				end				
			end			
			SEND_ACK_RESP_2:
			begin
				// WAIT for the DIR to be low so the line is not used
				if (DIR == 1'b1)
					state <= SEND_ACK_RESP_2; // remain
				else 
					if (NXT == 1'b1)
					begin
						// tell the phy that the outgoing message is completely output
						outdata <= 8'h00;
						STP <= 1'b1;
						state <= SEND_ACK_RESP_3;
					end
					else 
						state <= state;
			end			
			SEND_ACK_RESP_3:
			begin
				outdata <= 8'h00;
				STP <= 1'b0;
				
				state <= PID_SETUP_WAIT;
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
	
	localparam SEND_RESPONSE_1 			= 8'd34;
	localparam SEND_RESPONSE_2				= 8'd35;
	localparam SEND_RESPONSE_3				= 8'd36;
	localparam SEND_RESPONSE_4				= 8'd37;
	localparam SEND_RESPONSE_5				= 8'd38;
	
	localparam SEND_RESPONSE_6 			= 8'd39;
	localparam SEND_RESPONSE_7				= 8'd40;
	localparam SEND_RESPONSE_8				= 8'd41;
	localparam SEND_RESPONSE_9				= 8'd42;
	localparam SEND_RESPONSE_10			= 8'd43;
	
	localparam SEND_RESPONSE_11 			= 8'd44;
	localparam SEND_RESPONSE_12			= 8'd45;
	localparam SEND_RESPONSE_13			= 8'd46;
	localparam SEND_RESPONSE_14			= 8'd47;
	localparam SEND_RESPONSE_15			= 8'd48;
	
	localparam SEND_RESPONSE_16 			= 8'd49;
	localparam SEND_RESPONSE_17			= 8'd50;
	localparam SEND_RESPONSE_18			= 8'd51;
	localparam SEND_RESPONSE_19			= 8'd52;
	localparam SEND_RESPONSE_20			= 8'd53;
	
	localparam SEND_RESPONSE_21			= 8'd54;
	localparam SEND_RESPONSE_22			= 8'd55;
	
	localparam OUT_WAIT_HOST_ACK			= 8'd56;
	localparam OUT_WAIT_HOST_PID			= 8'd57;
	localparam OUT_WAIT_HOST_PID_ADDR	= 8'd58;
	localparam OUT_WAIT_HOST_PID_CRC		= 8'd59;
	
	localparam SEND_ACK_RESP_1          = 8'd60;
	localparam SEND_ACK_RESP_2          = 8'd61;
	localparam SEND_ACK_RESP_3          = 8'd62;
	
	localparam SEND_RESPONSE_STOP_1		= 8'd70;
	localparam SEND_RESPONSE_STOP_2		= 8'd71;
	
	localparam STATE_IDLE 					= 8'd255;
	
endmodule