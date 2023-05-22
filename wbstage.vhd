LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY wbstage IS
    PORT (

        inData, inport : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        inportControl : IN STD_LOGIC;
        outData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        outPortControl : IN STD_LOGIC;
        outPortData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY wbstage;

ARCHITECTURE WBStage OF wbstage IS
BEGIN

    outData <= inport WHEN inportControl = '1'
        ELSE
        inData;

    outPortData <= inData WHEN outPortControl = '1'
        ELSE
        "0000000000000000";

    outData <= inport WHEN inportControl = '1'
        ELSE
        inData;

END WBStage;