library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

--- visible area 1280, front porch 48, sync pulse 112, back porch 248
--- whole line 1688
SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0; 

--- visible area 1024, front porch 1, sync pulse 3, back porch 38
--- whole line 1066
SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;
BEGIN

 PROCESS(CLK)
 BEGIN
IF(CLK'EVENT AND CLK='1')THEN

	IF(HPOS=1048 OR VPOS=554)THEN
		R<=(OTHERS=>'1');
		G<=(OTHERS=>'0');
		B<=(OTHERS=>'0');
		ELSE
		R<=(OTHERS=>'0');
		G<=(OTHERS=>'0');
		B<=(OTHERS=>'0');
	END IF;


	IF(HPOS < 1688)THEN
	HPOS<=HPOS+1;
	ELSE
	HPOS<=0;
		IF(VPOS < 1066)THEN
			VPOS<=VPOS+1;
			ELSE
			vpos<=0;
		END IF;
	END IF;
	
	IF (HPOS>48 AND HPOS<160)THEN
		HSYNC<='0';
		ELSE
		HSYNC<='1';
	END IF;
	
	IF(VPOS>0 AND VPOS<4)THEN
		VSYNC<='0';
		ELSE
		VSYNC<='1';
	END IF;
	
	IF((HPOS>0AND HPOS<408)OR(VPOS>0 AND VPOS< 42))THEN
		R<=(OTHERS=>'0');
		G<=(OTHERS=>'0');
		B<=(OTHERS=>'0');
	END IF;
END IF;	
END PROCESS;
END MAIN;