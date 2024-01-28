LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
port( clck:in std_logic;
StallPC_Fetch,StallDecodA,FlushFetchD,FlushDecodeA,FlushAluM :out std_logic;
memreadAlu,memwriteAlu: in std_logic;
memreadM1,memwriteM1: in std_logic;
 memreadM2,wbM2: in std_logic;

rDstM1:in std_logic_vector(2 downto 0);
rDstM2:in std_logic_vector(2 downto 0);
src1Alu:in std_logic_vector(2 downto 0);
src2Alu:in std_logic_vector(2 downto 0);

unconditionalJmp,conditionalJmp:in std_logic
);
end entity HazardDetectionUnit;
--F D E M W
--  F D D E M W
--    F F D E M W
architecture archHDU of HazardDetectionUnit is
    Signal bufdd :STD_LOGIC;
    component bitbuff is    
	generic (n: integer := 16);
	port (enable, clk, rst: in std_logic;
		d: in std_logic;
		q: out std_logic);
end component;
    begin
  


    --pc f
	StallPC_Fetch<='0' when(((memreadM2 = '1' or  wbM2 = '1') and ((rdstM2 = src1Alu) or (rdstM2 = src2Alu)))-- forwording failier
     or (memreadM1 = '1' and ((rdstM1 = src1Alu) or (rdstM1 = src2Alu))) --load use
     or ( (memreadM1 = '1' or memwriteM1='1') and( memreadAlu = '1' or memwriteAlu='1')))--2 mem stall

     else '1';

	FlushFetchD<='1' when(unconditionalJmp='1' or conditionalJmp='1') else '0';



	StallDecodA<='0' when(((memreadM2 = '1' or  wbM2 = '1') and ((rdstM2 = src1Alu) or (rdstM2 = src2Alu)))-- forwording failier
    or (memreadM1 = '1' and ((rdstM1 = src1Alu) or (rdstM1 = src2Alu))) --load use
    or ( (memreadM1 = '1' or memwriteM1='1') and( memreadAlu = '1' or memwriteAlu='1')))--2 mem stall
    else '1';
	
    FlushDecodeA<='1' when(conditionalJmp='1') --decode flush
	else '0';




	bufdd<='1' when(((memreadM2 = '1' or  wbM2 = '1') and ((rdstM2 = src1Alu) or (rdstM2 = src2Alu)))-- forwording failier
    or (memreadM1 = '1' and ((rdstM1 = src1Alu) or (rdstM1 = src2Alu))) --load use
    or ( (memreadM1 = '1' or memwriteM1='1') and( memreadAlu = '1' or memwriteAlu='1')))--2 mem stall
	else '0';

    flush: bitbuff port map('1',clck,'0','0',FlushAluM);

    -- flush happend at the eadge of the new clck

end archHDU;
