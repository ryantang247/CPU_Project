`timescale 1ns / 1ps

module dmemory32(
input wire clk,
input wire [0 : 0] wea, //controller
input wire [31 : 0] addra,
input wire [31 : 0] din,
 output wire [31 : 0] douta,
 
 input upg_rst_i, // UPG reset (Active High)
 input upg_clk_i, // UPG ram_clk_i (10MHz)
 input upg_wen_i, // UPG write enable
 input [13:0] upg_adr_i, // UPG write address
 input [31:0] upg_dat_i, // UPG write data
 input upg_done_i
);

wire ram_clk = !clk;
wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

//should we 'not' the clock for RAM?
RAM ram (
.clka(kickOff? clk: upg_clk_i), // input wire clka
.wea(kickOff? wea: upg_wen_i), // input wire [0 : 0] wea
.addra(kickOff? addra[13:0]:upg_adr_i), // input wire [13 : 0] addra
.dina(kickOff? din: upg_dat_i), // input wire [31 : 0] dina
.douta(douta) // output wire [31 : 0] douta
);

endmodule

