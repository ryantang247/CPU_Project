`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/02 20:34:23
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    Instruction, read_data, ALU_result, Jal, RegWrite, MemtoReg, RegDst, clock, reset, opcplus4, read_data_1, read_data_2, imme_extend
    );
    input [31:0]  Instruction;     
    input [31:0]  read_data;       
    input [31:0]  ALU_result;      
    input         Jal;            
    input         RegWrite;        
    input         MemtoReg;        
    input         RegDst;          
    input         clock,reset;     
    input [31:0]  opcplus4;        
    
    output [31:0] read_data_1;    
    output [31:0] read_data_2;    
    output reg[31:0] imme_extend;    
    
        wire [5:0]  opcode;
        wire [4:0]  rs;
        wire [4:0]  rt;
        wire [4:0]  rd;
        wire [4:0]  shamt;
        wire [5:0]  funct;
        wire [15:0] immediate;
        wire [25:0] address;
        assign opcode       = Instruction[31:26];
        assign rs           = Instruction[25:21];
        assign rt           = Instruction[20:16];
        assign rd           = Instruction[15:11];
        assign shamt        = Instruction[10:6];
        assign funct        = Instruction[5:0];
        assign immediate    = Instruction[15:0];
        assign address      = Instruction[25:0];
        
        reg[31:0]   register[0:31];
            
        

            reg[4:0]    write_register_address; 
            reg[31:0]   write_data;            
        
        
            
            wire    sign_bit; 
            assign   sign_bit = immediate[15];
            wire    [15:0] sign_extend; 
            assign   sign_extend = (sign_bit == 1'b1)? 16'b1111_1111_1111_1111:16'b0000_0000_0000_0000;
        
        
            assign read_data_1 = register[rs];
            assign read_data_2 = register[rt];
            
            always @(posedge clock) begin
                    //  addi¡¢addiu¡¢lw
                    // andi¡¢ori
                    // andi¡¢ori 
                    if(opcode == 6'b001101 || opcode == 6'b001101) begin
                      imme_extend <= {16'b0000_0000_0000_0000,immediate};
                    end
                    else begin
                      imme_extend <= {sign_extend,immediate};
                    end
                end
            
            
                always @(posedge clock) begin
                    if(RegWrite == 1'b1) begin
                        // Jal 
                      if(Jal == 1'b1) begin
                        write_register_address <= 5'b11111; // 32
                      end
 
                      else if(RegDst == 1'b1) begin
                        write_register_address <= rd;
                      end

                      else if (RegDst == 1'b0) begin
                        write_register_address <= rt;
                      end
                    end
                end
            

                always @(posedge clock) begin
                    if(RegWrite == 1'b1) begin
                      // Jal Ö¸Áî
                      if(Jal == 1'b1) begin
                        write_data <= opcplus4;
                      end

                      else if(MemtoReg == 1'b0) begin
                        write_data <= ALU_result;
                      end

                      else if(MemtoReg == 1'b1) begin
                        write_data <= read_data;
                      end
                    end
                end
            
            
                integer i; 
                always @(negedge clock) begin
                    
                    if(reset == 1'b1) begin
                      for(i = 0; i < 32; i = i + 1) register[i] <= 0;
                    end
                    else begin

                        if(RegWrite == 1'b1) begin
                          register[write_register_address] <= write_data;
                        end
                    end
                end
    
endmodule
