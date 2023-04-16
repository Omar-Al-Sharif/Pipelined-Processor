library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity controller is
port(opcode : in std_logic_vector(4 downto 0);
	memWrite,memRead,wbEnable,aluEnable,memToReg: out std_logic;
	aluOperation: out std_logic_vector(4 downto 0)

);
end entity;

architecture controllerFlow of controller is
begin
    aluOperation <= opcode;
	process(opcode)
	begin
	if (opcode = "00000") then --NOP--
        memWrite <= '0';
        memRead  <= '0';
        wbEnable <= '0';
        aluEnable<= '0';
        memToReg <= '0';
	
        elsif (opcode = "00100") then --INC--
            memWrite <= '0';
            memRead  <= '0';
            wbEnable <= '1';
            aluEnable<= '1';
            memToReg <= '0'; 

            elsif (opcode = "01010") then --AND--
                memWrite <= '0';
                memRead  <= '0';
                wbEnable <= '1';
                aluEnable<= '1';
                memToReg <= '0';
  
                elsif (opcode = "01100") then --IN--
                    memWrite <= '0';
                    memRead  <= '0';
                    wbEnable <= '1';
                    aluEnable<= '1';
                    memToReg <= '0';

                    elsif (opcode = "10000") then --LDD--
                        memWrite <= '0';
                        memRead  <= '1';
                        wbEnable <= '1';
                        aluEnable<= '1';
                        memToReg <= '1';

                        elsif (opcode = "10001") then --STD--
                            memWrite <= '1';
                            memRead  <= '0';
                            wbEnable <= '0';
                            aluEnable<= '1';
                            memToReg <= '0';  
        end if;
        end process;



end controllerFlow;