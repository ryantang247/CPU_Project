`timescale 1ns / 1ps

module Decoder_TB;

    reg [31:0] Instruction;
    reg clock, reset;
    reg Jal, RegWrite, MemtoReg, RegDst;
    reg [31:0] opcplus4;
    
    wire [31:0] read_data, ALU_result, read_data_1, read_data_2, imme_extend;
    
    // Instantiate the Decoder module
    decode32 dut (
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
    
    // Initialize inputs
    initial begin
        // Set inputs to desired values
        Instruction = 32'h21080001;
        Jal = 0;
        RegWrite = 1;
        MemtoReg = 0;
        RegDst = 0;
        opcplus4 = 0;
        
        // Toggle clock
        clock = 0;
        forever #5 clock = ~clock;
        
        // Reset the design
        reset = 1;
        #10 reset = 0;
        
        // Wait for a few clock cycles
        #20;
        
        // Finish simulation
        $finish;
    end
    
    // Display relevant signals
    always @(posedge clock) begin
        $display("Instruction: %h", Instruction);
        $display("Read Data: %h", read_data);
        $display("ALU Result: %h", ALU_result);
        $display("Read Data 1: %h", read_data_1);
        $display("Read Data 2: %h", read_data_2);
        $display("Immediate Extend: %h", imme_extend);
        $display("");
    end
    
endmodule
