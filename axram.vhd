LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


-- 
ENTITY axram IS
PORT (clk : IN std_logic;
 we : IN std_logic;
 rst : IN std_logic;
read1_addres, read2_addres,read3_addres, write_adress :in std_logic_vector(2 downto 0);--address of regester
 datain : IN std_logic_vector(15 DOWNTO 0);  --for write back
 dataout1 ,dataout2,dataout3: OUT std_logic_vector(15 DOWNTO 0) );  -- src1 and src2 for alu

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
 ELSIF  (rst='1' )THEN
 ram <= (others => (others => '0'));
 
 END IF;
 END IF;
 
END PROCESS;
 dataout1 <= datain when (read1_addres=write_adress)
  else ram(to_integer(unsigned((read1_addres))));
 dataout2 <= datain when (read2_addres=write_adress) 
   else ram(to_integer(unsigned((read2_addres))));
   dataout3 <= datain when (read3_addres=write_adress) 
   else ram(to_integer(unsigned((read3_addres))));
END axsync_ram_a;