`timescale 1ns / 1ps

module CPU_TOP(
    input fpga_rst,
    input fpga_clk,
//    input[23:0] switch2N4,
//    output[23:0] led2N4,
    output [7:0] seg_out0, seg_out1,
    output [7:0] seg_en,
    // UART Programmer Pinouts
    // start Uart communicate at high level
    input start_pg
//    input rx,
//    output tx  
    );

// UART Programmer Pinouts
wire upg_clk, upg_clk_o;
wire upg_wen_o; //Uart write out enable
wire upg_done_o; //Uart rx data have done
//data to which memory unit of program_rom/dmemory32
wire [14:0] upg_adr_o;
//data to program_rom or dmemory32
wire [31:0] upg_dat_o;
wire MemtoReg;
wire spg_bufg;
BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
// Generate UART Programmer reset signal
reg upg_rst;
always @ (posedge fpga_clk) begin
if (spg_bufg) upg_rst = 0;
if (fpga_rst) upg_rst = 1;
end
//used for other modules which don't relate to UART
wire rst;
assign rst = fpga_rst | !upg_rst;

//important data
wire Zero,Branch,nBranch, Jmp,Jal,Jr; 

wire cpu_clk, uart_clk;
wire [31:0] Instruction; // Instruction fetched from this module to Decoder and Controller
wire [31:0]Addr_result;
wire [31:0] branch_base_addr;// (PC+4) to ALU which is used by branch type instruction
wire [31:0] link_addr; // (PC+4) to Decoder which is used by jal instruction
wire [31:0] Read_data_1;
wire [31:0]  read_data;  
wire [31:0] PC, Next_PC;
wire [31:0]  ALU_result; 
wire  RegWrite;
    wire         RegDst;          
wire         clock,reset;     
wire [31:0]  opcplus4;        

wire [31:0] read_data_1;    
wire [31:0] read_data_2;    
wire[31:0] imme_extend;    

cpuclk cpuclk(
    .clk_in1(fpga_clk),
    .clk_out1(cpu_clk),
    .clk_out2(uart_clk)
);


IFetc32 insMem(
    // Outputs
    .Instruction(Instruction),      
    .branch_base_addr(branch_base_addr), 
    .link_addr(link_addr),        
    // Inputs
    .clock(cpu_clk), .reset(fpga_rst),             // Clock and reset
    .Addr_result(Addr_result),       // Calculated address from ALU
    .Zero(Zero),                     // While Zero is 1, it means the ALUresult is zero
    .Read_data_1(Read_data_1),       // Address of instruction used by jr instruction
    .Branch(Branch),                   // While Branch is 1, it means current instruction is beq
    .nBranch(nBranch),                  // While nBranch is 1, it means current instruction is bnq
    .Jmp(Jmp),                      // While Jmp is 1, it means current instruction is jump
    .Jal(Jal),                      // While Jal is 1, it means current instruction is jal
    .Jr(Jr),                       // While Jr is 1, it means current instruction is jr
    .PC(PC),
    .Next_PC(Next_PC)   // Outputs
);

//dmemory32 datamem(
//    .clk(cpu_clk),
//    .wea(), //controller
//    .addra(),
//    .din(),
//    .douta(),
//    .upg_rst_i(), // UPG reset (Active High)
//    .upg_clk_i(), // UPG ram_clk_i (10MHz)
//   .upg_wen_i(), // UPG write enable
//    .upg_adr_i(), // UPG write address
//    .upg_dat_i(), // UPG write data
//    .upg_done_i()
//);

 Decoder decorder (
   .Instruction(Instruction),
   .read_data(read_data),
   .ALU_result(ALU_result),
   .Jal(Jal),
   .RegWrite(RegWrite),
   .MemtoReg(MemtoReg),
   .RegDst(RegDst),
   .clock(clock),
   .reset(reset),
   .opcplus4(opcplus4),
   .read_data_1(read_data_1),
   .read_data_2(read_data_2),
   .imme_extend(imme_extend)
 );

  wire[31:0] Read_data_2; //one of the sources of Binput
    wire[31:0] Sign_extend;//one of the sources of Binput
    // from IFetch
    wire[5:0] Opcode; //instruction[31:26]
    wire[5:0] Function_opcode; //instructions[5:0]
    wire[4:0] Shamt; //instruction[10:6], the amount of shift bits
    wire[31:0] PC_plus_4; //pc+4
// from Controller
    wire[1:0] ALUOp; //{ (R_format || I_format) , (Branch || nBranch) }
    wire ALUSrc; // 1 means the 2nd operand is an immediate (except beq,bne?
    wire I_format; // 1 means I-Type instruction except beq, bne, LW, SW
    wire Sftmd; // 1 means this is a shift instruction
    wire R_format;
     wire[31:0] ALU_Result;
wire[31:0] Addr_Result;
wire RegDST;
wire MemWrite;


executs32 alu(
    .Read_data_1(Read_data_1),
    .Read_data_2(Read_data_2),
    .Sign_extend(Sign_extend),
    .Exe_opcode(Opcode),
    .Function_opcode(Function_opcode),
    .Shamt(Shamt),
    .PC_plus_4(PC_plus_4),
    .ALUOp(ALUOp),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Sftmd(Sftmd),
//    .Branch(Branch),
//    .nBranch(nBranch),
    .ALU_Result(ALU_Result),
    .Zero(Zero),
    .Addr_Result(Addr_Result)
  );
  
   // instantiate the ALU_src module
//   ALU_src alu_src_inst (
//     .Read_data_1(Read_data_1), // connect input port Read_data_1
//     .Read_data_2(Read_data_2), // connect input port Read_data_2
//     .Sign_extend(Sign_extend), // connect input port Sign_extend
//     .ALUSrc(ALUSrc) // connect input port ALUSrc
//   );
   
   Controller controller_inst(
   .Opcode(Opcode),
   .Function_opcode(Function_opcode),
   .Jr(Jr),
   .Jmp(Jmp),
   .Jal(Jal),
   .Branch(Branch),
   .nBranch(nBranch),
   .RegDST(RegDST),
   .MemtoReg(MemtoReg),
   .RegWrite(RegWrite),
   .MemWrite(MemWrite),
   .ALUSrc(ALUSrc),
   .I_format(I_format),
   .Sftmd(Sftmd),
   .ALUOp(ALUOp)
   );
   
   top_segment mileage_record(
   .clk(cpu_clk),
   .rst(rst),
   .num(ALU_Result),
   .anode(seg_en),
   .cathode(seg_out0),
   .cathode2(seg_out1)
   );
   
endmodule
