module CPU_Top_test;

  reg fpga_rst;
  reg fpga_clk;
  reg start_pg;
  wire clock_led;
  wire [7:0] seg_out0;
  wire [7:0] seg_out1;
  wire [7:0] seg_en;
  // reg [23:0] switch2N4;
  // wire [23:0] led2N4;
   wire tx;
   reg rx;

  CPU_Top dut (
    .fpga_rst(fpga_rst),
    .fpga_clk(fpga_clk),
    // .switch2N4(switch2N4),
    // .led2N4(led2N4),
    .seg_out0(seg_out0),
    .seg_out1(seg_out1),
    .seg_en(seg_en),
    .clock_led(clock_led),
    .start_pg(start_pg),
     .rx(rx),
     .tx(tx)
  );

  // Clock generation
  reg clk;
  always #5 fpga_clk = ~fpga_clk;

  // Add stimulus code here
  initial begin
    // Initialize inputs
    fpga_rst = 0;
    fpga_clk = 0;
    start_pg = 0;
    // switch2N4 = 0;

    // Apply reset
    fpga_rst = 1;
    #10;
    fpga_rst = 0;

    // Apply test inputs
    start_pg = 1;
    rx=1;
    // switch2N4 = 8'hFF;
    #100;
    start_pg = 0;
    // switch2N4 = 8'h00;
    #50;

    // End simulation
    $finish;
  end

endmodule
