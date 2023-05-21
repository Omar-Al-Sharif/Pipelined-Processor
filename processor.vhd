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

COMPONENT ifstage IS
    PORT (
        clk, rst : IN STD_LOGIC;
        instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        pcEnable: IN STD_LOGIC;
        decodeJmpAddress, aluJmpAddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        conditionalBranchEn , unConditionalBranchEn : IN STD_LOGIC

    );
end COMPONENT;

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
        write_en : IN STD_LOGIC;
        read1_addres, read2_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        memWrite, memRead, wbEnable, aluEnable, inportControl : OUT STD_LOGIC;
        source1, source2 , rdstValue : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

        -- Phase 3:

        read3_addres: IN std_logic_vector(2 downto 0);

        -- Added Contoller Phase 3 outputs
        outportControl, unconditionalJmp, stackEnable : OUT STD_LOGIC;

        -- Added Hazard detection unit inputs & outputs:
        memreadAlu, memwriteAlu : IN STD_LOGIC;
        memreadM1, memwriteM1 : IN STD_LOGIC;
        memreadM2, wbM2 : IN STD_LOGIC;
        rDstM1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rDstM2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        src1Alu : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        src2Alu : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        conditionalJmp : IN STD_LOGIC;
        StallPC_Fetch, StallDecodA, FlushFetchD, FlushDecodeA, FlushAluM OUT STD_LOGIC
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
		result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		conditionalJump : OUT STD_LOGIC;
		Immediate    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--//17/5/2023

		Src1Address, Src2Address: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rd_ex_mem : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- destination register for EX/MEM pipeline register
        rd_mem_wb : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- destination register for MEM/WB pipeline register
        REG_WB_ex_mem : IN STD_LOGIC; -- (writeback) control signal for in EX/MEM pipeline register
        REG_WB_mem_wb : IN STD_LOGIC; -- (writeback) control signal for in MEM/WB pipeline register
        ex_mem_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- ALU output from EX/MEM pipeline register
        mem_wb_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- output from MEM/WB pipeline register (from mem stage 2 to wb)


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

-- if stage
signal fetchedInstruction: std_logic_vector(31 downto 0);


-- id stage
signal memWrite, memRead, wbEnable, aluEnable, inportControl: std_logic;
signal src1, src2, rdest: std_logic_vector(15 downto 0);
signal aluOp: std_logic_vector(4 downto 0);
signal outportControl, unconditionalJmp, stackEnable, conditionalJmp: std_logic;


-- ex stage
signal flagsIn, flagsOut: std_logic_vector(2 downto 0);
signal zeroFlag, negativeFlag, carryFlag: std_logic;
signal aluResult, aluAddress: std_logic_vector(15 downto 0);

-- mem stage
signal memReadData: std_logic_vector(15 downto 0);


-- wb stage
signal writeBackData: std_logic_vector(15 downto 0);
signal writeBackEnable: std_logic;
signal writeBackAddress: std_logic_vector(2 downto 0);


-- Buffer Concatenated Inputs and Outpus:
signal m1M2BufferInput: std_logic_vector(36 downto 0);
signal m1M2BufferOutput: std_logic_vector(36 downto 0);
signal m2WbBufferOutput: std_logic_vector(36 downto 0);
signal idExBufferOutput: std_logic_vector(81 downto 0);
signal idExBufferInput: std_logic_vector(81 downto 0);
signal ifIdBufferInput: std_logic_vector(47 downto 0);
signal ifIdBufferOutput: std_logic_vector(47 downto 0);
signal exMemBufferInput: std_logic_vector(54 downto 0);
signal exMemBufferOutput: std_logic_vector(54 downto 0);

-- Intermediate signals:

-- HDU outputs:

signal hduPcStall, stallIDEXBuffer, flushIFIDBuffer, flushIDEXBuffer, flushM1M2Buffer : std_logic;

-- PC Inputs:
signal decodeJmpAddress, aluJmpAddress: std_logic_vector (15 downto 0);
signal conditionalJmpEn , unConditionalJmpEn: std_logic;

-- id if buff:
signal opCodeIfIDBuffOut: std_logic_vector(4 downto 0);
signal destIfIDBuffOut, src1IfIDBuffOut, src2IfIDBuffOut : std_logic_vector(2 downto 0);
signal immIfIDBuffOut, inPortIfIDBuffOut: std_logic_vector(15 downto 0);

-- id ex buff:
signal immIdExBuffOut, src1IdExBuffOut, src2IdExBuffOut, inPortIdExBuffOut : std_logic_vector(15 downto 0);
signal src1AddressIdExBuffOut, src2AddressIdExBuffOut, destIdExBuffOut: std_logic_vector(2 downto 0);
signal memReadIdExBuffOut, memWriteIdExBuffOut, aluEnableIdExBuffOut, inportControlIdExBuffOut, wbEnableIdExBuffOut: std_logic;
signal aluOpIdExBuffOut: std_logic_vector(4 downto 0);

-- ex mem buff:
signal aluResultExMemBuffOut, aluAddressExMemBuffOut, inPortExMemBuffOut : std_logic_vector(15 downto 0);
signal destExMemBuffOut: std_logic_vector(2 downto 0);
signal memReadExMemBuffOut, memWriteExMemBuffOut, inportControlExMemBuffOut, wbEnableExMemBuffOut: std_logic;


-- m1m2 buff

signal destM1M2BuffOut: std_logic_vector(2 downto 0);

-- mem wb buff:
signal wbDataMemWbBuffOut, inPortMemWbBuffOut: std_logic_vector(15 downto 0); 
signal inportControlMemWbBuffOut, wbEnableMemWbBuffOut : std_logic;
signal destM2WbBuffOut: std_logic_vector(2 downto 0);


begin 

-- IF Stage: ----------------------------------------------------------------------

IF_Stage: ifstage port map(clk, rst, fetchedInstruction, hduPcStall, decodeJmpAddress, aluJmpAddress, conditionalJmpEn, unConditionalJmpEn);
ifIdBufferInput <=  (inport & fetchedInstruction );
IF_ID_Buffer: buff generic map(48) port map(hduPcStall, clk, flushIFIDBuffer, ifIdBufferInput , ifIdBufferOutput);

immIfIDBuffOut <= ifIdBufferOutput (15 downto 0);
opCodeIfIDBuffOut <= ifIdBufferOutput(31 downto 27);
destIfIDBuffOut <= ifIdBufferOutput (26 downto 24);
src1IfIDBuffOut <= ifIdBufferOutput (23 downto 21);
src2IfIDBuffOut <= ifIdBufferOutput (20 downto 18);



-- ID Stage: ------------------------------------------------------------------------

ID_Stage: idstage port map(clk, rst, wbEnableMemWbBuffOut, 
src1IfIDBuffOut, src2IfIDBuffOut, writeBackAddress, writeBackData, opCodeIfIDBuffOut,
memWrite, memRead, wbEnable, aluEnable, inportControl, src1, src2, rdest , aluOp,
destIfIDBuffOut, outportControl, unconditionalJmp, stackEnable,
memReadIdExBuffOut, memWriteIdExBuffOut, memReadExMemBuffOut, memWriteExMemBuffOut,
destExMemBuffOut, destM1M2BuffOut, src1AddressIdExBuffOut, src2AddressIdExBuffOut,
conditionalJmp, hduPcStall, stallIDEXBuffer, flushIFIDBuffer , flushIDEXBuffer, flushM1M2Buffer 
);


--                      81 - 67                   66-64               63-61             60-58          57             56-41  40-25  24-20    19         18          17          16     15-0
idExBufferInput <= ( immIfIDBuffOut  & src1IfIDBuffOut & src2IfIDBuffOut & destIfIDBuffOut & inportControl & src1 & src2 & aluOp & aluEnable & memWrite & memRead & wbEnable & inport);
ID_EX_Buffer: buff generic map(82) port map(stallIDEXBuffer, clk, flushIDEXBuffer, idExBufferInput, idExBufferOutput);

immIdExBuffOut <= idExBufferOutput (81 downto 67);
src1AddressIdExBuffOut <= idExBufferOutput(66 downto 64);
src2AddressIdExBuffOut <= idExBufferOutput(63 downto 61);
destIdExBuffOut <= idExBufferOutput(60 downto 58);
inportControlIdExBuffOut <= idExBufferOutput(57);
src1IdExBuffOut <= idExBufferOutput(56 downto 41);
src2IdExBuffOut <= idExBufferOutput(40 downto 25);
aluOpIdExBuffOut <= idExBufferOutput(24 downto 20);
aluEnableIdExBuffOut <= idExBufferOutput(19);
memWriteIdExBuffOut <= idExBufferOutput(18);
memReadIdExBuffOut <= idExBufferOutput(17);
wbEnableIdExBuffOut <= idExBufferOutput (16);
inportIdExBuffOut <= idExBufferOutput(15 downto 0);

-- Ex Stage: -----------------------------------------------------------------------

EX_Stage: exstage port map(src1IdExBuffOut,src2IdExBuffOut,aluOpIdExBuffOut, aluEnableIdExBuffOut, zeroFlag, negativeFlag, carryFlag,
aluAddress , aluResult, conditionalJmp, immIdExBuffOut, src1AddressIdExBuffOut, src2AddressIdExBuffOut,
destExMemBuffOut, destM2WbBuffOut, wbEnableExMemBuffOut, wbEnableMemWbBuffOut,
aluResultExMemBuffOut, wbDataMemWbBuffOut);

flagsIn <= (zeroFlag, negativeFlag, carryFlag);
Flags: buff generic map(3) port map('1', clk, rst, flagsIn, flagsOut);

--                      54-52    51-36      35-20          19        18       17              16         15-0
-- exMemBufferInput <= (dest &aluResult & aluAddress & memWrite & memRead & wbEnable & inportControl & inport);

-- sizes:              3                             16             16                 1          +       1                  +       1                 
exMemBufferInput <= (destIdExBuffOut & aluResult & aluAddress  & memWriteIdExBuffOut & memReadIdExBuffOut & wbEnableIdExBuffOut & inportControlIdExBuffOut & inportIdExBuffOut);
EX_Mem_Buffer: buff generic map(55) port map('1', clk, rst, exMemBufferInput, exMemBufferOutput);

destExMemBuffOut <= exMemBufferOutput(54 downto 52);
aluResultExMemBuffOut <= exMemBufferOutput(51 downto 36);
aluAddressExMemBuffOut <= exMemBufferOutput(35 downto 20);
memWriteExMemBuffOut <= exMemBufferOutput(19);
memReadExMemBuffOut <= exMemBufferOutput(18);
wbEnableExMemBuffOut <= exMemBufferOutput(17);
inportControlExMemBuffOut <= exMemBufferOutput(16);
inportExMemBuffOut <= exMemBufferOutput(15 downto 0);


Mem_Stage: memstage port map(clk, memWriteExMemBuffOut, memReadExMemBuffOut, aluAddressExMemBuffOut,
 aluResultExMemBuffOut,
 memReadData);
-- Might be a problem in the output

--      sizes                3                16             1                         1                          16             =   37
--                      36-34: dest       33-18          wbEnable  17           input control  16                  input port 15:0
m1M2BufferInput <= (destExMemBuffOut & memReadData & wbEnableExMemBuffOut & inportControlExMemBuffOut & inportExMemBuffOut ); 
M1_M2_Buffer: buff generic map(37) port map('1', clk, rst, m1M2BufferInput, m1M2BufferOutput);

destM1M2BuffOut <= m1M2BufferOutput(36 downto 34);

M2_WB_Buffer: buff generic map(37) port map('1',clk,rst, m1M2BufferOutput, m2WbBufferOutput);

destM2WbBuffOut <= m2WbBufferOutput(36 downto 34);

wbEnableMemWbBuffOut <= m2WbBufferOutput(17);

-- writeBackEnable <= m2WbBufferOutput(17);

-- writeBackData <= m2WbBufferOutput(33 downto 18);
writeBackAddress <= m2WbBufferOutput (36 downto 34);

wbDataMemWbBuffOut <= m2WbBufferOutput(33 downto 18);
inPortMemWbBuffOut <= m2WbBufferOutput(15 downto 0);
inportControlMemWbBuffOut <= m2WbBufferOutput(16);

WB_Stage: wbstage port map (wbDataMemWbBuffOut, inPortMemWbBuffOut, inportControlMemWbBuffOut, writeBackData);

end integration;