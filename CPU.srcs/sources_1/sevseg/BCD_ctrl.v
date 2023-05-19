`timescale 1ns / 1ps
//  similar to : scanseg  segen always @(scan_cnt) //select tube...
module BCD_ctrl(
  input [3:0] Ones,//x
  input [3:0] Tens,//x0
  input [3:0] Hundreds,//x00
  input [3:0] Thousands,//x000
  input [3:0] TenThousands,//x0_000
  input [3:0] HundredThousands,//x00_000
  input [3:0] Millions, //x_000_000
  input [3:0] TenMillions, //x0_000_000 =x000_0000
  
  input [3:0] clk_div,
  output reg [3:0] a_digit
);
  always@(clk_div)
    begin
      case(clk_div)
        4'd0:
          a_digit = Ones; //digit 1 ON (right)
        4'd1:
          a_digit = Tens;
        4'd2:
          a_digit = Hundreds;
        4'd3:
          a_digit = Thousands;
        4'd4:
          a_digit = TenThousands;
        4'd5:
          a_digit = HundredThousands;
        4'd6:
          a_digit = Millions;
        4'd7:
          a_digit = TenMillions; // digit 4 ON (left)  
      endcase
    end
endmodule
  
