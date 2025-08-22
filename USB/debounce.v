module debounce (
	input i_Clk,
	input i_data,
	output o_data);

	// The Go Board runs at a clock frequency of 25 MHz, and I have set the bouncing threshold to be 10 ms
	// Therefore, 1ms / (1 / 25MHz) = 250,000 clock cycles:
	//parameter c_COUNT_LIMIT = 250000;
	parameter c_COUNT_LIMIT = 600000;
	reg [17:0] r_counter =0; // 18 bit does the job as 2^18 > 250,000
	reg r_filtered_data = 1'b0;

	always @ (posedge i_Clk)
	begin
		if (i_data !== r_filtered_data && r_counter < c_COUNT_LIMIT)
			r_counter <= r_counter + 1;
		else if (r_counter == c_COUNT_LIMIT)
		begin
			r_filtered_data <= i_data;
			r_counter <= 0;
		end
		else
			r_counter <= 0;
	end

assign o_data = r_filtered_data;

endmodule