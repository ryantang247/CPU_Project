module executs32(
    input[31:0] Read_data_1, //the source of Ainput
    input[31:0] Read_data_2, //one of the sources of Binput
    input[31:0] Sign_extend, //one of the sources of Binput
    // from IFetch
    input[5:0] Function_opcode, //instruction[5:0]
    input[5:0] Exe_opcode, //instructions[31:0]
// from Controller
    input[1:0] ALUOp, //{ (R_format || I_format) , (Branch || nBranch) }
    input[4:0] Shamt, //instruction[10:6], the amount of shift bits
    input ALUSrc, // 1 means the 2nd operand is an immediate (except beq,bne?
    input I_format, // 1 means I-Type instruction except beq, bne, LW, SW
    //input R_format, 
    //Branch, nBranch,
    output Zero,
    input Sftmd, // 1 means this is a shift instruction
    output reg[31:0] ALU_Result, // the ALU calculation result
    output [31:0] Addr_Result,
    input[31:0] PC_plus_4, //pc+4
    input Jr
     // 1 means the ALU_result is zero, 0 otherwise
    );		       

    wire[31:0] Ainput,Binput; 
    wire[5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    wire[2:0] ALU_ctl; // the control signals which affact operation in ALU directely
    wire[2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg[31:0] Shift_Result; // the result of shift operation
    reg[31:0] AlU_output_mux; // the result of arithmetic or logic calculation

    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];

    assign Exe_code = (I_format == 0) ? Function_opcode : { 3'b000 , Exe_opcode[2:0] };
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    assign Zero = (AlU_output_mux == 32'b0)? 1 : 0;
    assign Addr_Result = PC_plus_4 + (Sign_extend << 2);

    always @(ALU_ctl or Ainput or Binput) begin
        case (ALU_ctl)
            3'b000:AlU_output_mux = Ainput & Binput;//and andi
            3'b001:AlU_output_mux = Ainput | Binput;//or ori
            3'b010:AlU_output_mux = $signed(Ainput) + $signed(Binput);//add addi lw sw
            3'b011:AlU_output_mux = Ainput + Binput;//addu addiu
            3'b100:AlU_output_mux = Ainput ^ Binput;//xor xori
            3'b101:AlU_output_mux = ~(Ainput | Binput);//nor lui
            3'b110:AlU_output_mux = $signed(Ainput) - $signed(Binput);//sub slti beq bne
            3'b111:AlU_output_mux = Ainput - Binput;//subu sltiu slt sltu
            default: AlU_output_mux = 32'h0000_0000;
        endcase
    end

    assign Sftm = Function_opcode[2:0]; //the code of shift operations 
    always @* begin // six types of shift instructions 
        if(Sftmd) begin
            case(Sftm[2:0]) 
                3'b000:Shift_Result = Binput << Shamt;        //Sll rd,rt,shamt 00000 
                3'b010:Shift_Result = Binput >> Shamt;        //Srl rd,rt,shamt 00010 
                3'b100:Shift_Result = Binput << Ainput;       //Sllv rd,rt,rs 00010 
                3'b110:Shift_Result = Binput >> Ainput;       //Srlv rd,rt,rs 00110 
                3'b011:Shift_Result = $signed(Binput) >>> Shamt;//Sra rd,rt,shamt 00011 
                3'b111:Shift_Result = $signed(Binput) >>> Ainput;//Srav rd,rt,rs 00111 
                default:Shift_Result = Binput; 
            endcase 
        end
        else begin 
            Shift_Result = Binput;
        end
    end

    always @* begin 
        if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1)) ||((ALU_ctl == 3'b110) && (Exe_opcode == 6'b001010))|| ((ALU_ctl == 3'b111) && (Exe_opcode == 6'b001011))) begin
            ALU_Result = (AlU_output_mux[31] == 1)? 1 : 0; //set type operation (slt, slti, sltu, sltiu)
        end
        else if((ALU_ctl == 3'b101) && (I_format == 1)) begin
            ALU_Result = {Binput[15:0],16'b0};  //lui operation 
        end
        else if(Sftmd == 1) begin
            ALU_Result = Shift_Result; //shift operation
        end
        else begin
            ALU_Result = AlU_output_mux;//other types of operation in ALU (arithmatic or logic calculation)
        end
    end

endmodule
