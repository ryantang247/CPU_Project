`timescale 1ns / 1ps

module control32(
    input[5:0] Opcode, Function_opcode,
    output Jr,R_format,Branch,nBranch,Jmp,Jal,RegDST,MemtoReg,RegWrite,MemWrite,ALUSrc,
    output[1:0] ALUOp,
    output Sftmd,I_format
    );
    
wire Lw;
wire Sw;

assign I_format = (Opcode[5:3]==3'b001) ? 1'b1 : 1'b0;

assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;

assign Jr =(R_format &&(Function_opcode==6'b001000)) ? 1'b1 : 1'b0;

assign Branch = (Opcode==6'b000100) ? 1'b1 : 1'b0;

assign nBranch = (Opcode==6'b000101) ? 1'b1 : 1'b0;

assign Jmp =((Opcode==6'b000010)) ? 1'b1 : 1'b0; 

assign Jal =((Opcode==6'b000011)) ? 1'b1 : 1'b0; 

assign Lw = ((Opcode==6'b100011)) ? 1'b1 : 1'b0; 

assign Sw = ((Opcode==6'b101011)) ? 1'b1 : 1'b0; 

assign RegDST = R_format;

assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);

assign MemWrite = Sw; //only store word changes the value of memory?

assign MemtoReg = Lw; //from the datapath, if the data comes from memory, then the data comes not from ALU but from memory 

assign ALUSrc = !(R_format) || I_format;

assign ALUOp = { (R_format || I_format) , (Branch || nBranch) };

assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)
||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)
||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))
&& R_format) ? 1'b1 : 1'b0;


endmodule
