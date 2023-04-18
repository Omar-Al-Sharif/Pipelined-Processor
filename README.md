# Pipelined-Processor
VHDL implementation of a 6-stage pipelined processor has a RISC-like instruction set architecture
===============================
Note that:
when the command is NOP or IN, the controller resets aluEnable by '0', so i think we don't need to put in alu a code to handle NOP or IN
IN alu -> In LDD instruction -> I think it won't change the flag register, 
but now the result of LDD is (result = "0000"; aluToMemAddress = Src1;) which affects the flag reg..........لو حبينا نعدلها مش هتاخد الا سطرين فقط
===============================
For alu Simulation:
from sim setting choose hex 
For controller simulation:
choose binary 
