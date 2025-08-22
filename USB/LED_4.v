module LED_4(

	// clock and reset
	input reset,
	input clk, // 50 MHz (see https://www.waveshare.com/wiki/OpenEP4CE6-C_User_Manual#Clock_Circuit)
	
	// LEDs
	inout reg [3:0] led,
	
	// ULPI
	input  wire CLKOUT, // PIN 50
	input  wire DIR,    // PIN 52	
	output wire RST,    // PIN 46
	input wire NXT, // PIN 54
	output wire STP, // PIN 58

	/*
	inout wire DATA_0, // PIN 33
	inout wire DATA_1, // PIN 38
	inout wire DATA_2, // PIN 42
	inout wire DATA_3, // PIN 44
	inout wire DATA_4, // PIN 49
	inout wire DATA_5, // PIN 51
	inout wire DATA_6, // PIN 53
	inout wire DATA_7, // PIN 55
	*/
	inout reg[7:0] data,
	
	// UART
	output wire uart_tx_pin, // PIN 
	
	// test
	output wire TESTPIN

);

	wire uart_tx_data_valid;
	reg uart_tx_data_valid_reg;
	assign uart_tx_data_valid = uart_tx_data_valid_reg;
	
	reg stp_reg;
	assign STP = stp_reg;
	
	// initializing bytes here has no effect! It does not work!
	//reg[7:0] uart_tx_data = 8'b10101010; // 0xAA
	//reg[7:0] uart_tx_data = 8'hAA; // 8'hAA
	reg[7:0] uart_tx_data;
	
	wire uart_tx_active;	
	wire uart_tx_done;
	
	// for the UART transceiver module, the 50 Mhz Clock does not work!
	// The clock needs to be converted down! 10 MHz works!
	wire clk_10;
	Clock_divider #(.DIVISOR(28'd5)) clk_divider_10(clk, clk_10);
	
	wire clk_1_hz;
	Clock_divider #(.DIVISOR(28'd50000000)) clk_divider_1(clk, clk_1_hz);
	
	/*
	always @(posedge clk_1_hz)
	begin 
		led_reg[0] = ~led_reg[0];
		led[0] = led_reg[0];
	end
	*/
	
	//assign led = led_reg;

	transmitter uart_tx(
		.i_Clock(clk_10),
      .i_Tx_DV(uart_tx_data_valid),
		.i_Tx_Byte(uart_tx_data),
      .o_Tx_Active(uart_tx_active),
		.o_Tx_Serial(uart_tx_pin),
		.o_Tx_Done(uart_tx_done)
	);
	
	reg [31:0] counter;	
	reg [31:0] counter2;
	reg clk2;
	reg [7:0] i;	
	reg [3:0] led_reg;
	
	// when reset is asserted, the phy resets
	reg [31:0] reset_counter;
	reg reset_performed;
	reg RST_reg;
	assign RST = RST_reg;
	
	// for testing pins with an oscilloscope
	reg testpin_reg;
	assign TESTPIN = testpin_reg;
	
	/* Make ULPI DIR visible via LED 3 
	always @(posedge CLKOUT)
	begin
		if(!reset) 
		begin
			led[1] <= 1; // LED 3 (L3) (1 = off, 0 == on)
		end
		else
		begin		
			led[1] <= DIR; // LED 3 (L3) (1 = off, 0 == on). When the LED is off, DIR is 1 (HIGH)
		end
	end
	*/
	
	reg ulpi_register_read_reg;
	
	/* UPLI, Perform RESET */
	always @(posedge CLKOUT)
	begin
	
		if (!reset) 
		begin
			counter <= 32'd0;
			
			//led[0] <= 1; // L4 (1 = off, 0 == on)
			//led[1] <= 1; // L3 (1 = off, 0 == on)
			//led[2] <= 1; // L2 (1 = off, 0 == on)
			//led[3] <= 1; // L1 (1 = off, 0 == on)
			
			// ULPI data is set to ULPI idle (= 0x00)
			//data <= 8'd0;
			
			reset_performed <= 0; // no reset performed yet
			RST_reg <= 1; // assert the reset pin to trigger a reset
			
			ulpi_register_read_reg = 0;
			
			stp_reg = 0;
			
//			// UART
//			uart_tx_data_valid_reg <= 0;
//			uart_tx_data = 8'h00;
		end
		
		if (counter == 60000000)
		begin
		
			counter <= 0;
			
			//led <= ~led;
			//led[0] <= ~led[0];
			
			// YORO - you only reset once
			if (reset_performed == 0)
			begin
				reset_performed <= 1;
				
				// do not reset any more
				RST_reg <= 0;
				
				// ULPI data is set to ULPI idle (= 0x00)
				//data <= 8'd0;
				
				// start register read
				ulpi_register_read_reg = 1;
			end
			
//			// UART start transmission
//			uart_tx_data_valid_reg <= 1;		
//			uart_tx_data = 8'h00;
			
		end
		else
		begin			
			counter <= counter + 32'd1;
			
//			// UART disable transmission once done
//			if (uart_tx_done == 1) 
//			begin
//				uart_tx_data_valid_reg <= 0;
//			end
		end		
		
	end
	
	
	/* PIN Tester command 
	always @(posedge clk)
	begin
	
		if(!nrst) 
		begin
			counter2 <= 32'd0;
		end
			
		if (counter2 == 50000000)
		begin
			counter2 <= 0;
			
			// toggle the pin
			testpin_reg <= ~testpin_reg;
			
			// blink the LED
			led[0] <= ~led[0];
		end
		else
		begin			
			counter2 <= counter2 + 32'd1;
		end
		
	end
	*/
	
	/**/
	reg [2:0] cur_state;
	reg [2:0] next_state;
	localparam STATE_0 		= 3'b000;
	localparam STATE_1 		= 3'b001;
	localparam STATE_2 		= 3'b010;
	localparam STATE_3 		= 3'b011;
	localparam STATE_4 		= 3'b100;
	localparam STATE_5 		= 3'b101;
	localparam STATE_6 		= 3'b110;
	localparam IDLE 			= 3'b111;
	
	reg ss_started;
	reg [7:0] return_value;
	
	// apply next state
	always @(posedge CLKOUT or negedge reset) 
	begin	
		if (!reset) 
		begin
			cur_state = IDLE;
			//ss_started = 0;
		end
		else 
		begin
			cur_state = next_state;
		end
	end
	
	// combinational always block for next state logic
	always @(cur_state) 
	begin
	
		//if (!reset) 
		//begin
		//	ss_started = 0;
		//end
	
		// default next state assignment
		next_state = IDLE;

		case (cur_state)

			STATE_0: 
			begin
//				led_reg[0] = 1;
//				led_reg[1] = 0;
//				led_reg[2] = 1;
//				led_reg[3] = 1;


				if (DIR == 1)
				begin
					next_state = STATE_0;
				end
				else
				begin
					led_reg = ~4'h00;
					led = led_reg;

					// A ULPI READ is described by 11xxxxxx in binary. The xxxxxx contains the address. 
					// To read Vendor ID Low, the address is 0x00. So combining the CMD BITS with the address 
					// 0x00 yields 11000000b = 0xC0.
					// 11000000bin = 0xC0
					//data = 8'hC0; // vendor id low (ULPI register READ: address 0x00)
					data = 8'hC1; // vendor id high (ULPI register READ: address 0x01)
					
					// next state
					next_state = STATE_1;
				end
			end

			STATE_1:
			begin
//				led_reg[0] = 1;
//				led_reg[1] = 1;
//				led_reg[2] = 0;
//				led_reg[3] = 1;

				led_reg = ~4'h01;
				led = led_reg;
				
				// next state
				next_state = STATE_2;
			end
			
			STATE_2:
			begin			
//				led_reg[0] = 1;
//				led_reg[1] = 1;
//				led_reg[2] = 1;
//				led_reg[3] = 1;

				led_reg = ~4'h02;
				led = led_reg;
				
				data = 8'h00;
				
				// next state
				next_state = STATE_3;
			end
			
			STATE_3:
			begin
				data = 8'h00;
				
				led_reg = ~4'h03;
				led = led_reg;
				
				// next state
				if (DIR == 1)
				begin
					next_state = STATE_4;
				end
				else
				begin
					next_state = STATE_3;
				end
			end
			
			STATE_4:
			begin
				return_value = data;
				
				// UART
				uart_tx_data = data;
				uart_tx_data_valid_reg = 0;
				
				led_reg = ~4'h04;
				led = led_reg;
			
				// next state
				next_state = STATE_5;
			end
			
			STATE_5:
			begin			
				//uart_tx_data_valid_reg = 0;
			
				// UART
				uart_tx_data = return_value;
				uart_tx_data_valid_reg = 1;
			
				led_reg = ~4'h05;
				led = led_reg;
				
				// next state
				next_state = STATE_6;
			end
			
			STATE_6:
			begin
				led_reg = ~4'h06;
				led = led_reg;
				
				//uart_tx_data_valid_reg = 0;
				
//				// UART
//				uart_tx_data = return_value;
//				uart_tx_data_valid_reg = 1;
				
				// UART disable transmission once done
				if (uart_tx_done == 1) 
				begin
					uart_tx_data_valid_reg = 0;
				end
				
				// drive ULPI idle
				data = 8'h00;
			
				// next state
				next_state = STATE_6;
				
				//ss_started = 0;
			end
			
			IDLE: 
			begin
				//led_reg = ~4'h07;
				//led = led_reg;
				
				// next state
				if ((ulpi_register_read_reg == 1) )//&& (ss_started == 0)
				begin
					//ss_started = 1; // state machine is started, do not start it again
					next_state = STATE_0;
				end
			end
			
			default:
			begin				
				// next state
				next_state = IDLE; // Fallback to default state
			end
			
		 endcase

	end
	
	
	/* State machine test
	reg [2:0] cur_state;
	reg [2:0] next_state;
	localparam STATE_0 		= 3'b000;
	localparam STATE_1 		= 3'b001;
	localparam STATE_2 		= 3'b010;
	localparam STATE_3 		= 3'b011;
	localparam STATE_4 		= 3'b100;
	localparam STATE_5 		= 3'b101;
	localparam STATE_6 		= 3'b110;
	localparam IDLE 			= 3'b111;
	
	always @(posedge clk_1_hz or negedge reset) begin
	
		// If reset is asserted, go back to IDLE state
		if (!reset) 
		begin
			cur_state <= IDLE;
		end

		// else transition to the next state
		else 
		begin
			cur_state <= next_state;
		end
	end
	
	// Combinational always block for next state logic
	always @(cur_state) 
	begin
	
		// Default next state assignment
		next_state = IDLE;

		case (cur_state)
		
			IDLE: 
			begin
				led_reg[0] = 0;
				led_reg[1] = 1;
				led_reg[2] = 1;
				led_reg[3] = 1;					
				led = led_reg;
				
				// next state
				next_state = STATE_0;
			end

			STATE_0: 
			begin
				led_reg[0] = 1;
				led_reg[1] = 0;
				led_reg[2] = 1;
				led_reg[3] = 1;					
				led = led_reg;
				
				// next state
				next_state = STATE_1;
			end

			STATE_1:  
			begin
				led_reg[0] = 1;
				led_reg[1] = 1;
				led_reg[2] = 0;
				led_reg[3] = 1;					
				led = led_reg;
				
				// next state
				next_state = STATE_2;
			end
			
			STATE_2:
			begin			
				led_reg[0] = 1;
				led_reg[1] = 1;
				led_reg[2] = 1;
				led_reg[3] = 1;				
				led = led_reg;
				
				// next state
				next_state = STATE_2;
			end
			  
			default:  next_state = IDLE; // Fallback to default state
			
		 endcase
	end
	*/
	
	/* UART test 
	always @(posedge clk)
	begin
		//led_reg[0] = nrst;
	
		if (!reset) 
		begin
			counter2 <= 32'd0;
			uart_tx_data <= 8'h00;
		end
			
		if (counter2 == 50000000)
		begin
			counter2 <= 0;
			
			// blink the LED
			//led[0] <= ~led[0];
			
			// UART start transmission
			// send current byte over the UART
			uart_tx_data_valid_reg <= 1;
			
			// increment the byte so we can observe a change in the terminal emulator
			uart_tx_data <= uart_tx_data + 8'h01;
		end
		else
		begin			
			counter2 <= counter2 + 32'd1;
			
			// UART disable transmission once done
			if (uart_tx_done == 1) 
			begin
				uart_tx_data_valid_reg <= 0;
			end
		end
		
	end
	*/
	
endmodule
