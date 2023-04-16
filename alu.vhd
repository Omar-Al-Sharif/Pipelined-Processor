library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity alu is
port(Src1,Src2 : in std_logic_vector(15 downto 0);
	aluOperation : in std_logic_vector(4 downto 0);
	zeroFlag,negativeFlag,carryFlag : out std_logic;
	aluToMemAdd: out std_logic_vector(15 downto 0); --the address fed to memory (whether to read or write) -> ithink it's dependant on write enable or read enable from memory
	result: out std_logic_vector(15 downto 0)
);
end entity;

architecture aluFlow of alu is
signal resultSignal : std_logic_vector(15 downto 0); --just to check on the flags (you can't use if condition on the outout 'result')

begin

	process(aluOperation,Src1,Src2,resultSignal)
	begin
	if(aluOperation = "00000") then  --NOP--
		aluToMemAdd <= (others => '0');
		resultSignal <= x"0000";
		result <= x"0000";
	elsif(aluOperation = "00100") then --INC--
		aluToMemAdd <= (others => '0');
		resultSignal <= Src1 +1;
		result <= Src1 + 1;
	elsif(aluOperation = "01010") then --AND--
		aluToMemAdd <= (others => '0');
		resultSignal <= Src1 and Src2;
		result <= Src1 and Src2;
	elsif(aluOperation = "01100") then --IN-- //need help here
		aluToMemAdd <= (others => '0');
		resultSignal <= (others => '0');
		result <= x"0000";
	elsif(aluOperation = "10000") then --LDD--
		aluToMemAdd <= Src1;
		resultSignal <= (others=> '0');
		result <= x"0000";
	elsif(aluOperation = "10001") then --STD--
		aluToMemAdd <= Src2;
		resultSignal <= Src1;
		result <= Src1;
	else
		aluToMemAdd <= (others => '0');
		resultSignal <= (others=> '0');
		result <= x"0000";
	end if;

	if(aluOperation ="00100") then   --in case of inc operation only
		if(Src1(15) = '1' and resultSignal(15) = '0')then --check the MSB of src1 and result MSB--
		carryFlag <= '1';				--in this case ffff+1 is the one which will set the carryFlag--
		else
		carryFlag <= '0';
		end if;
	else
		carryFlag <= '0';
	end if;


--	elsif(aluOperation ="00111") then   --in case of add operation only
--		if(Src1(15) = '1' and Src2(15) = '1' and resultSignal(15) = '0')then --check the MSB of each ops and result one--
--		carryFlag <= '1';
--		elsif(Src1(15) = '1' and Src2(15) = '0' and resultSignal(15) = '0')then	
--		carryFlag <= '1';
--		elsif(Src1(15) = '0' and Src2(15) = '1' and resultSignal(15) = '0')then	
--		carryFlag <= '1';
--		else
--		carryFlag <= '0';
--		end if;
--	else
--		carryFlag <= '0';
--	end if;
--
--	end process;
        -- Set negative flag if result is negative
        negativeFlag <= resultSignal(15);
		if(resultSignal = x"0000") then
			zeroFlag <= '1';
		else
			zeroFlag <= '0';

		end if;
	end process;

end aluFlow;