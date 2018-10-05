library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY VGA IS
PORT(
	CLOCK_50: 				IN STD_LOGIC; --SYSTEM CLOCK
	VGA_HS, VGA_VS: 		OUT STD_LOGIC; -- HORIZONTAL AND VERTICAL SYNCRONIZATION
	VGA_R, VGA_G, VGA_B: OUT STD_LOGIC_VECTOR(7 downto 0); -- COLORS
	VGA_CLOCK:				OUT STD_LOGIC;	-- VGA CLOCK OUT
	
	PS2_CLK:	 IN STD_LOGIC;
	PS2_DATA: IN STD_LOGIC;
	
	d_right : out  std_logic_vector(0 to 6) := "1111111";
	d_left : out  std_logic_vector(0 to 6):= "1111111"
);
END VGA;

ARCHITECTURE MAIN OF VGA IS


	SIGNAL VGACLK, RESET:	STD_LOGIC := '0';
	SIGNAL ASCII_PS2: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ASCII: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL		disp_right :  std_logic_vector(0 to 6);
	SIGNAL		disp_left :  std_logic_vector(0 to 6);
	
	-- PLL
	COMPONENT PLL IS
	PORT(
		CLK_IN_CLK:		IN 	STD_LOGIC := 'X'; --CLK
		RESET_RESET:	IN 	STD_LOGIC := 'X'; --RESET
		CLK_OUT_CLK:	OUT 	STD_LOGIC
	);
	END COMPONENT PLL;
	
	-- SYNC
	COMPONENT SYNC IS
	PORT(
		CLK:				IN 	STD_LOGIC; --PLL
		HSYNC, VSYNC:	OUT 	STD_LOGIC;
		R, G, B:			OUT 	STD_LOGIC_VECTOR(7 downto 0);
		ASCII: IN STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT SYNC;
	
	-- KEYBOARD COMPONENT 
	COMPONENT keyboard IS
		PORT(
			clk_keyboard: IN 	STD_LOGIC; -- Pin used to emulate the clk_keyboard cycles
			data: 			IN 	STD_LOGIC;	 -- Pin used for data input
			ASCII: out std_logic_vector(7 downto 0);
			display_right : out  std_logic_vector(0 to 6);
			display_left : out  std_logic_vector(0 to 6)
	);
	END COMPONENT keyboard;
	
	
	
BEGIN
	C1: SYNC PORT MAP(VGACLK, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, ASCII);
	C2: PLL PORT MAP(CLOCK_50, RESET, VGACLK);
	C3:	keyboard PORT MAP(PS2_CLK, PS2_DATA, ASCII_PS2,disp_right,disp_left);
	ASCII <= ASCII_PS2(7 DOWNTO 0); 
	VGA_CLOCK <= VGACLK;
	d_right <= disp_right(0 TO 6);
	d_left <= disp_left(0 to 6);
END MAIN;