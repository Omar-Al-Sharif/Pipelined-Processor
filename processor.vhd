LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;


ENTITY processor is

    port (
        clk, rst : in std_logic;
        inPort: in std_logic_vector(15 downto 0)
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
        memWrite, memRead, wbEnable, aluEnable, inportControl: OUT STD_LOGIC;
        source1, source2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)

    );
END component;


component exstage IS
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


component memstage IS
     PORT (
        clk : IN STD_LOGIC;
        memWrite, memRead : IN STD_LOGIC; -- read and write enables
        address, value : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --  adress = location for loading or location for storing in mem, value = value to be stored
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- data out from this block
END component;


component wbstage IS
    PORT (

        inData, inport: in std_logic_vector(15 downto 0);
        inportControl: in std_logic;
        outData: out std_logic_vector(15 downto 0)
    );
END component;


signal fetchedInstruction: std_logic_vector(31 downto 0);
signal writeBackEnable: std_logic;
signal writeBackData: std_logic_vector(15 downto 0);
signal memWrite, memRead, wbEnable, aluEnable, inportControl: std_logic;
signal src1, src2: std_logic_vector(15 downto 0);
signal aluOp: std_logic_vector(4 downto 0);
signal idExBufferOutput: std_logic_vector(60 downto 0);
signal idExBufferInput: std_logic_vector(60 downto 0);
signal ifIdBufferInput: std_logic_vector(47 downto 0);
signal ifIdBufferOutput: std_logic_vector(47 downto 0);
signal zeroFlag, negativeFlag, carryFlag: std_logic;
signal aluResult, aluAddress: std_logic_vector(15 downto 0);
signal flagsIn, flagsOut: std_logic_vector(2 downto 0);
signal exMemBufferInput: std_logic_vector(54 downto 0);
signal exMemBufferOutput: std_logic_vector(54 downto 0);
signal memReadData: std_logic_vector(15 downto 0);
signal m1M2BufferInput: std_logic_vector(36 downto 0);
signal m1M2BufferOutput: std_logic_vector(36 downto 0);
signal m2WbBufferOutput: std_logic_vector(36 downto 0);
signal writeBackAddress: std_logic_vector(2 downto 0);


begin 

IF_Stage: ifstage port map(clk, rst, fetchedInstruction);
ifIdBufferInput <=  (fetchedInstruction & inport);
IF_ID_Buffer: buff generic map(48) port map('1', clk, rst, ifIdBufferInput , ifIdBufferOutput);
ID_Stage: idstage port map(clk, rst, writeBackEnable, 
ifIdBufferOutput(23 downto 21),
ifIdBufferOutput(20 downto 18),
writeBackAddress,
writeBackData,
ifIdBufferOutput(31 downto 27),
memWrite, memRead, wbEnable, aluEnable, inportControl, src1, src2, aluOp);
--                                      60-58          57             56-41  40-25  24-20    19         18          17          16     15-0
idExBufferInput <= (ifIdBufferOutput(26 downto 24) & inportControl & src1 & src2 & aluOp & aluEnable & memWrite & memRead & wbEnable & inport);
ID_EX_Buffer: buff generic map(61) port map('1', clk, rst, idExBufferInput, idExBufferOutput);
EX_Stage: exstage port map(
idExBufferOutput(56 downto 41),
idExBufferOutput (40 downto 25),
idExBufferOutput (24 downto 20),
idExBufferOutput(19), zeroFlag, negativeFlag, carryFlag, aluAddress ,aluResult);

flagsIn <= (zeroFlag, negativeFlag, carryFlag);
Flags: buff generic map(3) port map('1', clk, rst, flagsIn, flagsOut);

--                      54-52    51-36      35-20          19        18       17              16         15-0
-- exMemBufferInput <= (dest &aluResult & aluAddress & memWrite & memRead & wbEnable & inportControl & inport);

-- sizes:              3                             16             16                 1          +       1                  +       1                 
exMemBufferInput <= (idExBufferOutput(60 downto 58) & aluResult & aluAddress  & idExBufferOutput(18) & idExBufferOutput(17) & idExBufferOutput(16) 
& idExBufferOutput(57) & idExBufferOutput(15 downto 0));
EX_Mem_Buffer: buff generic map(55) port map('1', clk, rst, exMemBufferInput, exMemBufferOutput);

Mem_Stage: memstage port map(clk, exMemBufferOutput(18), exMemBufferOutput(17), exMemBufferOutput(38 downto 23),
 exMemBufferOutput(54 downto 39),
 memReadData);
--      sizes                         3                     16             1                         1                          16             =   37
--                                 36-34: dest           33-18          wbEnable  17           input control  16                  input port 15:0
m1M2BufferInput <= (exMemBufferOutput(54 downto 52) & memReadData & exMemBufferOutput(17) & exMemBufferOutput(16) & exMemBufferOutput(15 downto 0) ); 
M1_M2_Buffer: buff generic map(37) port map('1', clk, rst, m1M2BufferInput, m1M2BufferOutput);

M2_WB_Buffer: buff generic map(37) port map('1',clk,rst, m1M2BufferOutput, m2WbBufferOutput);
writeBackEnable <= m2WbBufferOutput(17);

-- writeBackData <= m2WbBufferOutput(33 downto 18);
writeBackAddress <= m2WbBufferOutput (36 downto 34);

WB_Stage: wbstage port map (m2WbBufferOutput(33 downto 18), m2WbBufferOutput(15 downto 0), m2WbBufferOutput(16), writeBackData);

end integration;