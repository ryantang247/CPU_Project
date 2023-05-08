vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/uart_bmpg.v" \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/upg.v" \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/sim/uart_bmpg_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

