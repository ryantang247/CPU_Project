module CPU_TOP_tb;

  reg fpga_rst;
  reg fpga_clk;
//  reg [23:0] switch2N4;
//  wire [23:0] led2N4;
  wire [7:0] seg_out0, seg_out1;
  wire [7:0] seg_en;
  reg start_pg;
//  wire rx;
//  reg tx;

  CPU_TOP dut (
    .fpga_rst(fpga_rst),
    .fpga_clk(fpga_clk),
//    .switch2N4(switch2N4),
//    .led2N4(led2N4),
    .seg_out0(seg_out0),
    .seg_out1(seg_out1),
    .seg_en(seg_en),
    .start_pg(start_pg)
//    .rx(rx),
//    .tx(tx)
  );

  // Clock generation
  always begin
    fpga_clk = 1'b0;
    #5;
    fpga_clk = 1'b1;
    #5;
  end

  // Initial stimulus
  initial begin
    fpga_rst = 1'b1;
    start_pg = 1'b0;
//    switch2N4 = 24'b0;

    #10;
    fpga_rst = 1'b0;

    // Add testbench stimulus here

    #100;
    $finish;
  end

  // Add any necessary assertions or checks here

endmodule

