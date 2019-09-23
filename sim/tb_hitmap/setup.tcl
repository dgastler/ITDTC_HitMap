create_wave_config

add_wave -regexp /tb_hitmap/.*

add_wave -regexp /tb_hitmap/HitMapDecoder_1/.*

source tb_hitmap/run.tcl
