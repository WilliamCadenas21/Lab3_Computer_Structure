library ieee ;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY SYNC IS
PORT(
	CLK:				IN 	STD_LOGIC; --PLL
	HSYNC, VSYNC:	OUT 	STD_LOGIC; -- HORIZONTAL AND VERTICAL SYNCRONIZATION
	R, G, B:			OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0); -- COLORS
	ASCII: IN STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END SYNC;

ARCHITECTURE MAIN OF SYNC IS
	SIGNAL HPOS:	INTEGER RANGE 0 TO 800 := 0; -- HORIZONTAL POSITION
	SIGNAL VPOS:	INTEGER RANGE 0 TO 525 := 0; -- VERTICAL POSITION
	SIGNAL TEMP:	STD_LOGIC_VECTOR(7 DOWNTO 0); -- VECTOR DE LA LÍNEA ACTUAL
	SIGNAL ADDR:	STD_LOGIC_VECTOR(10 DOWNTO 0) := "0000001" &"0000"; -- DIRECCIÓN (DIR DEL SÍMBOLO Y LÍNEA)

	
	
	SIGNAL INDEX:	INTEGER := 7; -- POSICIÓN EN LA LÍNEA DEL SÍMBOLO
	
	-- FONT ROM
	COMPONENT fontROM IS
		GENERIC(
			addrWidth: integer := 11;
			dataWidth: integer := 8
		);
		PORT(
			clkA: in std_logic;
			writeEnableA: in std_logic;
			addrA: in std_logic_vector(addrWidth-1 DOWNTO 0);
			dataOutA: out std_logic_vector(dataWidth-1 DOWNTO 0);
			dataInA: in std_logic_vector(dataWidth-1 DOWNTO 0)
		);
	END COMPONENT fontROM;

	
BEGIN
	C1: fontROM PORT MAP(CLK, '0', ADDR, TEMP, "00000000");

	
	PROCESS(CLK,ASCII)
	BEGIN
		IF (CLK'EVENT AND CLK='1') THEN
			-- DIBUJAR
			IF (HPOS > 160 AND HPOS < 800) THEN
				
				IF (TEMP(INDEX) = '1') THEN
					R <= (OTHERS => '1');
					G <= (OTHERS => '1');
					B <= (OTHERS => '1');
				ELSE
					R <= (OTHERS => '0');
					G <= (OTHERS => '0');
					B <= (OTHERS => '0');
				END IF;
				
				-- AUMENTAR INDEX DE LA COLUMNA A DIBUJAR
				IF (INDEX > 0) THEN
					INDEX <= INDEX - 1;
				ELSE
					INDEX <= 7; -- VOLVER AL INICIO DE LA LÍNEA DEL CARACTER
				END IF;
			ELSE
				R <= (OTHERS => '0');
				G <= (OTHERS => '0');
				B <= (OTHERS => '0');
			END IF;
			-- // DIBUJAR

			-- AUMENTAR POSICIÓN
			IF (HPOS < 800) THEN
				HPOS <= HPOS + 1;
			ELSE
				HPOS <= 0;
				INDEX <= 7;
				ADDR(3 DOWNTO 0) <= ADDR(3 DOWNTO 0) + 1; -- AUMENTAR LÍNEA DE CARACTER
				
				IF (ADDR(3 DOWNTO 0) = "1111") THEN
					ADDR(3 DOWNTO 0) <= "0000";
				END IF;
				
				IF (VPOS < 525) THEN
					VPOS <= VPOS + 1;
				ELSE
					VPOS <= 0;
					INDEX <= 7;
					ADDR(3 DOWNTO 0) <= "0000";
				END IF;
			END IF;
			-- // AUMENTAR POSICIÓN
			
			-- HORIZONTAL (PD AND BP)
			IF (HPOS > 16 AND HPOS < 112) THEN
				HSYNC <= '0';
			ELSE
				HSYNC <= '1';
			END IF;
			-- // HORIZONTAL (PD AND BP)
			
			-- VERTICAL (PD AND BP)
			IF (VPOS > 0 AND VPOS < 4) THEN
				VSYNC <= '0';
			ELSE
				VSYNC <= '1';
			END IF;
			-- // VERTICAL (PD AND BP)
			
			-- LOW MOMENT
			IF ((HPOS > 0 AND HPOS < 160) OR (VPOS > 0 AND VPOS < 45)) THEN
				R <= (OTHERS => '0');
				G <= (OTHERS => '0');
				B <= (OTHERS => '0');
			END IF;
			-- // LOW MOMENT
			ADDR(10 DOWNTO 4) <= ASCII(6 DOWNTO 0);
		END IF;
	END PROCESS;
	
END MAIN;