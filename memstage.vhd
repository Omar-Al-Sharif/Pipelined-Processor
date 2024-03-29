LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY memstage IS
     PORT (
        clk : IN STD_LOGIC;
        memWrite, memRead : IN STD_LOGIC; -- read and write enables
        address, value : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- address = location for loading or location for storing in mem, value = value to be stored
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- data out from this block
        stacken: IN STD_LOGIC
        ); -- used in combination with read and write enables
END ENTITY memstage;

ARCHITECTURE MEMStage OF memstage IS

COMPONENT memory IS
	 PORT (
        clk : IN STD_LOGIC;
        memWrite, memRead : IN STD_LOGIC; -- read and write enables
        address, value : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- address = location for loading or location for storing in mem, value = value to be stored
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- data out from this block
        stacken: IN STD_LOGIC); -- used in combination with read and write enables
END component;

BEGIN

mem: memory port map(clk, memWrite, memRead, address, value, dataout, stacken);

END memstage;