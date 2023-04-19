mem load -i D:/arch/proj/instructions.mem /instructioncache/fx/ram
add wave  \
sim:/instructioncache/n \
sim:/instructioncache/clk \
sim:/instructioncache/rst \
sim:/instructioncache/write_en \
sim:/instructioncache/read1_addres \
sim:/instructioncache/write_adress \
sim:/instructioncache/source1 \
sim:/instructioncache/destination
force -freeze sim:/instructioncache/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/instructioncache/rst 0 0
force -freeze sim:/instructioncache/write_en 0 0
noforce sim:/instructioncache/read1_addres
force -freeze sim:/instructioncache/read1_addres 1 0
run 200