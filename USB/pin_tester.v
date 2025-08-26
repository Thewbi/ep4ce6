module pin_tester
(
	input 						clk, 		// 50 MHz (see https://www.waveshare.com/wiki/OpenEP4CE6-C_User_Manual#Clock_Circuit)
	input 						reset,
	
	// LEDs
	inout 	reg 	[3:0] 	led,
	
	output 	wire 				TESTPIN,
	
	inout 	wire  [7:0] 	data
);


reg [7:0] data_reg;
assign data = data_reg;

// for testing pins with an oscilloscope
reg testpin_reg;
assign TESTPIN = testpin_reg;

reg [31:0] counter;

wire reset_debounced;
debounce db(
	.i_Clk(clk),
	.i_data(!reset),
	.o_data(reset_debounced)
);

/* PIN Tester command */
always @(posedge clk)
begin

	if (!reset) 
	begin
		counter <= 32'd0;
		testpin_reg <= 0;
		data_reg <= 8'h00;
	end
		
	//if (counter == 50000000)
	if (counter == 500000)
	begin
		counter <= 0;
		
		// toggle the pin
		testpin_reg <= ~testpin_reg;
		
		data_reg[7] <= ~data_reg[7];
		
		// blink the LED
		led[0] <= ~led[0];
	end
	else
	begin			
		counter <= counter + 32'd1;
	end
	
end	

endmodule