module LED_4(
	input nrst,
	input clk,
	inout reg [3:0]led,
	input wire pin16IOs_1_8
	);
	
	reg [31:0] counter;	
	reg clk2;
	reg [7:0] i;	
	reg [3:0] led_reg;
	//reg pin16IOs_1_8_reg;
	
	//assign pin16IOs_1_8 = pin16IOs_1_8_reg;	
	//assign led = led_reg;
	
	always @(posedge pin16IOs_1_8)
	begin
	
		if(!nrst) 
		begin
			counter <= 32'd0;
			led <= 4'd0;
		end
		
		if (counter == 60000000)
		begin
			counter <= 0;
			led <= ~led;
		end
		else
		begin			
			counter <= counter + 32'd1;
		end
		
	end
	
//	always@(posedge clk, negedge nrst) 
//	begin
//		if(!nrst) 
//		begin
//			counter <= 0;
//			//clk2 <= 0;
//		end
//		else if (counter == 2500000) begin
//		//else if (counter == 1250000) begin
//		//else if (counter == 900000) begin
//		//else if (counter == 625000) begin
//		//else if (counter == 200000) begin
//			counter <= 0;
//			//clk2 = ~clk2;
//			
//			//pin16IOs_1_8_reg = ~pin16IOs_1_8_reg;
//		end
//		else
//			counter <= counter + 32'd1;
//	end

//	always@(posedge clk2, negedge nrst) 
//	begin
//		if(!nrst)
//			led <= 4'd0;
//		else
//			case (i)
//		      0:	begin led <= 4'b0001; i<=i+1; end
//				1:	begin led <= 4'b0010; i<=i+1; end
//				2:	begin led <= 4'b0100; i<=i+1; end
//				3:	begin led <= 4'b1000; i<=0; end
//			endcase			
//	end
	
endmodule
