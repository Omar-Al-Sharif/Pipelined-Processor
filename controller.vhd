LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY controller IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        memWrite, memRead, wbEnable, aluEnable,inportControl : OUT STD_LOGIC;
        aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE controllerFlow OF controller IS
BEGIN
    aluOperation <= opcode;
    PROCESS (opcode)
    BEGIN
        IF (opcode = "00000") THEN --NOP--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '0';
            inportControl <='0';

        ELSIF (opcode = "00100") THEN --INC--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	        inportControl <='0';
          
        ELSIF (opcode = "01010") THEN --AND--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='0';

        ELSIF (opcode = "01100") THEN --IN--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '0';
            inportControl <='1';

        ELSIF (opcode = "10000") THEN --LDD--
            memWrite <= '0';
            memRead <= '1';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='0';

        ELSIF (opcode = "10001") THEN --STD--
            memWrite <= '1';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	        inportControl <='0';
      
        END IF;
    END PROCESS;

END controllerFlow;
