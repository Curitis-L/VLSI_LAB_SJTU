///VLSI final-project
///name:optimized decoder


`timescale 1ns/1ns
module test();
reg clk;
    reg rst_n;
    reg data_in;
    wire data_out;
    wire out_flag;
    wire in_flag;
    reg [41:0] seq = 42'b1100101_0111100_0100111_1110000_1010000_0000000;
    reg [5:0] i;

    decoder_A2 test(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .out_flag(out_flag),
        .in_flag(in_flag)
    );

    initial begin
        #5 clk = 1'b1;
        #1 rst_n =1'b1;
        #4 rst_n = 1'b0;
        #5 rst_n = 1'b1;
        data_in = seq[0];
        #10 data_in = seq[1];
        for(i=2;i<42;i=i+1) begin
            #10 
            begin
                if(in_flag)
                  data_in = seq[i];
                else
                  i=i-1;
            end
        end
    end
    always #5 clk = ~clk;

endmodule