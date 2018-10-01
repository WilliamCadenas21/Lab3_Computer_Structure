library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-----------------------------------------------------

entity lab2 is
port(	

--inputs
	clock:		in std_logic;
	reset:		in std_logic;	-- sw[0]
	velocity:	in std_logic;
	ps2_clk:		in  std_logic;--clock signal from PS2 keyboard
	ps2_data: 	in  std_logic;
   provicional: 	in  std_logic; -- sw[17]

--outputs
	lcd:			out std_logic_vector(7 downto 0);--LCD data pins
	enviar: 		out std_logic;   --Send signal
	rs:			out std_logic;   --Data or command
	rw: 			out std_logic;   --read/write
	display_right : out  std_logic_vector(0 to 6) := "1111111";
	display_left : out  std_logic_vector(0 to 6):= "1111111";
	led_vector : out  std_logic_vector(7 downto 0)

);
end lab2;

-----------------------------------------------------

architecture FSM of lab2 is
	signal info: std_logic_vector(7 downto 0);

	signal stop: integer := 0;--sin funcionalidad
	signal sw: integer := 0;-- para el error de la primera letra
	signal ascii: std_logic_vector(7 downto 0) := "01000000";
	signal clockTimer: integer:= 0; --2hz 
	signal count: integer := 0;
	signal r1: std_logic_vector(3 downto 0);
	signal l1: std_logic_vector(3 downto 0); 
	signal ps2_array : STD_LOGIC_VECTOR(10 DOWNTO 0);		
	type state_type is (encender, configpantalla, encenderdisplay, limpiardisplay, configcursor, listo, fin, breakLine, startagain);    --Define dfferent states to control the LCD
   signal estado: state_type;
	constant milisegundos: integer := 50000;
	constant microsegundos: integer := 50; 
	
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
				when "11110000" => ascii <= "01000000";--@ ~ F0
				when "00101001" => ascii <= "00100000";-- (space)
				
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

-- this process verify the number of the count
process(ps2_clk) 
begin
	if(ps2_clk'EVENT and ps2_clk='0') then

		ps2_array(count) <= ps2_data;
		if(count < 10)then
			count <= count + 1;
			
			else
			--mostrar hexadecimal
			info <= ps2_array(8 downto 1);
			
			led_vector<= ps2_array(8 downto 1);
			display_right <= show(ps2_array(8 downto 5));
			display_left <= show(ps2_array(4 downto 1));
			stop<=0;
			count <= 0;
		end if;
			
		end if;
end process;

comb_logic: process(clock)
  variable contar: integer := 0;
  variable contar3: integer := 0;
  variable contar2: integer := 0;
  begin
  
	if (clock'event and clock='1') then
--		if(reset = '0')then
--		  estado <= encender;
--      end if;
  
	  case estado is
	  
	    when encender =>
		  if (contar < 50*milisegundos) then    --Wait for the LCD to start all its components
				contar := contar + 1;
				estado <= encender;
			else
				enviar <= '0';
				contar := 0; 
				estado <= configpantalla;
			end if;
			
			--From this point we will send diffrent configuration commands as shown in class
			--You should check the manual to understand what configurations we are sending to
			--The display. You have to wait between each command for the LCD to take configurations.
	    when configpantalla =>
			if (contar = 0) then
				contar := contar +1;
				rs <= '0';
				rw <= '0';
				lcd <= "00111000";
				enviar <= '1';
				estado <= configpantalla;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= configpantalla;
			else
				enviar <= '0';
				contar := 0;
				estado <= encenderdisplay;
			end if;
			
	    when encenderdisplay =>
			if (contar = 0) then
				contar := contar +1;
				lcd <= "00001111";				
				enviar <= '1';
				estado <= encenderdisplay;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= encenderdisplay;
			else
				enviar <= '0';
				contar := 0;
				estado <= limpiardisplay;
			end if;
			
	    when limpiardisplay =>	
			if (contar = 0) then
				contar := contar +1;
				lcd <= "00000001";				
				enviar <= '1';
				estado <= limpiardisplay;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= limpiardisplay;
			else
				enviar <= '0';
				contar := 0;
				estado <= configcursor;
			end if;
			
	    when configcursor =>	
			if (contar = 0) then
				contar := contar +1;
				lcd <= "00000100";				
				enviar <= '1';
				estado <= configcursor;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;
				estado <= configcursor;
			else
				enviar <= '0';
				contar := 0;
				estado <= listo;
			end if;
			--The display is now configured now it you just can send data to de LCD 
			--In this example we are just sending letter A, for this project you
			--Should make it variable for what has been pressed on the keyboard.
			
	    when listo =>	
			if (contar = 0) then
				rs <= '1';
				rw <= '0';
				enviar <= '1';
				if(ascii /= "01000000") then
						lcd <= ascii; -- ascii
						contar := contar +1;
						contar2 := contar2 +1;
						contar3 := contar3 +1;
						estado <= listo;   
				end if;
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;       
				estado <= listo;
			else
				enviar <= '0';
				contar := 0;
				estado <= fin;
			end if;
			
		when startagain =>	
			if (contar = 0) then
				rs <= '0';
				rw <= '0';
				enviar <= '1';
				lcd <= "10000000"; --Hacia arriba
				contar := contar +1;
				estado <= startagain;   
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;       
				estado <= startagain;
			else
				enviar <= '0';
				contar := 0;
				estado <= fin;
			end if;
			
		when breakline =>	
			if (contar = 0) then
				rs <= '0';
				rw <= '0';
				enviar <= '1';
				lcd <= "11000000"; --Hacia abajo
				contar := contar +1;
				estado <= breakline;   
			elsif (contar < 1*milisegundos) then
				contar := contar + 1;       
				estado <= breakline;
			else
				enviar <= '0';
				contar := 0;
				estado <= fin;
			end if;
			
		  when fin =>
				if(ascii /= "01000000") then
					estado <= fin;
				else
					if(contar3 = 32)then
						contar3 := 0;
						contar2 := 0;
						estado <= startagain;
					elsif(contar2 = 16)then
						contar2 := 0;
						estado <= breakline;
					else
						estado <= listo;
					end if;	
				end if;
			
	    when others =>
			estado <= encender;
	  end case;
	end if;
 end process;	 

end FSM;
