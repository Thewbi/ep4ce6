-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

-- DATE "08/10/2025 08:30:09"

-- 
-- Device: Altera EP4CE6E22C8 Package TQFP144
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	LED_4 IS
    PORT (
	nrst : IN std_logic;
	clk : IN std_logic;
	led : INOUT std_logic_vector(3 DOWNTO 0);
	CLKOUT : IN std_logic;
	DIR : IN std_logic;
	RST : OUT std_logic;
	data : INOUT std_logic_vector(7 DOWNTO 0);
	uart_tx_pin : OUT std_logic;
	TESTPIN : OUT std_logic
	);
END LED_4;

-- Design Ports Information
-- nrst	=>  Location: PIN_125,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- CLKOUT	=>  Location: PIN_50,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- DIR	=>  Location: PIN_52,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- RST	=>  Location: PIN_46,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- uart_tx_pin	=>  Location: PIN_126,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- TESTPIN	=>  Location: PIN_127,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- led[0]	=>  Location: PIN_11,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- led[1]	=>  Location: PIN_10,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- led[2]	=>  Location: PIN_7,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- led[3]	=>  Location: PIN_3,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[0]	=>  Location: PIN_33,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[1]	=>  Location: PIN_38,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[2]	=>  Location: PIN_42,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[3]	=>  Location: PIN_44,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[4]	=>  Location: PIN_49,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[5]	=>  Location: PIN_51,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[6]	=>  Location: PIN_53,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- data[7]	=>  Location: PIN_55,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 8mA
-- clk	=>  Location: PIN_23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF LED_4 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_nrst : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_CLKOUT : std_logic;
SIGNAL ww_DIR : std_logic;
SIGNAL ww_RST : std_logic;
SIGNAL ww_uart_tx_pin : std_logic;
SIGNAL ww_TESTPIN : std_logic;
SIGNAL \comb_4|clock_out~clkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \nrst~input_o\ : std_logic;
SIGNAL \CLKOUT~input_o\ : std_logic;
SIGNAL \DIR~input_o\ : std_logic;
SIGNAL \led[0]~input_o\ : std_logic;
SIGNAL \led[1]~input_o\ : std_logic;
SIGNAL \led[2]~input_o\ : std_logic;
SIGNAL \led[3]~input_o\ : std_logic;
SIGNAL \data[0]~input_o\ : std_logic;
SIGNAL \data[1]~input_o\ : std_logic;
SIGNAL \data[2]~input_o\ : std_logic;
SIGNAL \data[3]~input_o\ : std_logic;
SIGNAL \data[4]~input_o\ : std_logic;
SIGNAL \data[5]~input_o\ : std_logic;
SIGNAL \data[6]~input_o\ : std_logic;
SIGNAL \data[7]~input_o\ : std_logic;
SIGNAL \led[0]~output_o\ : std_logic;
SIGNAL \led[1]~output_o\ : std_logic;
SIGNAL \led[2]~output_o\ : std_logic;
SIGNAL \led[3]~output_o\ : std_logic;
SIGNAL \data[0]~output_o\ : std_logic;
SIGNAL \data[1]~output_o\ : std_logic;
SIGNAL \data[2]~output_o\ : std_logic;
SIGNAL \data[3]~output_o\ : std_logic;
SIGNAL \data[4]~output_o\ : std_logic;
SIGNAL \data[5]~output_o\ : std_logic;
SIGNAL \data[6]~output_o\ : std_logic;
SIGNAL \data[7]~output_o\ : std_logic;
SIGNAL \RST~output_o\ : std_logic;
SIGNAL \uart_tx_pin~output_o\ : std_logic;
SIGNAL \TESTPIN~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \comb_4|counter[0]~28_combout\ : std_logic;
SIGNAL \comb_4|counter[1]~31\ : std_logic;
SIGNAL \comb_4|counter[2]~32_combout\ : std_logic;
SIGNAL \comb_4|counter[2]~33\ : std_logic;
SIGNAL \comb_4|counter[3]~34_combout\ : std_logic;
SIGNAL \comb_4|counter[3]~35\ : std_logic;
SIGNAL \comb_4|counter[4]~36_combout\ : std_logic;
SIGNAL \comb_4|counter[4]~37\ : std_logic;
SIGNAL \comb_4|counter[5]~38_combout\ : std_logic;
SIGNAL \comb_4|counter[5]~39\ : std_logic;
SIGNAL \comb_4|counter[6]~40_combout\ : std_logic;
SIGNAL \comb_4|counter[6]~41\ : std_logic;
SIGNAL \comb_4|counter[7]~42_combout\ : std_logic;
SIGNAL \comb_4|counter[7]~43\ : std_logic;
SIGNAL \comb_4|counter[8]~44_combout\ : std_logic;
SIGNAL \comb_4|counter[8]~45\ : std_logic;
SIGNAL \comb_4|counter[9]~46_combout\ : std_logic;
SIGNAL \comb_4|counter[9]~47\ : std_logic;
SIGNAL \comb_4|counter[10]~48_combout\ : std_logic;
SIGNAL \comb_4|counter[10]~49\ : std_logic;
SIGNAL \comb_4|counter[11]~50_combout\ : std_logic;
SIGNAL \comb_4|counter[11]~51\ : std_logic;
SIGNAL \comb_4|counter[12]~52_combout\ : std_logic;
SIGNAL \comb_4|counter[12]~53\ : std_logic;
SIGNAL \comb_4|counter[13]~54_combout\ : std_logic;
SIGNAL \comb_4|counter[13]~55\ : std_logic;
SIGNAL \comb_4|counter[14]~56_combout\ : std_logic;
SIGNAL \comb_4|counter[14]~57\ : std_logic;
SIGNAL \comb_4|counter[15]~58_combout\ : std_logic;
SIGNAL \comb_4|counter[15]~59\ : std_logic;
SIGNAL \comb_4|counter[16]~60_combout\ : std_logic;
SIGNAL \comb_4|counter[16]~61\ : std_logic;
SIGNAL \comb_4|counter[17]~62_combout\ : std_logic;
SIGNAL \comb_4|counter[17]~63\ : std_logic;
SIGNAL \comb_4|counter[18]~64_combout\ : std_logic;
SIGNAL \comb_4|counter[18]~65\ : std_logic;
SIGNAL \comb_4|counter[19]~66_combout\ : std_logic;
SIGNAL \comb_4|counter[19]~67\ : std_logic;
SIGNAL \comb_4|counter[20]~68_combout\ : std_logic;
SIGNAL \comb_4|counter[20]~69\ : std_logic;
SIGNAL \comb_4|counter[21]~70_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~5_combout\ : std_logic;
SIGNAL \comb_4|counter[21]~71\ : std_logic;
SIGNAL \comb_4|counter[22]~72_combout\ : std_logic;
SIGNAL \comb_4|counter[22]~73\ : std_logic;
SIGNAL \comb_4|counter[23]~74_combout\ : std_logic;
SIGNAL \comb_4|counter[23]~75\ : std_logic;
SIGNAL \comb_4|counter[24]~76_combout\ : std_logic;
SIGNAL \comb_4|counter[24]~77\ : std_logic;
SIGNAL \comb_4|counter[25]~78_combout\ : std_logic;
SIGNAL \comb_4|counter[25]~79\ : std_logic;
SIGNAL \comb_4|counter[26]~80_combout\ : std_logic;
SIGNAL \comb_4|counter[26]~81\ : std_logic;
SIGNAL \comb_4|counter[27]~82_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~7_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~6_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~1_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~2_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~3_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~0_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~4_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~8_combout\ : std_logic;
SIGNAL \comb_4|counter[0]~29\ : std_logic;
SIGNAL \comb_4|counter[1]~30_combout\ : std_logic;
SIGNAL \comb_4|LessThan1~9_combout\ : std_logic;
SIGNAL \comb_4|clock_out~q\ : std_logic;
SIGNAL \comb_4|clock_out~clkctrl_outclk\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[0]~8_combout\ : std_logic;
SIGNAL \uart_tx|LessThan1~1_combout\ : std_logic;
SIGNAL \Add1~0_combout\ : std_logic;
SIGNAL \counter2~1_combout\ : std_logic;
SIGNAL \Add1~1\ : std_logic;
SIGNAL \Add1~2_combout\ : std_logic;
SIGNAL \Add1~3\ : std_logic;
SIGNAL \Add1~4_combout\ : std_logic;
SIGNAL \Add1~5\ : std_logic;
SIGNAL \Add1~6_combout\ : std_logic;
SIGNAL \Add1~7\ : std_logic;
SIGNAL \Add1~8_combout\ : std_logic;
SIGNAL \Add1~9\ : std_logic;
SIGNAL \Add1~10_combout\ : std_logic;
SIGNAL \Add1~11\ : std_logic;
SIGNAL \Add1~12_combout\ : std_logic;
SIGNAL \Add1~13\ : std_logic;
SIGNAL \Add1~14_combout\ : std_logic;
SIGNAL \counter2~0_combout\ : std_logic;
SIGNAL \Add1~15\ : std_logic;
SIGNAL \Add1~16_combout\ : std_logic;
SIGNAL \Add1~17\ : std_logic;
SIGNAL \Add1~18_combout\ : std_logic;
SIGNAL \Add1~19\ : std_logic;
SIGNAL \Add1~20_combout\ : std_logic;
SIGNAL \Add1~21\ : std_logic;
SIGNAL \Add1~22_combout\ : std_logic;
SIGNAL \Add1~23\ : std_logic;
SIGNAL \Add1~24_combout\ : std_logic;
SIGNAL \counter2~2_combout\ : std_logic;
SIGNAL \Add1~25\ : std_logic;
SIGNAL \Add1~26_combout\ : std_logic;
SIGNAL \counter2~3_combout\ : std_logic;
SIGNAL \Add1~27\ : std_logic;
SIGNAL \Add1~28_combout\ : std_logic;
SIGNAL \counter2~4_combout\ : std_logic;
SIGNAL \Add1~29\ : std_logic;
SIGNAL \Add1~30_combout\ : std_logic;
SIGNAL \counter2~5_combout\ : std_logic;
SIGNAL \Add1~31\ : std_logic;
SIGNAL \Add1~32_combout\ : std_logic;
SIGNAL \Add1~33\ : std_logic;
SIGNAL \Add1~34_combout\ : std_logic;
SIGNAL \counter2~6_combout\ : std_logic;
SIGNAL \Add1~35\ : std_logic;
SIGNAL \Add1~36_combout\ : std_logic;
SIGNAL \Add1~37\ : std_logic;
SIGNAL \Add1~38_combout\ : std_logic;
SIGNAL \counter2~7_combout\ : std_logic;
SIGNAL \Add1~39\ : std_logic;
SIGNAL \Add1~40_combout\ : std_logic;
SIGNAL \counter2~8_combout\ : std_logic;
SIGNAL \Add1~41\ : std_logic;
SIGNAL \Add1~42_combout\ : std_logic;
SIGNAL \counter2~9_combout\ : std_logic;
SIGNAL \Add1~43\ : std_logic;
SIGNAL \Add1~44_combout\ : std_logic;
SIGNAL \counter2~10_combout\ : std_logic;
SIGNAL \Add1~45\ : std_logic;
SIGNAL \Add1~46_combout\ : std_logic;
SIGNAL \counter2~11_combout\ : std_logic;
SIGNAL \Add1~47\ : std_logic;
SIGNAL \Add1~48_combout\ : std_logic;
SIGNAL \Add1~49\ : std_logic;
SIGNAL \Add1~50_combout\ : std_logic;
SIGNAL \counter2~12_combout\ : std_logic;
SIGNAL \Add1~51\ : std_logic;
SIGNAL \Add1~52_combout\ : std_logic;
SIGNAL \Add1~53\ : std_logic;
SIGNAL \Add1~54_combout\ : std_logic;
SIGNAL \Add1~55\ : std_logic;
SIGNAL \Add1~56_combout\ : std_logic;
SIGNAL \Add1~57\ : std_logic;
SIGNAL \Add1~58_combout\ : std_logic;
SIGNAL \Add1~59\ : std_logic;
SIGNAL \Add1~60_combout\ : std_logic;
SIGNAL \Add1~61\ : std_logic;
SIGNAL \Add1~62_combout\ : std_logic;
SIGNAL \Equal0~9_combout\ : std_logic;
SIGNAL \Equal0~8_combout\ : std_logic;
SIGNAL \Equal0~5_combout\ : std_logic;
SIGNAL \Equal0~6_combout\ : std_logic;
SIGNAL \Equal0~7_combout\ : std_logic;
SIGNAL \Equal0~1_combout\ : std_logic;
SIGNAL \Equal0~0_combout\ : std_logic;
SIGNAL \Equal0~3_combout\ : std_logic;
SIGNAL \Equal0~2_combout\ : std_logic;
SIGNAL \Equal0~4_combout\ : std_logic;
SIGNAL \Equal0~10_combout\ : std_logic;
SIGNAL \uart_tx|LessThan1~0_combout\ : std_logic;
SIGNAL \uart_tx|LessThan1~2_combout\ : std_logic;
SIGNAL \uart_tx|Selector15~1_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.s_TX_START_BIT~q\ : std_logic;
SIGNAL \uart_tx|Selector12~0_combout\ : std_logic;
SIGNAL \uart_tx|Selector12~1_combout\ : std_logic;
SIGNAL \uart_tx|Selector11~0_combout\ : std_logic;
SIGNAL \uart_tx|Selector11~1_combout\ : std_logic;
SIGNAL \uart_tx|Selector10~1_combout\ : std_logic;
SIGNAL \uart_tx|Selector10~0_combout\ : std_logic;
SIGNAL \uart_tx|Selector10~2_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\ : std_logic;
SIGNAL \uart_tx|Selector16~0_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.s_TX_STOP_BIT~1_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\ : std_logic;
SIGNAL \uart_tx|Selector1~0_combout\ : std_logic;
SIGNAL \uart_tx|Selector1~1_combout\ : std_logic;
SIGNAL \uart_tx|r_Tx_Done~q\ : std_logic;
SIGNAL \uart_tx_data_valid_reg~0_combout\ : std_logic;
SIGNAL \uart_tx_data_valid_reg~q\ : std_logic;
SIGNAL \uart_tx|Selector14~0_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.000~q\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[7]~12_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[0]~9\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[1]~10_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[1]~11\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[2]~13_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[2]~14\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[3]~15_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[3]~16\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[4]~17_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[4]~18\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[5]~19_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[5]~20\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[6]~21_combout\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[6]~22\ : std_logic;
SIGNAL \uart_tx|r_Clock_Count[7]~23_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main~9_combout\ : std_logic;
SIGNAL \uart_tx|r_SM_Main.s_CLEANUP~q\ : std_logic;
SIGNAL \uart_tx_data[0]~21_combout\ : std_logic;
SIGNAL \uart_tx_data[1]~7_combout\ : std_logic;
SIGNAL \uart_tx_data[1]~8\ : std_logic;
SIGNAL \uart_tx_data[2]~9_combout\ : std_logic;
SIGNAL \uart_tx_data[2]~10\ : std_logic;
SIGNAL \uart_tx_data[3]~11_combout\ : std_logic;
SIGNAL \uart_tx_data[3]~12\ : std_logic;
SIGNAL \uart_tx_data[4]~13_combout\ : std_logic;
SIGNAL \uart_tx_data[4]~14\ : std_logic;
SIGNAL \uart_tx_data[5]~15_combout\ : std_logic;
SIGNAL \uart_tx_data[5]~16\ : std_logic;
SIGNAL \uart_tx_data[6]~17_combout\ : std_logic;
SIGNAL \uart_tx|Selector15~0_combout\ : std_logic;
SIGNAL \uart_tx_data[6]~18\ : std_logic;
SIGNAL \uart_tx_data[7]~19_combout\ : std_logic;
SIGNAL \uart_tx|r_Tx_Data[5]~feeder_combout\ : std_logic;
SIGNAL \uart_tx|Mux0~0_combout\ : std_logic;
SIGNAL \uart_tx|Mux0~1_combout\ : std_logic;
SIGNAL \uart_tx|Selector0~0_combout\ : std_logic;
SIGNAL \uart_tx|r_Tx_Data[2]~feeder_combout\ : std_logic;
SIGNAL \uart_tx|r_Tx_Data[1]~feeder_combout\ : std_logic;
SIGNAL \uart_tx|Mux0~2_combout\ : std_logic;
SIGNAL \uart_tx|Mux0~3_combout\ : std_logic;
SIGNAL \uart_tx|Selector0~1_combout\ : std_logic;
SIGNAL \uart_tx|Selector0~2_combout\ : std_logic;
SIGNAL \uart_tx|o_Tx_Serial~q\ : std_logic;
SIGNAL uart_tx_data : std_logic_vector(7 DOWNTO 0);
SIGNAL counter2 : std_logic_vector(31 DOWNTO 0);
SIGNAL \comb_4|counter\ : std_logic_vector(27 DOWNTO 0);
SIGNAL \uart_tx|r_Tx_Data\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \uart_tx|r_Clock_Count\ : std_logic_vector(7 DOWNTO 0);
SIGNAL \uart_tx|r_Bit_Index\ : std_logic_vector(2 DOWNTO 0);
SIGNAL \comb_4|ALT_INV_LessThan1~8_combout\ : std_logic;
SIGNAL \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\ : std_logic;

BEGIN

ww_nrst <= nrst;
ww_clk <= clk;
ww_CLKOUT <= CLKOUT;
ww_DIR <= DIR;
RST <= ww_RST;
uart_tx_pin <= ww_uart_tx_pin;
TESTPIN <= ww_TESTPIN;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\comb_4|clock_out~clkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \comb_4|clock_out~q\);

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);
\comb_4|ALT_INV_LessThan1~8_combout\ <= NOT \comb_4|LessThan1~8_combout\;
\uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\ <= NOT \uart_tx|r_SM_Main.s_CLEANUP~q\;

-- Location: IOOBUF_X0_Y18_N23
\led[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \led[0]~output_o\);

-- Location: IOOBUF_X0_Y18_N16
\led[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \led[1]~output_o\);

-- Location: IOOBUF_X0_Y21_N9
\led[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \led[2]~output_o\);

-- Location: IOOBUF_X0_Y23_N16
\led[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \led[3]~output_o\);

-- Location: IOOBUF_X0_Y6_N23
\data[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[0]~output_o\);

-- Location: IOOBUF_X1_Y0_N23
\data[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[1]~output_o\);

-- Location: IOOBUF_X3_Y0_N2
\data[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[2]~output_o\);

-- Location: IOOBUF_X5_Y0_N16
\data[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[3]~output_o\);

-- Location: IOOBUF_X13_Y0_N16
\data[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[4]~output_o\);

-- Location: IOOBUF_X16_Y0_N23
\data[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[5]~output_o\);

-- Location: IOOBUF_X16_Y0_N2
\data[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[6]~output_o\);

-- Location: IOOBUF_X18_Y0_N16
\data[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "true")
-- pragma translate_on
PORT MAP (
	i => VCC,
	devoe => ww_devoe,
	o => \data[7]~output_o\);

-- Location: IOOBUF_X7_Y0_N2
\RST~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \RST~output_o\);

-- Location: IOOBUF_X16_Y24_N2
\uart_tx_pin~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \uart_tx|o_Tx_Serial~q\,
	devoe => ww_devoe,
	o => \uart_tx_pin~output_o\);

-- Location: IOOBUF_X16_Y24_N9
\TESTPIN~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \TESTPIN~output_o\);

-- Location: IOIBUF_X0_Y11_N8
\clk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G2
\clk~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: LCCOMB_X13_Y15_N4
\comb_4|counter[0]~28\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[0]~28_combout\ = \comb_4|counter\(0) $ (VCC)
-- \comb_4|counter[0]~29\ = CARRY(\comb_4|counter\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(0),
	datad => VCC,
	combout => \comb_4|counter[0]~28_combout\,
	cout => \comb_4|counter[0]~29\);

-- Location: LCCOMB_X13_Y15_N6
\comb_4|counter[1]~30\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[1]~30_combout\ = (\comb_4|counter\(1) & (!\comb_4|counter[0]~29\)) # (!\comb_4|counter\(1) & ((\comb_4|counter[0]~29\) # (GND)))
-- \comb_4|counter[1]~31\ = CARRY((!\comb_4|counter[0]~29\) # (!\comb_4|counter\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(1),
	datad => VCC,
	cin => \comb_4|counter[0]~29\,
	combout => \comb_4|counter[1]~30_combout\,
	cout => \comb_4|counter[1]~31\);

-- Location: LCCOMB_X13_Y15_N8
\comb_4|counter[2]~32\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[2]~32_combout\ = (\comb_4|counter\(2) & (\comb_4|counter[1]~31\ $ (GND))) # (!\comb_4|counter\(2) & (!\comb_4|counter[1]~31\ & VCC))
-- \comb_4|counter[2]~33\ = CARRY((\comb_4|counter\(2) & !\comb_4|counter[1]~31\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(2),
	datad => VCC,
	cin => \comb_4|counter[1]~31\,
	combout => \comb_4|counter[2]~32_combout\,
	cout => \comb_4|counter[2]~33\);

-- Location: FF_X13_Y15_N9
\comb_4|counter[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[2]~32_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(2));

-- Location: LCCOMB_X13_Y15_N10
\comb_4|counter[3]~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[3]~34_combout\ = (\comb_4|counter\(3) & (!\comb_4|counter[2]~33\)) # (!\comb_4|counter\(3) & ((\comb_4|counter[2]~33\) # (GND)))
-- \comb_4|counter[3]~35\ = CARRY((!\comb_4|counter[2]~33\) # (!\comb_4|counter\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(3),
	datad => VCC,
	cin => \comb_4|counter[2]~33\,
	combout => \comb_4|counter[3]~34_combout\,
	cout => \comb_4|counter[3]~35\);

-- Location: FF_X13_Y15_N11
\comb_4|counter[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[3]~34_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(3));

-- Location: LCCOMB_X13_Y15_N12
\comb_4|counter[4]~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[4]~36_combout\ = (\comb_4|counter\(4) & (\comb_4|counter[3]~35\ $ (GND))) # (!\comb_4|counter\(4) & (!\comb_4|counter[3]~35\ & VCC))
-- \comb_4|counter[4]~37\ = CARRY((\comb_4|counter\(4) & !\comb_4|counter[3]~35\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(4),
	datad => VCC,
	cin => \comb_4|counter[3]~35\,
	combout => \comb_4|counter[4]~36_combout\,
	cout => \comb_4|counter[4]~37\);

-- Location: FF_X13_Y15_N13
\comb_4|counter[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[4]~36_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(4));

-- Location: LCCOMB_X13_Y15_N14
\comb_4|counter[5]~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[5]~38_combout\ = (\comb_4|counter\(5) & (!\comb_4|counter[4]~37\)) # (!\comb_4|counter\(5) & ((\comb_4|counter[4]~37\) # (GND)))
-- \comb_4|counter[5]~39\ = CARRY((!\comb_4|counter[4]~37\) # (!\comb_4|counter\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(5),
	datad => VCC,
	cin => \comb_4|counter[4]~37\,
	combout => \comb_4|counter[5]~38_combout\,
	cout => \comb_4|counter[5]~39\);

-- Location: FF_X13_Y15_N15
\comb_4|counter[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[5]~38_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(5));

-- Location: LCCOMB_X13_Y15_N16
\comb_4|counter[6]~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[6]~40_combout\ = (\comb_4|counter\(6) & (\comb_4|counter[5]~39\ $ (GND))) # (!\comb_4|counter\(6) & (!\comb_4|counter[5]~39\ & VCC))
-- \comb_4|counter[6]~41\ = CARRY((\comb_4|counter\(6) & !\comb_4|counter[5]~39\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(6),
	datad => VCC,
	cin => \comb_4|counter[5]~39\,
	combout => \comb_4|counter[6]~40_combout\,
	cout => \comb_4|counter[6]~41\);

-- Location: FF_X13_Y15_N17
\comb_4|counter[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[6]~40_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(6));

-- Location: LCCOMB_X13_Y15_N18
\comb_4|counter[7]~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[7]~42_combout\ = (\comb_4|counter\(7) & (!\comb_4|counter[6]~41\)) # (!\comb_4|counter\(7) & ((\comb_4|counter[6]~41\) # (GND)))
-- \comb_4|counter[7]~43\ = CARRY((!\comb_4|counter[6]~41\) # (!\comb_4|counter\(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(7),
	datad => VCC,
	cin => \comb_4|counter[6]~41\,
	combout => \comb_4|counter[7]~42_combout\,
	cout => \comb_4|counter[7]~43\);

-- Location: FF_X13_Y15_N19
\comb_4|counter[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[7]~42_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(7));

-- Location: LCCOMB_X13_Y15_N20
\comb_4|counter[8]~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[8]~44_combout\ = (\comb_4|counter\(8) & (\comb_4|counter[7]~43\ $ (GND))) # (!\comb_4|counter\(8) & (!\comb_4|counter[7]~43\ & VCC))
-- \comb_4|counter[8]~45\ = CARRY((\comb_4|counter\(8) & !\comb_4|counter[7]~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(8),
	datad => VCC,
	cin => \comb_4|counter[7]~43\,
	combout => \comb_4|counter[8]~44_combout\,
	cout => \comb_4|counter[8]~45\);

-- Location: FF_X13_Y15_N21
\comb_4|counter[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[8]~44_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(8));

-- Location: LCCOMB_X13_Y15_N22
\comb_4|counter[9]~46\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[9]~46_combout\ = (\comb_4|counter\(9) & (!\comb_4|counter[8]~45\)) # (!\comb_4|counter\(9) & ((\comb_4|counter[8]~45\) # (GND)))
-- \comb_4|counter[9]~47\ = CARRY((!\comb_4|counter[8]~45\) # (!\comb_4|counter\(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(9),
	datad => VCC,
	cin => \comb_4|counter[8]~45\,
	combout => \comb_4|counter[9]~46_combout\,
	cout => \comb_4|counter[9]~47\);

-- Location: FF_X13_Y15_N23
\comb_4|counter[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[9]~46_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(9));

-- Location: LCCOMB_X13_Y15_N24
\comb_4|counter[10]~48\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[10]~48_combout\ = (\comb_4|counter\(10) & (\comb_4|counter[9]~47\ $ (GND))) # (!\comb_4|counter\(10) & (!\comb_4|counter[9]~47\ & VCC))
-- \comb_4|counter[10]~49\ = CARRY((\comb_4|counter\(10) & !\comb_4|counter[9]~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(10),
	datad => VCC,
	cin => \comb_4|counter[9]~47\,
	combout => \comb_4|counter[10]~48_combout\,
	cout => \comb_4|counter[10]~49\);

-- Location: FF_X13_Y15_N25
\comb_4|counter[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[10]~48_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(10));

-- Location: LCCOMB_X13_Y15_N26
\comb_4|counter[11]~50\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[11]~50_combout\ = (\comb_4|counter\(11) & (!\comb_4|counter[10]~49\)) # (!\comb_4|counter\(11) & ((\comb_4|counter[10]~49\) # (GND)))
-- \comb_4|counter[11]~51\ = CARRY((!\comb_4|counter[10]~49\) # (!\comb_4|counter\(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(11),
	datad => VCC,
	cin => \comb_4|counter[10]~49\,
	combout => \comb_4|counter[11]~50_combout\,
	cout => \comb_4|counter[11]~51\);

-- Location: FF_X13_Y15_N27
\comb_4|counter[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[11]~50_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(11));

-- Location: LCCOMB_X13_Y15_N28
\comb_4|counter[12]~52\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[12]~52_combout\ = (\comb_4|counter\(12) & (\comb_4|counter[11]~51\ $ (GND))) # (!\comb_4|counter\(12) & (!\comb_4|counter[11]~51\ & VCC))
-- \comb_4|counter[12]~53\ = CARRY((\comb_4|counter\(12) & !\comb_4|counter[11]~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(12),
	datad => VCC,
	cin => \comb_4|counter[11]~51\,
	combout => \comb_4|counter[12]~52_combout\,
	cout => \comb_4|counter[12]~53\);

-- Location: FF_X13_Y15_N29
\comb_4|counter[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[12]~52_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(12));

-- Location: LCCOMB_X13_Y15_N30
\comb_4|counter[13]~54\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[13]~54_combout\ = (\comb_4|counter\(13) & (!\comb_4|counter[12]~53\)) # (!\comb_4|counter\(13) & ((\comb_4|counter[12]~53\) # (GND)))
-- \comb_4|counter[13]~55\ = CARRY((!\comb_4|counter[12]~53\) # (!\comb_4|counter\(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(13),
	datad => VCC,
	cin => \comb_4|counter[12]~53\,
	combout => \comb_4|counter[13]~54_combout\,
	cout => \comb_4|counter[13]~55\);

-- Location: FF_X13_Y15_N31
\comb_4|counter[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[13]~54_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(13));

-- Location: LCCOMB_X13_Y14_N0
\comb_4|counter[14]~56\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[14]~56_combout\ = (\comb_4|counter\(14) & (\comb_4|counter[13]~55\ $ (GND))) # (!\comb_4|counter\(14) & (!\comb_4|counter[13]~55\ & VCC))
-- \comb_4|counter[14]~57\ = CARRY((\comb_4|counter\(14) & !\comb_4|counter[13]~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(14),
	datad => VCC,
	cin => \comb_4|counter[13]~55\,
	combout => \comb_4|counter[14]~56_combout\,
	cout => \comb_4|counter[14]~57\);

-- Location: FF_X13_Y14_N1
\comb_4|counter[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[14]~56_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(14));

-- Location: LCCOMB_X13_Y14_N2
\comb_4|counter[15]~58\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[15]~58_combout\ = (\comb_4|counter\(15) & (!\comb_4|counter[14]~57\)) # (!\comb_4|counter\(15) & ((\comb_4|counter[14]~57\) # (GND)))
-- \comb_4|counter[15]~59\ = CARRY((!\comb_4|counter[14]~57\) # (!\comb_4|counter\(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(15),
	datad => VCC,
	cin => \comb_4|counter[14]~57\,
	combout => \comb_4|counter[15]~58_combout\,
	cout => \comb_4|counter[15]~59\);

-- Location: FF_X13_Y14_N3
\comb_4|counter[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[15]~58_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(15));

-- Location: LCCOMB_X13_Y14_N4
\comb_4|counter[16]~60\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[16]~60_combout\ = (\comb_4|counter\(16) & (\comb_4|counter[15]~59\ $ (GND))) # (!\comb_4|counter\(16) & (!\comb_4|counter[15]~59\ & VCC))
-- \comb_4|counter[16]~61\ = CARRY((\comb_4|counter\(16) & !\comb_4|counter[15]~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(16),
	datad => VCC,
	cin => \comb_4|counter[15]~59\,
	combout => \comb_4|counter[16]~60_combout\,
	cout => \comb_4|counter[16]~61\);

-- Location: FF_X13_Y14_N5
\comb_4|counter[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[16]~60_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(16));

-- Location: LCCOMB_X13_Y14_N6
\comb_4|counter[17]~62\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[17]~62_combout\ = (\comb_4|counter\(17) & (!\comb_4|counter[16]~61\)) # (!\comb_4|counter\(17) & ((\comb_4|counter[16]~61\) # (GND)))
-- \comb_4|counter[17]~63\ = CARRY((!\comb_4|counter[16]~61\) # (!\comb_4|counter\(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(17),
	datad => VCC,
	cin => \comb_4|counter[16]~61\,
	combout => \comb_4|counter[17]~62_combout\,
	cout => \comb_4|counter[17]~63\);

-- Location: FF_X13_Y14_N7
\comb_4|counter[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[17]~62_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(17));

-- Location: LCCOMB_X13_Y14_N8
\comb_4|counter[18]~64\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[18]~64_combout\ = (\comb_4|counter\(18) & (\comb_4|counter[17]~63\ $ (GND))) # (!\comb_4|counter\(18) & (!\comb_4|counter[17]~63\ & VCC))
-- \comb_4|counter[18]~65\ = CARRY((\comb_4|counter\(18) & !\comb_4|counter[17]~63\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(18),
	datad => VCC,
	cin => \comb_4|counter[17]~63\,
	combout => \comb_4|counter[18]~64_combout\,
	cout => \comb_4|counter[18]~65\);

-- Location: FF_X13_Y14_N9
\comb_4|counter[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[18]~64_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(18));

-- Location: LCCOMB_X13_Y14_N10
\comb_4|counter[19]~66\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[19]~66_combout\ = (\comb_4|counter\(19) & (!\comb_4|counter[18]~65\)) # (!\comb_4|counter\(19) & ((\comb_4|counter[18]~65\) # (GND)))
-- \comb_4|counter[19]~67\ = CARRY((!\comb_4|counter[18]~65\) # (!\comb_4|counter\(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(19),
	datad => VCC,
	cin => \comb_4|counter[18]~65\,
	combout => \comb_4|counter[19]~66_combout\,
	cout => \comb_4|counter[19]~67\);

-- Location: FF_X13_Y14_N11
\comb_4|counter[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[19]~66_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(19));

-- Location: LCCOMB_X13_Y14_N12
\comb_4|counter[20]~68\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[20]~68_combout\ = (\comb_4|counter\(20) & (\comb_4|counter[19]~67\ $ (GND))) # (!\comb_4|counter\(20) & (!\comb_4|counter[19]~67\ & VCC))
-- \comb_4|counter[20]~69\ = CARRY((\comb_4|counter\(20) & !\comb_4|counter[19]~67\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(20),
	datad => VCC,
	cin => \comb_4|counter[19]~67\,
	combout => \comb_4|counter[20]~68_combout\,
	cout => \comb_4|counter[20]~69\);

-- Location: FF_X13_Y14_N13
\comb_4|counter[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[20]~68_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(20));

-- Location: LCCOMB_X13_Y14_N14
\comb_4|counter[21]~70\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[21]~70_combout\ = (\comb_4|counter\(21) & (!\comb_4|counter[20]~69\)) # (!\comb_4|counter\(21) & ((\comb_4|counter[20]~69\) # (GND)))
-- \comb_4|counter[21]~71\ = CARRY((!\comb_4|counter[20]~69\) # (!\comb_4|counter\(21)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(21),
	datad => VCC,
	cin => \comb_4|counter[20]~69\,
	combout => \comb_4|counter[21]~70_combout\,
	cout => \comb_4|counter[21]~71\);

-- Location: FF_X13_Y14_N15
\comb_4|counter[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[21]~70_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(21));

-- Location: LCCOMB_X14_Y14_N0
\comb_4|LessThan1~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~5_combout\ = (!\comb_4|counter\(21) & (!\comb_4|counter\(19) & (!\comb_4|counter\(18) & !\comb_4|counter\(20))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(21),
	datab => \comb_4|counter\(19),
	datac => \comb_4|counter\(18),
	datad => \comb_4|counter\(20),
	combout => \comb_4|LessThan1~5_combout\);

-- Location: LCCOMB_X13_Y14_N16
\comb_4|counter[22]~72\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[22]~72_combout\ = (\comb_4|counter\(22) & (\comb_4|counter[21]~71\ $ (GND))) # (!\comb_4|counter\(22) & (!\comb_4|counter[21]~71\ & VCC))
-- \comb_4|counter[22]~73\ = CARRY((\comb_4|counter\(22) & !\comb_4|counter[21]~71\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(22),
	datad => VCC,
	cin => \comb_4|counter[21]~71\,
	combout => \comb_4|counter[22]~72_combout\,
	cout => \comb_4|counter[22]~73\);

-- Location: FF_X13_Y14_N17
\comb_4|counter[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[22]~72_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(22));

-- Location: LCCOMB_X13_Y14_N18
\comb_4|counter[23]~74\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[23]~74_combout\ = (\comb_4|counter\(23) & (!\comb_4|counter[22]~73\)) # (!\comb_4|counter\(23) & ((\comb_4|counter[22]~73\) # (GND)))
-- \comb_4|counter[23]~75\ = CARRY((!\comb_4|counter[22]~73\) # (!\comb_4|counter\(23)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(23),
	datad => VCC,
	cin => \comb_4|counter[22]~73\,
	combout => \comb_4|counter[23]~74_combout\,
	cout => \comb_4|counter[23]~75\);

-- Location: FF_X13_Y14_N19
\comb_4|counter[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[23]~74_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(23));

-- Location: LCCOMB_X13_Y14_N20
\comb_4|counter[24]~76\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[24]~76_combout\ = (\comb_4|counter\(24) & (\comb_4|counter[23]~75\ $ (GND))) # (!\comb_4|counter\(24) & (!\comb_4|counter[23]~75\ & VCC))
-- \comb_4|counter[24]~77\ = CARRY((\comb_4|counter\(24) & !\comb_4|counter[23]~75\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(24),
	datad => VCC,
	cin => \comb_4|counter[23]~75\,
	combout => \comb_4|counter[24]~76_combout\,
	cout => \comb_4|counter[24]~77\);

-- Location: FF_X13_Y14_N21
\comb_4|counter[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[24]~76_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(24));

-- Location: LCCOMB_X13_Y14_N22
\comb_4|counter[25]~78\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[25]~78_combout\ = (\comb_4|counter\(25) & (!\comb_4|counter[24]~77\)) # (!\comb_4|counter\(25) & ((\comb_4|counter[24]~77\) # (GND)))
-- \comb_4|counter[25]~79\ = CARRY((!\comb_4|counter[24]~77\) # (!\comb_4|counter\(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(25),
	datad => VCC,
	cin => \comb_4|counter[24]~77\,
	combout => \comb_4|counter[25]~78_combout\,
	cout => \comb_4|counter[25]~79\);

-- Location: FF_X13_Y14_N23
\comb_4|counter[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[25]~78_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(25));

-- Location: LCCOMB_X13_Y14_N24
\comb_4|counter[26]~80\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[26]~80_combout\ = (\comb_4|counter\(26) & (\comb_4|counter[25]~79\ $ (GND))) # (!\comb_4|counter\(26) & (!\comb_4|counter[25]~79\ & VCC))
-- \comb_4|counter[26]~81\ = CARRY((\comb_4|counter\(26) & !\comb_4|counter[25]~79\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \comb_4|counter\(26),
	datad => VCC,
	cin => \comb_4|counter[25]~79\,
	combout => \comb_4|counter[26]~80_combout\,
	cout => \comb_4|counter[26]~81\);

-- Location: FF_X13_Y14_N25
\comb_4|counter[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[26]~80_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(26));

-- Location: LCCOMB_X13_Y14_N26
\comb_4|counter[27]~82\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|counter[27]~82_combout\ = \comb_4|counter\(27) $ (\comb_4|counter[26]~81\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(27),
	cin => \comb_4|counter[26]~81\,
	combout => \comb_4|counter[27]~82_combout\);

-- Location: FF_X13_Y14_N27
\comb_4|counter[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[27]~82_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(27));

-- Location: LCCOMB_X12_Y14_N12
\comb_4|LessThan1~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~7_combout\ = (!\comb_4|counter\(27) & !\comb_4|counter\(26))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \comb_4|counter\(27),
	datad => \comb_4|counter\(26),
	combout => \comb_4|LessThan1~7_combout\);

-- Location: LCCOMB_X13_Y14_N30
\comb_4|LessThan1~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~6_combout\ = (!\comb_4|counter\(25) & (!\comb_4|counter\(24) & (!\comb_4|counter\(23) & !\comb_4|counter\(22))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(25),
	datab => \comb_4|counter\(24),
	datac => \comb_4|counter\(23),
	datad => \comb_4|counter\(22),
	combout => \comb_4|LessThan1~6_combout\);

-- Location: LCCOMB_X14_Y15_N30
\comb_4|LessThan1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~1_combout\ = (!\comb_4|counter\(6) & (!\comb_4|counter\(8) & (!\comb_4|counter\(9) & !\comb_4|counter\(7))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(6),
	datab => \comb_4|counter\(8),
	datac => \comb_4|counter\(9),
	datad => \comb_4|counter\(7),
	combout => \comb_4|LessThan1~1_combout\);

-- Location: LCCOMB_X12_Y15_N6
\comb_4|LessThan1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~2_combout\ = (!\comb_4|counter\(13) & (!\comb_4|counter\(11) & (!\comb_4|counter\(10) & !\comb_4|counter\(12))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(13),
	datab => \comb_4|counter\(11),
	datac => \comb_4|counter\(10),
	datad => \comb_4|counter\(12),
	combout => \comb_4|LessThan1~2_combout\);

-- Location: LCCOMB_X13_Y14_N28
\comb_4|LessThan1~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~3_combout\ = (!\comb_4|counter\(17) & (!\comb_4|counter\(15) & (!\comb_4|counter\(16) & !\comb_4|counter\(14))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(17),
	datab => \comb_4|counter\(15),
	datac => \comb_4|counter\(16),
	datad => \comb_4|counter\(14),
	combout => \comb_4|LessThan1~3_combout\);

-- Location: LCCOMB_X14_Y15_N4
\comb_4|LessThan1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~0_combout\ = (!\comb_4|counter\(5) & (!\comb_4|counter\(3) & (!\comb_4|counter\(4) & !\comb_4|counter\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|counter\(5),
	datab => \comb_4|counter\(3),
	datac => \comb_4|counter\(4),
	datad => \comb_4|counter\(2),
	combout => \comb_4|LessThan1~0_combout\);

-- Location: LCCOMB_X13_Y15_N0
\comb_4|LessThan1~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~4_combout\ = (\comb_4|LessThan1~1_combout\ & (\comb_4|LessThan1~2_combout\ & (\comb_4|LessThan1~3_combout\ & \comb_4|LessThan1~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|LessThan1~1_combout\,
	datab => \comb_4|LessThan1~2_combout\,
	datac => \comb_4|LessThan1~3_combout\,
	datad => \comb_4|LessThan1~0_combout\,
	combout => \comb_4|LessThan1~4_combout\);

-- Location: LCCOMB_X13_Y15_N2
\comb_4|LessThan1~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~8_combout\ = (\comb_4|LessThan1~5_combout\ & (\comb_4|LessThan1~7_combout\ & (\comb_4|LessThan1~6_combout\ & \comb_4|LessThan1~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \comb_4|LessThan1~5_combout\,
	datab => \comb_4|LessThan1~7_combout\,
	datac => \comb_4|LessThan1~6_combout\,
	datad => \comb_4|LessThan1~4_combout\,
	combout => \comb_4|LessThan1~8_combout\);

-- Location: FF_X13_Y15_N5
\comb_4|counter[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[0]~28_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(0));

-- Location: FF_X13_Y15_N7
\comb_4|counter[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|counter[1]~30_combout\,
	sclr => \comb_4|ALT_INV_LessThan1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|counter\(1));

-- Location: LCCOMB_X12_Y15_N8
\comb_4|LessThan1~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \comb_4|LessThan1~9_combout\ = (!\comb_4|counter\(1) & \comb_4|LessThan1~8_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \comb_4|counter\(1),
	datad => \comb_4|LessThan1~8_combout\,
	combout => \comb_4|LessThan1~9_combout\);

-- Location: FF_X12_Y15_N9
\comb_4|clock_out\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \comb_4|LessThan1~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \comb_4|clock_out~q\);

-- Location: CLKCTRL_G3
\comb_4|clock_out~clkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \comb_4|clock_out~clkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \comb_4|clock_out~clkctrl_outclk\);

-- Location: LCCOMB_X24_Y18_N12
\uart_tx|r_Clock_Count[0]~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[0]~8_combout\ = \uart_tx|r_Clock_Count\(0) $ (VCC)
-- \uart_tx|r_Clock_Count[0]~9\ = CARRY(\uart_tx|r_Clock_Count\(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(0),
	datad => VCC,
	combout => \uart_tx|r_Clock_Count[0]~8_combout\,
	cout => \uart_tx|r_Clock_Count[0]~9\);

-- Location: LCCOMB_X24_Y18_N28
\uart_tx|LessThan1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|LessThan1~1_combout\ = ((!\uart_tx|r_Clock_Count\(4) & !\uart_tx|r_Clock_Count\(5))) # (!\uart_tx|r_Clock_Count\(6))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Clock_Count\(4),
	datac => \uart_tx|r_Clock_Count\(5),
	datad => \uart_tx|r_Clock_Count\(6),
	combout => \uart_tx|LessThan1~1_combout\);

-- Location: LCCOMB_X24_Y16_N0
\Add1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~0_combout\ = counter2(0) $ (VCC)
-- \Add1~1\ = CARRY(counter2(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => counter2(0),
	datad => VCC,
	combout => \Add1~0_combout\,
	cout => \Add1~1\);

-- Location: LCCOMB_X23_Y16_N6
\counter2~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~1_combout\ = (\Add1~0_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~0_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~1_combout\);

-- Location: FF_X24_Y16_N25
\counter2[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \counter2~1_combout\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(0));

-- Location: LCCOMB_X24_Y16_N2
\Add1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~2_combout\ = (counter2(1) & (!\Add1~1\)) # (!counter2(1) & ((\Add1~1\) # (GND)))
-- \Add1~3\ = CARRY((!\Add1~1\) # (!counter2(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(1),
	datad => VCC,
	cin => \Add1~1\,
	combout => \Add1~2_combout\,
	cout => \Add1~3\);

-- Location: FF_X24_Y16_N3
\counter2[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(1));

-- Location: LCCOMB_X24_Y16_N4
\Add1~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~4_combout\ = (counter2(2) & (\Add1~3\ $ (GND))) # (!counter2(2) & (!\Add1~3\ & VCC))
-- \Add1~5\ = CARRY((counter2(2) & !\Add1~3\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(2),
	datad => VCC,
	cin => \Add1~3\,
	combout => \Add1~4_combout\,
	cout => \Add1~5\);

-- Location: FF_X24_Y16_N5
\counter2[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(2));

-- Location: LCCOMB_X24_Y16_N6
\Add1~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~6_combout\ = (counter2(3) & (!\Add1~5\)) # (!counter2(3) & ((\Add1~5\) # (GND)))
-- \Add1~7\ = CARRY((!\Add1~5\) # (!counter2(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(3),
	datad => VCC,
	cin => \Add1~5\,
	combout => \Add1~6_combout\,
	cout => \Add1~7\);

-- Location: FF_X24_Y16_N7
\counter2[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(3));

-- Location: LCCOMB_X24_Y16_N8
\Add1~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~8_combout\ = (counter2(4) & (\Add1~7\ $ (GND))) # (!counter2(4) & (!\Add1~7\ & VCC))
-- \Add1~9\ = CARRY((counter2(4) & !\Add1~7\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(4),
	datad => VCC,
	cin => \Add1~7\,
	combout => \Add1~8_combout\,
	cout => \Add1~9\);

-- Location: FF_X24_Y16_N9
\counter2[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(4));

-- Location: LCCOMB_X24_Y16_N10
\Add1~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~10_combout\ = (counter2(5) & (!\Add1~9\)) # (!counter2(5) & ((\Add1~9\) # (GND)))
-- \Add1~11\ = CARRY((!\Add1~9\) # (!counter2(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(5),
	datad => VCC,
	cin => \Add1~9\,
	combout => \Add1~10_combout\,
	cout => \Add1~11\);

-- Location: FF_X24_Y16_N11
\counter2[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(5));

-- Location: LCCOMB_X24_Y16_N12
\Add1~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~12_combout\ = (counter2(6) & (\Add1~11\ $ (GND))) # (!counter2(6) & (!\Add1~11\ & VCC))
-- \Add1~13\ = CARRY((counter2(6) & !\Add1~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(6),
	datad => VCC,
	cin => \Add1~11\,
	combout => \Add1~12_combout\,
	cout => \Add1~13\);

-- Location: FF_X24_Y16_N13
\counter2[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(6));

-- Location: LCCOMB_X24_Y16_N14
\Add1~14\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~14_combout\ = (counter2(7) & (!\Add1~13\)) # (!counter2(7) & ((\Add1~13\) # (GND)))
-- \Add1~15\ = CARRY((!\Add1~13\) # (!counter2(7)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(7),
	datad => VCC,
	cin => \Add1~13\,
	combout => \Add1~14_combout\,
	cout => \Add1~15\);

-- Location: LCCOMB_X23_Y16_N4
\counter2~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~0_combout\ = (\Add1~14_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~14_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~0_combout\);

-- Location: FF_X23_Y16_N5
\counter2[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(7));

-- Location: LCCOMB_X24_Y16_N16
\Add1~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~16_combout\ = (counter2(8) & (\Add1~15\ $ (GND))) # (!counter2(8) & (!\Add1~15\ & VCC))
-- \Add1~17\ = CARRY((counter2(8) & !\Add1~15\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(8),
	datad => VCC,
	cin => \Add1~15\,
	combout => \Add1~16_combout\,
	cout => \Add1~17\);

-- Location: FF_X24_Y16_N17
\counter2[8]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~16_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(8));

-- Location: LCCOMB_X24_Y16_N18
\Add1~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~18_combout\ = (counter2(9) & (!\Add1~17\)) # (!counter2(9) & ((\Add1~17\) # (GND)))
-- \Add1~19\ = CARRY((!\Add1~17\) # (!counter2(9)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(9),
	datad => VCC,
	cin => \Add1~17\,
	combout => \Add1~18_combout\,
	cout => \Add1~19\);

-- Location: FF_X24_Y16_N19
\counter2[9]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~18_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(9));

-- Location: LCCOMB_X24_Y16_N20
\Add1~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~20_combout\ = (counter2(10) & (\Add1~19\ $ (GND))) # (!counter2(10) & (!\Add1~19\ & VCC))
-- \Add1~21\ = CARRY((counter2(10) & !\Add1~19\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(10),
	datad => VCC,
	cin => \Add1~19\,
	combout => \Add1~20_combout\,
	cout => \Add1~21\);

-- Location: FF_X24_Y16_N21
\counter2[10]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~20_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(10));

-- Location: LCCOMB_X24_Y16_N22
\Add1~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~22_combout\ = (counter2(11) & (!\Add1~21\)) # (!counter2(11) & ((\Add1~21\) # (GND)))
-- \Add1~23\ = CARRY((!\Add1~21\) # (!counter2(11)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(11),
	datad => VCC,
	cin => \Add1~21\,
	combout => \Add1~22_combout\,
	cout => \Add1~23\);

-- Location: FF_X24_Y16_N23
\counter2[11]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~22_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(11));

-- Location: LCCOMB_X24_Y16_N24
\Add1~24\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~24_combout\ = (counter2(12) & (\Add1~23\ $ (GND))) # (!counter2(12) & (!\Add1~23\ & VCC))
-- \Add1~25\ = CARRY((counter2(12) & !\Add1~23\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(12),
	datad => VCC,
	cin => \Add1~23\,
	combout => \Add1~24_combout\,
	cout => \Add1~25\);

-- Location: LCCOMB_X23_Y16_N12
\counter2~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~2_combout\ = (\Add1~24_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~24_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~2_combout\);

-- Location: FF_X23_Y16_N13
\counter2[12]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(12));

-- Location: LCCOMB_X24_Y16_N26
\Add1~26\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~26_combout\ = (counter2(13) & (!\Add1~25\)) # (!counter2(13) & ((\Add1~25\) # (GND)))
-- \Add1~27\ = CARRY((!\Add1~25\) # (!counter2(13)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(13),
	datad => VCC,
	cin => \Add1~25\,
	combout => \Add1~26_combout\,
	cout => \Add1~27\);

-- Location: LCCOMB_X23_Y16_N18
\counter2~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~3_combout\ = (\Add1~26_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~26_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~3_combout\);

-- Location: FF_X23_Y16_N19
\counter2[13]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(13));

-- Location: LCCOMB_X24_Y16_N28
\Add1~28\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~28_combout\ = (counter2(14) & (\Add1~27\ $ (GND))) # (!counter2(14) & (!\Add1~27\ & VCC))
-- \Add1~29\ = CARRY((counter2(14) & !\Add1~27\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(14),
	datad => VCC,
	cin => \Add1~27\,
	combout => \Add1~28_combout\,
	cout => \Add1~29\);

-- Location: LCCOMB_X23_Y16_N28
\counter2~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~4_combout\ = (!\Equal0~10_combout\ & \Add1~28_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Equal0~10_combout\,
	datad => \Add1~28_combout\,
	combout => \counter2~4_combout\);

-- Location: FF_X23_Y16_N29
\counter2[14]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~4_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(14));

-- Location: LCCOMB_X24_Y16_N30
\Add1~30\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~30_combout\ = (counter2(15) & (!\Add1~29\)) # (!counter2(15) & ((\Add1~29\) # (GND)))
-- \Add1~31\ = CARRY((!\Add1~29\) # (!counter2(15)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(15),
	datad => VCC,
	cin => \Add1~29\,
	combout => \Add1~30_combout\,
	cout => \Add1~31\);

-- Location: LCCOMB_X23_Y16_N22
\counter2~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~5_combout\ = (\Add1~30_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~30_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~5_combout\);

-- Location: FF_X23_Y16_N23
\counter2[15]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~5_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(15));

-- Location: LCCOMB_X24_Y15_N0
\Add1~32\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~32_combout\ = (counter2(16) & (\Add1~31\ $ (GND))) # (!counter2(16) & (!\Add1~31\ & VCC))
-- \Add1~33\ = CARRY((counter2(16) & !\Add1~31\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(16),
	datad => VCC,
	cin => \Add1~31\,
	combout => \Add1~32_combout\,
	cout => \Add1~33\);

-- Location: FF_X24_Y15_N1
\counter2[16]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~32_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(16));

-- Location: LCCOMB_X24_Y15_N2
\Add1~34\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~34_combout\ = (counter2(17) & (!\Add1~33\)) # (!counter2(17) & ((\Add1~33\) # (GND)))
-- \Add1~35\ = CARRY((!\Add1~33\) # (!counter2(17)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(17),
	datad => VCC,
	cin => \Add1~33\,
	combout => \Add1~34_combout\,
	cout => \Add1~35\);

-- Location: LCCOMB_X23_Y15_N22
\counter2~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~6_combout\ = (!\Equal0~10_combout\ & \Add1~34_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal0~10_combout\,
	datad => \Add1~34_combout\,
	combout => \counter2~6_combout\);

-- Location: FF_X23_Y15_N23
\counter2[17]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~6_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(17));

-- Location: LCCOMB_X24_Y15_N4
\Add1~36\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~36_combout\ = (counter2(18) & (\Add1~35\ $ (GND))) # (!counter2(18) & (!\Add1~35\ & VCC))
-- \Add1~37\ = CARRY((counter2(18) & !\Add1~35\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(18),
	datad => VCC,
	cin => \Add1~35\,
	combout => \Add1~36_combout\,
	cout => \Add1~37\);

-- Location: FF_X24_Y15_N5
\counter2[18]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~36_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(18));

-- Location: LCCOMB_X24_Y15_N6
\Add1~38\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~38_combout\ = (counter2(19) & (!\Add1~37\)) # (!counter2(19) & ((\Add1~37\) # (GND)))
-- \Add1~39\ = CARRY((!\Add1~37\) # (!counter2(19)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(19),
	datad => VCC,
	cin => \Add1~37\,
	combout => \Add1~38_combout\,
	cout => \Add1~39\);

-- Location: LCCOMB_X23_Y15_N4
\counter2~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~7_combout\ = (!\Equal0~10_combout\ & \Add1~38_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal0~10_combout\,
	datad => \Add1~38_combout\,
	combout => \counter2~7_combout\);

-- Location: FF_X23_Y15_N5
\counter2[19]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~7_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(19));

-- Location: LCCOMB_X24_Y15_N8
\Add1~40\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~40_combout\ = (counter2(20) & (\Add1~39\ $ (GND))) # (!counter2(20) & (!\Add1~39\ & VCC))
-- \Add1~41\ = CARRY((counter2(20) & !\Add1~39\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(20),
	datad => VCC,
	cin => \Add1~39\,
	combout => \Add1~40_combout\,
	cout => \Add1~41\);

-- Location: LCCOMB_X23_Y15_N16
\counter2~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~8_combout\ = (\Add1~40_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~40_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~8_combout\);

-- Location: FF_X23_Y15_N17
\counter2[20]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~8_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(20));

-- Location: LCCOMB_X24_Y15_N10
\Add1~42\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~42_combout\ = (counter2(21) & (!\Add1~41\)) # (!counter2(21) & ((\Add1~41\) # (GND)))
-- \Add1~43\ = CARRY((!\Add1~41\) # (!counter2(21)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(21),
	datad => VCC,
	cin => \Add1~41\,
	combout => \Add1~42_combout\,
	cout => \Add1~43\);

-- Location: LCCOMB_X23_Y15_N2
\counter2~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~9_combout\ = (\Add1~42_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~42_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~9_combout\);

-- Location: FF_X23_Y15_N3
\counter2[21]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(21));

-- Location: LCCOMB_X24_Y15_N12
\Add1~44\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~44_combout\ = (counter2(22) & (\Add1~43\ $ (GND))) # (!counter2(22) & (!\Add1~43\ & VCC))
-- \Add1~45\ = CARRY((counter2(22) & !\Add1~43\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(22),
	datad => VCC,
	cin => \Add1~43\,
	combout => \Add1~44_combout\,
	cout => \Add1~45\);

-- Location: LCCOMB_X23_Y15_N8
\counter2~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~10_combout\ = (\Add1~44_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~44_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~10_combout\);

-- Location: FF_X23_Y15_N9
\counter2[22]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(22));

-- Location: LCCOMB_X24_Y15_N14
\Add1~46\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~46_combout\ = (counter2(23) & (!\Add1~45\)) # (!counter2(23) & ((\Add1~45\) # (GND)))
-- \Add1~47\ = CARRY((!\Add1~45\) # (!counter2(23)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(23),
	datad => VCC,
	cin => \Add1~45\,
	combout => \Add1~46_combout\,
	cout => \Add1~47\);

-- Location: LCCOMB_X23_Y15_N30
\counter2~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~11_combout\ = (\Add1~46_combout\ & !\Equal0~10_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Add1~46_combout\,
	datad => \Equal0~10_combout\,
	combout => \counter2~11_combout\);

-- Location: FF_X23_Y15_N31
\counter2[23]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(23));

-- Location: LCCOMB_X24_Y15_N16
\Add1~48\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~48_combout\ = (counter2(24) & (\Add1~47\ $ (GND))) # (!counter2(24) & (!\Add1~47\ & VCC))
-- \Add1~49\ = CARRY((counter2(24) & !\Add1~47\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(24),
	datad => VCC,
	cin => \Add1~47\,
	combout => \Add1~48_combout\,
	cout => \Add1~49\);

-- Location: FF_X24_Y15_N17
\counter2[24]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~48_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(24));

-- Location: LCCOMB_X24_Y15_N18
\Add1~50\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~50_combout\ = (counter2(25) & (!\Add1~49\)) # (!counter2(25) & ((\Add1~49\) # (GND)))
-- \Add1~51\ = CARRY((!\Add1~49\) # (!counter2(25)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(25),
	datad => VCC,
	cin => \Add1~49\,
	combout => \Add1~50_combout\,
	cout => \Add1~51\);

-- Location: LCCOMB_X23_Y15_N0
\counter2~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \counter2~12_combout\ = (!\Equal0~10_combout\ & \Add1~50_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal0~10_combout\,
	datad => \Add1~50_combout\,
	combout => \counter2~12_combout\);

-- Location: FF_X23_Y15_N1
\counter2[25]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \counter2~12_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(25));

-- Location: LCCOMB_X24_Y15_N20
\Add1~52\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~52_combout\ = (counter2(26) & (\Add1~51\ $ (GND))) # (!counter2(26) & (!\Add1~51\ & VCC))
-- \Add1~53\ = CARRY((counter2(26) & !\Add1~51\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(26),
	datad => VCC,
	cin => \Add1~51\,
	combout => \Add1~52_combout\,
	cout => \Add1~53\);

-- Location: FF_X24_Y15_N21
\counter2[26]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~52_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(26));

-- Location: LCCOMB_X24_Y15_N22
\Add1~54\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~54_combout\ = (counter2(27) & (!\Add1~53\)) # (!counter2(27) & ((\Add1~53\) # (GND)))
-- \Add1~55\ = CARRY((!\Add1~53\) # (!counter2(27)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(27),
	datad => VCC,
	cin => \Add1~53\,
	combout => \Add1~54_combout\,
	cout => \Add1~55\);

-- Location: FF_X24_Y15_N23
\counter2[27]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~54_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(27));

-- Location: LCCOMB_X24_Y15_N24
\Add1~56\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~56_combout\ = (counter2(28) & (\Add1~55\ $ (GND))) # (!counter2(28) & (!\Add1~55\ & VCC))
-- \Add1~57\ = CARRY((counter2(28) & !\Add1~55\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(28),
	datad => VCC,
	cin => \Add1~55\,
	combout => \Add1~56_combout\,
	cout => \Add1~57\);

-- Location: FF_X24_Y15_N25
\counter2[28]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~56_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(28));

-- Location: LCCOMB_X24_Y15_N26
\Add1~58\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~58_combout\ = (counter2(29) & (!\Add1~57\)) # (!counter2(29) & ((\Add1~57\) # (GND)))
-- \Add1~59\ = CARRY((!\Add1~57\) # (!counter2(29)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(29),
	datad => VCC,
	cin => \Add1~57\,
	combout => \Add1~58_combout\,
	cout => \Add1~59\);

-- Location: FF_X24_Y15_N27
\counter2[29]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~58_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(29));

-- Location: LCCOMB_X24_Y15_N28
\Add1~60\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~60_combout\ = (counter2(30) & (\Add1~59\ $ (GND))) # (!counter2(30) & (!\Add1~59\ & VCC))
-- \Add1~61\ = CARRY((counter2(30) & !\Add1~59\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => counter2(30),
	datad => VCC,
	cin => \Add1~59\,
	combout => \Add1~60_combout\,
	cout => \Add1~61\);

-- Location: FF_X24_Y15_N29
\counter2[30]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~60_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(30));

-- Location: LCCOMB_X24_Y15_N30
\Add1~62\ : cycloneive_lcell_comb
-- Equation(s):
-- \Add1~62_combout\ = counter2(31) $ (\Add1~61\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => counter2(31),
	cin => \Add1~61\,
	combout => \Add1~62_combout\);

-- Location: FF_X24_Y15_N31
\counter2[31]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \Add1~62_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => counter2(31));

-- Location: LCCOMB_X23_Y15_N12
\Equal0~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~9_combout\ = (!counter2(31) & (!counter2(28) & (!counter2(30) & !counter2(29))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(31),
	datab => counter2(28),
	datac => counter2(30),
	datad => counter2(29),
	combout => \Equal0~9_combout\);

-- Location: LCCOMB_X23_Y15_N18
\Equal0~8\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~8_combout\ = (!counter2(26) & (counter2(25) & (!counter2(24) & !counter2(27))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(26),
	datab => counter2(25),
	datac => counter2(24),
	datad => counter2(27),
	combout => \Equal0~8_combout\);

-- Location: LCCOMB_X23_Y15_N26
\Equal0~5\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~5_combout\ = (counter2(19) & !counter2(18))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => counter2(19),
	datad => counter2(18),
	combout => \Equal0~5_combout\);

-- Location: LCCOMB_X23_Y15_N28
\Equal0~6\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~6_combout\ = (counter2(23) & (counter2(21) & (counter2(22) & counter2(20))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(23),
	datab => counter2(21),
	datac => counter2(22),
	datad => counter2(20),
	combout => \Equal0~6_combout\);

-- Location: LCCOMB_X23_Y15_N14
\Equal0~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~7_combout\ = (counter2(17) & (!counter2(16) & (\Equal0~5_combout\ & \Equal0~6_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0010000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(17),
	datab => counter2(16),
	datac => \Equal0~5_combout\,
	datad => \Equal0~6_combout\,
	combout => \Equal0~7_combout\);

-- Location: LCCOMB_X23_Y16_N30
\Equal0~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~1_combout\ = (!counter2(1) & (!counter2(0) & (counter2(7) & !counter2(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(1),
	datab => counter2(0),
	datac => counter2(7),
	datad => counter2(2),
	combout => \Equal0~1_combout\);

-- Location: LCCOMB_X23_Y15_N20
\Equal0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~0_combout\ = (!counter2(6) & (!counter2(3) & (!counter2(4) & !counter2(5))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(6),
	datab => counter2(3),
	datac => counter2(4),
	datad => counter2(5),
	combout => \Equal0~0_combout\);

-- Location: LCCOMB_X23_Y16_N8
\Equal0~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~3_combout\ = (counter2(12) & (counter2(13) & (counter2(15) & counter2(14))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(12),
	datab => counter2(13),
	datac => counter2(15),
	datad => counter2(14),
	combout => \Equal0~3_combout\);

-- Location: LCCOMB_X23_Y15_N6
\Equal0~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~2_combout\ = (!counter2(11) & (!counter2(8) & (!counter2(9) & !counter2(10))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => counter2(11),
	datab => counter2(8),
	datac => counter2(9),
	datad => counter2(10),
	combout => \Equal0~2_combout\);

-- Location: LCCOMB_X23_Y15_N24
\Equal0~4\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~4_combout\ = (\Equal0~1_combout\ & (\Equal0~0_combout\ & (\Equal0~3_combout\ & \Equal0~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal0~1_combout\,
	datab => \Equal0~0_combout\,
	datac => \Equal0~3_combout\,
	datad => \Equal0~2_combout\,
	combout => \Equal0~4_combout\);

-- Location: LCCOMB_X23_Y15_N10
\Equal0~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \Equal0~10_combout\ = (\Equal0~9_combout\ & (\Equal0~8_combout\ & (\Equal0~7_combout\ & \Equal0~4_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Equal0~9_combout\,
	datab => \Equal0~8_combout\,
	datac => \Equal0~7_combout\,
	datad => \Equal0~4_combout\,
	combout => \Equal0~10_combout\);

-- Location: LCCOMB_X24_Y18_N30
\uart_tx|LessThan1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|LessThan1~0_combout\ = (!\uart_tx|r_Clock_Count\(5) & (!\uart_tx|r_Clock_Count\(3) & ((!\uart_tx|r_Clock_Count\(2)) # (!\uart_tx|r_Clock_Count\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000100010001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(5),
	datab => \uart_tx|r_Clock_Count\(3),
	datac => \uart_tx|r_Clock_Count\(1),
	datad => \uart_tx|r_Clock_Count\(2),
	combout => \uart_tx|LessThan1~0_combout\);

-- Location: LCCOMB_X24_Y18_N2
\uart_tx|LessThan1~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|LessThan1~2_combout\ = (!\uart_tx|r_Clock_Count\(7) & ((\uart_tx|LessThan1~0_combout\) # (\uart_tx|LessThan1~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(7),
	datac => \uart_tx|LessThan1~0_combout\,
	datad => \uart_tx|LessThan1~1_combout\,
	combout => \uart_tx|LessThan1~2_combout\);

-- Location: LCCOMB_X24_Y18_N10
\uart_tx|Selector15~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector15~1_combout\ = (\uart_tx|r_SM_Main.000~q\ & (((\uart_tx|r_SM_Main.s_TX_START_BIT~q\ & \uart_tx|LessThan1~2_combout\)))) # (!\uart_tx|r_SM_Main.000~q\ & ((\uart_tx_data_valid_reg~q\) # ((\uart_tx|r_SM_Main.s_TX_START_BIT~q\ & 
-- \uart_tx|LessThan1~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010001000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_SM_Main.000~q\,
	datab => \uart_tx_data_valid_reg~q\,
	datac => \uart_tx|r_SM_Main.s_TX_START_BIT~q\,
	datad => \uart_tx|LessThan1~2_combout\,
	combout => \uart_tx|Selector15~1_combout\);

-- Location: FF_X24_Y18_N11
\uart_tx|r_SM_Main.s_TX_START_BIT\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector15~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_SM_Main.s_TX_START_BIT~q\);

-- Location: LCCOMB_X24_Y18_N4
\uart_tx|Selector12~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector12~0_combout\ = (!\uart_tx|r_Clock_Count\(7) & ((\uart_tx|LessThan1~0_combout\) # (\uart_tx|LessThan1~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(7),
	datac => \uart_tx|LessThan1~0_combout\,
	datad => \uart_tx|LessThan1~1_combout\,
	combout => \uart_tx|Selector12~0_combout\);

-- Location: LCCOMB_X23_Y18_N28
\uart_tx|Selector12~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector12~1_combout\ = (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & ((\uart_tx|r_Bit_Index\(0) $ (!\uart_tx|Selector12~0_combout\)))) # (!\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & (\uart_tx|r_SM_Main.000~q\ & (\uart_tx|r_Bit_Index\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000000101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_SM_Main.000~q\,
	datab => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datac => \uart_tx|r_Bit_Index\(0),
	datad => \uart_tx|Selector12~0_combout\,
	combout => \uart_tx|Selector12~1_combout\);

-- Location: FF_X23_Y18_N29
\uart_tx|r_Bit_Index[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector12~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Bit_Index\(0));

-- Location: LCCOMB_X22_Y18_N28
\uart_tx|Selector11~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector11~0_combout\ = (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & (\uart_tx|r_Bit_Index\(0))) # (!\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & ((\uart_tx|r_SM_Main.000~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Bit_Index\(0),
	datac => \uart_tx|r_SM_Main.000~q\,
	datad => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	combout => \uart_tx|Selector11~0_combout\);

-- Location: LCCOMB_X22_Y18_N16
\uart_tx|Selector11~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector11~1_combout\ = (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & (\uart_tx|r_Bit_Index\(1) $ (((\uart_tx|Selector11~0_combout\ & !\uart_tx|LessThan1~2_combout\))))) # (!\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & (\uart_tx|Selector11~0_combout\ & 
-- (\uart_tx|r_Bit_Index\(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000001101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datab => \uart_tx|Selector11~0_combout\,
	datac => \uart_tx|r_Bit_Index\(1),
	datad => \uart_tx|LessThan1~2_combout\,
	combout => \uart_tx|Selector11~1_combout\);

-- Location: FF_X22_Y18_N17
\uart_tx|r_Bit_Index[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector11~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Bit_Index\(1));

-- Location: LCCOMB_X22_Y18_N14
\uart_tx|Selector10~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector10~1_combout\ = (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & (\uart_tx|r_Bit_Index\(1))) # (!\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & ((\uart_tx|r_SM_Main.000~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Bit_Index\(1),
	datac => \uart_tx|r_SM_Main.000~q\,
	datad => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	combout => \uart_tx|Selector10~1_combout\);

-- Location: LCCOMB_X23_Y18_N18
\uart_tx|Selector10~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector10~0_combout\ = (\uart_tx|r_Bit_Index\(0) & ((\uart_tx|r_Clock_Count\(7)) # ((!\uart_tx|LessThan1~1_combout\ & !\uart_tx|LessThan1~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100010001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(7),
	datab => \uart_tx|r_Bit_Index\(0),
	datac => \uart_tx|LessThan1~1_combout\,
	datad => \uart_tx|LessThan1~0_combout\,
	combout => \uart_tx|Selector10~0_combout\);

-- Location: LCCOMB_X23_Y18_N6
\uart_tx|Selector10~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector10~2_combout\ = (\uart_tx|Selector10~1_combout\ & (\uart_tx|r_Bit_Index\(2) $ (((\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & \uart_tx|Selector10~0_combout\))))) # (!\uart_tx|Selector10~1_combout\ & (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & 
-- (\uart_tx|r_Bit_Index\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110100011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|Selector10~1_combout\,
	datab => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datac => \uart_tx|r_Bit_Index\(2),
	datad => \uart_tx|Selector10~0_combout\,
	combout => \uart_tx|Selector10~2_combout\);

-- Location: FF_X23_Y18_N7
\uart_tx|r_Bit_Index[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector10~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Bit_Index\(2));

-- Location: LCCOMB_X23_Y18_N12
\uart_tx|r_SM_Main.s_TX_STOP_BIT~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\ = (\uart_tx|r_Bit_Index\(1) & (\uart_tx|r_Bit_Index\(0) & (\uart_tx|r_Bit_Index\(2) & !\uart_tx|LessThan1~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Bit_Index\(1),
	datab => \uart_tx|r_Bit_Index\(0),
	datac => \uart_tx|r_Bit_Index\(2),
	datad => \uart_tx|LessThan1~2_combout\,
	combout => \uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\);

-- Location: LCCOMB_X23_Y18_N16
\uart_tx|Selector16~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector16~0_combout\ = (\uart_tx|LessThan1~2_combout\ & (((\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & !\uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\)))) # (!\uart_tx|LessThan1~2_combout\ & ((\uart_tx|r_SM_Main.s_TX_START_BIT~q\) # 
-- ((\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & !\uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100010011110100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|LessThan1~2_combout\,
	datab => \uart_tx|r_SM_Main.s_TX_START_BIT~q\,
	datac => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datad => \uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\,
	combout => \uart_tx|Selector16~0_combout\);

-- Location: FF_X23_Y18_N17
\uart_tx|r_SM_Main.s_TX_DATA_BITS\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector16~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\);

-- Location: LCCOMB_X23_Y18_N30
\uart_tx|r_SM_Main.s_TX_STOP_BIT~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_SM_Main.s_TX_STOP_BIT~1_combout\ = (\uart_tx|LessThan1~2_combout\ & ((\uart_tx|r_SM_Main.s_TX_STOP_BIT~q\) # ((\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & \uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\)))) # (!\uart_tx|LessThan1~2_combout\ & 
-- (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & ((\uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110110010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|LessThan1~2_combout\,
	datab => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datac => \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\,
	datad => \uart_tx|r_SM_Main.s_TX_STOP_BIT~0_combout\,
	combout => \uart_tx|r_SM_Main.s_TX_STOP_BIT~1_combout\);

-- Location: FF_X23_Y18_N31
\uart_tx|r_SM_Main.s_TX_STOP_BIT\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_SM_Main.s_TX_STOP_BIT~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\);

-- Location: LCCOMB_X23_Y18_N20
\uart_tx|Selector1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector1~0_combout\ = (\uart_tx|r_Tx_Done~q\ & ((\uart_tx|r_SM_Main.s_TX_STOP_BIT~q\) # ((\uart_tx|r_SM_Main.s_TX_START_BIT~q\) # (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Tx_Done~q\,
	datab => \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\,
	datac => \uart_tx|r_SM_Main.s_TX_START_BIT~q\,
	datad => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	combout => \uart_tx|Selector1~0_combout\);

-- Location: LCCOMB_X23_Y18_N2
\uart_tx|Selector1~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector1~1_combout\ = (\uart_tx|Selector1~0_combout\) # ((\uart_tx|r_SM_Main.s_CLEANUP~q\) # ((\uart_tx|r_SM_Main.s_TX_STOP_BIT~q\ & !\uart_tx|LessThan1~2_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|Selector1~0_combout\,
	datab => \uart_tx|r_SM_Main.s_CLEANUP~q\,
	datac => \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\,
	datad => \uart_tx|LessThan1~2_combout\,
	combout => \uart_tx|Selector1~1_combout\);

-- Location: FF_X23_Y18_N3
\uart_tx|r_Tx_Done\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector1~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Done~q\);

-- Location: LCCOMB_X23_Y18_N24
\uart_tx_data_valid_reg~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data_valid_reg~0_combout\ = (\Equal0~10_combout\) # ((\uart_tx_data_valid_reg~q\ & !\uart_tx|r_Tx_Done~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Equal0~10_combout\,
	datac => \uart_tx_data_valid_reg~q\,
	datad => \uart_tx|r_Tx_Done~q\,
	combout => \uart_tx_data_valid_reg~0_combout\);

-- Location: FF_X23_Y18_N25
uart_tx_data_valid_reg : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data_valid_reg~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx_data_valid_reg~q\);

-- Location: LCCOMB_X22_Y18_N8
\uart_tx|Selector14~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector14~0_combout\ = (!\uart_tx|r_SM_Main.s_CLEANUP~q\ & ((\uart_tx|r_SM_Main.000~q\) # (\uart_tx_data_valid_reg~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_SM_Main.s_CLEANUP~q\,
	datac => \uart_tx|r_SM_Main.000~q\,
	datad => \uart_tx_data_valid_reg~q\,
	combout => \uart_tx|Selector14~0_combout\);

-- Location: FF_X22_Y18_N9
\uart_tx|r_SM_Main.000\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector14~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_SM_Main.000~q\);

-- Location: LCCOMB_X24_Y18_N0
\uart_tx|r_Clock_Count[7]~12\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[7]~12_combout\ = (\uart_tx|r_Clock_Count\(7)) # (((!\uart_tx|LessThan1~1_combout\ & !\uart_tx|LessThan1~0_combout\)) # (!\uart_tx|r_SM_Main.000~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(7),
	datab => \uart_tx|LessThan1~1_combout\,
	datac => \uart_tx|r_SM_Main.000~q\,
	datad => \uart_tx|LessThan1~0_combout\,
	combout => \uart_tx|r_Clock_Count[7]~12_combout\);

-- Location: FF_X24_Y18_N13
\uart_tx|r_Clock_Count[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[0]~8_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(0));

-- Location: LCCOMB_X24_Y18_N14
\uart_tx|r_Clock_Count[1]~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[1]~10_combout\ = (\uart_tx|r_Clock_Count\(1) & (!\uart_tx|r_Clock_Count[0]~9\)) # (!\uart_tx|r_Clock_Count\(1) & ((\uart_tx|r_Clock_Count[0]~9\) # (GND)))
-- \uart_tx|r_Clock_Count[1]~11\ = CARRY((!\uart_tx|r_Clock_Count[0]~9\) # (!\uart_tx|r_Clock_Count\(1)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Clock_Count\(1),
	datad => VCC,
	cin => \uart_tx|r_Clock_Count[0]~9\,
	combout => \uart_tx|r_Clock_Count[1]~10_combout\,
	cout => \uart_tx|r_Clock_Count[1]~11\);

-- Location: FF_X24_Y18_N15
\uart_tx|r_Clock_Count[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[1]~10_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(1));

-- Location: LCCOMB_X24_Y18_N16
\uart_tx|r_Clock_Count[2]~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[2]~13_combout\ = (\uart_tx|r_Clock_Count\(2) & (\uart_tx|r_Clock_Count[1]~11\ $ (GND))) # (!\uart_tx|r_Clock_Count\(2) & (!\uart_tx|r_Clock_Count[1]~11\ & VCC))
-- \uart_tx|r_Clock_Count[2]~14\ = CARRY((\uart_tx|r_Clock_Count\(2) & !\uart_tx|r_Clock_Count[1]~11\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Clock_Count\(2),
	datad => VCC,
	cin => \uart_tx|r_Clock_Count[1]~11\,
	combout => \uart_tx|r_Clock_Count[2]~13_combout\,
	cout => \uart_tx|r_Clock_Count[2]~14\);

-- Location: FF_X24_Y18_N17
\uart_tx|r_Clock_Count[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[2]~13_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(2));

-- Location: LCCOMB_X24_Y18_N18
\uart_tx|r_Clock_Count[3]~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[3]~15_combout\ = (\uart_tx|r_Clock_Count\(3) & (!\uart_tx|r_Clock_Count[2]~14\)) # (!\uart_tx|r_Clock_Count\(3) & ((\uart_tx|r_Clock_Count[2]~14\) # (GND)))
-- \uart_tx|r_Clock_Count[3]~16\ = CARRY((!\uart_tx|r_Clock_Count[2]~14\) # (!\uart_tx|r_Clock_Count\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Clock_Count\(3),
	datad => VCC,
	cin => \uart_tx|r_Clock_Count[2]~14\,
	combout => \uart_tx|r_Clock_Count[3]~15_combout\,
	cout => \uart_tx|r_Clock_Count[3]~16\);

-- Location: FF_X24_Y18_N19
\uart_tx|r_Clock_Count[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[3]~15_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(3));

-- Location: LCCOMB_X24_Y18_N20
\uart_tx|r_Clock_Count[4]~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[4]~17_combout\ = (\uart_tx|r_Clock_Count\(4) & (\uart_tx|r_Clock_Count[3]~16\ $ (GND))) # (!\uart_tx|r_Clock_Count\(4) & (!\uart_tx|r_Clock_Count[3]~16\ & VCC))
-- \uart_tx|r_Clock_Count[4]~18\ = CARRY((\uart_tx|r_Clock_Count\(4) & !\uart_tx|r_Clock_Count[3]~16\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Clock_Count\(4),
	datad => VCC,
	cin => \uart_tx|r_Clock_Count[3]~16\,
	combout => \uart_tx|r_Clock_Count[4]~17_combout\,
	cout => \uart_tx|r_Clock_Count[4]~18\);

-- Location: FF_X24_Y18_N21
\uart_tx|r_Clock_Count[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[4]~17_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(4));

-- Location: LCCOMB_X24_Y18_N22
\uart_tx|r_Clock_Count[5]~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[5]~19_combout\ = (\uart_tx|r_Clock_Count\(5) & (!\uart_tx|r_Clock_Count[4]~18\)) # (!\uart_tx|r_Clock_Count\(5) & ((\uart_tx|r_Clock_Count[4]~18\) # (GND)))
-- \uart_tx|r_Clock_Count[5]~20\ = CARRY((!\uart_tx|r_Clock_Count[4]~18\) # (!\uart_tx|r_Clock_Count\(5)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(5),
	datad => VCC,
	cin => \uart_tx|r_Clock_Count[4]~18\,
	combout => \uart_tx|r_Clock_Count[5]~19_combout\,
	cout => \uart_tx|r_Clock_Count[5]~20\);

-- Location: FF_X24_Y18_N23
\uart_tx|r_Clock_Count[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[5]~19_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(5));

-- Location: LCCOMB_X24_Y18_N24
\uart_tx|r_Clock_Count[6]~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[6]~21_combout\ = (\uart_tx|r_Clock_Count\(6) & (\uart_tx|r_Clock_Count[5]~20\ $ (GND))) # (!\uart_tx|r_Clock_Count\(6) & (!\uart_tx|r_Clock_Count[5]~20\ & VCC))
-- \uart_tx|r_Clock_Count[6]~22\ = CARRY((\uart_tx|r_Clock_Count\(6) & !\uart_tx|r_Clock_Count[5]~20\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => \uart_tx|r_Clock_Count\(6),
	datad => VCC,
	cin => \uart_tx|r_Clock_Count[5]~20\,
	combout => \uart_tx|r_Clock_Count[6]~21_combout\,
	cout => \uart_tx|r_Clock_Count[6]~22\);

-- Location: FF_X24_Y18_N25
\uart_tx|r_Clock_Count[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[6]~21_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(6));

-- Location: LCCOMB_X24_Y18_N26
\uart_tx|r_Clock_Count[7]~23\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Clock_Count[7]~23_combout\ = \uart_tx|r_Clock_Count\(7) $ (\uart_tx|r_Clock_Count[6]~22\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(7),
	cin => \uart_tx|r_Clock_Count[6]~22\,
	combout => \uart_tx|r_Clock_Count[7]~23_combout\);

-- Location: FF_X24_Y18_N27
\uart_tx|r_Clock_Count[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Clock_Count[7]~23_combout\,
	sclr => \uart_tx|r_Clock_Count[7]~12_combout\,
	ena => \uart_tx|ALT_INV_r_SM_Main.s_CLEANUP~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Clock_Count\(7));

-- Location: LCCOMB_X24_Y18_N8
\uart_tx|r_SM_Main~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_SM_Main~9_combout\ = (\uart_tx|r_SM_Main.s_TX_STOP_BIT~q\ & ((\uart_tx|r_Clock_Count\(7)) # ((!\uart_tx|LessThan1~1_combout\ & !\uart_tx|LessThan1~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Clock_Count\(7),
	datab => \uart_tx|LessThan1~1_combout\,
	datac => \uart_tx|LessThan1~0_combout\,
	datad => \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\,
	combout => \uart_tx|r_SM_Main~9_combout\);

-- Location: FF_X24_Y18_N9
\uart_tx|r_SM_Main.s_CLEANUP\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_SM_Main~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_SM_Main.s_CLEANUP~q\);

-- Location: LCCOMB_X22_Y15_N0
\uart_tx_data[0]~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[0]~21_combout\ = \Equal0~10_combout\ $ (uart_tx_data(0))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Equal0~10_combout\,
	datac => uart_tx_data(0),
	combout => \uart_tx_data[0]~21_combout\);

-- Location: FF_X22_Y15_N1
\uart_tx_data[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[0]~21_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(0));

-- Location: LCCOMB_X22_Y15_N6
\uart_tx_data[1]~7\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[1]~7_combout\ = (uart_tx_data(1) & (uart_tx_data(0) $ (VCC))) # (!uart_tx_data(1) & (uart_tx_data(0) & VCC))
-- \uart_tx_data[1]~8\ = CARRY((uart_tx_data(1) & uart_tx_data(0)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110011010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => uart_tx_data(1),
	datab => uart_tx_data(0),
	datad => VCC,
	combout => \uart_tx_data[1]~7_combout\,
	cout => \uart_tx_data[1]~8\);

-- Location: FF_X22_Y15_N7
\uart_tx_data[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[1]~7_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(1));

-- Location: LCCOMB_X22_Y15_N8
\uart_tx_data[2]~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[2]~9_combout\ = (uart_tx_data(2) & (!\uart_tx_data[1]~8\)) # (!uart_tx_data(2) & ((\uart_tx_data[1]~8\) # (GND)))
-- \uart_tx_data[2]~10\ = CARRY((!\uart_tx_data[1]~8\) # (!uart_tx_data(2)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => uart_tx_data(2),
	datad => VCC,
	cin => \uart_tx_data[1]~8\,
	combout => \uart_tx_data[2]~9_combout\,
	cout => \uart_tx_data[2]~10\);

-- Location: FF_X22_Y15_N9
\uart_tx_data[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[2]~9_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(2));

-- Location: LCCOMB_X22_Y15_N10
\uart_tx_data[3]~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[3]~11_combout\ = (uart_tx_data(3) & (\uart_tx_data[2]~10\ $ (GND))) # (!uart_tx_data(3) & (!\uart_tx_data[2]~10\ & VCC))
-- \uart_tx_data[3]~12\ = CARRY((uart_tx_data(3) & !\uart_tx_data[2]~10\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010010100001010",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => uart_tx_data(3),
	datad => VCC,
	cin => \uart_tx_data[2]~10\,
	combout => \uart_tx_data[3]~11_combout\,
	cout => \uart_tx_data[3]~12\);

-- Location: FF_X22_Y15_N11
\uart_tx_data[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[3]~11_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(3));

-- Location: LCCOMB_X22_Y15_N12
\uart_tx_data[4]~13\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[4]~13_combout\ = (uart_tx_data(4) & (!\uart_tx_data[3]~12\)) # (!uart_tx_data(4) & ((\uart_tx_data[3]~12\) # (GND)))
-- \uart_tx_data[4]~14\ = CARRY((!\uart_tx_data[3]~12\) # (!uart_tx_data(4)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001011111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	dataa => uart_tx_data(4),
	datad => VCC,
	cin => \uart_tx_data[3]~12\,
	combout => \uart_tx_data[4]~13_combout\,
	cout => \uart_tx_data[4]~14\);

-- Location: FF_X22_Y15_N13
\uart_tx_data[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[4]~13_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(4));

-- Location: LCCOMB_X22_Y15_N14
\uart_tx_data[5]~15\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[5]~15_combout\ = (uart_tx_data(5) & (\uart_tx_data[4]~14\ $ (GND))) # (!uart_tx_data(5) & (!\uart_tx_data[4]~14\ & VCC))
-- \uart_tx_data[5]~16\ = CARRY((uart_tx_data(5) & !\uart_tx_data[4]~14\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100001100001100",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => uart_tx_data(5),
	datad => VCC,
	cin => \uart_tx_data[4]~14\,
	combout => \uart_tx_data[5]~15_combout\,
	cout => \uart_tx_data[5]~16\);

-- Location: FF_X22_Y15_N15
\uart_tx_data[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[5]~15_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(5));

-- Location: LCCOMB_X22_Y15_N16
\uart_tx_data[6]~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[6]~17_combout\ = (uart_tx_data(6) & (!\uart_tx_data[5]~16\)) # (!uart_tx_data(6) & ((\uart_tx_data[5]~16\) # (GND)))
-- \uart_tx_data[6]~18\ = CARRY((!\uart_tx_data[5]~16\) # (!uart_tx_data(6)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011110000111111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datab => uart_tx_data(6),
	datad => VCC,
	cin => \uart_tx_data[5]~16\,
	combout => \uart_tx_data[6]~17_combout\,
	cout => \uart_tx_data[6]~18\);

-- Location: FF_X22_Y15_N17
\uart_tx_data[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[6]~17_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(6));

-- Location: LCCOMB_X22_Y18_N18
\uart_tx|Selector15~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector15~0_combout\ = (!\uart_tx|r_SM_Main.000~q\ & \uart_tx_data_valid_reg~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \uart_tx|r_SM_Main.000~q\,
	datad => \uart_tx_data_valid_reg~q\,
	combout => \uart_tx|Selector15~0_combout\);

-- Location: FF_X22_Y18_N31
\uart_tx|r_Tx_Data[6]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	asdata => uart_tx_data(6),
	sload => VCC,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(6));

-- Location: LCCOMB_X22_Y15_N18
\uart_tx_data[7]~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx_data[7]~19_combout\ = \uart_tx_data[6]~18\ $ (!uart_tx_data(7))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000001111",
	sum_lutc_input => "cin")
-- pragma translate_on
PORT MAP (
	datad => uart_tx_data(7),
	cin => \uart_tx_data[6]~18\,
	combout => \uart_tx_data[7]~19_combout\);

-- Location: FF_X22_Y15_N19
\uart_tx_data[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \uart_tx_data[7]~19_combout\,
	ena => \Equal0~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => uart_tx_data(7));

-- Location: FF_X22_Y18_N11
\uart_tx|r_Tx_Data[7]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	asdata => uart_tx_data(7),
	sload => VCC,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(7));

-- Location: LCCOMB_X22_Y18_N22
\uart_tx|r_Tx_Data[5]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Tx_Data[5]~feeder_combout\ = uart_tx_data(5)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => uart_tx_data(5),
	combout => \uart_tx|r_Tx_Data[5]~feeder_combout\);

-- Location: FF_X22_Y18_N23
\uart_tx|r_Tx_Data[5]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Tx_Data[5]~feeder_combout\,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(5));

-- Location: FF_X22_Y18_N21
\uart_tx|r_Tx_Data[4]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	asdata => uart_tx_data(4),
	sload => VCC,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(4));

-- Location: LCCOMB_X22_Y18_N20
\uart_tx|Mux0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Mux0~0_combout\ = (\uart_tx|r_Bit_Index\(1) & (((\uart_tx|r_Bit_Index\(0))))) # (!\uart_tx|r_Bit_Index\(1) & ((\uart_tx|r_Bit_Index\(0) & (\uart_tx|r_Tx_Data\(5))) # (!\uart_tx|r_Bit_Index\(0) & ((\uart_tx|r_Tx_Data\(4))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Tx_Data\(5),
	datab => \uart_tx|r_Bit_Index\(1),
	datac => \uart_tx|r_Tx_Data\(4),
	datad => \uart_tx|r_Bit_Index\(0),
	combout => \uart_tx|Mux0~0_combout\);

-- Location: LCCOMB_X22_Y18_N10
\uart_tx|Mux0~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Mux0~1_combout\ = (\uart_tx|r_Bit_Index\(1) & ((\uart_tx|Mux0~0_combout\ & ((\uart_tx|r_Tx_Data\(7)))) # (!\uart_tx|Mux0~0_combout\ & (\uart_tx|r_Tx_Data\(6))))) # (!\uart_tx|r_Bit_Index\(1) & (((\uart_tx|Mux0~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Tx_Data\(6),
	datab => \uart_tx|r_Bit_Index\(1),
	datac => \uart_tx|r_Tx_Data\(7),
	datad => \uart_tx|Mux0~0_combout\,
	combout => \uart_tx|Mux0~1_combout\);

-- Location: LCCOMB_X22_Y18_N2
\uart_tx|Selector0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector0~0_combout\ = ((\uart_tx|r_Bit_Index\(2) & (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & \uart_tx|Mux0~1_combout\))) # (!\uart_tx|r_SM_Main.000~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000111100001111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Bit_Index\(2),
	datab => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datac => \uart_tx|r_SM_Main.000~q\,
	datad => \uart_tx|Mux0~1_combout\,
	combout => \uart_tx|Selector0~0_combout\);

-- Location: LCCOMB_X22_Y18_N12
\uart_tx|r_Tx_Data[2]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Tx_Data[2]~feeder_combout\ = uart_tx_data(2)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => uart_tx_data(2),
	combout => \uart_tx|r_Tx_Data[2]~feeder_combout\);

-- Location: FF_X22_Y18_N13
\uart_tx|r_Tx_Data[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Tx_Data[2]~feeder_combout\,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(2));

-- Location: FF_X22_Y18_N7
\uart_tx|r_Tx_Data[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	asdata => uart_tx_data(3),
	sload => VCC,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(3));

-- Location: LCCOMB_X22_Y18_N26
\uart_tx|r_Tx_Data[1]~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|r_Tx_Data[1]~feeder_combout\ = uart_tx_data(1)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => uart_tx_data(1),
	combout => \uart_tx|r_Tx_Data[1]~feeder_combout\);

-- Location: FF_X22_Y18_N27
\uart_tx|r_Tx_Data[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|r_Tx_Data[1]~feeder_combout\,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(1));

-- Location: FF_X22_Y18_N1
\uart_tx|r_Tx_Data[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	asdata => uart_tx_data(0),
	sload => VCC,
	ena => \uart_tx|Selector15~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|r_Tx_Data\(0));

-- Location: LCCOMB_X22_Y18_N0
\uart_tx|Mux0~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Mux0~2_combout\ = (\uart_tx|r_Bit_Index\(1) & (((\uart_tx|r_Bit_Index\(0))))) # (!\uart_tx|r_Bit_Index\(1) & ((\uart_tx|r_Bit_Index\(0) & (\uart_tx|r_Tx_Data\(1))) # (!\uart_tx|r_Bit_Index\(0) & ((\uart_tx|r_Tx_Data\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111000110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Tx_Data\(1),
	datab => \uart_tx|r_Bit_Index\(1),
	datac => \uart_tx|r_Tx_Data\(0),
	datad => \uart_tx|r_Bit_Index\(0),
	combout => \uart_tx|Mux0~2_combout\);

-- Location: LCCOMB_X22_Y18_N6
\uart_tx|Mux0~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Mux0~3_combout\ = (\uart_tx|r_Bit_Index\(1) & ((\uart_tx|Mux0~2_combout\ & ((\uart_tx|r_Tx_Data\(3)))) # (!\uart_tx|Mux0~2_combout\ & (\uart_tx|r_Tx_Data\(2))))) # (!\uart_tx|r_Bit_Index\(1) & (((\uart_tx|Mux0~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111001110001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Tx_Data\(2),
	datab => \uart_tx|r_Bit_Index\(1),
	datac => \uart_tx|r_Tx_Data\(3),
	datad => \uart_tx|Mux0~2_combout\,
	combout => \uart_tx|Mux0~3_combout\);

-- Location: LCCOMB_X22_Y18_N24
\uart_tx|Selector0~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector0~1_combout\ = (\uart_tx|r_SM_Main.s_TX_STOP_BIT~q\) # ((!\uart_tx|r_Bit_Index\(2) & (\uart_tx|r_SM_Main.s_TX_DATA_BITS~q\ & \uart_tx|Mux0~3_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111010011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_Bit_Index\(2),
	datab => \uart_tx|r_SM_Main.s_TX_DATA_BITS~q\,
	datac => \uart_tx|r_SM_Main.s_TX_STOP_BIT~q\,
	datad => \uart_tx|Mux0~3_combout\,
	combout => \uart_tx|Selector0~1_combout\);

-- Location: LCCOMB_X22_Y18_N4
\uart_tx|Selector0~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \uart_tx|Selector0~2_combout\ = (\uart_tx|Selector0~0_combout\) # ((\uart_tx|Selector0~1_combout\) # ((\uart_tx|r_SM_Main.s_CLEANUP~q\ & \uart_tx|o_Tx_Serial~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111101100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \uart_tx|r_SM_Main.s_CLEANUP~q\,
	datab => \uart_tx|Selector0~0_combout\,
	datac => \uart_tx|o_Tx_Serial~q\,
	datad => \uart_tx|Selector0~1_combout\,
	combout => \uart_tx|Selector0~2_combout\);

-- Location: FF_X22_Y18_N5
\uart_tx|o_Tx_Serial\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \comb_4|clock_out~clkctrl_outclk\,
	d => \uart_tx|Selector0~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \uart_tx|o_Tx_Serial~q\);

-- Location: IOIBUF_X18_Y24_N22
\nrst~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_nrst,
	o => \nrst~input_o\);

-- Location: IOIBUF_X13_Y0_N1
\CLKOUT~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLKOUT,
	o => \CLKOUT~input_o\);

-- Location: IOIBUF_X16_Y0_N8
\DIR~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_DIR,
	o => \DIR~input_o\);

-- Location: IOIBUF_X0_Y18_N22
\led[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => led(0),
	o => \led[0]~input_o\);

-- Location: IOIBUF_X0_Y18_N15
\led[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => led(1),
	o => \led[1]~input_o\);

-- Location: IOIBUF_X0_Y21_N8
\led[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => led(2),
	o => \led[2]~input_o\);

-- Location: IOIBUF_X0_Y23_N15
\led[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => led(3),
	o => \led[3]~input_o\);

-- Location: IOIBUF_X0_Y6_N22
\data[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(0),
	o => \data[0]~input_o\);

-- Location: IOIBUF_X1_Y0_N22
\data[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(1),
	o => \data[1]~input_o\);

-- Location: IOIBUF_X3_Y0_N1
\data[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(2),
	o => \data[2]~input_o\);

-- Location: IOIBUF_X5_Y0_N15
\data[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(3),
	o => \data[3]~input_o\);

-- Location: IOIBUF_X13_Y0_N15
\data[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(4),
	o => \data[4]~input_o\);

-- Location: IOIBUF_X16_Y0_N22
\data[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(5),
	o => \data[5]~input_o\);

-- Location: IOIBUF_X16_Y0_N1
\data[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(6),
	o => \data[6]~input_o\);

-- Location: IOIBUF_X18_Y0_N15
\data[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => data(7),
	o => \data[7]~input_o\);

ww_RST <= \RST~output_o\;

ww_uart_tx_pin <= \uart_tx_pin~output_o\;

ww_TESTPIN <= \TESTPIN~output_o\;

led(0) <= \led[0]~output_o\;

led(1) <= \led[1]~output_o\;

led(2) <= \led[2]~output_o\;

led(3) <= \led[3]~output_o\;

data(0) <= \data[0]~output_o\;

data(1) <= \data[1]~output_o\;

data(2) <= \data[2]~output_o\;

data(3) <= \data[3]~output_o\;

data(4) <= \data[4]~output_o\;

data(5) <= \data[5]~output_o\;

data(6) <= \data[6]~output_o\;

data(7) <= \data[7]~output_o\;
END structure;


