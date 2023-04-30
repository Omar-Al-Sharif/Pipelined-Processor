library ieee;
use ieee.std_logic_1164.all;

entity regfile is
	port (clk, rst: in std_logic;
        
        write_en : in std_logic;
        read1_addres, read2_addres, write_adress :in std_logic_vector(2 downto 0);
        source1,source2: out std_logic_vector(15 downto 0);
        write_data: in std_logic_vector(15 downto 0));


end entity regfile;

architecture regfile_arch1 of regfile is
	
	component axram IS
PORT (clk : IN std_logic;
 we : IN std_logic;
 rst : IN std_logic;
read1_addres, read2_addres, write_adress :in std_logic_vector(2 downto 0);
 datain : IN std_logic_vector(15 DOWNTO 0);
 dataout1 ,dataout2: OUT std_logic_vector(15 DOWNTO 0) );
	end component;

begin


	fx: axram generic map(n) port map(clk,write_en,rst,read1_addres, read2_addres, write_adress,write_data,source1,source2);



end architecture regfile_arch1;
