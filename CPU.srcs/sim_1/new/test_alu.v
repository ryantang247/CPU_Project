module test_ALU;

reg [31:0] Read_data_1;
reg [31:0] Read_data_2;
reg [31:0] Sign_extend;
reg ALUSrc;
wire [31:0] ALU_Result;
wire Zero;
wire [31:0] Addr_Result;

ALU_src ALU_src_inst(
  .Read_data_1(Read_data_1),
  .Read_data_2(Read_data_2),
  .Sign_extend(Sign_extend),
  .ALUSrc(ALUSrc)
);

ALU ALU_inst(
  .Read_data_1(Read_data_1),
  .Read_data_2(Read_data_2),
  .Sign_extend(Sign_extend),
  .Opcode(6'b001001), // example opcode value
  .Function_opcode(6'b100001), // plus function
  .Shamt(5'b00000), // example shamt value
  .PC_plus_4(32'h80000004), // example PC+4 value
  .ALUOp(2'b10), // example ALUOp value
  .ALUSrc(ALUSrc),
  .I_format(1'b0), // example I_format value
  .Sftmd(1'b0), // example Sftmd value
  .R_format(1'b1), // example R_format value
  .Branch(1'b0), // example Branch value
  .nBranch(1'b1), // example nBranch value
  .ALU_Result(ALU_Result),
  .Zero(Zero),
  .Addr_Result(Addr_Result)
);

initial begin
  // Test case 1
  Read_data_1 = 32'h00000005;
  Read_data_2 = 32'h00000000;
  Sign_extend = 32'h00000008;
  ALUSrc = 1'b1;
  #10;
  $display("ALU_Result = %h, Zero = %b, Addr_Result = %h", ALU_Result, Zero, Addr_Result);
  
//  //Test case 2
//  Read_data_1 = 32'hFFFFFFF8;
//  Read_data_2 = 32'h00000007;
//  Sign_extend = 32'hFFFFFFFF;
//  ALUSrc = 1'b1;
//  #10;
//  $display("ALU_Result = %h, Zero = %b, Addr_Result = %h", ALU_Result, Zero, Addr_Result);
end

endmodule
 