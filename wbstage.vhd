LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY wbstage IS
    PORT (

        inData, inport: in std_logic_vector(15 downto 0);
        inportControl: in std_logic;
        outData: out std_logic_vector(15 downto 0)  
    );
END ENTITY wbstage;

ARCHITECTURE WBStage OF wbstage IS


BEGIN

    outData <= inport when inportControl = '1' 
    else inData ;
    
END WBStage;