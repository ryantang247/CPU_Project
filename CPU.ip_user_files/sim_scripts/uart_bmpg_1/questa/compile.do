vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/uart_bmpg.v" \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/upg.v" \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/sim/uart_bmpg_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

