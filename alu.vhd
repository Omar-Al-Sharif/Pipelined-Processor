LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY alu IS
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
		Immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0)--//17/5/2023
	);
END ENTITY;

ARCHITECTURE aluFlow OF alu IS
	SIGNAL resultSignal : STD_LOGIC_VECTOR(15 DOWNTO 0); --just to check on the flags (you can't use if condition on the outout 'result')
	SIGNAL Src2Signal : STD_LOGIC_VECTOR(15 DOWNTO 0); --used for subract operation and flags due to it
	SIGNAL zeroFlagSignal, negativeFlagSignal, carryFlagSignal : STD_LOGIC;
	--SIGNAL conditionalJumpSignal : STD_LOGIC;
	--SIGNAL carryFlagSignal,setcSignal,clrcSignal: STD_LOGIC;
BEGIN

	PROCESS (aluOperation, Src1, Src2, resultSignal, aluEnable, zeroFlagSignal, carryFlagSignal)
	BEGIN
		IF (aluEnable = '1') THEN
			--			IF (aluOperation = "00000") THEN NOP--
			--				aluToMemAddress <= (OTHERS => '0');
			--				resultSignal <= x"0000";
			--				result <= x"0000";
			--			IF (aluOperation = "00001") THEN --SETC-- Since it only affects flags, therefore it's written in flag manipulation section
			--				aluToMemAddress <= (OTHERS => '0');
			--				--result unchanged, so that other flags don;t change
			--				setcSignal <= '1';
			--				clrcSignal <= '0';
			--				carryFlagSignal <= '1';
			--			ELSIF (aluOperation = "00010") THEN --CLRC-- Since it only affects flags, therefore it's written in flag manipulation section
			--				aluToMemAddress <= (OTHERS => '0');
			--				--result unchanged, so that other flags don;t change
			--				setcSignal <= '0';
			--				clrcSignal <= '1';
			--				carryFlagSignal <= '1';
			IF (aluOperation = "00011") THEN --NOT-- //17/5/2023 //doesn't change in carry flag: done
				resultSignal <= NOT Src1;
				result <= NOT Src1;
				conditionalJump <= '0';
			elsIF (aluOperation = "00000") THEN --nop-- 
				conditionalJump <= '0';
			ELSIF (aluOperation = "00100") THEN --INC--
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 + 1;
				result <= Src1 + 1;
				conditionalJump <= '0';

			ELSIF (aluOperation = "00101") THEN --DEC-- //17/5/2023
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 - 1;
				result <= Src1 - 1;
				conditionalJump <= '0';
			ELSIF (aluOperation = "00110") THEN --MOV-- //17/5/2023
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1;
				result <= Src1;
				conditionalJump <= '0';
			ELSIF (aluOperation = "00111") THEN --ADD-- //17/5/2023
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 + Src2;
				result <= Src1 + Src2;
				conditionalJump <= '0';

			ELSIF (aluOperation = "01000") THEN --IADD-- //17/5/2023
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 + Immediate;
				result <= Src1 + Immediate;
				conditionalJump <= '0';

			ELSIF (aluOperation = "01001") THEN --SUB-- //17/5/2023
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 - Src2;
				result <= Src1 - Src2;

				Src2Signal <= (NOT Src2) + '1'; --//2's complement
				conditionalJump <= '0';

			ELSIF (aluOperation = "01010") THEN --AND--
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 AND Src2;
				result <= Src1 AND Src2;
				conditionalJump <= '0';

			ELSIF (aluOperation = "01011") THEN --OR--
				aluToMemAddress <= (OTHERS => '0');
				resultSignal <= Src1 OR Src2;
				result <= Src1 OR Src2;
				conditionalJump <= '0';

				--			ELSIF (aluOperation = "01100") THEN --IN-- //need help here
				--				aluToMemAddress <= (OTHERS => '0');
				--				resultSignal <= (OTHERS => '0'); --this is correct inport value passes by buffers only till it reaches mux --ziad comment
				--				result <= x"0000";
			ELSIF (aluOperation = "01100") THEN --OUT-- 
				result <= Src1;
				conditionalJump <= '0';
			ELSIF (aluOperation = "01110") THEN --PUSH--  //needs to be changed in the doceument
				--aluToMemAddress <= Immediate;
				--resultSignal <= (OTHERS => '0'); to not affect flags (-ve flag)
				result <= Src1;
				conditionalJump <= '0';
				-- ELSIF (aluOperation = "10010") THEN --LDM--  //needs to be changed in the doceument
				-- 	aluToMemAddress <= Immediate;
			ELSIF (aluOperation = "10010") THEN --LDM--
				result <= Immediate;
				conditionalJump <= '0';

				--resultSignal <= (OTHERS => '0'); --should be src1 like result? --ziad comment
				--result <= x"0000";
				-- conditionalJump <= '0';

			ELSIF (aluOperation = "10000") THEN --LDD-- //error from last phase LDD opcode is 10001 not 10000 //needs to be changed in the doceument:done
				aluToMemAddress <= Src1;
				--resultSignal <= (OTHERS => '0'); --should be src1 like result? --ziad comment
				--result <= x"0000";
				conditionalJump <= '0';

			ELSIF (aluOperation = "10001") THEN --STD-- //error from last phase STD opcode is 10010 not 10001 //needs to be changed in the doceument:done
				aluToMemAddress <= Src2;
				resultSignal <= Src1;
				result <= Src1;
				conditionalJump <= '0';
				--Branching Instructions--///////////////////////////////////
			ELSIF (aluOperation = "10011") THEN --JZ-- 
				IF (zeroFlagSignal = '1') THEN
					conditionalJump <= '1';
				ELSE
					conditionalJump <= '0';
				END IF;

			ELSIF (aluOperation = "10100") THEN --JC-- 
				IF (carryFlagSignal = '1') THEN
					conditionalJump <= '1';
				ELSE
					conditionalJump <= '0';
				END IF;
				

			
              else 
			  conditionalJump <= '0';
				--			ELSIF (aluOperation = "10101") THEN --JMP-- 
				--					branchingAddress <= Src1;
				--					conditionalJump <= '1';

				--			ELSE  --I am considering deleteing this 'else' as it affects flags by reseting the result--
				--				aluToMemAddress <= (OTHERS => '0');
				--				resultSignal <= (OTHERS => '0');
				--				result <= x"0000";

			END IF;
			--//Flag manipulation//-- Carry section --
			IF (aluOperation = "00100") THEN --in case of inc operation only
				IF (Src1(15) = '1' AND resultSignal(15) = '0') THEN --check the MSB of src1 and result MSB--
					carryFlag <= '1'; --in this case ffff+1 is the one which will set the carryFlag--
					carryFlagSignal <= '1';
				ELSE
					carryFlag <= '0';
					carryFlagSignal <= '0';
				END IF;

			ELSIF (aluOperation = "00101") THEN --in case of dec operation only  //need help here  //17/5/2023
				IF (Src1 = x"0000" OR Src1(15) = '1') THEN --check the value of src1 if it's zero--
					carryFlag <= '1'; --in this case 0-1 is the one which will set the carryFlag or the MSB is 1 (which means number is negative)--
					carryFlagSignal <= '1';
				ELSE
					carryFlag <= '0';
					carryFlagSignal <= '0';
				END IF;

			ELSIF (aluOperation = "00111") THEN --in case of add operation only  //17/5/2023 
				IF (Src1(15) = '1' AND Src2(15) = '1' AND resultSignal(15) = '0') THEN --check the MSB of each operands and result one--
					carryFlag <= '1';
					carryFlagSignal <= '1';
				ELSIF (Src1(15) = '1' AND Src2(15) = '0' AND resultSignal(15) = '0') THEN
					carryFlag <= '1';
					carryFlagSignal <= '1';
				ELSIF (Src1(15) = '0' AND Src2(15) = '1' AND resultSignal(15) = '0') THEN
					carryFlag <= '1';
					carryFlagSignal <= '1';
				ELSE
					carryFlag <= '0';
					carryFlagSignal <= '0';
				END IF;
			ELSIF (aluOperation = "01000") THEN --in case of IADD operation only  //17/5/2023 
				IF (Src1(15) = '1' AND Immediate(15) = '1' AND resultSignal(15) = '0') THEN --check the MSB of each operands and result one--
					carryFlag <= '1';
					carryFlagSignal <= '1';
				ELSIF (Src1(15) = '1' AND Immediate(15) = '0' AND resultSignal(15) = '0') THEN
					carryFlag <= '1';
					carryFlagSignal <= '1';
				ELSIF (Src1(15) = '0' AND Immediate(15) = '1' AND resultSignal(15) = '0') THEN
					carryFlag <= '1';
					carryFlagSignal <= '1';
				ELSE
					carryFlag <= '0';
					carryFlagSignal <= '0';
				END IF;
			ELSIF (aluOperation = "01001") THEN --in case of SUB operation only  //17/5/2023 
				IF (Src1 = Src2) THEN
					carryFlag <= '0';
					carryFlagSignal <= '0';
				ELSIF (Src1 < Src2) THEN
					carryFlag <= '1';
					carryFlagSignal <= '1';
					--                   			if(Src1(15) = '1' and Src2Signal(15) = '1' and resultSignal(15) = '0')then --check the MSB of each operands and result one--
					--                    				carryFlag <= '1';
					--						carryFlagSignal <= '1';
					--                    			elsif(Src1(15) = '1' and Src2Signal(15) = '0' and resultSignal(15) = '0')then	
					--                    				carryFlag <= '1';
					--						carryFlagSignal <= '1';
					--                    			elsif(Src1(15) = '0' and Src2Signal(15) = '1' and resultSignal(15) = '0')then	
					--                    				carryFlag <= '1';
					--						carryFlagSignal <= '1';
					--                    			else
					--                    				carryFlag <= '0';
					--						carryFlagSignal <= '0';
					--                    			END IF;
				END IF;
			ELSIF (aluOperation = "00001") THEN --SETC operation only-- //17/5/2023
				carryFlag <= '1';
				carryFlagSignal <= '1';
			ELSIF (aluOperation = "00010") THEN --CLRC operation only-- //17/5/2023
				carryFlag <= '0';
				carryFlagSignal <= '0';
				--ELSIF(aluOperation ="01001") then --sub operation only--
			
				--else
       
				--carryFlag <= '0';

			END IF;

			-- Set negative flag if result is negative //--Negative flag section-- --mov ldd std ldm in out
			IF (aluOperation /= "00110" AND aluOperation /= "10000" AND aluOperation /= "10001" AND aluOperation /= "10010" AND aluOperation /= "01100" AND aluOperation /= "01101") THEN-- //17/5/2023  as mov instruction doesn't affect any flag --
				IF (aluOperation /= "00001" AND aluOperation /= "00010" AND aluOperation /= "01110") THEN--SETC CLRC push
					negativeFlag <= resultSignal(15);
					negativeFlagSignal <= resultSignal(15);
				END IF;
			END IF;

			IF (resultSignal = x"0000" AND aluOperation /= "00110" AND aluOperation /= "10001") THEN --mov std
				zeroFlag <= '1';
				zeroFlagSignal <= '1';
			ELSE
				zeroFlag <= '0';
				zeroFlagSignal <= '0';
			END IF;

		
		 elsIF (aluOperation = "00000") THEN --nop-- 
				conditionalJump <= '0';
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