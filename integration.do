vsim -gui work.processor
mem load -i {D:/Omar's Files/CUFE/Spring 23/Computer Architecture/Project/Project/instructions.mem} /processor/IF_Stage/cache/fx/ram
mem load -i {D:/Omar's Files/CUFE/Spring 23/Computer Architecture/Project/Project/memory.mem} /processor/Mem_Stage/mem/ram
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/fetchedInstruction
add wave -position end  sim:/processor/ifIdBufferOutput
add wave -position end  sim:/processor/writeBackEnable
add wave -position end  sim:/processor/writeBackData
add wave -position end  sim:/processor/memWrite
add wave -position end  sim:/processor/memRead
add wave -position end  sim:/processor/wbEnable
add wave -position end  sim:/processor/aluEnable
add wave -position end  sim:/processor/src1
add wave -position end  sim:/processor/src2
add wave -position end  sim:/processor/aluOp
add wave -position end  sim:/processor/IF_Stage/clk
add wave -position end  sim:/processor/IF_Stage/rst
add wave -position end  sim:/processor/IF_Stage/instruction
add wave -position end  sim:/processor/IF_Stage/counter
add wave -position end  sim:/processor/inPort
force -freeze sim:/processor/inPort 0000000000000011 0
force -freeze sim:/processor/clk 1 0, 0 {2 ps} -r 5
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/writeBackEnable 1 0
run
force -freeze sim:/processor/writeBackEnable 0 0
force -freeze sim:/processor/rst 0 0
run