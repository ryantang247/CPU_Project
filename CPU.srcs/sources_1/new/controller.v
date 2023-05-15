`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/02 19:58:41
// Design Name: 
// Module Name: Controller
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


module Controller(
    input [5:0]Opcode,      // instruction[31:26]
    input [5:0]Function_opcode,     // r-type instruction[5:0]
    input [21:0] Alu_resultHigh,
    output Jr,      // 1 means jr
    output Jmp,     // 1 means j
    output Jal,     // 1 means jal
    output Branch,      // 1 means beq 
    output nBranch,     // 1 means bne
    output RegDST,      // 1 means the destination register is rd, 0 means the destination register is rt
    output MemtoReg,        // 1 means need to load data from memory to register
    output RegWrite,        // 1 means need to write register
    output MemWrite,        // 1 means need to write memory
    output ALUSrc,      // 1 means the second operation number is immediate number
    output I_format,        // 1 means the instruction is I_type(except for beq, bne, lw and sw)
    output Sftmd,       // 1 means the instruction is shift cmd
    output [1:0] ALUOp,
    
    //new output for the MemtoIO
    output MemorIOtoReg, //1 indicates that read date from memory or I/O to write to the register
    output MemRead, // 1 indicates that reading from the memory to get data
    output IORead, // 1 indicates I/O read
    output IOWrite // 1 indicates I/O write
    );
    
    wire R_format,Lw,sw;

    assign Lw=((Opcode==6'h23) && (Function_opcode==6'h08)) ? 1'b1 : 1'b0;
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;

    assign Jr =((Function_opcode==6'b001000)&&(Opcode==6'b000000)) ? 1'b1 : 1'b0;
    assign Jmp = (Opcode==6'h02 && Function_opcode==6'h08)? 1'b1:1'b0;
    assign Jal = (Opcode==6'h03 && Function_opcode==6'h08)? 1'b1:1'b0;
    assign Branch = (Opcode==6'h04 && Function_opcode==6'h08)? 1'b1:1'b0;
    assign nBranch = (Opcode==6'h05 && Function_opcode==6'h08)? 1'b1:1'b0;

    assign RegDST = R_format;
    assign MemtoReg = (Opcode==6'h23 && Function_opcode==6'h08)? 1'b1:1'b0;
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
    assign MemWrite = (Opcode==6'h2b && Function_opcode==6'h08)? 1'b1:1'b0;
    
    //added sw for MemorIO, maybe subjected to change
    assign ALUSrc = (I_format || Lw || sw || MemWrite) ? 1'b1 : 1'b0;
    assign I_format = (Opcode[5:3]==3'b001)?1'b1:1'b0;
    
    assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))&& R_format)? 1'b1:1'b0;
    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};
    
    //new assignment for MemorIO
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr) ; // Write memory or write IO
    
    assign sw = (Opcode == 6'b101011)?1'b1:1'b0;
    
    //may need to change MemWrite for MemorIO
    assign MemWrite = ((sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
    assign MemRead = (Lw  == 1'b1&& (Alu_resultHigh[21:0] != 22'b1111111111111111111111))?1'b1:1'b0; // Read memory
    assign IORead = (Lw  == 1'b1&& (Alu_resultHigh[21:0] == 22'b1111111111111111111111))?1'b1:1'b0; // Read input port
    assign IOWrite = (sw == 1'b1&& (Alu_resultHigh[21:0] == 22'b1111111111111111111111))?1'b1:1'b0; // Write output port
    // Read operations require reading data from memory or I/O to write to the register
    assign MemorIOtoReg = IORead || MemRead;
    
endmodule
