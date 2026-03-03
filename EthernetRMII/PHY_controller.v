`include "ethernet_define.v"

module PHY_controller
(
	input 				nrst,
	input 				clk, // 50 Mhz clock of the FPGA
	output wire [3:0] led,

	input  wire 		i_clock, // 50 MHz clock coming from the breakout board
	
	output wire [1:0] o_data_out,
	output wire     	o_TX_enab,
	
	//
	// Ethernet Receive
	// 
	
	input wire 			crs_dv, // Carrier Sense / Receive Data Valid
	input wire [1:0]  rx,
	
	//
	// UART
	//
	
	output wire 		o_uart_tx_pin // PIN 
	
);
 
	// wire declaration
	wire 			w_clock;
	wire 			w_clock_data;
	reg 			w_clock_data_reg;
	wire 			w_reset;
	wire [7:0] 	w_data_8bits;
	wire [1:0] 	w_data_2bits;
	wire [8:0] 	w_addr_wire;
	wire       	w_enab_write;
	wire [8:0] 	w_addr_read;
	wire       	w_data_full;
	wire 			i_reset;	
	
	//reg [3:0] led_reg = 4'b1111;
	reg [3:0] led_reg;
	assign led = ~led_reg;
	//assign led[0] = uart_transmit_start;	

	assign w_clock = i_clock;
	assign w_clock_data = w_clock_data_reg;
	assign w_reset = !nrst;
	 
	reg [31:0] counter;
	reg [31:0] slow_counter;
	 
	always @(posedge i_clock)
	begin
		if (!nrst)
		begin
			//led <= 4'b1111; // 1 turns LEDs off
			
			counter <= 32'd0;
			w_clock_data_reg <= 32'd0;
		end
		else
		begin

			//led <= 4'b0000; // 0 turns LEDs on
		
			//if (counter == 50000000)
			if (counter == 20)
			begin
				counter <= 32'd0;
				w_clock_data_reg <= !w_clock_data_reg;
			end
			else
			begin
				counter <= counter + 32'd1;
			end
			
		end
	end
	
	//
	// ???
	//
	
	parameter datab2n = 9; // 2^9 = 512 bits = 64 byte
	parameter skip_bytes = 0;

/*	*/
	//
	// UART RX -> ETHERNET TX
	//
	
	reg  [1:0] 	o_data_out_reg;
	assign o_data_out = o_data_out_reg;
	
	reg         o_TX_enab_reg = 0;
	assign o_TX_enab  = o_TX_enab_reg;
	
	// I think that there is a -1 because this halves the amount of elements:
	// 2^9 = 512
	// 2^8 = 256
	// but as each element is a touple of two bits, this adds up to the full amount of bits
	reg [1:0] T_data[0 : 2**(datab2n-0)-1]; // (T)ransmit data, collects data from UART RX
	reg [datab2n-0:0] t_idx; // (t)ransmit index
	
	reg [31:0] one_second_counter = 0;
	reg one_second_toggle = 0;
	reg one_second_toggle_sensor = 0;
	
	always @(posedge i_clock)
	begin
		if (!nrst)
		begin			
			one_second_counter <= 0;
		end
		else
		begin
			if (one_second_counter >= 50000000)
			begin
				one_second_counter <= 0;
				one_second_toggle <= ~one_second_toggle;
			end
			else
			begin
				one_second_counter <= one_second_counter + 1;
			end
		end
	end
	
	always @(posedge i_clock)
	begin
		if (!nrst)
		begin			
			t_idx <= 0;
		end
		else
		begin
			if (t_idx < 288)
			begin
				//o_data_out_reg <= T_data[t_idx[datab2n-0:0]];
				o_data_out_reg <= T_data[t_idx];
				o_TX_enab_reg <= 1;
				t_idx <= t_idx + 1;
				//led_reg <= 4'b1111;
			end
			else
			begin
				o_data_out_reg <= {1'b0, 1'b0};
				o_TX_enab_reg <= 0;
				
				if (one_second_toggle_sensor != one_second_toggle)
				begin
					one_second_toggle_sensor <= one_second_toggle;
					t_idx <= 0;
					//led_reg <= 4'b1111;
					led_reg <= ~led_reg;
				end
				else
				begin
					t_idx <= t_idx;
					//led_reg <= 4'b0000;
				end
			end			
		end
	end
	
	// 55 55 55 55 55 55 55 D5
	// 00 00 10 01 b3 bd 
	// 04 05 06 07 08 09 
	// 08 06 
	// 00 01 
	// 08 00 
	// 06 
	// 04 
	// 00 02 // ARP opcode (2 = reply)
	// 04 05 06 07 08 09 
	// c0 a8 00 2c 
	// 00 00 10 01 b3 bd 
	// c0 a8 00 04 
	// 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
	// 7d a4 9a 63
	always @(negedge nrst)
	begin
		if (!nrst)
		begin
		
			//T_data[t_idx[datab2n-2:0]] <= {1'b0, 1'b1};
	
			// preamble (7 byte preamble: 01010101, followed by 1 byte Start Frame Delimiter (SFD) 11010101)
			// the bits need to be sent LSB first, MSB last
/*			
			// 0 byte
			
			T_data [0] <= {1'b0, 1'b1};
			T_data [1] <= {1'b0, 1'b1};
			T_data [2] <= {1'b0, 1'b1};
			T_data [3] <= {1'b0, 1'b1};
			
			T_data [4] <= {1'b0, 1'b1};
			T_data [5] <= {1'b0, 1'b1};
			T_data [6] <= {1'b0, 1'b1};
			T_data [7] <= {1'b0, 1'b1};
			
			T_data [8] <= {1'b0, 1'b1};
			T_data [9] <= {1'b0, 1'b1};
			T_data[10] <= {1'b0, 1'b1};
			T_data[11] <= {1'b0, 1'b1};
			
			T_data[12] <= {1'b0, 1'b1};
			T_data[13] <= {1'b0, 1'b1};
			T_data[14] <= {1'b0, 1'b1};
			T_data[15] <= {1'b0, 1'b1};
			
			T_data[16] <= {1'b0, 1'b1};
			T_data[17] <= {1'b0, 1'b1};
			T_data[18] <= {1'b0, 1'b1};
			T_data[19] <= {1'b0, 1'b1};
			
			T_data[20] <= {1'b0, 1'b1};
			T_data[21] <= {1'b0, 1'b1};
			T_data[22] <= {1'b0, 1'b1};
			T_data[23] <= {1'b0, 1'b1};
			
			T_data[24] <= {1'b0, 1'b1};
			T_data[25] <= {1'b0, 1'b1};
			T_data[26] <= {1'b0, 1'b1};
			T_data[27] <= {1'b0, 1'b1};
			
			// Start Frame Delimiter (SFD) 11010101)
			T_data[28] <= {1'b0, 1'b1};
			T_data[29] <= {1'b0, 1'b1};
			T_data[30] <= {1'b0, 1'b1};
			T_data[31] <= {1'b1, 1'b1};
		
			// 8 byte (8*8 = 64 bit)

//			T_data [0] <= {1'b1, 1'b0};
//			T_data [1] <= {1'b1, 1'b0};
//			T_data [2] <= {1'b1, 1'b0};
//			T_data [3] <= {1'b1, 1'b0};
//			
//			T_data [4] <= {1'b1, 1'b0};
//			T_data [5] <= {1'b1, 1'b0};
//			T_data [6] <= {1'b1, 1'b0};
//			T_data [7] <= {1'b1, 1'b0};
//			
//			T_data [8] <= {1'b1, 1'b0};
//			T_data [9] <= {1'b1, 1'b0};
//			T_data[10] <= {1'b1, 1'b0};
//			T_data[11] <= {1'b1, 1'b0};
//			
//			T_data[12] <= {1'b1, 1'b0};
//			T_data[13] <= {1'b1, 1'b0};
//			T_data[14] <= {1'b1, 1'b0};
//			T_data[15] <= {1'b1, 1'b0};
//			
//			T_data[16] <= {1'b1, 1'b0};
//			T_data[17] <= {1'b1, 1'b0};
//			T_data[18] <= {1'b1, 1'b0};
//			T_data[19] <= {1'b1, 1'b0};
//			
//			T_data[20] <= {1'b1, 1'b0};
//			T_data[21] <= {1'b1, 1'b0};
//			T_data[22] <= {1'b1, 1'b0};
//			T_data[23] <= {1'b1, 1'b0};
//			
//			T_data[24] <= {1'b1, 1'b0};
//			T_data[25] <= {1'b1, 1'b0};
//			T_data[26] <= {1'b1, 1'b0};
//			T_data[27] <= {1'b1, 1'b0};
//			
//			// Start Frame Delimiter (SFD) 11010101)
//			T_data[28] <= {1'b1, 1'b0};
//			T_data[29] <= {1'b1, 1'b0};
//			T_data[30] <= {1'b1, 1'b0};
//			T_data[31] <= {1'b1, 1'b1};
			
			
			// 8 byte

			// MAC ADDRESSES
			
			// MAC DESTINATION ADDRESS - 00 00 10 01 b3 bd (00:00:10:01:B3:BD)
			{T_data[32], T_data[33], T_data[34], T_data[35]} <= 8'h00;
			{T_data[36], T_data[37], T_data[38], T_data[39]} <= 8'h00;
			{T_data[40], T_data[41], T_data[42], T_data[43]} <= 8'h10;
			{T_data[44], T_data[45], T_data[46], T_data[47]} <= 8'h01;
			{T_data[48], T_data[49], T_data[50], T_data[51]} <= 8'hb3;
			{T_data[52], T_data[53], T_data[54], T_data[55]} <= 8'hbd;
			
//			{T_data[35], T_data[34], T_data[33], T_data[32]} <= 8'h00;
//			{T_data[39], T_data[38], T_data[37], T_data[36]} <= 8'h00;
//			{T_data[43], T_data[42], T_data[41], T_data[40]} <= 8'h10;
//			{T_data[47], T_data[46], T_data[45], T_data[44]} <= 8'h01;
//			{T_data[51], T_data[50], T_data[49], T_data[48]} <= 8'hb3;
//			{T_data[55], T_data[54], T_data[53], T_data[52]} <= 8'hbd;
			
			// MAC SOURCE ADDRESS - 04 05 06 07 08 09
			{T_data[56], T_data[57], T_data[58], T_data[59]} <= 8'h04;
			{T_data[60], T_data[61], T_data[62], T_data[63]} <= 8'h05;
			{T_data[64], T_data[65], T_data[66], T_data[67]} <= 8'h06;
			{T_data[68], T_data[69], T_data[70], T_data[71]} <= 8'h07;
			{T_data[72], T_data[73], T_data[74], T_data[75]} <= 8'h08;
			{T_data[76], T_data[77], T_data[78], T_data[79]} <= 8'h09;
			
			// 20 byte

			// ETHERNET TYPE
			{T_data[80], T_data[81], T_data[82], T_data[83]} <= 8'h08;
			{T_data[84], T_data[85], T_data[86], T_data[87]} <= 8'h06;
			
			// 22 byte
			
			// ARP
		   // 0x00, 0x01, // ARP: hardware type: ethernet
		   {T_data[88], T_data[89], T_data[90], T_data[91]} <= 8'h00;
		   {T_data[92], T_data[93], T_data[94], T_data[95]} <= 8'h01;
			
			// 24 byte
			
		   // 0x08, 0x00, // ARP: protocol type: IPv4
			{T_data[96], T_data[97], T_data[98], T_data[99]} <= 8'h08;
			{T_data[100], T_data[101], T_data[102], T_data[103]} <= 8'h00;
			
			// 26 byte
			
		   // 0x06, // ARP: hardware size
			{T_data[104], T_data[105], T_data[106], T_data[107]} <= 8'h06;
			
		   // 0x04, // ARP: protocol size
			{T_data[108], T_data[109], T_data[110], T_data[111]} <= 8'h04;
			
			// 28 byte
			
		   // 0x00, 0x02, // ARP: Opcode (2 == reply)
			{T_data[112], T_data[113], T_data[114], T_data[115]} <= 8'h00;
			{T_data[116], T_data[117], T_data[118], T_data[119]} <= 8'h02;
			
			// 30 byte
			
		   // 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, // ARP: Sender MAC Address
			{T_data[120], T_data[121], T_data[122], T_data[123]} <= 8'h04;
			{T_data[124], T_data[125], T_data[126], T_data[127]} <= 8'h05;
			{T_data[128], T_data[129], T_data[130], T_data[131]} <= 8'h06;
			{T_data[132], T_data[133], T_data[134], T_data[135]} <= 8'h07;
			{T_data[136], T_data[137], T_data[138], T_data[139]} <= 8'h08;
			{T_data[140], T_data[141], T_data[142], T_data[143]} <= 8'h09;
			
			// 36 byte
			
		   // c0 a8 00 2c , // ARP: Sender IP Address
			{T_data[144], T_data[145], T_data[146], T_data[147]} <= 8'hC0;
			{T_data[148], T_data[149], T_data[150], T_data[151]} <= 8'hA8;
			{T_data[152], T_data[153], T_data[154], T_data[155]} <= 8'h00;
			{T_data[156], T_data[157], T_data[158], T_data[159]} <= 8'h2C;
			
			// 40 byte
			
		   // 00 00 10 01 b3 bd, // ARP: Target MAC address
			{T_data[160], T_data[161], T_data[162], T_data[163]} <= 8'h00;
			{T_data[164], T_data[165], T_data[166], T_data[167]} <= 8'h00;
			{T_data[168], T_data[169], T_data[170], T_data[171]} <= 8'h10;
			{T_data[172], T_data[173], T_data[174], T_data[175]} <= 8'h01;
			{T_data[176], T_data[177], T_data[178], T_data[179]} <= 8'hb3;
			{T_data[180], T_data[181], T_data[182], T_data[183]} <= 8'hbd;
			
			// 46 byte
			
		   // c0 a8 00 04, // ARP: Target IP address
			{T_data[184], T_data[185], T_data[186], T_data[187]} <= 8'hC0;
			{T_data[188], T_data[189], T_data[190], T_data[191]} <= 8'hA8;
			{T_data[192], T_data[193], T_data[194], T_data[195]} <= 8'h00;
			{T_data[196], T_data[197], T_data[198], T_data[199]} <= 8'h04;
			
			// 50 byte

         // Ethernet: Padding (18 byte
         // 0x00, 0x00, 0x00, 0x00, 
			// 0x00, 0x00, 0x00, 0x00, 
			// 0x00, 0x00, 0x00, 0x00, 
			// 0x00, 0x00, 0x00, 0x00, 
			// 0x00, 0x00,
			{T_data[200], T_data[201], T_data[202], T_data[203]} <= 8'h00;
			{T_data[204], T_data[205], T_data[206], T_data[207]} <= 8'h00;
			{T_data[208], T_data[209], T_data[210], T_data[211]} <= 8'h00;
			{T_data[212], T_data[213], T_data[214], T_data[215]} <= 8'h00;
			
			{T_data[216], T_data[217], T_data[218], T_data[219]} <= 8'h00;
			{T_data[220], T_data[221], T_data[222], T_data[223]} <= 8'h00;
			{T_data[224], T_data[225], T_data[226], T_data[227]} <= 8'h00;
			{T_data[228], T_data[229], T_data[230], T_data[231]} <= 8'h00;
			
			{T_data[232], T_data[233], T_data[234], T_data[235]} <= 8'h00;
			{T_data[236], T_data[237], T_data[238], T_data[239]} <= 8'h00;
			{T_data[240], T_data[241], T_data[242], T_data[243]} <= 8'h00;
			{T_data[244], T_data[245], T_data[246], T_data[247]} <= 8'h00;
			
			{T_data[248], T_data[249], T_data[250], T_data[251]} <= 8'h00;
			{T_data[252], T_data[253], T_data[254], T_data[255]} <= 8'h00;
			{T_data[256], T_data[257], T_data[258], T_data[259]} <= 8'h00;
			{T_data[260], T_data[261], T_data[262], T_data[263]} <= 8'h00;
			
			{T_data[264], T_data[265], T_data[266], T_data[267]} <= 8'h00;
			{T_data[268], T_data[269], T_data[270], T_data[271]} <= 8'h00;
			
			// 68 byte
			
         // Ethernet: FCS
         // 7d a4 9a 63
			// 7D A4 9A 63
			{T_data[272], T_data[273], T_data[274], T_data[275]} <= 8'h7d;
			{T_data[276], T_data[277], T_data[278], T_data[279]} <= 8'ha4;
			{T_data[280], T_data[281], T_data[282], T_data[283]} <= 8'h9a;
			{T_data[284], T_data[285], T_data[286], T_data[287]} <= 8'h63;
			
			// 72 byte = 288 * 2 = 576 bits = 576 / 8 = 72 byte == 64 byte + 8 byte preamble
			*/
			
			T_data [0] <= {1'b0, 1'b1};
			T_data [1] <= {1'b0, 1'b1};
			T_data [2] <= {1'b0, 1'b1};
			T_data [3] <= {1'b0, 1'b1};
			T_data [4] <= {1'b0, 1'b1};
			T_data [5] <= {1'b0, 1'b1};
			T_data [6] <= {1'b0, 1'b1};
			T_data [7] <= {1'b0, 1'b1};
			T_data [8] <= {1'b0, 1'b1};
			T_data [9] <= {1'b0, 1'b1};
			T_data [10] <= {1'b0, 1'b1};
			T_data [11] <= {1'b0, 1'b1};
			T_data [12] <= {1'b0, 1'b1};
			T_data [13] <= {1'b0, 1'b1};
			T_data [14] <= {1'b0, 1'b1};
			T_data [15] <= {1'b0, 1'b1};
			T_data [16] <= {1'b0, 1'b1};
			T_data [17] <= {1'b0, 1'b1};
			T_data [18] <= {1'b0, 1'b1};
			T_data [19] <= {1'b0, 1'b1};
			T_data [20] <= {1'b0, 1'b1};
			T_data [21] <= {1'b0, 1'b1};
			T_data [22] <= {1'b0, 1'b1};
			T_data [23] <= {1'b0, 1'b1};
			T_data [24] <= {1'b0, 1'b1};
			T_data [25] <= {1'b0, 1'b1};
			T_data [26] <= {1'b0, 1'b1};
			T_data [27] <= {1'b0, 1'b1};
			T_data [28] <= {1'b0, 1'b1};
			T_data [29] <= {1'b0, 1'b1};
			T_data [30] <= {1'b0, 1'b1};
			T_data [31] <= {1'b1, 1'b1};
			T_data [32] <= {1'b0, 1'b0};
			T_data [33] <= {1'b0, 1'b0};
			T_data [34] <= {1'b0, 1'b0};
			T_data [35] <= {1'b0, 1'b0};
			T_data [36] <= {1'b0, 1'b0};
			T_data [37] <= {1'b0, 1'b0};
			T_data [38] <= {1'b0, 1'b0};
			T_data [39] <= {1'b0, 1'b0};
			T_data [40] <= {1'b0, 1'b0};
			T_data [41] <= {1'b0, 1'b0};
			T_data [42] <= {1'b0, 1'b1};
			T_data [43] <= {1'b0, 1'b0};
			T_data [44] <= {1'b0, 1'b1};
			T_data [45] <= {1'b0, 1'b0};
			T_data [46] <= {1'b0, 1'b0};
			T_data [47] <= {1'b0, 1'b0};
			T_data [48] <= {1'b1, 1'b1};
			T_data [49] <= {1'b0, 1'b0};
			T_data [50] <= {1'b1, 1'b1};
			T_data [51] <= {1'b1, 1'b0};
			T_data [52] <= {1'b0, 1'b1};
			T_data [53] <= {1'b1, 1'b1};
			T_data [54] <= {1'b1, 1'b1};
			T_data [55] <= {1'b1, 1'b0};
			T_data [56] <= {1'b0, 1'b0};
			T_data [57] <= {1'b0, 1'b1};
			T_data [58] <= {1'b0, 1'b0};
			T_data [59] <= {1'b0, 1'b0};
			T_data [60] <= {1'b0, 1'b1};
			T_data [61] <= {1'b0, 1'b1};
			T_data [62] <= {1'b0, 1'b0};
			T_data [63] <= {1'b0, 1'b0};
			T_data [64] <= {1'b1, 1'b0};
			T_data [65] <= {1'b0, 1'b1};
			T_data [66] <= {1'b0, 1'b0};
			T_data [67] <= {1'b0, 1'b0};
			T_data [68] <= {1'b1, 1'b1};
			T_data [69] <= {1'b0, 1'b1};
			T_data [70] <= {1'b0, 1'b0};
			T_data [71] <= {1'b0, 1'b0};
			T_data [72] <= {1'b0, 1'b0};
			T_data [73] <= {1'b1, 1'b0};
			T_data [74] <= {1'b0, 1'b0};
			T_data [75] <= {1'b0, 1'b0};
			T_data [76] <= {1'b0, 1'b1};
			T_data [77] <= {1'b1, 1'b0};
			T_data [78] <= {1'b0, 1'b0};
			T_data [79] <= {1'b0, 1'b0};
			T_data [80] <= {1'b0, 1'b0};
			T_data [81] <= {1'b1, 1'b0};
			T_data [82] <= {1'b0, 1'b0};
			T_data [83] <= {1'b0, 1'b0};
			T_data [84] <= {1'b1, 1'b0};
			T_data [85] <= {1'b0, 1'b1};
			T_data [86] <= {1'b0, 1'b0};
			T_data [87] <= {1'b0, 1'b0};
			T_data [88] <= {1'b0, 1'b0};
			T_data [89] <= {1'b0, 1'b0};
			T_data [90] <= {1'b0, 1'b0};
			T_data [91] <= {1'b0, 1'b0};
			T_data [92] <= {1'b0, 1'b1};
			T_data [93] <= {1'b0, 1'b0};
			T_data [94] <= {1'b0, 1'b0};
			T_data [95] <= {1'b0, 1'b0};
			T_data [96] <= {1'b0, 1'b0};
			T_data [97] <= {1'b1, 1'b0};
			T_data [98] <= {1'b0, 1'b0};
			T_data [99] <= {1'b0, 1'b0};
			T_data [100] <= {1'b0, 1'b0};
			T_data [101] <= {1'b0, 1'b0};
			T_data [102] <= {1'b0, 1'b0};
			T_data [103] <= {1'b0, 1'b0};
			T_data [104] <= {1'b1, 1'b0};
			T_data [105] <= {1'b0, 1'b1};
			T_data [106] <= {1'b0, 1'b0};
			T_data [107] <= {1'b0, 1'b0};
			T_data [108] <= {1'b0, 1'b0};
			T_data [109] <= {1'b0, 1'b1};
			T_data [110] <= {1'b0, 1'b0};
			T_data [111] <= {1'b0, 1'b0};
			T_data [112] <= {1'b0, 1'b0};
			T_data [113] <= {1'b0, 1'b0};
			T_data [114] <= {1'b0, 1'b0};
			T_data [115] <= {1'b0, 1'b0};
			T_data [116] <= {1'b1, 1'b0};
			T_data [117] <= {1'b0, 1'b0};
			T_data [118] <= {1'b0, 1'b0};
			T_data [119] <= {1'b0, 1'b0};
			T_data [120] <= {1'b0, 1'b0};
			T_data [121] <= {1'b0, 1'b1};
			T_data [122] <= {1'b0, 1'b0};
			T_data [123] <= {1'b0, 1'b0};
			T_data [124] <= {1'b0, 1'b1};
			T_data [125] <= {1'b0, 1'b1};
			T_data [126] <= {1'b0, 1'b0};
			T_data [127] <= {1'b0, 1'b0};
			T_data [128] <= {1'b1, 1'b0};
			T_data [129] <= {1'b0, 1'b1};
			T_data [130] <= {1'b0, 1'b0};
			T_data [131] <= {1'b0, 1'b0};
			T_data [132] <= {1'b1, 1'b1};
			T_data [133] <= {1'b0, 1'b1};
			T_data [134] <= {1'b0, 1'b0};
			T_data [135] <= {1'b0, 1'b0};
			T_data [136] <= {1'b0, 1'b0};
			T_data [137] <= {1'b1, 1'b0};
			T_data [138] <= {1'b0, 1'b0};
			T_data [139] <= {1'b0, 1'b0};
			T_data [140] <= {1'b0, 1'b1};
			T_data [141] <= {1'b1, 1'b0};
			T_data [142] <= {1'b0, 1'b0};
			T_data [143] <= {1'b0, 1'b0};
			T_data [144] <= {1'b0, 1'b0};
			T_data [145] <= {1'b0, 1'b0};
			T_data [146] <= {1'b0, 1'b0};
			T_data [147] <= {1'b1, 1'b1};
			T_data [148] <= {1'b0, 1'b0};
			T_data [149] <= {1'b1, 1'b0};
			T_data [150] <= {1'b1, 1'b0};
			T_data [151] <= {1'b1, 1'b0};
			T_data [152] <= {1'b0, 1'b0};
			T_data [153] <= {1'b0, 1'b0};
			T_data [154] <= {1'b0, 1'b0};
			T_data [155] <= {1'b0, 1'b0};
			T_data [156] <= {1'b0, 1'b0};
			T_data [157] <= {1'b1, 1'b1};
			T_data [158] <= {1'b1, 1'b0};
			T_data [159] <= {1'b0, 1'b0};
			T_data [160] <= {1'b0, 1'b0};
			T_data [161] <= {1'b0, 1'b0};
			T_data [162] <= {1'b0, 1'b0};
			T_data [163] <= {1'b0, 1'b0};
			T_data [164] <= {1'b0, 1'b0};
			T_data [165] <= {1'b0, 1'b0};
			T_data [166] <= {1'b0, 1'b0};
			T_data [167] <= {1'b0, 1'b0};
			T_data [168] <= {1'b0, 1'b0};
			T_data [169] <= {1'b0, 1'b0};
			T_data [170] <= {1'b0, 1'b1};
			T_data [171] <= {1'b0, 1'b0};
			T_data [172] <= {1'b0, 1'b1};
			T_data [173] <= {1'b0, 1'b0};
			T_data [174] <= {1'b0, 1'b0};
			T_data [175] <= {1'b0, 1'b0};
			T_data [176] <= {1'b1, 1'b1};
			T_data [177] <= {1'b0, 1'b0};
			T_data [178] <= {1'b1, 1'b1};
			T_data [179] <= {1'b1, 1'b0};
			T_data [180] <= {1'b0, 1'b1};
			T_data [181] <= {1'b1, 1'b1};
			T_data [182] <= {1'b1, 1'b1};
			T_data [183] <= {1'b1, 1'b0};
			T_data [184] <= {1'b0, 1'b0};
			T_data [185] <= {1'b0, 1'b0};
			T_data [186] <= {1'b0, 1'b0};
			T_data [187] <= {1'b1, 1'b1};
			T_data [188] <= {1'b0, 1'b0};
			T_data [189] <= {1'b1, 1'b0};
			T_data [190] <= {1'b1, 1'b0};
			T_data [191] <= {1'b1, 1'b0};
			T_data [192] <= {1'b0, 1'b0};
			T_data [193] <= {1'b0, 1'b0};
			T_data [194] <= {1'b0, 1'b0};
			T_data [195] <= {1'b0, 1'b0};
			T_data [196] <= {1'b0, 1'b0};
			T_data [197] <= {1'b0, 1'b1};
			T_data [198] <= {1'b0, 1'b0};
			T_data [199] <= {1'b0, 1'b0};
			T_data [200] <= {1'b0, 1'b0};
			T_data [201] <= {1'b0, 1'b0};
			T_data [202] <= {1'b0, 1'b0};
			T_data [203] <= {1'b0, 1'b0};
			T_data [204] <= {1'b0, 1'b0};
			T_data [205] <= {1'b0, 1'b0};
			T_data [206] <= {1'b0, 1'b0};
			T_data [207] <= {1'b0, 1'b0};
			T_data [208] <= {1'b0, 1'b0};
			T_data [209] <= {1'b0, 1'b0};
			T_data [210] <= {1'b0, 1'b0};
			T_data [211] <= {1'b0, 1'b0};
			T_data [212] <= {1'b0, 1'b0};
			T_data [213] <= {1'b0, 1'b0};
			T_data [214] <= {1'b0, 1'b0};
			T_data [215] <= {1'b0, 1'b0};
			T_data [216] <= {1'b0, 1'b0};
			T_data [217] <= {1'b0, 1'b0};
			T_data [218] <= {1'b0, 1'b0};
			T_data [219] <= {1'b0, 1'b0};
			T_data [220] <= {1'b0, 1'b0};
			T_data [221] <= {1'b0, 1'b0};
			T_data [222] <= {1'b0, 1'b0};
			T_data [223] <= {1'b0, 1'b0};
			T_data [224] <= {1'b0, 1'b0};
			T_data [225] <= {1'b0, 1'b0};
			T_data [226] <= {1'b0, 1'b0};
			T_data [227] <= {1'b0, 1'b0};
			T_data [228] <= {1'b0, 1'b0};
			T_data [229] <= {1'b0, 1'b0};
			T_data [230] <= {1'b0, 1'b0};
			T_data [231] <= {1'b0, 1'b0};
			T_data [232] <= {1'b0, 1'b0};
			T_data [233] <= {1'b0, 1'b0};
			T_data [234] <= {1'b0, 1'b0};
			T_data [235] <= {1'b0, 1'b0};
			T_data [236] <= {1'b0, 1'b0};
			T_data [237] <= {1'b0, 1'b0};
			T_data [238] <= {1'b0, 1'b0};
			T_data [239] <= {1'b0, 1'b0};
			T_data [240] <= {1'b0, 1'b0};
			T_data [241] <= {1'b0, 1'b0};
			T_data [242] <= {1'b0, 1'b0};
			T_data [243] <= {1'b0, 1'b0};
			T_data [244] <= {1'b0, 1'b0};
			T_data [245] <= {1'b0, 1'b0};
			T_data [246] <= {1'b0, 1'b0};
			T_data [247] <= {1'b0, 1'b0};
			T_data [248] <= {1'b0, 1'b0};
			T_data [249] <= {1'b0, 1'b0};
			T_data [250] <= {1'b0, 1'b0};
			T_data [251] <= {1'b0, 1'b0};
			T_data [252] <= {1'b0, 1'b0};
			T_data [253] <= {1'b0, 1'b0};
			T_data [254] <= {1'b0, 1'b0};
			T_data [255] <= {1'b0, 1'b0};
			T_data [256] <= {1'b0, 1'b0};
			T_data [257] <= {1'b0, 1'b0};
			T_data [258] <= {1'b0, 1'b0};
			T_data [259] <= {1'b0, 1'b0};
			T_data [260] <= {1'b0, 1'b0};
			T_data [261] <= {1'b0, 1'b0};
			T_data [262] <= {1'b0, 1'b0};
			T_data [263] <= {1'b0, 1'b0};
			T_data [264] <= {1'b0, 1'b0};
			T_data [265] <= {1'b0, 1'b0};
			T_data [266] <= {1'b0, 1'b0};
			T_data [267] <= {1'b0, 1'b0};
			T_data [268] <= {1'b0, 1'b0};
			T_data [269] <= {1'b0, 1'b0};
			T_data [270] <= {1'b0, 1'b0};
			T_data [271] <= {1'b0, 1'b0};
			T_data [272] <= {1'b1, 1'b1};
			T_data [273] <= {1'b0, 1'b0};
			T_data [274] <= {1'b1, 1'b0};
			T_data [275] <= {1'b0, 1'b1};
			T_data [276] <= {1'b1, 1'b0};
			T_data [277] <= {1'b1, 1'b0};
			T_data [278] <= {1'b0, 1'b1};
			T_data [279] <= {1'b1, 1'b0};
			T_data [280] <= {1'b0, 1'b0};
			T_data [281] <= {1'b0, 1'b1};
			T_data [282] <= {1'b1, 1'b0};
			T_data [283] <= {1'b1, 1'b0};
			T_data [284] <= {1'b0, 1'b1};
			T_data [285] <= {1'b1, 1'b1};
			T_data [286] <= {1'b1, 1'b1};
			T_data [287] <= {1'b0, 1'b1};

		end
	end	

	//
	// ETHERNET RX -> UART TX
	//
	
	reg [1:0] R_data[0 : 2**(datab2n-1)-1]; // (R)eceive data, collects data from ETHERNET RX
   reg [1:0] preamble = 1; // 0:data, 1:wait 5, 2:wait non-5, 3:skip 

	reg [datab2n-1:0] idx;
	
	//reg [3:0] cnt = 4'b0;
	reg swap = 0;
	
//	// for every data valid, increment the LEDs by 1
//	always @(posedge crs_dv or negedge nrst)
//	begin
//		if (!nrst)
//		begin
//			led_reg <= 4'b0000; // all off
//		end
//		else
//		begin
//			led_reg <= led_reg + 1;
//		end
//	end
  
	// receive bytes from ETHERNET. 
	// Uses the fast 50Mhz clock from the eth-extension-board.
	always @(posedge i_clock)
	begin
	
		if (!nrst)
		begin
			swap <= 0;
			//led_reg <= 4'b0000; // all on
		end
		else
		begin
	  
			if (crs_dv)
			begin // data valid

				//led_reg <= 4'b0000; // on
				
				eth_bytes_received <= 0;
				
				// charge up only once action which is executed as soon as data valid goes 
				// low which menas one frame has been received
				swap <= 1;				
				 
				if (preamble == 2'd1)
				begin
				
					// preamble == 2'd1 is the state where the first preamble (01) pair is detected
					// If (01) is seen, transition to preamble == 2'd2
					// 5-pattern
					//if ({rx[0], rx[1]} == 2'b01)
					if ({rx[1], rx[0]} == 2'b01)
					begin
						preamble <= 2;
					end
					
				end
				else if (preamble == 2'd2)
				begin
				
					// preamble == 2'd2 is the state, where the end of the SFD byte is awaited
					// If the end is detected, either skip data if configured or immediately go to preamble == 2'd0
					// end of 5-pattern, SFD pattern
					//if ({rx[0], rx[1]} != 2'b01) 
					if ({rx[1], rx[0]} == 2'b11) 
					begin
						if (skip_bytes)
						begin
							idx <= 1 - 4 * skip_bytes; // skip further bytes
							preamble = 3;
						end
						else // nothing to skip, directly to data
						begin
							idx <= 0;
							preamble <= 0;
						end
					end
					
				end
				else if (preamble == 2'd3) // skip some data
				begin
				
					// preamble == 2'd3 is the state where bits are skipped
				
					if (idx == 0)
					begin
						preamble <= 0;
					end
					else
					begin
						// count skip
						idx <= idx + 1;
					end
						
				end
				else 
				begin
				
					// preamble == 2'd0 is the state where payload data is consumed
				
					// preamble=0, store data
					// preamble is over, start storing data of the ethernet frame
				
					if (idx[datab2n-1] == 0)
					begin
						//R_data[idx[datab2n-2:0]] <= {rx[0], rx[1]};
						R_data[idx[datab2n-2:0]] <= {rx[1], rx[0]};
						
						// one pair of bits has been received
						idx <= idx + 1;
					end
					
				end

			end
			else // not data valid
			begin
			
				//led_reg <= 4'b1111; // off
				
				// perform the "once only" action here when data valid goes low
				// which means an entire frame has been received
				if (swap == 1)
				begin
				
					// turn off once only action
					swap <= 0;
					
					//
					// only once operations here:
					//
					
					//led_reg <= led_reg + 1;
					
					// compute the amount of bytes received
					// since bit-pairs are counted in idx, the amount of bytes is division by 4 instead of 8
					eth_bytes_received = idx / 4;
					
					// The UART TX will start operating as soon as data valid goes low.
					// The UART TX will monitor data valid independently.
					// This means that this state machine does not set any extra bits to 
					// start the UART transmission
				
				end
				
				// go back to state 2'd1 - preamble == 2'd1 is the state where the first preamble (01) pair is detected
				preamble <= 2'd1;
				
			end
		
		end
	end
	
	//
	// UART driver - sends bytes from R_data into the TX UART
	//
	
	reg [7:0] eth_bytes_received = 8'b0;
	reg [7:0] uart_bytes_transmitted = 8'b0;
	
	reg [3:0] uart_tx_driver_state = 4'b1000;
	
	// send bytes to the UART. Uses the fast 50Mhz clock from the eth-extension-board
	always @(posedge clk)
	begin
	
		case (uart_tx_driver_state)
		
			4'b1000:
			begin
				// state - wait for incoming eth message (DV)
				
				uart_tx_driver_state <= 4'b1000;
				
				if (crs_dv == 1'b1)
				begin
					uart_tx_driver_state <= 4'b1001;
				end
				
			end
			
			4'b1001:
			begin
				// state - wait for full packet reception (dv == 0 after it has been 1)
				// now the system knows that the ethernet frame has been buffered inside R_data
				// and that the length is contained inside uart_bytes_transmitted
				
				uart_tx_driver_state <= 4'b1001;
			
				uart_bytes_transmitted <= 0;
				
				if (crs_dv == 1'b0)
				begin
					uart_tx_driver_state <= 4'b0000;
				end
			end
		
			4'b0000:
			begin
				// state - idle - check if there is the need to transmit another byte over UART
				
				// next state
				uart_tx_driver_state <= 4'b0000;
				
				// if data is available and has not been transmitted over UART yet
				if (eth_bytes_received > 8'b0)
				begin
					if (uart_bytes_transmitted < eth_bytes_received)
					begin
						// next state
						uart_tx_driver_state <= 4'b0001;
					end
					else
					begin
						// stop the UART
						uart_tx_data <= 8'b0;
						uart_tx_data_valid_reg <= 0;
						
						// next state (back to wait for incoming ethernet)
						uart_tx_driver_state <= 4'b1000;
					end
				end
				else
				begin
					// stop the UART
					uart_tx_data <= 8'b0;
					uart_tx_data_valid_reg <= 0;
					
					// next state (back to wait for incoming ethernet)
					uart_tx_driver_state <= 4'b1000;
				end
				
			end
			
			4'b0001:
			begin
				// state - send a byte
				
				// provide a byte
				uart_tx_data <= { R_data[uart_bytes_transmitted*4 + 3], R_data[uart_bytes_transmitted*4 + 2], R_data[uart_bytes_transmitted*4 + 1], R_data[uart_bytes_transmitted*4 + 0] };

				// give the UART the command to start transmission
				uart_tx_data_valid_reg <= 1;
				
				// next state
				uart_tx_driver_state <= 4'b0010;
			end
			
			4'b0010:
			begin
				// state - wait for UART to become active
				
				uart_tx_driver_state <= 4'b0010;
				
				if (uart_tx_active == 1'b1)
				begin
					// next state - wait for UART to be done transmitting a byte
					uart_tx_driver_state <= 4'b0011;
				end
			end
			
			4'b0011:
			begin
				// state - wait for UART to be done with the byte
				
				uart_tx_driver_state <= 4'b0011;
				
				if (uart_tx_done == 1'b1)
				begin
					// next state - increment index
					uart_tx_driver_state <= 4'b0100;
				end
			end
			
			4'b0100:
			begin
				// state - one byte successfully transmitted by the UART
				
				// one byte transferred over UART
				uart_bytes_transmitted <= uart_bytes_transmitted + 8'b1;
				
				// next state - check if another byte needs sending
				uart_tx_driver_state <= 4'b0000;
			end
			
		endcase
		
	end
	
//		if (eth_bytes_received > 8'b0)
//		begin
//		
//			if (uart_bytes_transmitted < eth_bytes_received)
//			begin			
//			
//				if ((uart_bytes_transmitted == 8'b0) || ((uart_tx_active == 1'b0) && (uart_tx_done == 1'b1)))
//				begin
//					// byte to transmit
//					//uart_tx_data <= 8'b11111111;
//					//uart_tx_data <= eth_bytes_received;
//					uart_tx_data <= uart_bytes_transmitted;
//
//					// give the UART the command to start transmission
//					uart_tx_data_valid_reg <= 1;
//					
//					// one byte transferred
//					uart_bytes_transmitted <= uart_bytes_transmitted + 8'b1;
//				end
//			end
//			else
//			begin
//				uart_tx_data <= 8'b0;
//				uart_tx_data_valid_reg <= 0;
//			end
//			
//		end
//		else
//		begin
//			uart_tx_data <= 8'b0;
//			uart_tx_data_valid_reg <= 0;
//			
//			uart_bytes_transmitted <= 0;
//		end
//		
// end
	
	
	//
	// UART test driver
	//
	
//	reg [31:0] counter2;
//	
//	// UART test
//	always @(posedge clk)
//	begin
//	
//		if(!nrst) 
//		begin
//			counter2 <= 32'd0;
//		end
//			
//		if (counter2 == 50000000)
//		begin
//			counter2 <= 0;
//			
//			// blink the LED
//			//led[0] <= ~led[0];
//			
//			// UART start transmission
//			// send current byte over the UART
//			uart_tx_data_valid_reg <= 1;
//			
//			// increment the byte so we can observe a change in the terminal emulator
//			uart_tx_data <= uart_tx_data + 8'h01;
//		end
//		else
//		begin			
//			counter2 <= counter2 + 32'd1;
//			
//			// UART disable transmission once done
//			if (uart_tx_done == 1) 
//			begin
//				uart_tx_data_valid_reg <= 0;
//			end
//		end
//		
//	end
	
	//
	// UART driver, send character when crs_dv is asserted
	//
	
//	always @(posedge crs_dv or negedge nrst)
//	begin
//		if (!nrst)
//		begin
//			uart_tx_data_valid_reg <= 0;
//		end
//		else
//		begin
//			uart_tx_data_valid_reg <= 1;
//		end
//	end

////	//
////	// UART driver
////	//
////	
////	always @(posedge clk_10)
////	begin
////		if (!nrst)
////		begin
////		end
////		else
////		begin
////		end
////	end

//	//
//	// UART Driver that transfers a byte array
//	//
//	
//	reg       uart_transmit_start = 0;
//	reg       uart_transmit_finished = 0;
//	reg [7:0] uart_transmit_idx = 8'b0;
//	
//	//reg       st = 0;
//	
//	always @(posedge clk_10)
////	always @(posedge clk)
//	begin
//	
//		if (!nrst)
//		begin
//			uart_transmit_idx <= 8'b0;
//			uart_transmit_finished <= 1;
//			//st <= 0;
//			//led_reg <= 4'b0001;
//		end
//		else
//		begin
//		
//			if (uart_transmit_start == 1)
//			begin
//			
//				// ethernet packet received, transmit over UART
//			
//				//led_reg <= 4'b0000; // LEDS on
//				
//				uart_transmit_finished <= 0;
//				
//				if (uart_transmit_idx < rx_idx)
//				begin
//					
//					if (uart_tx_done == 1)
//					begin
//					
//						//if (st == 1)
//						//begin						
//						   // next byte
//							uart_transmit_idx <= uart_transmit_idx + 8'b1;
//							
//							uart_tx_data_valid_reg <= 0;
//						
//						//	st <= 0;
//						//end
//						
//					end
//					else
//					begin
//					
//						//if (st == 0)
//						//begin
//							// give the UART a byte to transmit
//							uart_tx_data <= rx_byte_array[uart_transmit_idx];
//							
//							// give the UART the command to start transmission
//							uart_tx_data_valid_reg <= 1;
//							
//							//st <= 1;
//						//end
//						
//					end
//					
//				end
//				else
//				begin
//				
//					// stop the UART
//					uart_tx_data_valid_reg <= 0;
//					
//					// signal end of array transmission
//					uart_transmit_finished <= 1;
//					
//					//st <= 0;
//					
//				end
//				
//			end
//			else
//			begin
//			
//				// ethernet packet transmitted over UART, stop transmitting
//			
//				//led_reg <= 4'b1111;  // LEDS off
//			
//				// no data for the UART
//				uart_tx_data <= 0;
//			
//				// stop the UART
//				uart_tx_data_valid_reg <= 0;
//					
//				// reset
//				uart_transmit_idx <= 0;
//				
//				uart_transmit_finished <= 1;
//				
//				//st <= 0;
//				
//			end
//		end
//	end
	
	//assign uart_tx_data_valid = crs_dv;
	
	// local parameters declaration
	localparam 	[2:0] RX_IDLE       =    3'b111;
	localparam 	[2:0] RX_BUS_0      =    3'b000;
	localparam 	[2:0] RX_BUS_1      =    3'b001;
	localparam 	[2:0] RX_BUS_2      =    3'b010;
	localparam 	[2:0] RX_BUS_3      =    3'b011;
	localparam 	[2:0] RX_BUS_4      =    3'b100;
	localparam 	[2:0] RX_BUS_1_INIT =    3'b101;
	localparam 	[2:0] RX_STOP       =    3'b110;
	
	reg     		[2:0]       r_RX_state;
	
	//reg     		[7:0]       rx_byte;
	
	
//	// https://stackoverflow.com/questions/3011510/how-to-declare-and-use-1d-and-2d-byte-arrays-in-verilog
//	// Verilog thinks in bits, so reg [7:0] a[0:3] will give you a 4x8 bit array (=4x1 byte array). 
//	// You get the first byte out of this with a[0]. The third bit of the 2nd byte is a[1][2].
//	
//	reg [31:0] rx_idx;
//	//reg [1:0] rx_byte_array [0:20];
//	reg [799:0] rx_byte_array;
	
	
	
//	always @(posedge clk or negedge nrst)
//	begin
//		if (!nrst)
//		begin
//			//uart_transmit_start <= 0;
//			rx_idx <= 32'b0;
//		end
//		else
//		begin
//			if (crs_dv == 1) begin
//				rx_byte_array[rx_idx] = rx;
//				rx_idx <= rx_idx + 32'b1;
//				
//			end
//		   else
//			begin
//				//uart_transmit_start <= 1;
//				
//				if (uart_transmit_finished == 1)
//				begin
//					rx_idx <= 32'b0;
//				end
//				
//			end
//			
//			
//		end
//	end
//	
//	always @(posedge clk or negedge nrst)
//	begin
//		if (!nrst)
//		begin
//			r_RX_state <= RX_IDLE;
//		end
//		else
//		begin
//		
//			case (r_RX_state)
//			
//				RX_IDLE:
//				begin
//					if (crs_dv == 1) 
//					begin
//						uart_transmit_start <= 0;
//					
//						r_RX_state <= RX_BUS_0;
//					end
//				end
//				
//				RX_BUS_0:
//				begin
//				
//					if (crs_dv == 0) 
//					begin
//						uart_transmit_start <= 1;
//					
//						r_RX_state <= RX_IDLE;
//					end
//					
//				end				
//				
//			endcase
//			
//		end
//	end
	
	
	
//	// https://stackoverflow.com/questions/3011510/how-to-declare-and-use-1d-and-2d-byte-arrays-in-verilog
//	// Verilog thinks in bits, so reg [7:0] a[0:3] will give you a 4x8 bit array (=4x1 byte array). 
//	// You get the first byte out of this with a[0]. The third bit of the 2nd byte is a[1][2].
//	reg [7:0] rx_byte_array [0:99];
//	
//	
//	reg [7:0] rx_idx;
//	
//	//always @(posedge clk or negedge nrst)
//	//always @(posedge clk)
//	always @(posedge i_clock)
//	begin
//		if (!nrst)
//		begin
//			//uart_tx_data_valid_reg 	<= 0;
//			uart_transmit_start 		<= 0;
//			rx_idx 						<= 8'b0;
//			
//			r_RX_state       			<= RX_IDLE;
//		end
//		else
//		begin
//			//uart_tx_data_valid_reg <= 1;
//			
//			case (r_RX_state)
//			
//				// the idle state performs two actions at once.
//				// It resets the system and it consume the first two bits
//				// Therefore it performs the state RX_BUS_0's task and skips RX_BUS_0 for RX_BUS_1 directly
//				RX_IDLE:
//				begin
//					led_reg <= 4'b1111;
//					
//					uart_transmit_start <= 0;
//					
//					rx_idx <= 8'b0;
//					
//					if (crs_dv == 1) 
//					begin
//						rx_byte_array[rx_idx][1:0] <= rx;						
//						r_RX_state <= RX_BUS_1;
//					end
//					else
//					begin
//						r_RX_state <= RX_IDLE;
//					end
//				end
//				
//				RX_BUS_0:
//				begin
//					led_reg <= 4'b1110;
//					
//					rx_byte_array[rx_idx][1:0] <= rx;
//					
//					if (crs_dv == 1) 
//					begin
//						uart_transmit_start <= 0;
//						r_RX_state <= RX_BUS_1;
//					end
//					else
//					begin
//						uart_transmit_start <= 1;
//						r_RX_state <= RX_BUS_1_INIT;
//					end					
//				end
//				
//				RX_BUS_1:
//				begin
//					led_reg <= 4'b1101;
//					
//					rx_byte_array[rx_idx][3:2] <= rx;
//					
//					if (crs_dv == 1) 
//					begin
//						uart_transmit_start <= 0;
//						r_RX_state <= RX_BUS_2;
//					end
//					else
//					begin
//						uart_transmit_start <= 1;
//						r_RX_state <= RX_BUS_1_INIT;
//					end
//				end
//				
//				RX_BUS_2:
//				begin
//					led_reg <= 4'b1100;
//					
//					rx_byte_array[rx_idx][5:4] <= rx;					
//					
//					if (crs_dv == 1) 
//					begin
//						uart_transmit_start <= 0;
//						r_RX_state <= RX_BUS_3;
//					end
//					else
//					begin
//						uart_transmit_start <= 1;
//						r_RX_state <= RX_BUS_1_INIT;
//					end					
//				end
//				
//				RX_BUS_3:
//				begin
//					led_reg <= 4'b1011;
//					
//					rx_byte_array[rx_idx][7:6] <= rx;
//					
//					if (crs_dv == 1) 
//					begin
//						rx_idx <= rx_idx + 8'b1;
//						uart_transmit_start <= 0;
//						
//						r_RX_state <= RX_BUS_0; // start to consume the next byte
//					end
//					else
//					begin
//						uart_transmit_start <= 1;
//						r_RX_state <= RX_BUS_1_INIT;
//					end
//				end
//				
////				RX_BUS_4:
////				begin
////					uart_tx_data_valid_reg 	<= 0;
////					r_RX_state <= RX_BUS_1_INIT;
////				end
//				
//				RX_BUS_1_INIT:
//				begin
//					led_reg <= 4'b1010;
//					//led_reg <= 4'b0000;
//					
//					// remain in this state as long as the UART transmits data
//					if (uart_transmit_finished == 1)
//					begin
//						uart_transmit_start <= 0;
//						
//						r_RX_state <= RX_STOP;
//					end
//					else
//					begin
//						uart_transmit_start <= 1;
//					
//						r_RX_state <= RX_BUS_1_INIT;
//					end
//				end
//				
//				RX_STOP:
//				begin
//					led_reg <= 4'b1001;
//					uart_transmit_start <= 0;
//					
//					r_RX_state <= RX_IDLE;
//				end
//				
//			endcase
//			
//		end
//	end
   
	//
	// UART TX
	//
	
	// for the UART transceiver module, the 50 Mhz Clock does not work!
	// The clock needs to be converted down! 10 MHz works!
	wire clk_10;
	Clock_divider(clk, clk_10);
	
	// set to 1 if data is ready for transmission
	wire uart_tx_data_valid;
	reg uart_tx_data_valid_reg;
	assign uart_tx_data_valid = uart_tx_data_valid_reg;
	
	// a byte of data to transmit (currently driven by the UART test driver)
	reg[7:0] uart_tx_data;
	
	wire uart_tx_active;
	
	wire uart_tx_done;
	
	transmitter uart_tx(
      .i_Clock(clk_10), // 50 Mhz clock divided down to 10 Mhz because at full 50 Mhz the UART does not work
      .i_Tx_DV(uart_tx_data_valid), // from test driver
      .i_Tx_Byte(uart_tx_data), // from test driver
      .o_Tx_Active(uart_tx_active), // not connected
      .o_Tx_Serial(o_uart_tx_pin), // this is the port pin of the design towards the UART output
      .o_Tx_Done(uart_tx_done) // to test driver
	);
	
/*
	//
	// Ethernet
	//
	
	// source of static data to write into the transmission fifo
	static_data static_data
	(
		.i_clock_data(w_clock_data),
		.i_reset(w_reset),
		.o_data_out(w_data_8bits)
	);

	// read from the fifo and send over the ethernet phy
	fifo_read_control read_control_inst
	(
		.i_clock(w_clock),
		.i_reset(w_reset),
		.i_data_full(w_data_full),
		.o_addr_read(w_addr_read),
		.o_TX_enab(o_TX_enab), // ETHERNET-TX transmit enable pin
		.o_reading_done(),
		.o_led()
	);
	
	// write data into the fifo so that this data can be transmitted
	fifo_write_control write_control_inst
	(
		.i_clock(w_clock),
		.i_clock_data(w_clock_data),
		.i_reset(w_reset),
		.i_data_in(w_data_8bits),
		.o_data_write(w_data_2bits), 	// <--------
		.o_addr_write(w_addr_wire),	//
		.o_enab_write(w_enab_write),	//
		.o_data_empt(),					//
		.o_data_full(w_data_full),		//
	);
	
	// fifo for the transmission direction
	fifo fifo_inst
	(
		.i_clock(w_clock),
		.i_data_in(w_data_2bits), // -----------
		.i_addr_write(w_addr_wire),
		.i_enab_write(w_enab_write),
		.i_addr_read(w_addr_read),
		.o_data_out(o_data_out) // ETHERNET-TX onto the phy's to bit interface TX[1:0]
	);
*/
	  
endmodule   
    