LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY alu IS
	PORT (
		Src1, Src2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		aluOperation : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		zeroFlag, negativeFlag, carryFlag : OUT STD_LOGIC;
		aluToMemAdd : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --the address fed to memory (whether to read or write) -> ithink it's dependant on write enable or read enable from memory
		-- integration from outside or gets passed by alu, ask omar since he is doing the integration, might be not needed --ziad comment
		--fix naming aluToMemAddress for readability to --ziad comment
		result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE aluFlow OF alu IS
	SIGNAL resultSignal : STD_LOGIC_VECTOR(15 DOWNTO 0); --just to check on the flags (you can't use if condition on the outout 'result')

BEGIN

	PROCESS (aluOperation, Src1, Src2, resultSignal)
	BEGIN
		IF (aluOperation = "00000") THEN --NOP--
			aluToMemAdd <= (OTHERS => '0');
			resultSignal <= x"0000";
			result <= x"0000";

		ELSIF (aluOperation = "00100") THEN --INC--
			aluToMemAdd <= (OTHERS => '0');
			resultSignal <= Src1 + 1;
			result <= Src1 + 1;

		ELSIF (aluOperation = "01010") THEN --AND--
			aluToMemAdd <= (OTHERS => '0');
			resultSignal <= Src1 AND Src2;
			result <= Src1 AND Src2;

		ELSIF (aluOperation = "01100") THEN --IN-- //need help here
			aluToMemAdd <= (OTHERS => '0');
			resultSignal <= (OTHERS => '0'); --this is correct inport value passes by buffers only till it reaches mux --ziad comment
			result <= x"0000";

		ELSIF (aluOperation = "10000") THEN --LDD--
			aluToMemAdd <= Src1;
			resultSignal <= (OTHERS => '0'); --should be src1 like result? --ziad comment
			result <= x"0000";

		ELSIF (aluOperation = "10001") THEN --STD--
			aluToMemAdd <= Src2;
			resultSignal <= Src1;
			result <= Src1;

		ELSE
			aluToMemAdd <= (OTHERS => '0');
			resultSignal <= (OTHERS => '0');
			result <= x"0000";

		END IF;

		IF (aluOperation = "00100") THEN --in case of inc operation only
			IF (Src1(15) = '1' AND resultSignal(15) = '0') THEN --check the MSB of src1 and result MSB--
				carryFlag <= '1'; --in this case ffff+1 is the one which will set the carryFlag--
			ELSE
				carryFlag <= '0';
			END IF;
		ELSE
			carryFlag <= '0';
		END IF;
		
		-- Set negative flag if result is negative
		negativeFlag <= resultSignal(15);

		IF (resultSignal = x"0000") THEN
			zeroFlag <= '1';
		ELSE
			zeroFlag <= '0';

		END IF;
	END PROCESS;

END aluFlow;


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