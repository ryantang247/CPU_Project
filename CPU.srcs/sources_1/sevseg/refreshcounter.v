`timescale 1ns / 1ps

module refreshcounter(
    input refresh_clock,
    output reg [3:0] refreshcounter =0
    );
    
    always@ (posedge refresh_clock)refreshcounter <= refreshcounter+1;
endmodule
