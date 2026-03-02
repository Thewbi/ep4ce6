module fifo_read_control
(
	input        			i_clock, // 50MHz of RMII
	input        			i_reset,
	input        			i_data_full, // this signal starts the transmission

	output 		[8:0] 	o_addr_read,
	output       			o_reading_done,
	output       			o_TX_enab,
	
	output wire [3:0] 	o_led
);

	// registers declaration
	reg        	[8:0]		r_addr_read;
	reg              		r_reading_done;
	reg        	[2:0]		r_ST_main;
	reg              		r_TX_enab;
	
	reg     		[7:0]		r_led;
	assign 					o_led = r_led;

	localparam 	[2:0]    IDLE      = 3'b000;
	localparam 	[2:0]    READ      = 3'b001;
	localparam 	[2:0]    WAIT      = 3'b010;
	 
	// reading data
	always @(negedge i_clock or posedge i_reset)
	begin
	
		if (i_reset)
		begin
			r_addr_read <= 9'b0;
			r_reading_done <= 1'b0;
			r_ST_main <= IDLE;
			
			r_TX_enab <= 1'b0;
			r_led <= 4'b1111; // LEDs off
		end
		else
		begin
		
			r_reading_done <= 1'b0;
			
			r_TX_enab <= 1'b0;
			r_led <= 4'b1111; // LEDs off
			
			if (r_addr_read >= 9'd287)
			begin
				r_reading_done <= 1'b1;
				r_addr_read <= 9'b0;
				
				r_TX_enab <= 1'b0;
				r_led <= 4'b1010;
			end
			
			case(r_ST_main)
			
				IDLE:
				begin
					r_addr_read <= r_addr_read;
					r_reading_done <= 1'b0;
					
					if (i_data_full)
					begin						
						r_TX_enab <= 1'b1;
						r_led <= 4'b1110;
						
						// next state
						r_ST_main <= READ;
					end
				end
				
				READ:
				begin
					r_addr_read <= r_addr_read + 1;
					r_reading_done <= 1'b0;
		
               r_TX_enab <= 1'b1;		
					r_led <= 4'b1101; // LEDs on
					
					if (r_addr_read >= 9'd287) // 288 touples * 2 bit per touple = 576 bits == 72 byte
					begin
					
						// all 72 byte have been read into the FIFO
						r_reading_done <= 1'b1;
						r_addr_read <= r_addr_read;
						
						r_TX_enab <= 1'b0;
						r_led <= 4'b1100; // LEDs off
						
						// next state
						r_ST_main <= WAIT;
						
					end
					else
					begin
						// next state
						r_ST_main <= READ;
					end
				end
				
				WAIT:
				begin
					r_addr_read <= 9'b0;
					
					r_TX_enab <= 1'b0;
					r_led <= 4'b1011; // LEDs on
					
					r_reading_done <= 1'b0;
					
					// next state
					r_ST_main <= WAIT;
					//r_ST_main <= IDLE;
				end
				
			endcase
			
		end
	end
	
	assign o_addr_read = r_addr_read;
	assign o_TX_enab = r_TX_enab;
	
endmodule