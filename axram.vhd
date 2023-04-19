LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


-- 
ENTITY axram IS
PORT (clk : IN std_logic;
 we : IN std_logic;
 rst : IN std_logic;
read1_addres, read2_addres, write_adress :in std_logic_vector(2 downto 0);--address of regester
 datain : IN std_logic_vector(15 DOWNTO 0);  --for write back
 dataout1 ,dataout2: OUT std_logic_vector(15 DOWNTO 0) );  -- src1 and src2 for alu

END ENTITY axram;



ARCHITECTURE axsync_ram_a OF axram IS 
 TYPE ram_type IS ARRAY(0 TO 7) of std_logic_vector(15 DOWNTO 0);-- 8 regster and each one have 16 bits
 SIGNAL ram : ram_type ;
BEGIN
PROCESS(clk) IS 
BEGIN
 IF rising_edge(clk) THEN 
 IF (we = '1' and rst='0') THEN 
 ram(to_integer(unsigned((write_adress)))) <= datain;
 ELSIF  ( we = '1' and rst='1' )THEN
 ram <= (others => (others => '0'));
 
 END IF;
 END IF;
 
END PROCESS;
 dataout1 <= ram(to_integer(unsigned((read1_addres))));
 dataout2 <= ram(to_integer(unsigned((read2_addres))));
END axsync_ram_a;