`timescale 1ns / 1ps

//limit for 16 bit number is 65535
module binary_BCD(
    input clk,//system clock 100MHZ 
    input [15:0] sixteenbit_val,//system clock 100MHZ 
    output reg [3:0] Ones,//x
    output reg [3:0] Tens,//x0
    output reg [3:0] Hundreds,//x00
    output reg [3:0] Thousands,//x000
    output reg [3:0] TenThousands,//x0_000
    output reg [3:0] HundredThousands,//x00_000
    output reg [3:0] Millions, //x_000_000
    output reg [3:0] TenMillions //x0_000_000 =x000_0000
    );
    reg [8:0] i=0;
    reg [49:0] shift_reg=0;
    reg [3:0] temp_ones=0;//x
    reg [3:0] temp_tens=0;//x0
    reg [3:0] temp_hundreds=0;//x00
    reg [3:0] temp_thousands=0;//x000
    reg [3:0] temp_tenThousands=0;//x0_000
    reg [3:0] temp_hundredThousands=0;//x00_000
    reg [3:0] temp_millions=0; //x_000_000
    reg [3:0] temp_tenMillions=0; //x0_000_000 =x000_0000*/
    reg [15:0] init_sixteenbit_val=0;
    
    always @(posedge clk)  begin //
        if (i == 0 & (init_sixteenbit_val != sixteenbit_val)) begin//turn left/right
            shift_reg = 47'd0;///reset clkout <= 0;
            init_sixteenbit_val = sixteenbit_val;
            shift_reg[15:0] = sixteenbit_val;
            temp_ones = shift_reg[19:16];
            temp_tens = shift_reg[23:20];
            temp_hundreds = shift_reg[27:24];
            temp_thousands = shift_reg[31:28];
            temp_tenThousands = shift_reg[35:32];
            temp_hundredThousands = shift_reg[39:36];
            temp_millions = shift_reg[43:40];
            temp_tenMillions = shift_reg[47:44];
            i=i+1;
        end
        //Since 1010 =10 decimal
        if (i <= 16 & i > 0) begin
            if(temp_ones >= 5) temp_ones = temp_ones +3;
            if(temp_tens >= 5) temp_tens = temp_tens +3;
            if(temp_hundreds >= 5) temp_hundreds = temp_hundreds +3;
            if(temp_thousands >= 5) temp_thousands = temp_thousands +3;
            if(temp_tenThousands >= 5) temp_tenThousands = temp_tenThousands +3;
            if(temp_hundredThousands >= 5) temp_hundredThousands = temp_hundredThousands +3;
            if(temp_millions >= 5) temp_millions = temp_millions +3;
            if(temp_tenMillions >= 5) temp_tenMillions = temp_tenMillions +3;
            shift_reg [49:16] = {temp_tenMillions,temp_millions,temp_hundredThousands,temp_tenThousands,temp_thousands,temp_hundreds,temp_tens,temp_ones};
            //shift_reg [19:8] = {temp_hundreds,temp_tens,temp_ones};
            shift_reg = shift_reg<<1;
            temp_ones = shift_reg[19:16];
            temp_tens = shift_reg[23:20];
            temp_hundreds = shift_reg[27:24];
            temp_thousands = shift_reg[31:28];
            temp_tenThousands = shift_reg[35:32];
            temp_hundredThousands = shift_reg[39:36];
            temp_millions = shift_reg[43:40];
            temp_tenMillions = shift_reg[47:44];  
            i=i+1;
        end
        if (i > 16) begin
            i=0;
            Ones = temp_ones;
            Tens = temp_tens;
            Hundreds = temp_hundreds;
            Thousands = temp_thousands;
            TenThousands = temp_tenThousands;
            HundredThousands = temp_hundredThousands;
            Millions = temp_millions; 
            TenMillions = temp_tenMillions;
        end
    end
endmodule

