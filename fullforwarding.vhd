LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- entity declaration for forwarding unit
ENTITY forwarding_unit IS
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
END forwarding_unit;

-- architecture declaration for forwarding unit
ARCHITECTURE behavioral OF forwarding_unit IS
BEGIN
    forward_src1 <= ex_mem_out WHEN (REG_WB_ex_mem = '1' AND rd_ex_mem = rs1) ELSE
        mem_wb_out WHEN (REG_WB_mem_wb = '1' AND rd_mem_wb = rs1) ELSE
        decode_rs1;

    forward_src2 <= ex_mem_out WHEN (REG_WB_ex_mem = '1' AND rd_ex_mem = rs2) ELSE
        mem_wb_out WHEN (REG_WB_mem_wb = '1' AND rd_mem_wb = rs2) ELSE
        decode_rs2;
END behavioral;