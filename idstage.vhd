LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY idstage IS
    PORT (

        clk, rst : IN STD_LOGIC;
        write_en : IN STD_LOGIC;
        read1_addres, read2_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        memWrite, memRead, wbEnable, aluEnable, inportControl : OUT STD_LOGIC;
        source1, source2, rdstValue : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

        -- Phase 3:

        read3_addres : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

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
        StallPC_Fetch, StallDecodA, FlushFetchD, FlushDecodeA, FlushAluM : OUT STD_LOGIC
    );
END ENTITY idstage;

ARCHITECTURE IDStage OF idstage IS

    COMPONENT regfile IS
        PORT (
            clk, rst : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            read1_addres, read2_addres, read3_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            source1, source2, source3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;

    COMPONENT controller IS
        PORT (

            opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            memWrite, memRead, wbEnable, aluEnable : OUT STD_LOGIC;
            inportControl, outportControl : OUT STD_LOGIC;
            unconditionalJump : OUT STD_LOGIC;
            stackEnable : OUT STD_LOGIC;
            aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT HazardDetectionUnit IS
        PORT (
            StallPC_Fetch, StallDecodA, FlushFetchD, FlushDecodeA, FlushAluM: OUT STD_LOGIC;
            memreadAlu, memwriteAlu : IN STD_LOGIC;
            memreadM1, memwriteM1 : IN STD_LOGIC;
            memreadM2, wbM2 : IN STD_LOGIC;

            rDstM1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            rDstM2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            src1Alu : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            src2Alu : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            unconditionalJmp, conditionalJmp : IN STD_LOGIC
        );
    END COMPONENT;
    SIGNAL controllerUnConditionalJmp : STD_LOGIC;

BEGIN

    regFile1 : regfile PORT MAP(clk, rst, write_en, read1_addres, read2_addres, read3_addres, write_adress, source1, source2, rdstValue, write_data);
    -- regFile1 : regfile PORT MAP(clk, rst, write_en, read1_addres, read2_addres, write_adress, source1, source2, write_data);
    controller1 : controller PORT MAP(opcode, memWrite, memRead, wbEnable, aluEnable, inportControl, outportControl, controllerUnConditionalJmp, stackEnable, aluOperation);
    unconditionalJmp <= controllerUnConditionalJmp;
    hdu1 : HazardDetectionUnit PORT MAP(
        StallPC_Fetch, StallDecodA, FlushFetchD, FlushDecodeA, FlushAluM, memreadAlu, memwriteAlu,
        memreadM1, memwriteM1, memreadM2, wbM2, rDstM1, rDstM2, src1Alu, src2Alu, controllerUnConditionalJmp, conditionalJmp);
END IDStage;