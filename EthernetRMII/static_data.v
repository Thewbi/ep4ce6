`include "ethernet_define.v"

module static_data
(
	input i_clock_data,
	input i_reset,
		  
	output [7:0] o_data_out
);

	// register declaration
	reg [7:0] r_status_data;
	reg [7:0] r_data_out;
	 
	// increase status register each rising edge of i_clock_data
	always @(posedge i_reset or posedge i_clock_data)
	begin
	
		if (i_reset)
		begin
			r_status_data <= 8'b0;
			r_data_out    <= 8'b0;
		end
		else
		begin
		
			r_status_data <= r_status_data + 1;
			
			// ater the last state, go back to state 0
			if (r_status_data >= 8'd71)
			begin
				r_status_data <= 8'b0;
			end
			
			// 55 55 55 55 55 55 55 D5 00 10 A4 7B EA 80 00 12 34 56 78 90 08 00 45 00 00 2E B3 FE 00 00 80 11 05 40 C0 A8 00 2C C0 A8 00 04 04 00 04 00 00 1A 2D E8 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 B3 31 88 1B
			
			// https://www.fpga4fun.com/10BASE-T2.html
			//
			// [55 55 55 55 55 55 55 D5] [00 10 A4 7B EA 80] [00 12 34 56 78 90] [08 00] 
			// [45 00] [00 2E] [B3 FE] [00 00] [80] [11] [05 40] [C0 A8 00 2C] 
			// [C0 A8 00 04] [04 00] [04 00] [00 1A] [2D E8] 
			// [00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11]
			// [B3 31 88 1B]
			
//			Ethernet preamble/SFD (synchronizer): 55 55 55 55 55 55 55 D5
//			Ethernet destination address: 00 10 A4 7B EA 80
//			Ethernet source address: 00 12 34 56 78 90
//			Ethernet type: 08 00 (=IP)
//			IP header: 45 00 00 2E B3 FE 00 00 80
//			IP protocol: 11 (=UDP)
//			IP checksum: 05 40
//			IP source (192.168.0.44): C0 A8 00 2C
//			IP destination (192.168.0.4): C0 A8 00 04
//			UPD source port (1024): 04 00
//			UPD destination port (1024): 04 00
//			UDP payload length (18): 00 1A
//			UPD checksum: 2D E8
//			UDP payload (18 bytes): 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11
//			Ethernet checksum: B3 31 88 1B

			case(r_status_data)

				// REDDIT Post: https://www.reddit.com/r/FPGA/comments/s56dtt/using_fpga_as_a_mac_to_control_a_phy_by_rmii/
			   // https://cpudev.org/wiki/Ethernet
				// preamble (7 byte preamble: 01010101, followed by 1 byte Start Frame Delimiter (SFD) 11010101)
				// the bits need to be sent LSB first, MSB last
				8'b00000000 : r_data_out <= `PREAMBLE; // 0x55 (01 01 01 01)
				8'b00000001 : r_data_out <= `PREAMBLE; // 0x55
				8'b00000010 : r_data_out <= `PREAMBLE; // 0x55
				8'b00000011 : r_data_out <= `PREAMBLE; // 0x55				
				8'b00000100 : r_data_out <= `PREAMBLE; // 0x55
				8'b00000101 : r_data_out <= `PREAMBLE; // 0x55
				8'b00000110 : r_data_out <= `PREAMBLE; // 0x55				
				8'b00000111 : r_data_out <= `PREAMBLE_SDF; // 0xD5
				
				// 8 byte

				// MAC ADDRESSES
				// MAC DESTINATION ADDRESS
				8'b00001000 : r_data_out <= `TX_DST_ADDR_1; // FF
				8'b00001001 : r_data_out <= `TX_DST_ADDR_2; // FF
				8'b00001010 : r_data_out <= `TX_DST_ADDR_3; // FF
				8'b00001011 : r_data_out <= `TX_DST_ADDR_4; // FF
				8'b00001100 : r_data_out <= `TX_DST_ADDR_5; // FF
				8'b00001101 : r_data_out <= `TX_DST_ADDR_6; // FF
				// MAC SOURCE ADDRESS
				8'b00001110 : r_data_out <= `TX_SRC_ADDR_1; // 00
				8'b00001111 : r_data_out <= `TX_SRC_ADDR_2; // 00
				8'b00010000 : r_data_out <= `TX_SRC_ADDR_3; // 00
				8'b00010001 : r_data_out <= `TX_SRC_ADDR_4; // 00
				8'b00010010 : r_data_out <= `TX_SRC_ADDR_5; // 00
				8'b00010011 : r_data_out <= `TX_SRC_ADDR_6; // 00
				
				// 20 byte

				// ETHERNET TYPE
				8'b00010100 : r_data_out <= `LENGTH_TYPE_IP_1; // 08
				8'b00010101 : r_data_out <= `LENGTH_TYPE_IP_2; // 00
				
				// 22 byte

				// VERSION LENGTH + DIFFERENCE FIELD
				8'b00010110 : r_data_out <= `VER_LENGTH; // 45
				8'b00010111 : r_data_out <= `DIFF_FIELD; // 00
				
				// 24 byte

				// TOTAL LENGTH
				8'b00011000 : r_data_out <= `TOTAL_LENGTH_1; // 00
				8'b00011001 : r_data_out <= `TOTAL_LENGTH_2; // 2E
				
				// 26 byte

				// ARBITARY NUMBER
				8'b00011010 : r_data_out <= `IDENTIFICATION_1; // B3
				8'b00011011 : r_data_out <= `IDENTIFICATION_2; // FE
				
				// 28 byte

				// FLAG + FRAGMENT
				8'b00011100 : r_data_out <= `FLAG_FRAGMENT_1; // 00
				8'b00011101 : r_data_out <= `FLAG_FRAGMENT_2; // 00
				
				// 30 byte

				// TIME LIVE
				8'b00011110 : r_data_out <= `TIME_LIVE; // 80
				
				// 31 byte

				// define IP protocol
				8'b00011111 : r_data_out <= `IP_PROTOCOL; // 11
				
				// 32 byte

				// IP checksum
				8'b00100000 : r_data_out <= `IP_CHECKSUM_1; // 05
				8'b00100001 : r_data_out <= `IP_CHECKSUM_2; // 40
				
				// 34 byte

				// IP SOURCE ADDRESS // 192.168.0.44
				8'b00100010 : r_data_out <= `IP_SOURCE_ADDR_1; // 8'hC0
				8'b00100011 : r_data_out <= `IP_SOURCE_ADDR_2; // 8'hA8
				8'b00100100 : r_data_out <= `IP_SOURCE_ADDR_3; // 8'h00
				8'b00100101 : r_data_out <= `IP_SOURCE_ADDR_4; // 8'h2C
				
				// 38 byte

				// IP SEDTINATION ADDRESS // 192.168.0.4
				8'b00100110 : r_data_out <= `IP_DST_ADDR_1; // 8'hC0
				8'b00100111 : r_data_out <= `IP_DST_ADDR_2; // 8'hA8
				8'b00101000 : r_data_out <= `IP_DST_ADDR_3; // 8'h00
				8'b00101001 : r_data_out <= `IP_DST_ADDR_4; // 8'h04
				
				// 42 byte

				// UDP SOURCE PORT // 1024
				8'b00101010 : r_data_out <= `UDP_SRC_PORT_1; // 8'h04
				8'b00101011 : r_data_out <= `UDP_SRC_PORT_2; // 8'h00

				// UDP DESTINATION PORT 
				8'b00101100 : r_data_out <= `UDP_DST_PORT_1; // 8'h04
				8'b00101101 : r_data_out <= `UDP_DST_PORT_2; // 8'h00

				// UDP PAYLOAD LENGTH = UDP length + UDP port + UDP checksum +  UDP payload (not ethernet checksum)
				8'b00101110 : r_data_out <= `UDP_LENGTH_1; // 8'h00
				8'b00101111 : r_data_out <= `UDP_LENGTH_2; // 8'h1A

				// UDP CHECKSUM
				8'b00110000 : r_data_out <= `UDP_CHECKSUM_1; // 8'h2D
				8'b00110001 : r_data_out <= `UDP_CHECKSUM_2; // 8'hE8
				
				// 50 byte

				// UDP PAYLOAD (18 byte)
				8'b00110010 : r_data_out <= `UDP_PAYLOAD_1;  // 8'h00
				8'b00110011 : r_data_out <= `UDP_PAYLOAD_2;  // 8'h01
				8'b00110100 : r_data_out <= `UDP_PAYLOAD_3;  // 8'h02
				8'b00110101 : r_data_out <= `UDP_PAYLOAD_4;  // 8'h03
				8'b00110110 : r_data_out <= `UDP_PAYLOAD_5;  // 8'h04
				8'b00110111 : r_data_out <= `UDP_PAYLOAD_6;  // 8'h05
				8'b00111000 : r_data_out <= `UDP_PAYLOAD_7;  // 8'h06
				8'b00111001 : r_data_out <= `UDP_PAYLOAD_8;  // 8'h07
				8'b00111010 : r_data_out <= `UDP_PAYLOAD_9;  // 8'h08
				8'b00111011 : r_data_out <= `UDP_PAYLOAD_10; // 8'h09
				8'b00111100 : r_data_out <= `UDP_PAYLOAD_11; // 8'h0A
				8'b00111101 : r_data_out <= `UDP_PAYLOAD_12; // 8'h0B
				8'b00111110 : r_data_out <= `UDP_PAYLOAD_13; // 8'h0C
				8'b00111111 : r_data_out <= `UDP_PAYLOAD_14; // 8'h0D
				8'b01000000 : r_data_out <= `UDP_PAYLOAD_15; // 8'h0E
				8'b01000001 : r_data_out <= `UDP_PAYLOAD_16; // 8'h0F
				8'b01000010 : r_data_out <= `UDP_PAYLOAD_17; // 8'h10
				8'b01000011 : r_data_out <= `UDP_PAYLOAD_18; // 8'h11
				
				// 68 byte

//				// CRC 32
//				8'b01000100 : r_data_out <= `ETHER_CHECKSUM_1; // 8'hB3
//				8'b01000101 : r_data_out <= `ETHER_CHECKSUM_2; // 8'h31
//				8'b01000110 : r_data_out <= `ETHER_CHECKSUM_3; // 8'h88
//				8'b01000111 : r_data_out <= `ETHER_CHECKSUM_4; // 8'h1B
				
				// CRC 32 - E3 33 5C 8A
				8'b01000100 : r_data_out <= `ETHER_CHECKSUM_1; // 8'hE3
				8'b01000101 : r_data_out <= `ETHER_CHECKSUM_2; // 8'h33
				8'b01000110 : r_data_out <= `ETHER_CHECKSUM_3; // 8'h5C
				8'b01000111 : r_data_out <= `ETHER_CHECKSUM_4; // 8'h8A
				
				// 72 byte

			endcase
		end
	end
    
	assign o_data_out = r_data_out;
	
endmodule
