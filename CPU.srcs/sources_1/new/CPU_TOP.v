`timescale 1ns / 1ps

module CPU_TOP(
    input fpga_rst,
    input fpga_clk,
    input[23:0] switch2N4,
    output[23:0] led2N4,
    
    // UART Programmer Pinouts
    // start Uart communicate at high level
    input start_pg,
    input rx,
    output tx  
    );

// UART Programmer Pinouts
wire upg_clk, upg_clk_o;
wire upg_wen_o; //Uart write out enable
wire upg_done_o; //Uart rx data have done
//data to which memory unit of program_rom/dmemory32
wire [14:0] upg_adr_o;
//data to program_rom or dmemory32
wire [31:0] upg_dat_o;

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

wire [31:0] PC, Next_PC;

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
    .clock(cpuclk), .reset(fpga_rst),             // Clock and reset
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

dmemory32 datamem(
    .clk(cpu_clk),
    .wea(), //controller
    .addra(),
    .din(),
    .douta(),
    .upg_rst_i(), // UPG reset (Active High)
    .upg_clk_i(), // UPG ram_clk_i (10MHz)
   .upg_wen_i(), // UPG write enable
    .upg_adr_i(), // UPG write address
    .upg_dat_i(), // UPG write data
    .upg_done_i()
);

Decoder(
    .Instruction(Instruction),.read_data(Read_data_1), .ALU_result(), Jal, RegWrite, MemtoReg, RegDst, clock, reset, opcplus4, read_data_1, read_data_2, imme_extend
 );

endmodule
