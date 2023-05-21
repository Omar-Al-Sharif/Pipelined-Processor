LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY controller IS
    PORT (
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        memWrite, memRead, wbEnable, aluEnable: OUT STD_LOGIC;
        inportControl,outportControl: OUT STD_LOGIC;
        unconditionalJump: OUT STD_LOGIC;
	    stackEnable :OUT STD_LOGIC;
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
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00001") THEN --SETC--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00010") THEN --CLRC--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00011") THEN --NOT--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00100") THEN --INC--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00101") THEN --DEC--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00110") THEN --MOV--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "00111") THEN --ADD--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "01000") THEN --IADD--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "01001") THEN --SUB--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
          
        ELSIF (opcode = "01010") THEN --AND--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';

        ELSIF (opcode = "01100") THEN --IN--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='1';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
	ELSIF (opcode = "01101") THEN --OUT--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
            inportControl <='0';
	    outportControl <='1';
	    unconditionalJump <='0';
	    stackEnable <='0';
-----------------------------------------
	ELSIF (opcode = "01110") THEN --PUSH--
            memWrite <= '1';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
            inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='1';
	ELSIF (opcode = "01111") THEN --POP--
            memWrite <= '0';
            memRead <= '1';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='1';
	ELSIF (opcode = "10010") THEN --LDM--
            memWrite <= '0';
            memRead <= '1';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
        ELSIF (opcode = "10000") THEN --LDD--
            memWrite <= '0';
            memRead <= '1';
            wbEnable <= '1';
            aluEnable <= '1';
            inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';

        ELSIF (opcode = "10001") THEN --STD--
            memWrite <= '1';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
----------------------------------------------
	ELSIF (opcode = "10011") THEN --JZ--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
	ELSIF (opcode = "10100") THEN --JC--
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
	ELSIF (opcode = "10101") THEN --JMP-- //need to check the document for aluEnable in jmp
            memWrite <= '0';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '0'; --//21/5/2023 //need to be edited in the document
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='1';
	    stackEnable <='0';
	ELSIF (opcode = "10110") THEN --CALL-- //need to ask sth from document
            memWrite <= '1';
            memRead <= '0';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
	ELSIF (opcode = "10111") THEN --RET--
            memWrite <= '0';
            memRead <= '1';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
	ELSIF (opcode = "11000") THEN --RTI--
            memWrite <= '0';
            memRead <= '1';
            wbEnable <= '0';
            aluEnable <= '1';
	    inportControl <='0';
	    outportControl <='0';
	    unconditionalJump <='0';
	    stackEnable <='0';
      
        END IF;
    END PROCESS;

END controllerFlow;