library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE MY IS 
PROCEDURE SQ(
SIGNAL Xcur, Ycur,Xpos, Ypos: in integer; 
signal RGB: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL DRAW: OUT STD_LOGIC);
END MY

PACKAGE BODY MY IS 
PROCEDURE SQ(
SIGNAL Xcur, Ycur,Xpos, Ypos: in integer; 
signal RGB: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL DRAW: OUT STD_LOGIC) IS 

BEGIN

	IF (Xcur > Xpos AND Xcur<(Xpos+100) AND Ycur>Ypos AND Ycur<(Ypos+100))THEN
		RGB <= "11111111";
		DRAW <='1';
		else
		DRAW <='1';
	END IF;
	
END SQ;
END MY;