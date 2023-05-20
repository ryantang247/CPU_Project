`timescale 1ns / 1ps

module seven_seg_controller(
    input wire refresh_clk,
    input wire [3:0] Ones,
    input wire [3:0] Tens,
    input wire [3:0] Hundreds,
    input wire [3:0] Thousands,
    input wire [3:0] TenThousands,
    input wire [3:0] HundredThousands,
    input wire [3:0] Millions,
    input wire [3:0] TenMillions,
    output wire [7:0] anode,
    output wire [7:0] cathode,
    output wire [7:0] cathode2
    );
    
//wire [3:0] refreshcounter;
wire [3:0] a_digit;

//refreshcounter Refreshcounter_wrapper (
//    .refresh_clock(refresh_clk),
//    .refreshcounter(refreshcounter)
//);

 //anode_ctrl anodeCtr(refreshcounter, anode);
    
    BCD_ctrl bcdCTR(
    .Ones(Ones), .Tens(Tens),
    .Hundreds(Hundreds), .Thousands(Thousands),
    .TenThousands(TenThousands), .HundredThousands(HundredThousands),
    .Millions(Millions), .TenMillions(TenMillions),.clk_div(refreshcounter), .a_digit(a_digit));
    
    BCD_to_Cathodes BCD_cathodes(
    .digit(a_digit), .cathode(cathode));
    
    BCD_to_Cathodes BCD_cathodes2(
        .digit(a_digit), .cathode(cathode2));
endmodule
