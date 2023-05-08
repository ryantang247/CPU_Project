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



endmodule
