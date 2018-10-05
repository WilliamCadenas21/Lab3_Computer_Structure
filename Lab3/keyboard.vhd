library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keyboard is
port(
	clk_keyboard: in std_logic; -- Pin used to emulate the clk_keyboard cycles
	data: 			in std_logic;	 -- Pin used for data input
	clk:				in std_logic    --Clock to keep trak of time
	-- rom:				out std_logic_vector(7 DOWNTO 0);
);

end keyboard;

-----------------------------------------------------

architecture FSM of keyboard is
	 signal counter: integer := 0;
	 signal data_vector: unsigned(10 DOWNTO 0); -- Is the data
--	 Signal real_clk: std_logic;
--	 Signal real_clk_anterior: std_logic;
begin    
	
	-- read data
	process(clk_keyboard)
	begin
--		real_clk <= clk_keyboard;
		if(clk_keyboard'event and clk_keyboard = '0') then
			counter <= counter + 1;	
			data_vector(counter) <= data;
		end if;
		
		if (counter > 10) then
			counter <= 0;
		end if;	
		
		if (counter = 10 and data_vector(8 downto 1) /= "11110000") then
			-- display <= not display;
		end if;
	end process;
	
	
end architecture FSM;