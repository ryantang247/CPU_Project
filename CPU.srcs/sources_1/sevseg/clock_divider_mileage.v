module clock_divider #(parameter div_value = 4999)(//local->global param
    input wire clk,//100MHz
    output reg divided_clk=0 //10khz
    );
    integer cnt_val=0;//32 bit
    
    always @(posedge clk) //sesivity list, rising edge 0-1
    begin // counting until div value
        if (cnt_val == div_value)
            cnt_val <= 0;///reset clkout <= 0;
        else 
            cnt_val <= cnt_val+1;
    end
    //divide clk
    always @(posedge clk) //sesivity list //rising edge 0-1
    begin // counting until div value
        if (cnt_val == div_value)
            divided_clk <= ~divided_clk;///reset clkout <= 0;
    end
endmodule