vsim -gui work.processor
mem load -i {D:/Omar's Files/CUFE/Spring 23/Computer Architecture/Project/Project/instructions.mem} /processor/IF_Stage/cache/fx/ram
#mem load -i {D:/arch/project/Pipelined-Processor/instructions copy.mem} /processor/IF_Stage/cache/fx/ram
mem load -i {D:/Omar's Files/CUFE/Spring 23/Computer Architecture/Project/Project/memory.mem} /processor/Mem_Stage/mem/ram
#mem load -i D:/arch/project/Pipelined-Processor/memory.mem /processor/Mem_Stage/mem/ram
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/fetchedInstruction
add wave -position end  sim:/processor/writeBackEnable
add wave -position end  sim:/processor/writeBackData
add wave -position end  sim:/processor/memWrite
add wave -position end  sim:/processor/memRead
add wave -position end  sim:/processor/wbEnable
add wave -position end  sim:/processor/aluEnable
add wave -position end  sim:/processor/src1
add wave -position end  sim:/processor/src2
#add wave -position end  sim:/processor/aluOp
#add wave -position end  sim:/processor/IF_Stage/instruction
add wave -position end  sim:/processor/IF_Stage/counter
add wave -position end  sim:/processor/inPort
add wave -position 21  sim:/processor/writeBackAddress
#add wave -position 22  sim:/processor/opCodeIfIDBuffOut
#add wave -position 23  sim:/processor/destIfIDBuffOut
#add wave -position 24  sim:/processor/src1IfIDBuffOut
#add wave -position 25  sim:/processor/src2IfIDBuffOut
#add wave -position 26  sim:/processor/immIfIDBuffOut
#add wave -position 27  sim:/processor/inPortIfIDBuffOut
#add wave -position 28  sim:/processor/src1IdExBuffOut
#add wave -position 29  sim:/processor/src2IdExBuffOut
#add wave -position 30  sim:/processor/inPortIdExBuffOut
#add wave -position 31  sim:/processor/destIdExBuffOut
#add wave -position 32  sim:/processor/memReadIdExBuffOut
#add wave -position 33  sim:/processor/memWriteIdExBuffOut
#add wave -position 34  sim:/processor/aluEnableIdExBuffOut
#add wave -position 35  sim:/processor/inportControlIdExBuffOut
#add wave -position 36  sim:/processor/wbEnableIdExBuffOut
#add wave -position 37  sim:/processor/aluOpIdExBuffOut
#add wave -position 38  sim:/processor/aluResultExMemBuffOut
#add wave -position 39  sim:/processor/aluAddressExMemBuffOut
# add wave -position 40  sim:/processor/inPortExMemBuffOut
add wave -position 40  sim:/processor/flagsOut
#add wave -position 41  sim:/processor/destExMemBuffOut
#add wave -position 42  sim:/processor/memReadExMemBuffOut
#add wave -position 43  sim:/processor/memWriteExMemBuffOut
#add wave -position 44  sim:/processor/inportControlExMemBuffOut
#add wave -position 45  sim:/processor/wbEnableExMemBuffOut
#add wave -position 46  sim:/processor/wbDataMemWbBuffOut
#add wave -position 47  sim:/processor/inPortMemWbBuffOut
#add wave -position 48  sim:/processor/inportControlMemWbBuffOut
add wave -position 21 sim:/processor/ID_Stage/regFile1/fx/ram
add wave -position end sim:/processor/ID_Stage/controller1/*
#add wave -position end sim:/processor/ID_Stage/regFile1/write_adress
#add wave -position end  sim:/processor/writeBackAddress
#add wave -position end  sim:/processor/m1M2BufferOutput
#add wave -position end  sim:/processor/m2WbBufferOutput
#add wave -position end  sim:/processor/wbDataMemWbBuffOut
#add wave -position end  sim:/processor/m1M2BufferInput


#force -freeze sim:/processor/inPort FFFE 0
force -freeze sim:/processor/clk 1 0, 0 {2 ps} -r 5
force -freeze sim:/processor/rst 1 0
run
#force -freeze sim:/processor/inPort 0001 50
force -freeze sim:/processor/rst 0 0 
#force -freeze sim:/processor/inPort 000F 55
#force -freeze sim:/processor/inPort 00C8 60
#force -freeze sim:/processor/inPort 001F 65
#force -freeze sim:/processor/inPort 00FC 70

