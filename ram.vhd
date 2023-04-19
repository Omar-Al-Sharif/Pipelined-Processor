LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ram IS
--generic (n: integer := 65536);--2^16

PORT (clk : IN std_logic;
 we : IN std_logic;
 rst : IN std_logic;
read1_addres, write_adress :in std_logic_vector(15 downto 0);--writ address mlnash d3wa beh
 datain : IN std_logic_vector(31 DOWNTO 0);     --data
 dataout1 : OUT std_logic_vector(31 DOWNTO 0) );--dataout mlansh d3wa beh bardo

END ENTITY ram;



ARCHITECTURE sync_ram_a OF ram IS 
--generic (n: integer := 65536);--2^16
 TYPE ram_type IS ARRAY(0 TO 65536-1) of std_logic_vector(31 DOWNTO 0);--2^16=65536, 32 dah el pc size
 SIGNAL ram : ram_type ;
BEGIN
PROCESS(clk) IS 
BEGIN
 IF rising_edge(clk) THEN 
 IF (we = '1' and rst='0') THEN 
ram(to_integer(unsigned((write_adress)))) <= datain;
 ELSIF  ( we = '1' and rst='1' )THEN
ram(to_integer(unsigned((write_adress)))) <= (others=>'0');
 
 END IF;
 END IF;
END PROCESS;
 dataout1 <= ram(to_integer(unsigned((read1_addres))));
END sync_ram_a;