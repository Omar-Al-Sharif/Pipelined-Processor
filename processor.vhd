LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;


ENTITY processor is

    port (
        clk, rst : in std_logic

    );

end ENTITY;

architecture integration of processor is

component ifstage IS
    PORT (
        clk, rst : IN STD_LOGIC;
        instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END component;

component buff is    
	generic (n: integer := 16);
	port (enable, clk, rst: in std_logic;
		d: in std_logic_vector(n-1 downto 0);
		q: out std_logic_vector(n-1 downto 0));
end component;

component fallingedgebuff is    
	generic (n: integer := 16);
	port (enable, clk, rst: in std_logic;
		d: in std_logic_vector(n-1 downto 0);
		q: out std_logic_vector(n-1 downto 0));
end component;


component idstage IS
    PORT (

        clk, rst : IN STD_LOGIC;
        write_en : in std_logic;
        read1_addres, read2_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        memWrite, memRead, wbEnable, aluEnable : OUT STD_LOGIC;
        source1, source2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)

    );
END component;

signal fetchedInstruction: std_logic_vector(31 downto 0);
signal ifIdBufferOutput: std_logic_vector(31 downto 0);
signal writeBackEnable: std_logic;
signal writeBackData: std_logic_vector(15 downto 0);
signal memWrite, memRead, wbEnable, aluEnable: std_logic;
signal src1, src2: std_logic_vector(15 downto 0);
signal aluOp: std_logic_vector(4 downto 0);

begin 


IF_Stage: ifstage port map(clk, rst, fetchedInstruction);
IF_ID_Buffer: fallingedgebuff generic map(32) port map('1', clk, rst, fetchedInstruction, ifIdBufferOutput);
ID_Stage: idstage port map(clk, rst, writeBackEnable, 
ifIdBufferOutput(23 downto 21),
ifIdBufferOutput(20 downto 18),
ifIdBufferOutput(26 downto 24),
writeBackData,
ifIdBufferOutput(31 downto 27),
memWrite, memRead, wbEnable, aluEnable, src1, src2, aluOp);





end integration;