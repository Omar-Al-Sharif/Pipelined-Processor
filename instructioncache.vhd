library ieee;
use ieee.std_logic_1164.all;

entity instructionCache is
	generic (n: integer := 16);
	port (clk, rst: in std_logic; -- rst 7otaha dayman b zero 
        write_en : in std_logic; --7otaha dayman b zero e7na bn read bas
        read1_addres, write_adress :in std_logic_vector(n-1 downto 0);--writ address mlnash d3wa beh da5alo ay signal buff bas ma tsta5dmhosh
        source1: out std_logic_vector(15 downto 0); --instruction
        destination: in std_logic_vector(15 downto 0));--dataout mlansh d3wa beh bardo da5alo ay signal buff bas ma tsta5dmhosh

end entity instructionCache;

architecture instructionCache_arch1 of instructionCache is
	
	component ram IS
	--generic (n: integer := 65536);--2^16 
	PORT (clk : IN std_logic;
		we : IN std_logic;
		rst : IN std_logic;
		read1_addres, write_adress :in std_logic_vector(15 downto 0);--writ address mlnash d3wa beh
		datain : IN std_logic_vector(15 DOWNTO 0);     --data
		dataout1 : OUT std_logic_vector(15 DOWNTO 0) );--dataout mlansh d3wa beh bardo
	end component;

begin


	fx: ram generic map(n) port map(clk,write_en,rst,read1_addres, write_adress,destination,source1);



end architecture instructionCache_arch1;
