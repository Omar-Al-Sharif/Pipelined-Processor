LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY pc IS
	PORT (
		en : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		rs : IN STD_LOGIC;
		count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		branch : IN STD_LOGIC;
		branchaddress : IN STD_LOGIC_VECTOR (15 DOWNTO 0)
		); --16 bit pc value
END ENTITY pc;
ARCHITECTURE archPc OF pc IS
BEGIN
	PROCESS (clk, en, rs) IS
		VARIABLE countTemp : INTEGER := 0;
	BEGIN
		IF (rs = '1' OR countTemp >= 65536) THEN -- reset or 2^16 = 65536, check to avoid overflow
			countTemp := 0; --reset program counter to start
		ELSIF (rising_edge(clk) AND en = '1' AND branch = '1') THEN
			countTemp := to_integer(unsigned(branchaddress));
		ELSIF (rising_edge(clk) AND en = '1') THEN
			countTemp := countTemp + 1;
			-- if instruction cache is divided into 2byte (16 bit) chunks and our instruction size is 32 bits so increment by 2
			-- if instruction cache is divided into 32 bit chunks this should be 4 and if 8 bit chunks then +1
		END IF;

		count <= STD_LOGIC_VECTOR(to_unsigned(countTemp, 16));
		-- converts an integer value countTemp to an n-bit unsigned vector and then assigns it to the signal count which is of type std_logic_vector.
		-- The to_unsigned function takes two arguments: a natural number to convert and the vector length to convert to

	END PROCESS;

END archPc;