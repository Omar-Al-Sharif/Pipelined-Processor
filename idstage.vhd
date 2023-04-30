LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY idstage IS
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
END ENTITY idstage;

ARCHITECTURE IDStage OF idstage IS

    COMPONENT regfile IS
        PORT (
            clk, rst : IN STD_LOGIC;

            write_en : IN STD_LOGIC;
            read1_addres, read2_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            source1, source2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;

    COMPONENT controller IS
      PORT (
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        memWrite, memRead, wbEnable, aluEnable,inportControl : OUT STD_LOGIC;
        aluOperation : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)

    );
    END COMPONENT;
BEGIN

    regFile1 : regfile PORT MAP(clk, rst, write_en, read1_addres, read2_addres, write_adress, source1, source2, write_data);
    controller1 : controller PORT MAP(opcode, memWrite, memRead, wbEnable, aluEnable, inportControl ,aluOperation);
END IDStage;