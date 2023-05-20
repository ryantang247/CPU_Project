`timescale 1ns / 1ps

module dmemory32(
input wire clock,
input  memWrite, //controller
input wire [31 : 0] address,
input wire [31 : 0] writeData,
 output wire [31 : 0] readData
 
// input upg_rst_i, // UPG reset (Active High)
// input upg_clk_i, // UPG ram_clk_i (10MHz)
// input upg_wen_i, // UPG write enable
// input [13:0] upg_adr_i, // UPG write address
// input [31:0] upg_dat_i, // UPG write data
// input upg_done_i
);

wire ram_clk = !clock;
//wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

//should we 'not' the clock for RAM?
//RAM ram (
//.clka(kickOff? ram_clk: upg_clk_i), // input wire clka
//.wea(kickOff? memWrite: upg_wen_i), // input wire [0 : 0] wea
//.addra(kickOff? address[15:2]:upg_adr_i), // input wire [13 : 0] addra
//.dina(kickOff? writeData: upg_dat_i), // input wire [31 : 0] dina
//.douta(readData) // output wire [31 : 0] douta
//);
RAM ram (
.clka(ram_clk), // input wire clka
.wea(memWrite), // input wire [0 : 0] wea
.addra(address[15:2]), // input wire [13 : 0] addra
.dina(writeData), // input wire [31 : 0] dina
.douta(readData) // output wire [31 : 0] douta
);

endmodule

