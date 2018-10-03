library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.my.all;

ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;
VSYNC: OUT STD_LOGIC;
R: OUT STD_LOGIC_VECTOR(7 downto 0);
G: OUT STD_LOGIC_VECTOR(7 downto 0);
B: OUT STD_LOGIC_VECTOR(7 downto 0)
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS
-----Model Hp L1710
-----1280x1024 @ 60 Hz pixel clock 108 MHz
--- visible area 1280, front porch 48, sync pulse 112, back porch 248 BLANKIN 240--- whole line 1688
--- visible area 1024, front porch 1, sync pulse 3, back porch 38 BLANKIN 42--- whole line 1066


-----Model hp zDisplayz22i
-----Full HD (1080p) 1920 x 1080 @ 60HZ at 148.5 MHz
--- Visble area 1920, front porch 88, sync pulse 44, back porch 148 --- whole line 2200
--- visible area 1080, front porch 4, sync pulse 5, back porch 38 --- whole line 1125

-----LOW RESOLUTION
----- 640 x 480  @  at 25.175 MHz
--- Visble area 640, front porch 16, sync pulse 96, back porch 48 BLANKIN 160--- whole line 800
--- visible area 480, front porch 11, sync pulse 2, back porch 31 BLANKIN 44 --- whole line 524

---CONFIGURATION
SIGNAL TOTALLINESH:INTEGER := 800;
SIGNAL FRONTPORCHH:INTEGER := 16;
SIGNAL SYNCPULSEH:INTEGER := 96;
SIGNAL BACKPORCHH:INTEGER := 48;

SIGNAL TOTALLINESV:INTEGER := 524;
SIGNAL FRONTPORCHV:INTEGER := 11;
SIGNAL SYNCPULSEV:INTEGER := 2;
SIGNAL BACKPORCHV:INTEGER := 31;

SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0; 

SIGNAL VPOS: INTEGER RANGE 0 TO 1066 :=0;

--SIGNAL SQ_X1,SQ_Y1: INTEGER RANGE 0 TO 1688:=0;
--SIGNAL RGB: STD_LOGIC_VECTOR(7 DOWNTO 0);
--SIGNAL DRAW: STD_LOGIC;

			--101 HORIZONTAL
			--42 VERITCAL
SIGNAL SIZEFONTH: INTEGER:= 20; --1688/8
SIGNAL SIZEFONTV: INTEGER:= 20; --1066/12
SIGNAL SIZECOUNTH: INTEGER:= 0;
SIGNAL SIZECOUNTV: INTEGER:= 0;


SIGNAL LETTER: STD_LOGIC;

SIGNAL HCOUNT: INTEGER RANGE 0 to 8 := 0;
SIGNAL VCOUNT: INTEGER RANGE 0 to 8 := 0;
type ROM_TYPE is array (0 to 15) of std_logic_vector(7 downto 0);
SIGNAL ROM: ROM_TYPE;
SIGNAL ASCII: STD_LOGIC_VECTOR(7 DOWNTO 0) := "01100101";
SIGNAL TEST: INTEGER:=0;

	
BEGIN
--the middle is ((BP,FP,Sync) + visible area/2)
--SQ_X1<=1048; -- 408+1280/2
--SQ_Y1<=554; --	42+1024/2

PROCESS(ASCII)
BEGIN
		case ASCII is
			when "01100101" => ROM <= (
			"00000000", -- 0
			"00000000", -- 1
			"00010000", -- 2    *
			"00111000", -- 3   ***
			"01101100", -- 4  ** **
			"11000110", -- 5 **   **
			"11000110", -- 6 **   **
			"11111110", -- 7 *******
			"11000110", -- 8 **   **
			"11000110", -- 9 **   **
			"11000110", -- a **   **
			"11000110", -- b **   **
			"00000000", -- c
			"00000000", -- d
			"00000000", -- e
			"00000000" -- f
			);
			when "11111111" => ROM <= (
			"11111111", -- 0
			"11111111", -- 1
			"11111111", -- 2    *
			"11111111", -- 3   ***
			"11111111", -- 4  ** **
			"11111111", -- 5 **   **
			"11111111", -- 6 **   **
			"11111111", -- 7 *******
			"11111111", -- 8 **   **
			"11111111", -- 9 **   **
			"11111111", -- a **   **
			"11111111", -- b **   **
			"11111111", -- c
			"11111111", -- d
			"11111111", -- e
			"11111111" -- f
			);
			when others => ROM <=(
			"00000000", -- 0
			"00000000", -- 1
			"01111110", -- 2  ******
			"10000001", -- 3 *      *
			"10100101", -- 4 * *  * *
			"10000001", -- 5 *      *
			"10000001", -- 6 *      *
			"10111101", -- 7 * **** *
			"10011001", -- 8 *  **  *
			"10000001", -- 9 *      *
			"10000001", -- a *      *
			"01111110", -- b  ******
			"00000000", -- c
			"00000000", -- d
			"00000000", -- e
			"00000000" -- f
			);
		end case;
END PROCESS;



PROCESS(CLK)
BEGIN

	IF(CLK'EVENT AND CLK='1') then
	
	
		ASCII <= "01100101";
		IF( (HPOS<1048 AND HPOS>240) AND (VPOS<554 AND VPOS>42) ) then
			--101 HORIZONTAL
			--42 VERITCAL
		if('0' = ROM(VCOUNT)(HCOUNT) ) then
			--IF(1=TEST)THEN
				R<=(OTHERS=>'1');
				G<=(OTHERS=>'1');
				B<=(OTHERS=>'1');
			ELSE 
				R<=(OTHERS=>'1');--RED
				G<=(OTHERS=>'0');
				B<=(OTHERS=>'0');
			END IF;
								
			--IF(SIZECOUNTH>SIZEFONTH)THEN
				if(HCOUNT<8)then
					HCOUNT <= HCOUNT+1;
				else
					IF(1=TEST)THEN
						TEST<=0;
					ELSE
						TEST<=1;
					END IF; 
					HCOUNT <= 0;
				end if;
			--else
				--SIZECOUNTH<=SIZECOUNTH + 1;
			--END IF;
			
			--if(SIZECOUNTV=SIZEFONTV)then
				if(VCOUNT< 16)then
					VCOUNT <= VCOUNT+1;
				else
					VCOUNT <=0;
				end if;
			--end if;
			IF (HPOS=)THEN
			
			END IF;
			
		ELSE
			R<=(OTHERS=>'0');
			G<=(OTHERS=>'0');
			B<=(OTHERS=>'0');
		END IF;
		




		
	--	IF(DRAW='1')THEN
	--		R<=RGB;
	--		G<=RGB;
	--		B<=RGB;
	--		ELSE
	--		R<=(OTHERS=>'0');
	--		G<=(OTHERS=>'0');
	--		B<=(OTHERS=>'0');
	--	END IF;

		IF(HPOS < 1688)THEN
		HPOS<=HPOS+1;
		ELSE
		HPOS<=0;
			IF(VPOS < 1066)THEN
				VPOS<=VPOS+1;
				--SIZECOUNTV<=SIZECOUNTV+1;
				ELSE
				VPOS<=0;
				--SIZECOUNTV<=0;
			END IF;
		END IF;
		
		--HPOS>FRONTPORCHH AND HPOS< FRONTH+SYNCH 
		IF (HPOS>48 AND HPOS<160)THEN 
		
			HSYNC<='0';
			ELSE
			HSYNC<='1';
		END IF;
		
		--VPOS>0 AND VPOS< FRONTH+SYNCH
		IF(VPOS>0 AND VPOS<4)THEN 
			VSYNC<='0';
			ELSE
			VSYNC<='1';
		END IF;
		
		--HPOS>0 AND HPOS<FRONTH+SYCNH+BACKH OR VPOS>0 AND VPOS< FRONTH+SYCNH+BACKH
		IF((HPOS>0 AND HPOS<408) OR (VPOS>0 AND VPOS< 42))THEN
			R<=(OTHERS=>'0');
			G<=(OTHERS=>'0');
			B<=(OTHERS=>'0');	
		END IF;
		
	END IF;	
END PROCESS;
END MAIN;