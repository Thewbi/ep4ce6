# EP4EC6

## Install Quartus II

## LED Example

## Flashing the bitstream

First you have to install a driver for the USB Blaster.
Once Quartus II is installed, the driver is available in the folder C:\altera\13.1\quartus\drivers\usb-blaster
Windows 11 will not accept this driver unless you disable memory integrity in the core isolation menu:
Into the start menu, type "core isolation", open the menu. Turn off "Memory Integrity" and restart your PC.
After restarting your PC, the USB Blaster should show up in the Device Manager and there should be no warnings
in the drivers settings of that device. You want to see the text: "This device is working properly."

Connect the USB-Blaster to the FPGA-Board.
Open the programmer using the button in the toolbar or the very last entry in the list of compilation steps.
Then, inside the programmer dialog, first click on "Hardware Setup..."
The Hardware Setup Dialog has to list the USB blaster automatically. Double click it, so it is selected in the
top input field and click on "Close"

Add Device: Cyclone IV E > EP4CE6E22
The programmer will detect the EP4CE6E22 automatically.

It will also preselect the LED_4.sof file.

Once the USB Blaster Hardware is detected and also the .sof file is selected, the Start button should light up.

The design is not burned onto the FPGA and not written into any flash. It is just copied into some volatile
memory. This means after a powercycle, the factory example is back.

A simple change is to make the LEDS blink faster by changing the LED_4 file and the line 

```
else if (counter == 1250000) begin
```

to 

```
else if (counter == 2500000) begin
```

or 

```
else if (counter == 625000) begin
```

Then recompile the project and use the programmer dialog to upload the .sof bitstream to the FPGA.
The LED pattern should execute a lot faster now using 625000 and slower using 2500000.

TODO: explain where to retrieve the official examples.
They are currently stored here: C:\Users\lapto\Downloads\EP4CE6-Verilog-VHDL





# Creating a new Project

Family: Cyclone IV E 
PinCount: 144

Name: EP4CE6E22C8, CoreVoltage: 1.2V, LEs: 6272, User I/Os: 92, Memory Bits: 276480, 

Once the project is created, you need to add at least one verilog file and make
that verilog file the top level entity by switching to the Files tabe, opening
the context menu on the verilog file and selecting "Set as Top-Level Entity".

Next you need to specify in/out pin assignments so that the correct pins are
accessed by your source code. Run "Analysis & Synthesis" then from the "Assignments" 
menu, selects "Pin Planner".

For the waveshare CoreEP4CE6 and the base board, some usfull pinouts are:

```
clk,    Input, PIN_23, 	I/O Bank = 1, 3.3V LVTTL (default), 8mA
led[3], Bidir, PIN_3,	I/O Bank = 1, 3.3V LVTTL (default), 8mA
led[2], Bidir, PIN_7,	I/O Bank = 1, 3.3V LVTTL (default), 8mA
led[1], Bidir, PIN_10,	I/O Bank = 1, 3.3V LVTTL (default), 8mA
led[0], Bidir, PIN_11,	I/O Bank = 1, 3.3V LVTTL (default), 8mA
nrst,   Input, PIN_125, I/O Bank = 7, 3.3V LVTTL (default), 8mA
```

Full list: https://www.waveshare.com/w/upload/0/01/EP4CE6-pin-conf.txt



# Motherboard: http://waveshare.com/dvk601.htm

http://waveshare.com/dvk601.htm
https://www.waveshare.com/wiki/DVK601



# USB3300

HINT: The USB3300 extension board from waveshare has two 5V pins! I am not sure if
these pins are 5V inputs or if they output 5V should you connect the extension board
to a laptop using a USB cable for example!
Connecting 5V to a FPGA is the FPGA's sure death or irreparable damage is caused which renders
your FPGA useless. Therefore I suggest to not connect these 5V pins to the FPGA at all
unless you know exactly what you are doing! (I have just bent the pins to the side so that they
do not plug into the female header of the motherboard!).

According to this discussion: https://electronics.stackexchange.com/questions/177871/waveshare-usb3300-board-with-stm32f429
the 5V pins are there to power the USB port which means that it will provide 5V to the device connected to the USB port.
The voltage on the USB port is called VBUS in USB-speak. After talking to an FPGA expert, there is a chance, that the
5V pins are used to supply VBUS from an external power supply and that the 5V are routed through the USB3300 but not
to the FPGA. This might also means that the USB3300 sinks the voltage into the ground plane without the FPGA getting
into contact with the 5V. I am not sure if this theory is correct or not.

I asked a question on stack overflow: https://electronics.stackexchange.com/questions/753447/can-the-waveshare-usb3300-5v-pins-damage-an-fpga
A nice user answered. The USB3300 extension board contains extended power switches for VBUS. When running the
USB3300 over the USB-A connector it acts as a perihperhal. The switches are then blocking the 5V going out the ULPI side
and therefore the FPGA should not get in contact with 5V. I have bent the 5V pins and not connected them to the FPGA for
extended safety. I have not tested the OTG scenario but the perihperal scenario does not damage the FPGA with bend / not connected
5V pins while being powered by a Microsoft Windows Laptop!

![image info](res/1754727452126.jpg)

For the following, we first need to understand how the I/O ports are labeled!

HINT: I never understood how the labels given in the schematics can be translated to pin names in the Quartus II
Pin Planner! The only thing that really worked was to put male dupont wires into the female headers and use
an oscilloscope to measure the pins toggle. I used a verilog test application to toggle each female connector
on the header one by one and noted down, which pins have which Pin on the FPGA EP4CE6. A very good tip is to 
turn the USB3300 ULPI board around and look at the silk screen of the PCB. The silk screen has the pin function
printed next to each pin. Here is the mapping I uncovered for the 16I/Os_1 header.

```
PIN49 - Data4
PIN50 - clkout
PIN51 - Data5
PIN52 - DIR
```

Locking at the schematic of the Motherboard DVK601 (https://www.waveshare.com/w/upload/3/3c/DVK601-Schematic.pdf),
we can see that the two 16I/Os_1 and 16I/Os_2 do have 20 pins in total of which only 16 carry signals that
the FPGA can consume or produce. The four other pins are GND and Voltage pins. The four GND and Voltage pins
have no name on the trace. This means that these four pins are not mappable in the pin assignment. Only
the 16 signal pins to have names on the traces!

Here is the list of names and the respective pin numbers on the pin socket 16I/Os_1:

```
 6 - I/O1_1
 8 - I/O1_2
10 - I/O1_3
12 - I/O1_4
14 - I/O1_5
16 - I/O1_6
18 - I/O1_7
20 - I/O1_8

 5 - I/O2_1
 7 - I/O2_2
 9 - I/O2_3
11 - I/O2_4
13 - I/O2_5
15 - I/O2_6
17 - I/O2_7
19 - I/O2_8
```

Here is the list of names and the respective pin numbers on the pin socket 16I/Os_2:

```
 6 - I/O1_13
 8 - I/O1_14
10 - I/O1_15
12 - I/O1_16
14 - I/O1_17
16 - I/O1_18
18 - I/O1_19
20 - I/O1_20

 5 - I/O2_13
 7 - I/O2_14
 9 - I/O2_15
11 - I/O2_16
13 - I/O2_17
15 - I/O2_18
17 - I/O2_19
19 - I/O2_20
```

Clockout - pin 12 (PA5) on the breakout - on the Motherboard DVK601: Bank: 16I/0s_1, pin 11 (I/O2_4)

The pin assignment below tells you what PIN you need to activate:
As an example: the clockout of the extension/breakout board is connected to the motherboard pin 11 of the 16I/0s_1.
This can be deduced from https://www.waveshare.com/wiki/USB3300_USB_HS_Board and from https://www.waveshare.com/w/upload/3/3c/DVK601-Schematic.pdf
Now, in the list below, look for a name that matches 16I/0s_1 and pin 11.
I guess it is 16I/Os_1_11 which is mapped to PIN_43.

```
#16I/Os_1
set_location_assignment	PIN_58	-to	16I/Os_1_1	   
set_location_assignment	PIN_55	-to	16I/Os_1_2
set_location_assignment	PIN_54	-to	16I/Os_1_3
set_location_assignment	PIN_53	-to	16I/Os_1_4
set_location_assignment	PIN_52	-to	16I/Os_1_5
set_location_assignment	PIN_51	-to	16I/Os_1_6
set_location_assignment	PIN_50	-to	16I/Os_1_7  ----------> In the schematic, this is pin 16I/Os_1 12 (I/O1_4) (lower row, pin 5 from the left, when looking into the header)
set_location_assignment	PIN_49	-to	16I/Os_1_8  ----------> In the schematic, this is pin 16I/Os_1 11 (I/O2_4) (upper row, pin 5 from the left, when looking into the header)

set_location_assignment	PIN_46	-to	16I/Os_1_9
set_location_assignment	PIN_44	-to	16I/Os_1_10
set_location_assignment	PIN_43	-to	16I/Os_1_11
set_location_assignment	PIN_42	-to	16I/Os_1_12
set_location_assignment	PIN_39	-to	16I/Os_1_13
set_location_assignment	PIN_38	-to	16I/Os_1_14
set_location_assignment	PIN_34	-to	16I/Os_1_15
set_location_assignment	PIN_33	-to	16I/Os_1_16
```

#16I/Os_2

```
set_location_assignment	PIN_2	-to	16I/Os_2_1	   
set_location_assignment	PIN_1	-to	16I/Os_2_2
set_location_assignment	PIN_144	-to	16I/Os_2_3
set_location_assignment	PIN_143	-to	16I/Os_2_4
set_location_assignment	PIN_142	-to	16I/Os_2_5
set_location_assignment	PIN_141	-to	16I/Os_2_6
set_location_assignment	PIN_138	-to	16I/Os_2_7
set_location_assignment	PIN_137	-to	16I/Os_2_8
set_location_assignment	PIN_136	-to	16I/Os_2_9
set_location_assignment	PIN_135	-to	16I/Os_2_10
set_location_assignment	PIN_133	-to	16I/Os_2_11
set_location_assignment	PIN_132	-to	16I/Os_2_12
set_location_assignment	PIN_129	-to	16I/Os_2_13
set_location_assignment	PIN_128	-to	16I/Os_2_14
set_location_assignment	PIN_127	-to	16I/Os_2_15
set_location_assignment	PIN_126	-to	16I/Os_2_16
```

# Test #1 - 60 Mhz Clock

The first test is to check if the 60Mhz clock is in fact produced by the extension board on pin clkout.
Therefore, copy the LED example and instead of using the FPGAs clk signal, use PIN50 in your top-level
design. Then make a counter variable that is incremented each posedge of the USB clk. The counter
will count from 0 to 60000000 each second with the 60Mhz USB clock. When the counter has reached 
60000000 one second is over. Each time when the timer reaches 60000000, toggle the LEDS. When the design
is run on the FPGA, you will turn the LEDS toggle every second!

Here is the top-level design:

```
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
	
endmodule
```




# Forum Posts

https://forum.microchip.com/s/topic/a5C3l000000MVVKEA4/t351162


Hi all,
(still unable to link images...)
I am currently implementing a FGPA-based USB High-Speed controller using an USB3300 (Waveshare module).

Everything seems to work well when using Full-Speed (12Mbit), but things are looking weird at High-Speed.

Just to give a glimpse of the initial setup, the USB3300 module is hard-reset using the external reset line, 
then logically reset using the Function Control register, Suspend is disabled, OTG register is cleared and 
all other bits are set up for Peripheral Full-Speed.

Upon host connection, the usual High-Speed negotiation is performed 
(and I have confirmed it using a scope, I can see clearly the reset, Peripheral Chirp, Host Chirp and the terminators enabling) 
and we configure it as per ULPI spec.

When I receive the first DATA0 packet, after the SETUP packet, something odd happens (see attached figure). 
I have used the FPGA itself to capture all ULPI signals.

http://www.alvie.com/zpui...00_rxcmd_oddities1.jpg
The DATA0 packet is 10 bytes in lenght (GET_DESCRIPTOR), but only 9 are sent by the PHY (the lasy CRC byte is missing). 
After the 1st CRC byte (0xDD), the NXT line goes down, and at this point I'd expect to receive an RXCMD, but I get 
all zeroes, which do not make sense at all. Plus, I seem to receive three of them. 
There is no RXERROR indication coming from the PHY.

If I ignore the packet lenght, the CRC check and proceed, it all seems to go well - I then get the IN packet from the host, 
and I can NAK it without any issue:

http://www.alvie.com/zpui...ges/usb3300_in_nak.jpg

Some packets seem to be well received, some others do not - I sometimes get (for a 10-byte request) 7 bytes, 8 bytes, 9 bytes. 
I never seem to receive any RXERROR indication at all. If I do have the CRC checks in place, 
I am completely unable to enumerate the device at HS - It does enumerate perfectly at FS, with the same PHY.

Any clues about what might be going on ?

Alvie