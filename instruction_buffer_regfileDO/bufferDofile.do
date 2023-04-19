add wave  \
sim:/buff/n \
sim:/buff/enable \
sim:/buff/clk \
sim:/buff/rst \
sim:/buff/d \
sim:/buff/q
force -freeze sim:/buff/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/buff/enable 1 0
force -freeze sim:/buff/rst 0 0
force -freeze sim:/buff/d 050f 0
run 100
run 1000
force -freeze sim:/buff/d 0255 0
run 100
run 100
run 100
run 100


