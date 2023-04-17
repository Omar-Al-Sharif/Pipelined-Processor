add wave  \
sim:/pc/en \
sim:/pc/clk \
sim:/pc/rs \
sim:/pc/count \
sim:/pc/countTemp
force -freeze sim:/pc/en 1 0
force -freeze sim:/pc/rs 1 0
force -freeze sim:/pc/rs 0 10
force -freeze sim:/pc/rs 1 30000
force -freeze sim:/pc/clk 1 0, 0 {50 ps} -r 100
run 31000
force -freeze sim:/pc/en 0 0
force -freeze sim:/pc/rs 0 0
run 1000