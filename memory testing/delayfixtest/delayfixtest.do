add wave  \
sim:/memory/clk \
sim:/memory/memWrite \
sim:/memory/memRead \
sim:/memory/address \
sim:/memory/value \
sim:/memory/dataout \
sim:/memory/ram \

mem load -i {C:\Users\ziadamr\Desktop\comparch\testing vhdl/memory.mem} /memory/ram
force -freeze sim:/memory/clk 1 0, 0 {50 ps} -r 100


force -freeze sim:/memory/memWrite 0 0
force -freeze sim:/memory/memRead 1 0
force -freeze sim:/memory/address 1 0
force -freeze sim:/memory/value 00a1 0

force -freeze sim:/memory/memWrite 1 100
force -freeze sim:/memory/memRead 0 100
force -freeze sim:/memory/address 2 100
force -freeze sim:/memory/value 00b1 100


force -freeze sim:/memory/memWrite 0 200
force -freeze sim:/memory/memRead 1 200
force -freeze sim:/memory/address 2 200
force -freeze sim:/memory/value 00a1 200

force -freeze sim:/memory/memWrite 0 300
force -freeze sim:/memory/memRead 1 300
force -freeze sim:/memory/address 2 300
force -freeze sim:/memory/value 00c1 300

force -freeze sim:/memory/memWrite 1 400
force -freeze sim:/memory/memRead 0 400
force -freeze sim:/memory/address 5 400
force -freeze sim:/memory/value 00a1 400

force -freeze sim:/memory/memWrite 0 500
force -freeze sim:/memory/memRead 1 500
force -freeze sim:/memory/address 5 500
force -freeze sim:/memory/value 00c1 500

force -freeze sim:/memory/memWrite 0 600
force -freeze sim:/memory/memRead 0 600
force -freeze sim:/memory/address 5 600
force -freeze sim:/memory/value 00ff 600

force -freeze sim:/memory/memWrite 1 700
force -freeze sim:/memory/memRead 1 700
force -freeze sim:/memory/address 5 700
force -freeze sim:/memory/value 008f 700

run 800