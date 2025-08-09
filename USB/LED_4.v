module LED_4(

	// clock and reset
	input nrst,
	input clk,
	
	// LEDs
	inout reg [3:0]led,
	
	// ULPI
	input wire clkout,
	input wire DIR, // PIN 52
	
	output wire RST // PIN 46
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
	
	always @(posedge clkout)
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
	
	always @(posedge clkout)
	//always @(posedge clk)
	begin
	
		if(!nrst) 
		begin
			counter <= 32'd0;
			led[0] <= 1; // L4 (1 = off, 0 == on)
			//led[1] <= 1; // L3 (1 = off, 0 == on)
			led[2] <= 1; // L2 (1 = off, 0 == on)
			led[3] <= 1; // L1 (1 = off, 0 == on)
			
			reset_performed <= 0; // no reset performed yet
			RST_reg <= 1; // assert the reset pin to trigger a reset
		end
		
		if (counter == 60000000)
		begin
			counter <= 0;
			//led <= ~led;
			led[0] <= ~led[0];
			//RST_reg <= ~RST_reg;
			
			if (reset_performed == 0)
			begin
				reset_performed <= 1;
				RST_reg <= 0;
			end
			
		end
		else
		begin			
			counter <= counter + 32'd1;
		end		
		
	end
	
	/* PIN Tester command */
	always @(posedge clk)
	begin
	
		if(!nrst) 
		begin
			counter2 <= 32'd0;
		end
			
		if (counter2 == 30000000)
		begin
			counter2 <= 0;
			RST_reg <= ~RST_reg;
		end
		else
		begin			
			counter2 <= counter2 + 32'd1;
		end
		
	end
	*/
	
endmodule
