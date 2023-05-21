LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regfile IS
        PORT (
                clk, rst : IN STD_LOGIC;
                write_en : IN STD_LOGIC;
                read1_addres, read2_addres, read3_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                source1, source2, source3 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
                write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY regfile;

ARCHITECTURE regfile_arch1 OF regfile IS

        COMPONENT axram IS
                PORT (
                        clk : IN STD_LOGIC;
                        we : IN STD_LOGIC;
                        rst : IN STD_LOGIC;
                        read1_addres, read2_addres, write_adress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                        dataout1, dataout2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
        END COMPONENT;

BEGIN
        fx : axram GENERIC MAP(n) PORT MAP(clk, write_en, rst, read1_addres, read2_addres, read3_addres, write_adress, write_data, source1, source2, source3);

END ARCHITECTURE regfile_arch1;