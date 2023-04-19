library ieee;
use ieee.std_logic_1164.all;

entity fallingedgebuff is    
	generic (n: integer := 16);
	port (enable, clk, rst: in std_logic;
		d: in std_logic_vector(n-1 downto 0);
		q: out std_logic_vector(n-1 downto 0));
end entity fallingedgebuff;

architecture buff_arch of fallingedgebuff is
begin
	process(clk,rst)
	begin
		if (rst='1') then
			q<=(others=>'0');
		elsif falling_edge(clk) and enable='1' then
			q<=d;
		end if;
	end process;

end architecture buff_arch;