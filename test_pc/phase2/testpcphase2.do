add wave  \
sim:/pc/en \
sim:/pc/clk \
sim:/pc/rs \
sim:/pc/count \
sim:/pc/countTemp \
sim:/pc/branch \
sim:/pc/branchaddress

force -freeze sim:/pc/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pc/branch 0 0
force -freeze sim:/pc/en 1 0
force -freeze sim:/pc/rs 1 0
force -freeze sim:/pc/rs 0 10
force -freeze sim:/pc/rs 1 30000


force -freeze sim:/pc/branch 1 1000
force -freeze sim:/pc/branchaddress b1 0
force -freeze sim:/pc/branch 0 1200

run 1000