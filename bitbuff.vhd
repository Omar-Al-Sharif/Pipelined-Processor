library ieee;
use ieee.std_logic_1164.all;

entity bitbuff is    
	
	port (enable, clk, rst: in std_logic;
		d: in std_logic;
		q: out std_logic);
end entity bitbuff;

architecture buff_arch of bitbuff is
begin
	process(clk)
	begin
		if (rst='1') then
			q<=('0');
		elsif rising_edge(clk) and enable='1' then
			q<=d;
		end if;
	end process;

end architecture buff_arch;