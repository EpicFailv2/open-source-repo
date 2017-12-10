library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IESigGen is
	Port ( 
		CLOCK_50 : IN STD_LOGIC;
		SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		KEY : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		HEX0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDG : OUT STD_LOGIC_VECTOR(9 downto 0);
		GPIO_0 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
end IESigGen;

architecture Whatever of IESigGen is

constant timer_max  : INTEGER := 50000000;

signal timer_count  	: INTEGER := 0;
signal led_state  	: STD_LOGIC := '0';
signal counter    	: INTEGER := 0;
SIGNAL FREQUENCY     : INTEGER := 0;
signal INTERVAL      : INTEGER := 0;

begin
		
	WITH FREQUENCY mod 10 SELECT HEX0 <=
		"11000000" WHEN 0,
		"11111001" WHEN 1,
		"10100100" WHEN 2,
		"10110000" WHEN 3,
		"10011001" WHEN 4,
		"10010010" WHEN 5,
		"10000010" WHEN 6,
		"11111000" WHEN 7,
		"10000000" WHEN 8,
		"10010000" WHEN 9,
		"01111111" WHEN OTHERS;
	
	WITH (FREQUENCY / 10) mod 10 SELECT HEX1 <=
		"11000000" WHEN 0,
		"11111001" WHEN 1,
		"10100100" WHEN 2,
		"10110000" WHEN 3,
		"10011001" WHEN 4,
		"10010010" WHEN 5,
		"10000010" WHEN 6,
		"11111000" WHEN 7,
		"10000000" WHEN 8,
		"10010000" WHEN 9,
		"01111111" WHEN OTHERS;
	
	WITH (FREQUENCY / 100) mod 10 SELECT HEX2 <=
		"01000000" WHEN 0,
		"01111001" WHEN 1,
		"00100100" WHEN 2,
		"00110000" WHEN 3,
		"00011001" WHEN 4,
		"00010010" WHEN 5,
		"00000010" WHEN 6,
		"01111000" WHEN 7,
		"00000000" WHEN 8,
		"00010000" WHEN 9,
		"01111111" WHEN OTHERS;
	
	WITH (FREQUENCY / 1000) mod 10 SELECT HEX3 <=
		"11000000" WHEN 0,
		"11111001" WHEN 1,
		"10100100" WHEN 2,
		"10110000" WHEN 3,
		"10011001" WHEN 4,
		"10010010" WHEN 5,
		"10000010" WHEN 6,
		"11111000" WHEN 7,
		"10000000" WHEN 8,
		"10010000" WHEN 9,
		"01111111" WHEN OTHERS;

	WITH COUNTER MOD 2 SELECT GPIO_0 <=
		"001" WHEN 0,
		"000" WHEN OTHERS;

	process(CLOCK_50)
	begin
		if rising_edge(CLOCK_50) then
			timer_count <= timer_count + 1;
			if (timer_count >= INTERVAL) then
				led_state <= not led_state;
				counter <= counter + 1;
				timer_count <= 0;
			end if;
			
			INTERVAL <= TO_INTEGER(UNSIGNED(SW));
			FREQUENCY <= 5000/((INTERVAL+1)*2);
			
		end if;
	end process;
	
	LEDG(0) <= led_state;
	
	LEDG(1) <= KEY(1);

end Whatever;



