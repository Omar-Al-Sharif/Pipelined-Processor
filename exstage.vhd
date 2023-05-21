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

COMPONENT forwarding_unit IS
    PORT (
        rs1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- first source register
        rs2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- second source register
        rd_ex_mem : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- destination register for EX/MEM pipeline register
        rd_mem_wb : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- destination register for MEM/WB pipeline register
        REG_WB_ex_mem : IN STD_LOGIC; -- (writeback) control signal for in EX/MEM pipeline register
        REG_WB_mem_wb : IN STD_LOGIC; -- (writeback) control signal for in MEM/WB pipeline register
        ex_mem_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- ALU output from EX/MEM pipeline register
        mem_wb_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- output from MEM/WB pipeline register (from mem stage 2 to wb)
        decode_rs1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- first source operand from decode stage
        decode_rs2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- second source operand from decode stage
        forward_src1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- forwarded value for first source operand
        forward_src2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- forwarded value for second source operand
    );
END COMPONENT;

BEGIN

alu1: alu port map(Src1,Src2,aluOperation,aluEnable,zeroFlag,negativeFlag,carryFlag,aluToMemAddress,result);

END EXStage;