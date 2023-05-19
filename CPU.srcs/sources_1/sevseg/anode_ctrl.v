`timescale 1ns / 1ps
//  similar to : scanseg act_num & led always begin case (counter) diff in using encode/decoder
module anode_ctrl (
  input [3:0] clk_div,//10khz
  output reg[7:0] anode 
);
  always@(clk_div)
    begin
      case(clk_div)
        4'b0000: 
            anode = 8'b0000_0001; //most right digit ON -> ones
        4'b0001: 
            anode = 8'b0000_0010;
        4'b0010: 
            anode = 8'b0000_0100; 
        4'b0011: 
            anode = 8'b0000_1000; 
        4'b0100: 
            anode = 8'b0001_0000; 
        4'b0101: 
            anode = 8'b0010_0000; 
        4'b0110: 
            anode = 8'b0100_0000; 
        4'b0111: 
            anode = 8'b1000_0000; 
        4'b1000: begin//reset counter = 0;
            anode = 8'b0000_0000; 
        end
        endcase
    end
endmodule        
