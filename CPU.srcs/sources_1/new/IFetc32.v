`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 01:50:30 PM
// Design Name: 
// Module Name: IFetc32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module IFetc32(
    // Outputs
    output [31:0] Instruction,      // Instruction fetched from this module to Decoder and Controller
    output [31:0] branch_base_addr, // (PC+4) to ALU which is used by branch type instruction
    output [31:0] link_addr,        // (PC+4) to Decoder which is used by jal instruction

    // Inputs
    input clock, reset,             // Clock and reset
    input [31:0] Addr_result,       // Calculated address from ALU
    input Zero,                     // While Zero is 1, it means the ALUresult is zero
    input [31:0] Read_data_1,       // Address of instruction used by jr instruction
    input Branch,                   // While Branch is 1, it means current instruction is beq
    input nBranch,                  // While nBranch is 1, it means current instruction is bnq
    input Jmp,                      // While Jmp is 1, it means current instruction is jump
    input Jal,                      // While Jal is 1, it means current instruction is jal
    input Jr,                       // While Jr is 1, it means current instruction is jr
    output reg [31:0] PC, Next_PC   // Outputs
);
    prgrominstmem(
    .clka(clock),
    .addra(PC[15:2]),
    .douta(Instruction)
    );
always @* begin
        if(((Branch == 1) && (Zero == 1 )) || ((nBranch == 1) && (Zero == 0))) // beq, bne
            Next_PC = Addr_result; // the calculated new value for PC
        else if(Jr == 1)
            Next_PC = Read_data_1; // the value of $31 register
        else
            Next_PC = PC+4; // PC+4
    end
    always @(negedge clock) begin
        if(reset == 1)
            PC <= 32'h0000_0000;
        else if((Jmp == 1) || (Jal == 1))
            PC <= {PC[31:28],Instruction[27:0]<<2};
        else 
            PC <= Next_PC;
    end
    
endmodule
