module LED_4(

	// clock and reset
	input nrst,
	input clk, // 50 MHz (see https://www.waveshare.com/wiki/OpenEP4CE6-C_User_Manual#Clock_Circuit)
	
	// LEDs
	inout reg [3:0]led,
	
	// ULPI
	input  wire CLKOUT, // PIN 50
	input  wire DIR,    // PIN 52	
	output wire RST,    // PIN 46

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
	
	// initializing bytes here has no effect! It does not work!
	//reg[7:0] uart_tx_data = 8'b10101010; // 0xAA
	//reg[7:0] uart_tx_data = 8'hAA; // 8'hAA
	reg[7:0] uart_tx_data;
	
	wire uart_tx_active;	
	wire uart_tx_done;
	
	// for the UART transceiver module, the 50 Mhz Clock does not work!
	// The clock needs to be converted down! 10 MHz works!
	wire clk_10;
	Clock_divider(clk, clk_10);

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
	
	/* Make ULPI DIR visiable via LED 3
	always @(posedge CLKOUT)
	begin
		if(!nrst) 
		begin
			led[1] <= 1; // LED 3 (L3) (1 = off, 0 == on)
		end
		else
		begin		
			led[1] <= DIR; // LED 3 (L3) (1 = off, 0 == on). When the LED is off, DIR is 1 (HIGH)
		end
	end
	*/
	
	/* Perform RESET
	always @(posedge CLKOUT)
	begin
	
		if(!nrst) 
		begin
			counter <= 32'd0;
			led[0] <= 1; // L4 (1 = off, 0 == on)
			//led[1] <= 1; // L3 (1 = off, 0 == on)
			led[2] <= 1; // L2 (1 = off, 0 == on)
			led[3] <= 1; // L1 (1 = off, 0 == on)
			
			// ULPI data is set to ULPI idle (= 0x00)
			data <= 8'd0;
			
			reset_performed <= 0; // no reset performed yet
			RST_reg <= 1; // assert the reset pin to trigger a reset
			
			uart_tx_data_valid_reg <= 0;
			uart_tx_data = 8'h00;
		end
		
		if (counter == 60000000)
		begin
		
			counter <= 0;
			//led <= ~led;
			led[0] <= ~led[0];
			
			// YORO - you only reset once
			if (reset_performed == 0)
			begin
				reset_performed <= 1;
				
				// do not reset any more
				RST_reg <= 0;
				
				// ULPI data is set to ULPI idle (= 0x00)
				data <= 8'd0;
			end
			
			// UART start transmission
			uart_tx_data_valid_reg <= 1;		
			uart_tx_data = 8'h00;
			
		end
		else
		begin			
			counter <= counter + 32'd1;
			
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
	
	/* UART test */
	always @(posedge clk)
	begin
	
		if(!nrst) 
		begin
			counter2 <= 32'd0;
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
	
endmodule
