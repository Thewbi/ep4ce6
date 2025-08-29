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
	//inout wire[7:0] data,
	
	// UART
	output wire uart_tx_pin, // PIN 
	
	// test
	output wire TESTPIN

);

	wire uart_tx_data_valid;
	reg uart_tx_data_valid_reg;
	assign uart_tx_data_valid = uart_tx_data_valid_reg;
	
	
	//reg[7:0] data_reg;
	//assign data = data_reg;
	
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
	
	/*
	wire reset_debounced;
	debounce db(
		.i_Clk(CLKOUT),
		.i_data(reset),
		.o_data(reset_debounced)
	);
	
	reg SYSTEM_READY_reg;
	
	usbModule(
	
		// output
		.STP(STP),
		.USB_RST(RST),
		
		// inout
		.DATA_OUT_PORT(data),
		
		// input
		.CLK_USB(CLKOUT),
		.DIR(DIR),
		.NXT(NXT),
		.SYS_RST(!reset_debounced),
		.SYSTEM_READY(SYSTEM_READY_reg)
	);
	*/
	
	reg [31:0] counter;	
	reg [31:0] counter2;
	reg [31:0] counter3;
	
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
	
	/*
	always @(posedge CLKOUT)
	begin
		if (!reset_debounced)
		begin
			counter <= 32'd0;
			SYSTEM_READY_reg = 0;			
		end
		
		if (counter == 60000000)
		begin
			SYSTEM_READY_reg = 1;
		end
		else
		begin			
			counter <= counter + 32'd1;
		end
	end
	*/
	
/**/
	reg ulpi_register_read_reg;
	
	// UPLI, Perform RESET
	always @(posedge CLKOUT)
	begin
	
		if (!reset)
		//if (!reset_debounced)
		begin
			counter <= 32'd0;
			//counter2 <= 32'd0;
			//counter3 <= 32'd0;
			
			//led[0] <= 1; // L4 (1 = off, 0 == on)
			//led[1] <= 1; // L3 (1 = off, 0 == on)
			//led[2] <= 1; // L2 (1 = off, 0 == on)
			//led[3] <= 1; // L1 (1 = off, 0 == on)
			
			// ULPI data is set to ULPI idle (= 0x00)
			//data <= 8'd0;
			
			reset_performed <= 0; // no reset performed yet
			RST_reg <= 1; // assert the reset pin to trigger a reset
			
			ulpi_register_read_reg = 0;
			
			//stp_reg = 0;
			
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
	
	
	
	
	
	reg [3:0] cur_state;
	reg [3:0] next_state;
	localparam STATE_0 		= 4'b0000;
	localparam STATE_1 		= 4'b0001;
	localparam STATE_2 		= 4'b0010;
	localparam STATE_3 		= 4'b0011;
	localparam STATE_4 		= 4'b0100;
	localparam STATE_5 		= 4'b0101;
	localparam STATE_6 		= 4'b0110;
	localparam STATE_7 		= 4'b0111;
	localparam STATE_8 		= 4'b1000;
	localparam STATE_9 		= 4'b1001;
	localparam STATE_10 		= 4'b1010;
	localparam STATE_11		= 4'b1011;
	localparam IDLE 			= 4'b1111;
	
	reg ss_started;
	reg [7:0] return_value;
	
	// apply next state
	always @(posedge CLKOUT or negedge reset) 
	begin	
		if (!reset) 
		begin
			cur_state = IDLE;
			//ss_started = 0;			
			//counter3 = 32'h00;
		end
		else 
		begin
			cur_state = next_state;
		end
	end
	
	always @(posedge CLKOUT)
	begin
		if (cur_state == STATE_6)
		begin
			if (counter3 == 60000001)
			begin
				counter3 = 0;
			end
			else
			begin
				counter3 = counter3 + 1;
			end
		end
		else
		begin
			counter3 = 0;
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

				stp_reg = 0;

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
					
					data = 8'hC0; 	// vendor id low  	(0x24, 00100100) (ULPI register READ: address 0x00)
					//data = 8'hC1; 	// vendor id high 	(0x04, 00000100) (ULPI register READ: address 0x01)
					
					//data = 8'hC2; 		// product id low  	(0x04, 00000100) (ULPI register READ: address 0x02)
					//data = 8'hC3; 	// product id high 	(0x00, 00000000) (ULPI register READ: address 0x03)
					
					//data = 8'hC4; // function control
					
					//data = 8'hCD; // USB Interrupt Enable Rising
					
					//data = 8'hD3;
					
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
				
				//data = 8'h00;
				
				// next state
				next_state = STATE_3;
			end
			
			STATE_3:
			begin
				data = 8'h00;
				
				led_reg = ~4'h03;
				led = led_reg;
				
				next_state = STATE_4;
			end
			
			STATE_4:
			begin
				led_reg = ~4'h04;
				led = led_reg;
			
				// next state
				//next_state = STATE_5;
				// next state
				if (DIR == 1)
				begin
					next_state = STATE_5;
				end
				else
				begin
					next_state = STATE_4;
				end
			end
			
			STATE_5:
			begin			
				//uart_tx_data_valid_reg = 0;
				
				return_value = data;
				
				// UART
				uart_tx_data = data;
				uart_tx_data_valid_reg = 1;
			
				// UART
				//uart_tx_data = return_value;
				//uart_tx_data_valid_reg = 1;
			
				led_reg = ~4'h05;
				led = led_reg;
				
				// next state
				next_state = STATE_6;
				
				//counter3 = 32'h00;
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
				
				// drive ULPI idle, otherwise buffers are still filled with last command
				data = 8'h00;
			
				if (counter3 >= 60000000)
				begin
					// next state
					next_state = STATE_7;
					
					//counter3 = 32'h00;
				end
				else
				begin
					next_state = STATE_6;
					
					//counter3 = counter3 + 32'h01;
				end
				
				//ss_started = 0;				
				
			end
			
			STATE_7:
			begin
				// https://cross-hair.co.uk/tech-articles/ULPI%20interface.html
				// First we must disable OTG features by writing x"00" to the OTG_CTRL (x"0a") register.
				// A TXCMD byte of x"8a" is sent then a data byte of x"00" as per Figure 1.
				
				led_reg = ~4'b0111;
				led = led_reg;
				
				data = 8'h8a; // [10][001010] = 10b = Register Write, 0x0A = OTG Control Write
				
				if (NXT == 1)
				begin
					next_state = STATE_8;
				end 
				else
				begin
					next_state = STATE_7;
				end
			end
			
			STATE_8:
			begin
				// https://cross-hair.co.uk/tech-articles/ULPI%20interface.html
				// First we must disable OTG features by writing x"00" to the OTG_CTRL (x"0a") register.
				// A TXCMD byte of x"8a" is sent then a data byte of x"00" as per Figure 1.
				
				led_reg = ~4'b1000;
				led = led_reg;
				
				data = 8'h8a;
				
				if (NXT == 0)
				begin
					next_state = STATE_8;
				end
				else
				begin
					next_state = STATE_9;
				end
			end
			
			STATE_9:
			begin
				
				led_reg = ~4'b1001;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h00;
				next_state = STATE_10;
			end
			
			STATE_10:
			begin
				
				led_reg = ~4'b10;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h01;
				next_state = STATE_11;
			end
			
			STATE_11:
			begin
				led_reg = ~4'b11;
				led = led_reg;
				
				stp_reg = 8'h00;
			end
			
			IDLE: 
			begin
				//led_reg = ~4'h07;
				//led = led_reg;
				
				// next state
				if ((ulpi_register_read_reg == 1))//&& (ss_started == 0)
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
	
endmodule
