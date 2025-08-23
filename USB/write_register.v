module write_register(

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
	inout reg[7:0] data,
	
	// UART
	output wire uart_tx_pin, // PIN 
	
	// test
	output wire TESTPIN

);

	// when reset is asserted, the phy resets
	//reg [31:0] phy_reset_counter;
	reg [31:0] phy_reset_counter;
	reg phy_reset_performed;
	
	reg RST_reg;
	assign RST = RST_reg;

	reg stp_reg;
	assign STP = stp_reg;
	
	reg ulpi_register_write_reg;
	
	reg [3:0] led_reg;
	
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
	localparam STATE_12		= 4'b1100;
	localparam STATE_13		= 4'b1101;
	localparam STATE_14		= 4'b1110;
	localparam IDLE 			= 4'b1111;
	
	// apply next state
	always @(posedge CLKOUT or negedge reset) 
	begin	
		if (!reset) 
		begin
			cur_state = IDLE;
		end
		else 
		begin
			cur_state = next_state;
		end
	end
	
	// combinational always block for next state logic
	always @(cur_state) 
	begin
	
		// default next state assignment
		next_state = IDLE;

		case (cur_state)

			STATE_0: 
			begin
			
				led_reg = ~4'h00;
				led = led_reg;

				// LINK needs to pull STP low otherwise nothing works at all
				stp_reg = 0;

				if (DIR == 1)
				begin
					next_state = STATE_0;
				end
				else
				begin

					// A ULPI READ is described by 11xxxxxx in binary. The xxxxxx contains the address. 
					// To read Vendor ID Low, the address is 0x00. So combining the CMD BITS with the address 
					// 0x00 yields 11000000b = 0xC0.
					// 11000000bin = 0xC0
					
					//data = 8'hC0; 	// vendor id low  	(0x24, 00100100) (ULPI register READ: address 0x00)
					//data = 8'hC1; 	// vendor id high 	(0x04, 00000100) (ULPI register READ: address 0x01)
					
					//data = 8'hC2; 		// product id low  	(0x04, 00000100) (ULPI register READ: address 0x02)
					//data = 8'hC3; 	// product id high 	(0x00, 00000000) (ULPI register READ: address 0x03)
					
					//data = 8'hC4; // function control
					
					//data = 8'hCD; // USB Interrupt Enable Rising
					
					//data = 8'hD3;
					
					// A ULPI WRITE 
					
					// https://cross-hair.co.uk/tech-articles/ULPI%20interface.html
					// First we must disable OTG features by writing x"00" to the OTG_CTRL (x"0a") register.
					// A TXCMD byte of x"8a" is sent then a data byte of x"00" as per Figure 1.
					
					data = 8'h8a; // [10][0x0A]
					
					next_state = STATE_1; // next state
				end
			end

			STATE_1:
			begin
				led_reg = ~4'h01;
				led = led_reg;
				
				data = 8'h8a; // [10][0x0A]
				
				next_state = STATE_2; // next state
			end
			
			STATE_2:
			begin
				led_reg = ~4'h02;
				led = led_reg;
				
				data = 8'h8a; // [10][0x0A]
				
				next_state = STATE_3; // next state
			end
			
			STATE_3:
			begin
				led_reg = ~4'h03;
				led = led_reg;
				
				data = 8'h00; // data byte to write into the register
				
				next_state = STATE_4; // next state
			end
			
			STATE_4:
			begin
				led_reg = ~4'h04;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h01;
			
				next_state = STATE_5; // next state
			end
			
			STATE_5:
			begin			
				led_reg = ~4'h05;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h00;
			
				next_state = STATE_6; // next state
			end
			
			STATE_6:
			begin
				led_reg = ~4'h06;
				led = led_reg;
				
				data = 8'h84; // [10][0x04] write the function control register
					
				next_state = STATE_7; // next state
			end 
			
			STATE_7:
			begin
				led_reg = ~4'h07;
				led = led_reg;
				
				data = 8'h84; // [10][0x04] write the function control register
					
				next_state = STATE_8; // next state
			end
			
			STATE_8:
			begin
				led_reg = ~4'h08;
				led = led_reg;
				
				data = 8'h84; // [10][0x04] write the function control register
					
				next_state = STATE_9; // next state
			end
			
			STATE_9:
			begin
				led_reg = ~4'h09;
				led = led_reg;
				
				data = 8'h45; // data byte to write into the register (0100 0101)
					
				next_state = STATE_10; // next state
			end
			
			STATE_10:
			begin
				led_reg = ~4'h0A;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h00;
				
				// The PHY should respond with a RXCMD showing a LineState of J ("01", FS Idle).
				// 10001010
					
				next_state = STATE_11; // next state
			end
			
			STATE_11:
			begin
				led_reg = ~4'h0B;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h01;
					
				next_state = STATE_12; // next state
			end
			
			STATE_12:
			begin
				led_reg = ~4'h0C;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h00;
					
				next_state = STATE_13; // next state
			end
			
			STATE_13:
			begin
				led_reg = ~4'h0D;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h00;
					
				next_state = STATE_14; // next state
			end
			
			STATE_14:
			begin
				led_reg = ~4'h0E;
				led = led_reg;
				
				data = 8'h00;
				stp_reg = 8'h00;
					
				next_state = STATE_14;
			end
			
			IDLE: 
			begin
				led_reg = ~4'h0F;
				led = led_reg;
				
				// LINK needs to pull STP low otherwise nothing works at all
				stp_reg = 0;
				
				// next state
				//if (ulpi_register_write_reg == 1)
				//begin
					next_state = STATE_0;
				//end
			end
			
			default:
			begin				
				// next state
				next_state = IDLE; // Fallback to default state
				
				// LINK needs to pull STP low otherwise nothing works at all
				stp_reg = 0;
			end			
			
		 endcase

	end

endmodule