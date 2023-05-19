`timescale 1ns / 1ps

module top_segment(//input rst_n,//reset: low effective
    input clk,//system clock 100MHZ 
    input rst,
    input [31:0] num,
    output wire [7:0] anode, // selection on tube 0-7
    output wire [7:0] cathode,
    output wire [7:0] cathode2

    );
    //wire [3:0] counter;
    wire clk_div;
    wire clk_cnt;
    //input outputs of seven_segment
    wire [15:0] sixteenbit_cntval;
    
    wire [3:0] Ones;//x
    wire [3:0] Tens;//x0
    wire [3:0] Hundreds;//x00
    wire [3:0] Thousands;//x000
    wire [3:0] TenThousands;//x0_000
    wire [3:0] HundredThousands;//x00_000
    wire [3:0] Millions; //x_000_000
    wire [3:0] TenMillions; //x0_000_000 =x000_0000
   
    //clockdivider 
    clock_divider #(4999) clkdiv_generator (clk, clk_div); //10kHz clock signal
    //refreshclock 
    clock_divider #(4999999) clkcnt_generator (clk, clk_cnt); //10Hz clock signal
    
    //manually define a new input to sixteeen bit
    binary_BCD converter(clk, num, Ones, Tens, Hundreds,
    Thousands, TenThousands, HundredThousands, Millions, TenMillions);
    
    seven_seg_controller seven_seg(.refresh_clk(clk_div),.Ones(Ones),.Tens(Tens),
    .Hundreds(Hundreds),.Thousands(Thousands),.TenThousands(TenThousands),.HundredThousands(HundredThousands),.Millions(Millions),.TenMillions(TenMillions),
    .anode(anode),.cathode(cathode), .cathode2(cathode2));  
endmodule

