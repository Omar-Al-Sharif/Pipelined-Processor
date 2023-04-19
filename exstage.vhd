LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY exstage IS
    PORT (
        Src1, Src2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		aluOperation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		aluEnable : IN STD_LOGIC;
		zeroFlag, negativeFlag, carryFlag : OUT STD_LOGIC;
		aluToMemAddress : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --the address fed to memory (whether to read or write) -> ithink it's dependant on write enable or read enable from memory
		-- integration from outside or gets passed by alu, ask omar since he is doing the integration, might be not needed --ziad comment
		--fix naming aluToMemAddressress for readability to --ziad comment
		result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY exstage;

ARCHITECTURE EXStage OF exstage IS

COMPONENT alu IS
	PORT (
		Src1, Src2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		aluOperation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		aluEnable : IN STD_LOGIC;
		zeroFlag, negativeFlag, carryFlag : OUT STD_LOGIC;
		aluToMemAddress : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --the address fed to memory (whether to read or write) -> ithink it's dependant on write enable or read enable from memory
		-- integration from outside or gets passed by alu, ask omar since he is doing the integration, might be not needed --ziad comment
		--fix naming aluToMemAddressress for readability to --ziad comment
		result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END component;

BEGIN

alu1: alu port map(Src1,Src2,aluOperation,aluEnable,zeroFlag,negativeFlag,carryFlag,aluToMemAddress,result);

END EXStage;