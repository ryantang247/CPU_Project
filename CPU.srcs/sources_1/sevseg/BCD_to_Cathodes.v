`timescale 1ns / 1ps
//light_7seg_ego1.v but diff in cathode output
module BCD_to_Cathodes (
  input [3:0] digit,
  output reg [7:0] cathode
  );
  always @ (digit)
    begin 
      case(digit)
        4'd0:
          cathode = 8'b1111_1100; //0
        4'd1:
          cathode = 8'b0110_0000; //1
        4'd2:
          cathode = 8'b1101_1010; //2
        4'd3:
          cathode = 8'b1111_0010; //3
        4'd4:
          cathode = 8'b0110_0110; //4
        4'd5:
          cathode = 8'b1011_0110; //5
        4'd6:
          cathode = 8'b1011_1110; //6
        4'd7:
          cathode = 8'b1110_0000; //7
        4'd8:
          cathode = 8'b1111_1110; //8
        4'd9:
          cathode = 8'b1110_0110; //9
        4'd10:
          cathode = 8'b1110_1110; //A  
        4'd11:
          cathode = 8'b0011_1110;
       4'd12:
           cathode = 8'b1001_1100;  
        4'd13:
            cathode = 8'b0111_1010;
        4'd14:
            cathode = 8'b1001_1110;
        4'd15:
            cathode = 8'b1000_1110;                          
        default:
          cathode = 8'b1111_1100; //0          
      endcase
    end
endmodule
