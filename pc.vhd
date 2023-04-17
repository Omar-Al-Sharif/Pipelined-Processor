LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


Entity pc is
	Port(	en:in std_logic;
		clk:in std_logic;
		rs:in std_logic;
		count:out std_logic_vector (15 downto 0)); --16 bit pc value
END ENTITY pc;

architecture archPc of pc IS

	signal countTemp:integer :=0;

	begin
		process(clk,en,rs) is
			begin
				if (rising_edge(clk) and en='1') then
					countTemp<=countTemp+1; 
					-- if instruction cache is divided into 2byte (16 bit) chunks and our instruction size is 32 bits so increment by 2
					-- if instruction cache is divided into 32 bit chunks this should be 4 and if 8 bit chunks then +1
				end if;
				if (rs='1' or countTemp >= 65536) then -- reset or 2^16 = 65536, check to avoid overflow
					countTemp<=0; --reset program counter to start
				end if; 
		end process;

	count<=std_logic_vector(to_unsigned(countTemp,16));
    -- converts an integer value countTemp to an n-bit unsigned vector and then assigns it to the signal count which is of type std_logic_vector.
    -- The to_unsigned function takes two arguments: a natural number to convert and the vector length to convert to

end archPc;
