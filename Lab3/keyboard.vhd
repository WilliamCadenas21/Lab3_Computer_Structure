library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keyboard is
port(
	clk_keyboard: in std_logic; -- Pin used to emulate the clk_keyboard cycles
	data: 			in std_logic;	 -- Pin used for data input
	ascii: out std_logic_vector(7 downto 0);   --Clock to keep trak of time
	display_right : out  std_logic_vector(0 to 6);
	display_left : out  std_logic_vector(0 to 6)
);

end keyboard;

-----------------------------------------------------

architecture FSM of keyboard is
	 signal counter: integer := 0;
	 signal data_vector: std_logic_vector(10 DOWNTO 0); -- Is the data
	 signal info: std_logic_vector(7 downto 0); -- keyboard code 
	 signal clock: std_logic;
	function show (vector : std_logic_vector(3 downto 0))
	return std_logic_vector is
	variable output :std_logic_vector(6 downto 0);
	begin
			case vector is
				when "0000" => output := "0000001";--0
				when "0001" => output := "1001111";--1
				when "0010" => output := "0010010";--2
				when "0011" => output := "0000110";--3
				when "0100" => output := "1001100";--4
				when "0101" => output := "0100100";--5	
				when "0110" => output := "0100000";--6	
				when "0111" => output := "0001111";--7	
				when "1000" => output := "0000000";--8
				when "1001" => output := "0001100";--9
				when "1010" => output := "0001000";--A
				when "1011" => output := "1100000";--b
				when "1100" => output := "0110001";--c
				when "1101" => output := "1000010";--d	
				when "1110" => output := "0110000";--e	
				when others => output := "0111000";--f	--"1111"
			end case;
			return output;
	end;
	 
begin    
	
	-- read data
	process(clk_keyboard)
	begin
		if(clk_keyboard'event and clk_keyboard = '1') then --cambiar el clock a 1
			
			data_vector(counter) <= data;
			if(counter <=10)then
				counter <= counter + 1;
			else
				--mostrar hexadecimal
				if(data_vector(8 downto 1) = "11110000")then
					info <=data_vector(8 downto 1);
					display_right <= show(data_vector(8 downto 5));
					display_left <= show(data_vector(4 downto 1));
				end if;
				counter <= 0;
			end if;	

	end process;
	
	process(info)

	begin
			case info is
				when "00011100" => ascii <= "01000001";--A 
				when "00110010" => ascii <= "01000010";--B 
				when "00100001" => ascii <= "01000011";--C
				when "00100011" => ascii <= "01000100";--D
				when "00100100" => ascii <= "01000101";--E
				when "00101011" => ascii <= "01000110";--F
				when "00110100" => ascii <= "01000111";--G
				when "00110011" => ascii <= "01001000";--H
				when "01000011" => ascii <= "01001001";--I
				when "00111011" => ascii <= "01001010";--J
				when "01000010" => ascii <= "01001011";--K
				when "01001011" => ascii <= "01001100";--L
				when "00111010" => ascii <= "01001101";--M
				when "00110001" => ascii <= "01001110";--N
				when "01000100" => ascii <= "01001111";--O
				when "01001101" => ascii <= "01010000";--P
				when "00010101" => ascii <= "01010001";--Q
				when "00101101" => ascii <= "01010010";--R
				when "00011011" => ascii <= "01010011";--S
				when "00101100" => ascii <= "01010100";--T
				when "00111100" => ascii <= "01010101";--U
				when "00101010" => ascii <= "01010110";--V
				when "00011101" => ascii <= "01010111";--W
				when "00100010" => ascii <= "01011000";--X
				when "00110101" => ascii <= "01011001";--Y
				when "00011010" => ascii <= "01011010";--Z
				when "11110000" => ascii <= "00000001";--@ ~ F0
				--when "00101001" => ascii <= "00100000";-- (space)
				
				when "01000101" => ascii <= "00110000";--0
				when "00010110" => ascii <= "00110001";--1
				when "00011110" => ascii <= "00110010";--2
				when "00100110" => ascii <= "00110011";--3
				when "00100101" => ascii <= "00110100";--4
				when "00101110" => ascii <= "00110101";--5
				when "00110110" => ascii <= "00110110";--6
				when "00111101" => ascii <= "00110111";--7
				when "00111110" => ascii <= "00111000";--8
				when "01000110" => ascii <= "00111001";--9
				when others => ascii <= "00101101";	--(dash) hex=25
			end case;
			
	end process;
end architecture FSM;