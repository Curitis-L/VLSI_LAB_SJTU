/************************************************************
//VLSI_Final_LAB
//Function:(7,4) Cyclic code codec
//g(x)=1+x+x^3
//Version:1.0
//module:test
*************************************************************/

`timescale 1ns/1ns
module test();
    reg clk;
    reg rst_n;
    reg data_in;
    wire data_out;
    reg [34:0] seq = 35'b0001111_0000001_0000011_0001001_0001010;
    reg [5:0] i;

    Encoder1 test(
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
        data_in = seq[0];
        for(i=1;i<35;i=i+1) begin
            #10 data_in = seq[i];
        end
    end
    always #5 clk = ~clk;

endmodule
