`timescale 1ns / 1ps

module refreshcounter(
    input refresh_clock,
    output reg [3:0] refreshcounter
    );
    
    always@ (posedge refresh_clock)refreshcounter <= refreshcounter+1;
endmodule
