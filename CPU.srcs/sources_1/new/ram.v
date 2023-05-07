`timescale 1ns / 1ps

module dmemory32(
input wire clk,
input wire [0 : 0] wea,
input wire [31 : 0] addra,
input wire [31 : 0] din,
 output wire [31 : 0] douta
);

//should we 'not' the clock for RAM?
RAM ram (
.clka(clk), // input wire clka
.wea(wea), // input wire [0 : 0] wea
.addra(addra[13:0]), // input wire [13 : 0] addra
.dina(din), // input wire [31 : 0] dina
.douta(douta) // output wire [31 : 0] douta
);

endmodule

