LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY ifstage IS
    PORT (
        clk, rst : IN STD_LOGIC;
        instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcEnable: IN STD_LOGIC;
        decodeJmpAddress, aluJmpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        conditionalBranchEn , unConditionalBranchEn : IN STD_LOGIC

    );
END ENTITY ifstage;
ARCHITECTURE IFStage OF ifstage IS

    COMPONENT instructionCache IS
        GENERIC (n : INTEGER := 16);
        PORT (
            clk, rst : IN STD_LOGIC; -- rst 7otaha dayman b zero 
            write_en : IN STD_LOGIC; --7otaha dayman b zero e7na bn read bas
            read1_addres, write_adress : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);--writ address mlnash d3wa beh da5alo ay signal buff bas ma tsta5dmhosh
            source1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --instruction
            destination : IN STD_LOGIC_VECTOR(31 DOWNTO 0));--dataout mlansh d3wa beh bardo da5alo ay signal buff bas ma tsta5dmhosh

    END COMPONENT;

COMPONENT pc IS
	PORT (
		en : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		rs : IN STD_LOGIC;
		conditional_branch : IN STD_LOGIC;
		conditional_alu_branchaddress : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		nonconditional_branch : IN STD_LOGIC;
		nonconditional_decode_branchaddress : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		count : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)); --16 bit pc value
END COMPONENT;

    signal counter: STD_LOGIC_VECTOR (15 DOWNTO 0);
    signal dummy: std_logic_vector(31 downto 0);
BEGIN

programCounter: pc port map(pcEnable,clk,rst, conditionalBranchEn, aluJmpAddress, unConditionalBranchEn, decodeJmpAddress, counter);
cache: instructionCache generic map(16) port map(clk, rst, '0', counter, counter, instruction, dummy);
--
END IFStage; -- arch