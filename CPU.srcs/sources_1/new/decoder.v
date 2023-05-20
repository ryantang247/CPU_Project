module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
input[31:0]  Instruction;               // The instruction fetched 
input[31:0]  mem_data;   				// DATA taken from the DATA RAM or I/O port for writing data to a specified register
input[31:0]  ALU_result;   				// The result of an operation from the Arithmetic logic unit ALU used to write data to a specified register
input        Jal;                       // From the control unit Controller, when the value is 1, it indicates that it is a JAL instruction
input        RegWrite;                  // From the control unit Controller, when the value is 1, do register write; When the value is 0, no write is performed
input        MemtoReg;                  // From the control unit Controller, indicating that DATA is written to a register after it is removed from the DATA RAM
input        RegDst;             //Control write to which specified register in instructions. when RegDst is 1, write to the target register, such as R type Rd; Is 0, writes the second register, such as I type is Rt
input		 clock;                     //Clock signal
input 		 reset;                     //Reset signal, active high level and clear all registers. Writing is not allowed here.
input[31:0]  opcplus4;                 // The JAL instruction is used to write the return address to the $ra register, what we have got here is PC + 4

output[31:0] read_data_1;
output[31:0] read_data_2;
output[31:0] Sign_extend;
// mem_data = read_data

// all the register
reg [31:0] Regs[0:31];
reg [4:0] WriteReg;
reg [31:0] WriteRegData;
//rs and rt
wire[4:0] ReadReg_1;
wire[4:0] ReadReg_2;
wire[4:0] R_WriteReg;
wire[4:0] I_WriteReg;
wire[5:0] Opcode;
integer j;
initial
    begin
        for(j=0;j<=31;j=j+1) begin
            Regs[j] <= 32'b0;
        end
    end

assign ReadReg_1 = Instruction[25:21];
assign ReadReg_2 = Instruction[20:16];
assign R_WriteReg = Instruction[15:11];
assign I_WriteReg = Instruction[20:16];
assign Opcode = Instruction[31:26];

//except addiu and sltiu.
assign Sign_extend = (Opcode == 6'b001011 || Opcode == 6'b001100 || Opcode == 6'b001101 || Opcode == 6'b001110)? {16'h0000, Instruction[15:0]}:
{{16{Instruction[15]}}, Instruction[15:0]};
assign read_data_1 = Regs[ReadReg_1];
assign read_data_2 = Regs[ReadReg_2];

always @* begin
        if (RegWrite == 1'b1) begin 
            if (Opcode == 6'b000000 && RegDst == 1'b1) begin
                WriteReg = R_WriteReg;
            end
            else if (Opcode == 6'b000011 && Jal == 1'b1) begin
                WriteReg = 5'b11111;
            end
            else begin
                WriteReg = I_WriteReg;
            end
        end
    end

//write into registers.
    integer i = 0;
    always @(posedge clock) begin
        if(reset == 1'b1) begin
            for(i = 0; i < 32; i = i + 1)
                Regs[i] <= 32'h0000_0000;
        end
        else begin
            if (RegWrite == 1'b1 && WriteReg != 1'b0) begin
                    Regs[WriteReg] <= WriteRegData;
            end
        end
    end

// what to write
//write what?
    always @* begin
        if (MemtoReg == 1'b1) WriteRegData <= mem_data;
        else if (Opcode == 6'b000011 && Jal == 1'b1) WriteRegData <= opcplus4;
        else WriteRegData <= ALU_result;
    end
    
endmodule