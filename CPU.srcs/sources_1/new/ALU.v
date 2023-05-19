`timescale 1ns / 1ps

//module ALU_src(
//input[31:0] Read_data_1, // from Decoder
//input[31:0] Read_data_2, // from Decoder
//input[31:0] Sign_extend, // from Decoder
//// from Controller, 1 means the Binput is an extended immediate, otherwise the Binput is Read_data_2
//input ALUSrc
//);

//wire Ainput;
//wire Binput;
//assign Ainput = Read_data_1;
//assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];

//endmodule

module executs32(
    input[31:0] Read_data_1, //the source of Ainput
    input[31:0] Read_data_2, //one of the sources of Binput
    input[31:0] Sign_extend, //one of the sources of Binput
    // from IFetch
    input[5:0] Function_opcode, //instruction[31:26]
    input[5:0] Exe_opcode, //instructions[5:0]
// from Controller
    input[1:0] ALUOp, //{ (R_format || I_format) , (Branch || nBranch) }
    input[4:0] Shamt, //instruction[10:6], the amount of shift bits
    input ALUSrc, // 1 means the 2nd operand is an immediate (except beq,bne?
    input I_format, // 1 means I-Type instruction except beq, bne, LW, SW
    //input R_format, 
    //Branch, nBranch,
    output reg Zero,
    input Sftmd, // 1 means this is a shift instruction
    output reg[31:0] ALU_Result, // the ALU calculation result
    output [31:0] Addr_Result,
    input[31:0] PC_plus_4, //pc+4
    input Jr
     // 1 means the ALU_result is zero, 0 otherwise
    );

wire[31:0] Ainput,Binput; // two operands for calculation
wire[5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
wire[2:0] ALU_ctl; // the control signals which affact operation in ALU directely
wire[2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
reg[31:0] Shift_Result; // the result of shift operation
reg[31:0] ALU_output_mux; // the result of arithmetic or logic calculation
reg[31:0] ALU_output_mux_2;
reg[31:0] ALU_output_mux_signed; //results of signed calculations
reg[31:0] Branch_Addr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]

reg tempZero;

//assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;
//assign ALUOp = { (R_format || I_format) , (Branch || nBranch) };

//000 {3 bits of function_opcode}
assign Exe_code = (I_format==0) ? Function_opcode :{ 3'b000 , Exe_opcode[2:0] };
assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];

assign Ainput = Read_data_1;
assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];
initial begin
  Branch_Addr = 32'b0;
  Zero = 0;
end
assign Addr_Result = Branch_Addr[31:0];
//assign Zero = (ALU_output_mux[31:0] == 32'h00000000) ? 1'b1 : 1'b0;
//assign Zero = (ALU_output_mux[31:0] == 32'h00000000) ? 1'b1 : 1'b0;

//default values:

always@ (ALU_ctl or Ainput or Binput)
begin
case(ALU_ctl)
    3'b000:ALU_output_mux = Ainput & Binput;
    3'b001:ALU_output_mux = Ainput | Binput;
    3'b010:
    begin
    ALU_output_mux = Ainput + Binput;
    end
    3'b011:ALU_output_mux = Ainput + Binput;
    3'b100:ALU_output_mux = Ainput ^ Binput;
    3'b101:
    begin //may contain shift inside
    if(Sftmd==0)
    begin
        ALU_output_mux = ~(Ainput | Binput); //nor
        if(I_format==1)
        ALU_output_mux[31:16] = Sign_extend[15:0]; //lui
    end
    end
    3'b110:
    begin
        if(ALUOp ==2'b10)
            begin
            if(I_format && Function_opcode[3]==1)
                assign Zero = (Ainput < Binput); //slti
            else
            begin
                Zero=0;
                ALU_output_mux = Ainput - Binput; //sub
            end
            end
        else 
            begin
        //beq and bne instructions 
            if(I_format && ALUOp ==2'b01)
                begin
                //if it's beq, since beq = 100 while bne is 101
                if(Exe_opcode[3:0]==4'b0100)
                begin
                    if(Read_data_1 == Read_data_2)
                    begin
                    Branch_Addr = Branch_Addr+ Sign_extend[31:0];
                    Zero =1;
                    end
                    else 
                    begin
                      Zero=0;
                    end
            end
        end
        else 
            begin
                if(Read_data_1 != Read_data_2)
                begin
                    assign Branch_Addr = PC_plus_4[31:0] +  Sign_extend[31:0];
                    assign Zero =1;
                end
                else
                begin
                    Zero=0;
                    assign Branch_Addr = PC_plus_4[31:0];
                end
            end
        end
    end
    3'b111:begin
    if(I_format)
    begin
        if(Function_opcode[3]==1)
            assign tempZero = (Ainput < Sign_extend); //sltiu
        else 
        begin
        if(Exe_code[3:0]==4'b1010)
              assign Zero = (Ainput < Binput); //sltu, using exe code to differentiate
        else 
              assign Zero = ($signed(Ainput) <$signed(Binput)); //slt
        end
    end 
    else
    begin
        Zero = 0;
        ALU_output_mux =  Ainput - Binput; //subu
    end
    end        
    default:
    begin
    assign Zero = 0;
    ALU_output_mux = 32'h00000000;
    end
endcase
end

always @* begin // six types of shift instructions
if(Sftmd)
case(Sftm[2:0])
    3'b000:Shift_Result = Binput << Shamt; //Sll rd,rt,shamt 00000
    3'b010:Shift_Result = Binput >> Shamt; //Srl rd,rt,shamt 00010
    3'b100:Shift_Result = Binput << Ainput; //Sllv rd,rt,rs 00100
    3'b110:Shift_Result = Binput >> Ainput; //Srlv rd,rt,rs 00110
    3'b011:Shift_Result = $signed(Binput) >>> Shamt; //Sra rd,rt,shamt 00011
    3'b111:Shift_Result = Binput >>> Ainput; //Srav rd,rt,rs 00111
    default:Shift_Result = Binput;
endcase
else
Shift_Result = Binput;
end

//outputs the ALU_result
always @* begin
  // set type operation (slt, slti, sltu, sltiu)
  if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1)) || ((ALU_ctl == 3'b110) && (Exe_code[3] == 1)))
    ALU_Result = (Ainput - Binput < 0) ? 1 : 0;
  // lui operation
  else if ((ALU_ctl == 3'b101) && (I_format == 1))
    ALU_Result[31:0] = ALU_output_mux; // lui result;
  // shift operation
  else if (Sftmd == 1)
    ALU_Result = Shift_Result;
  // other types of operation in ALU (arithmetic or logic calculation)
  else
    ALU_Result = ALU_output_mux[31:0];
end
endmodule
