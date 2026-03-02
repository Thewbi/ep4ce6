module fifo_write_control
(
	input           i_clock, // 50 MHz
	input           i_clock_data, // 2.5 MHz
	input           i_reset,
	input   [7:0]   i_data_in,

	output  [1:0]   o_data_write,
	output  [8:0]   o_addr_write,
	output          o_enab_write,
	output          o_data_empt,
	output          o_data_full,
	
	output wire [3:0] o_led
);

	// local parameters declaration
	localparam [2:0] IDLE       =    3'b000;
	localparam [2:0] BUS_1      =    3'b001;
	localparam [2:0] BUS_2      =    3'b010;
	localparam [2:0] BUS_3      =    3'b011;
	localparam [2:0] BUS_4      =    3'b100;
	localparam [2:0] BUS_1_INIT =    3'b101;
	localparam [2:0] STOP       =    3'b110;
	
	// registers and wires declaration 
	reg     [7:0]       r_data_in;
	reg     [2:0]       r_ST_main;
	reg     [8:0]       r_addr_write;
	reg     [1:0]       r_data_write;
	reg                 r_enab_write;
	reg                 r_data_empt;
	reg                 r_data_full;
	reg                 r_clock_data;
	reg                 r_DV;
	
	//reg     [7:0]       r_led;
	//assign o_led = r_led;

	// storage data clock to detect rising edge
	always @(posedge i_clock or posedge i_reset)
	begin
		if (i_reset)
		begin
			//r_led <= 4'b1111; // LEDs off
			r_clock_data <= 1'b0;
		end
		else
		begin
			//r_led <= 4'b0000; // LEDs on
			r_clock_data <= i_clock_data;
		end
	end

	// generate r_DV (Carrier Sense/Receive Data Valid) when rising edge of data clock 
	always @(posedge i_clock or posedge i_reset)
	begin
		if (i_reset)
		begin
			r_DV <= 1'b0;
		end
		else if ((r_clock_data == 1'b0) & (i_clock_data == 1'b1))
		begin
			r_DV <= 1'b1;
		end
		else
		begin
			r_DV <= 1'b0;
		end
	end
	
	// storage data in register
	always @(posedge i_clock or posedge i_reset)
	begin
		if (i_reset)
		begin
			r_data_in <= 7'b0;
		end
		else
		begin
			if (r_DV)
			begin
				r_data_in <= i_data_in;
			end
		end
	end

	// state machine write each pair of bit  
	always @(posedge i_clock or posedge i_reset)
	begin
	
		if (i_reset)
		begin
			r_ST_main       <= IDLE;
			r_addr_write    <= 9'b0;
			r_data_write    <= 2'b0;
			r_enab_write    <= 1'b0;
		end
		else
		begin
			r_data_full <= 1'b0;
			
			case(r_ST_main)
			
				IDLE:
				begin
					//r_led <= 4'b1111; // LEDs off
					
					r_enab_write <= 1'b0;       
					r_data_write <= r_data_write;
					r_addr_write <= r_addr_write;
					
					if (r_DV & (r_addr_write == 9'b0))
					begin
					   // skip BUS 1
						r_ST_main <= BUS_1_INIT;
					end
					else if (r_DV)
					begin
						r_ST_main <= BUS_1;
					end
				end
				
				// bits 7, 6
				BUS_1_INIT:
				begin
					//r_led <= 4'b1110;
					
					r_addr_write <= r_addr_write;
					//r_data_write <= r_data_in[7:6];
					r_data_write <= r_data_in[1:0];
					r_enab_write <= 1'b1;
					
					// go to state 2, since bits 7:6 written in state 1 have already been written here
					r_ST_main <= BUS_2;
					
					// after the last bit-pair go back to STOP
					if (r_addr_write >= 9'd287) // 288 * 2 / 8 = 72
					begin
						r_data_full  <= 1'b1; // this is a signal to fifo_read which then starts the transmission
						r_addr_write <= 9'b0;
						r_enab_write <= 1'b0;
						
						// go nowhere from STOP
						r_ST_main <= STOP;
					end
				end
				
				// bits 7, 6
				BUS_1:
				begin
					//r_led <= 4'b0100;
					
					r_addr_write <= r_addr_write + 1;
					//r_data_write <= r_data_in[7:6];
					r_data_write <= r_data_in[1:0];
					r_enab_write <= 1'b1;
					
					r_ST_main <= BUS_2;
					
					// after the last bit-pair go back to STOP
					if (r_addr_write >= 9'd287)
					begin
						r_data_full  <= 1'b1; // this is a signal to fifo_read which then starts the transmission
						r_addr_write <= 9'b0;
						r_enab_write <= 1'b0;
						
						// go nowhere from STOP
						r_ST_main <= STOP;
					end
				end
				
				// bits 5, 4
				BUS_2:
				begin
					//r_led <= 4'b1101;
					
					r_addr_write <= r_addr_write + 1;
					//r_data_write <= r_data_in[5:4];
					r_data_write <= r_data_in[3:2];
					r_enab_write <= 1'b1;
					
					r_ST_main <= BUS_3;
					
					// after the last bit-pair go back to STOP
					if (r_addr_write >= 9'd287)
					begin
						r_data_full  <= 1'b1; // this is a signal to fifo_read which then starts the transmission
						r_addr_write <= 9'b0;
						r_enab_write <= 1'b0;
						
						// go nowhere from STOP
						r_ST_main <= STOP;
					end
				end
				
				// bits 3, 2
				BUS_3:
				begin
					//r_led <= 4'b1100;
					
					r_addr_write <= r_addr_write + 1;
					//r_data_write <= r_data_in[3:2];
					r_data_write <= r_data_in[5:4];
					r_enab_write <= 1'b1;
					
					r_ST_main <= BUS_4;
					
					// after the last bit-pair go back to STOP
					if (r_addr_write >= 9'd287)
					begin
						r_data_full  <= 1'b1; // this is a signal to fifo_read which then starts the transmission
						r_addr_write <= 9'b0;
						r_enab_write <= 1'b0;
						
						// go nowhere from STOP
						r_ST_main <= STOP;
					end
				end
				
				// bits 1, 0
				BUS_4:
				begin
					//r_led <= 4'b1011;
					
					r_addr_write <= r_addr_write + 1;
					//r_data_write <= r_data_in[1:0];
					r_data_write <= r_data_in[7:6];
					r_enab_write <= 1'b1;
					
					// back to IDLE to write the next byte
					r_ST_main <= IDLE;
					
					// after the last bit-pair go back to STOP
					if (r_addr_write >= 9'd287)
					begin
						r_data_full  <= 1'b1; // this is a signal to fifo_read which then starts the transmission
						r_addr_write <= 9'b0;
						r_enab_write <= 1'b0;
						
						// go nowhere from STOP
						r_ST_main <= STOP;
					end
				end
				
				// we go nowhere from here!
				STOP:
				begin
					//r_led <= 4'b0110; // LEDs on
				
					r_addr_write <= 9'b0;
					r_data_write <= 2'b0;
					r_enab_write <= 1'b0;
				end
				
			endcase
		end
	end

	assign o_data_write = r_data_write;
	assign o_addr_write = r_addr_write;
	assign o_enab_write = r_enab_write;
	assign o_data_full  = r_data_full;

endmodule