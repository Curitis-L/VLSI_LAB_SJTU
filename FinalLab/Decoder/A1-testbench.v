///VLSI final-project
///name:Decoder with no optimization


`timescale 1ns/1ns
module test();
reg clk;
    reg rst_n;
    reg data_in;
    wire data_out;
    wire out_flag;
    reg [41:0] seq = 42'b1000101_0100100_0100011_1110010_1010001_0000000;
    reg [6:0] i;

    decoder_A1 test(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .out_flag(out_flag)
    );

    initial begin
        #5 clk = 1'b1;
        #1 rst_n =1'b1;
        #4 rst_n = 1'b0;
        #5 rst_n = 1'b1;
        data_in = seq[0];
        #10 data_in = seq[1];
        for(i=2;i<42;i=i+1) begin
            #10 data_in = seq[i];
        end
    end
    always #5 clk = ~clk;

endmodule