LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


Entity pc is
	Port(	en:in std_logic;
		clk:in std_logic;
		rs:in std_logic;
		count:out std_logic_vector (1023 downto 0)); --size based off 1kB addressable memory

architecture archPc of pc IS

	signal countTemp:integer;

	begin
		process(clk,en,rs) is
			begin
				if (rising_edge(clk) and en='1') then
					countTemp<=countTemp+2; --memory is divided into 2byte (16 bit) chunks and our instruction size is 32 bits so increment by 2
				end if;
				if (rs='1' or countTemp >= ) then 
					countTemp<=0; --reset program counter to start
				end if; 
		end process;

	count<=std_logic_vector(to_unsigned(countTemp,1000));
    -- converts an integer value countTemp to an n-bit unsigned vector and then assigns it to the signal count which is of type std_logic_vector.
    -- The to_unsigned function takes two arguments: a natural number to convert and the vector length to convert to

end archPc;
