library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY lab3 IS
PORT(
CLOCK_50: IN STD_LOGIC;
VGA_CLK: out std_logic;
VGA_HS,VGA_VS:OUT STD_LOGIC;
ps2_clk: 	in  std_logic;
ps2_data: 	in  std_logic;
display_right : out  std_logic_vector(0 to 6) := "1111111";
display_left : out  std_logic_vector(0 to 6) := "1111111";
VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(7 downto 0)
);
END lab3;


ARCHITECTURE MAIN OF lab3 IS
SIGNAL VGACLK,RESET: STD_LOGIC:='0';

 COMPONENT SYNC IS
 PORT(
	CLK: IN STD_LOGIC;
	HSYNC: OUT STD_LOGIC;
	VSYNC: OUT STD_LOGIC;
	R: OUT STD_LOGIC_VECTOR(7 downto 0);
	G: OUT STD_LOGIC_VECTOR(7 downto 0);
	B: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END COMPONENT SYNC;
----------------------------------------------
    component PLL is
        port (
            clk_in_clk : in std_logic := 'X'; 
				reset_reset  : in  std_logic := 'X';	
            clk_out_clk  : out  std_logic 
           
        );
	 END COMPONENT PLL;
-----------------------------------------------
component Lab2 is
port(	

--inputs
	clock:		in std_logic;
	ps2_clk:		in  std_logic;--clock signal from PS2 keyboard
	ps2_data: 	in  std_logic;

	display_right : out  std_logic_vector(0 to 6) := "1111111";
	display_left : out  std_logic_vector(0 to 6):= "1111111";
	led_vector : out  std_logic_vector(7 downto 0)

);
END COMPONENT Lab2;
BEGIN
 -----------------------------------------------
 
 C2: PLL PORT MAP (CLOCK_50,RESET,VGACLK);
 VGA_CLK <= VGACLK;
 C1: SYNC PORT MAP(VGACLK,VGA_HS,VGA_VS,VGA_R,VGA_G,VGA_B);
 C3: Lab2 PORT MAP(CLOCK_50,ps2_clk,ps2_data,display_right,display_left);
 
 
 
 END MAIN;
 