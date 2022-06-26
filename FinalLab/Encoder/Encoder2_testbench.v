/************************************************************
//VLSI_Final_LAB
//Function:(7,4) Cyclic code codec
//g(x)=1+x+x^3
//Version:1.0
//module:Encoder2_testbench
*************************************************************/
module Encoder2_tb ();
    reg clk;
    reg rst_n;
    reg [3:0] data_in;
    wire [6:0]data_out;



    Encoder2 test(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        #5 clk = 1'd1;
        #1 rst_n =1'd1;
        #4 rst_n = 1'd0;
        #10 rst_n = 1'd1;
            data_in = 4'b1010;
        #10 data_in = 4'b1001;
        #10 data_in = 4'b0011;
        #10 data_in = 4'b0001;
        #10 data_in = 4'b1111;
    end

    always #5 clk = ~clk;

endmodule
