LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY memory IS
    PORT (
        clk : IN STD_LOGIC;
        memWrite, memRead : IN STD_LOGIC; -- read and write enables
        address, value : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- address = location for loading or location for storing in mem, value = value to be stored
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- data out from this block
END ENTITY memory;

ARCHITECTURE archOfMemory OF memory IS
    TYPE ram_type IS ARRAY(0 TO 1023) OF STD_LOGIC_VECTOR(15 DOWNTO 0); --address space total is 1 KB
    SIGNAL ram : ram_type;
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF (memWrite = '1') THEN --store
                ram(to_integer(unsigned((address)))) <= value; --put value inside mem location

            END IF;

        END IF;
    END PROCESS;

    dataout <= (OTHERS => '0') when (clk = '1'and (memRead = '1' OR memWrite = '1') AND address >= 1024) OR memWrite = '1' else
        ram(to_integer(unsigned((address)))) WHEN clk = '1' and memRead = '1' AND memWrite = '0' else
        value  WHEN clk = '1' and memRead = '0' AND memWrite = '0' ; --output contents of mem location 
        --latching on purpose here
        
END archOfMemory;