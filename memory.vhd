LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY memory IS
    PORT (
        clk : IN STD_LOGIC;
        memWrite, memRead : IN STD_LOGIC; -- read and write enables
        OpCode : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- load = 10000, store = 10001 (same as aluoperation )
        Rsrc, Rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- rsrc = rsrc1, rdst = rdst/rsrc2 in data sheet
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- data out from this block
END ENTITY memory;

ARCHITECTURE archOfMemory OF memory IS
    TYPE ram_type IS ARRAY(0 TO 1023) OF STD_LOGIC_VECTOR(15 DOWNTO 0); --address space total is 1 KB
    SIGNAL ram : ram_type;
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
        
            IF (memWrite = '1' AND OpCode = '10001') THEN --store
                ram(to_integer(unsigned((Rdst)))) <= Rsrc; --put value of source inside mem location
                dataout <= (OTHERS => '0'); --output 0000s

            ELSIF (memRead = '1' AND OpCode = '10000') THEN --load
                dataout <= ram(to_integer(unsigned((Rsrc)))); --output mem contents of mem location rsrcs

            END IF;

        END IF;
    END PROCESS;
    

END archOfMemory;