restart
add_force {/tb_hitmap/clk} -radix hex {1 0ns} {0 10000ps} -repeat_every 20000ps
run 400ns
