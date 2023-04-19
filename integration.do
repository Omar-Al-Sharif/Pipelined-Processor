vsim -gui work.processor

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
force -freeze sim:/processor/rst 1 0
run
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/clk 1 0, 0 {2 ps} -r 5