module control32_tb();

reg [5:0] Opcode, Function_opcode; //reg type variables are use for binding with input ports
wire [1:0] ALUOp; //wire type variables are use for binding with output ports
wire Jr, RegDST, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, nBranch, Jmp, Jal, I_format, Sftmd;
//instance the module "control32", bind the ports
control32 c32
(Opcode,Function_opcode,
Jr,Branch,nBranch,Jmp,Jal,
RegDST,MemtoReg,RegWrite,MemWrite,
ALUSrc,ALUOp,Sftmd,I_format);
initial begin
//an example: #0 add $3,$1,$2. get the machine code of 'add $3,$1,$2'
// step1: edit the assembly code, add "add $3,$1,$2"
// step2: open the assembly code in Minisys1Assembler2.2, do the assembly procession
// step3: open the "output/prgmips32.coe" file, find the related machine code of 'add $3,$1,$2'
//in "0x00221820", 'Opcode' is 6'h00,'Function_opcode' is 6'h20
Opcode = 6'h23;
Function_opcode = 6'h08;
#200; //...
end
endmodule
