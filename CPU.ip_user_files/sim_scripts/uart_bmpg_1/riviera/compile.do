vlib work
vlib riviera

vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -v2k5 \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/uart_bmpg.v" \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/upg.v" \
"../../../../CPU.srcs/sources_1/ip/uart_bmpg_1/sim/uart_bmpg_1.v" \


vlog -work xil_defaultlib \
"glbl.v"

