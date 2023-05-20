`timescale 1ns / 1ps

module Decoder(
    Instruction, read_data, ALU_result, Jal, RegWrite, MemtoReg, RegDst, clock, reset, opcplus4, read_data_1, read_data_2, imme_extend,
    test_wire
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
    output reg test_wire;
    
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
        
    reg[31:0]   register[31:0];
    integer i;
        initial
        begin
            for(i=0;i<=31;i=i+1) begin
                register[i] <= 32'b0;
            end
        end
    reg[4:0]    write_register_address; 
    reg[31:0]   write_data;            
    wire    sign_bit;
    assign   sign_bit = immediate[15];
    wire    [15:0] sign_extend; 
    assign   sign_extend = (sign_bit == 1'b1)? 16'b1111_1111_1111_1111:16'b0000_0000_0000_0000;
        
        
            assign read_data_1 = register[rs];
            assign read_data_2 = register[rt];
            
            always @(*) begin
                    //  addi¡¢addiu¡¢lw
                    // andi¡¢ori
                    // andi¡¢ori 
                    if(opcode == 6'b001101 || opcode == 6'b001101) begin
                      imme_extend = {16'b0000_0000_0000_0000,immediate};
                    end
                    else begin
                      imme_extend = {sign_extend,immediate};
                    end
                end
            
            
                always @(*) begin
                    if(RegWrite == 1'b1) begin
                        // Jal 
                      test_wire =1;
                      if(Jal == 1'b1) begin
                        write_register_address = 5'b11111; // 32
                      end
 
                      else if(RegDst == 1'b1) begin
                        write_register_address = rd;
                      end

                      else if (RegDst == 1'b0) begin
                        write_register_address = rt;
                      end
                    end
                end
            

                always @(*) begin
                    if(RegWrite == 1'b1) begin
                      // Jal Ö¸Áî
                      if(Jal == 1'b1) begin
                        write_data = opcplus4;
                      end

                      else if(MemtoReg == 1'b0) begin
                        write_data = ALU_result;
                      end

                      else if(MemtoReg == 1'b1) begin
                        write_data = read_data;
                      end
                    end
                end
            
            
                integer j; 
                always @(negedge clock) begin
                    
                    if(reset) begin
                      for(j = 0; j < 32; j = j + 1) 
                      register[i] <= 32'b0;
                    end
                    else begin

                        if(RegWrite == 1'b1 && write_register_address!=0) begin
                          register[write_register_address] <= write_data;
                        end
                    end
                end
            
endmodule
