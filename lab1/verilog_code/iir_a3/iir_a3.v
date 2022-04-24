//************************************//
//IIR数字滤波器设计与实现
//Fs: 10MHz
//Fstop1: 0.5MHz
//Fpass1: 1.5MHz
//Fpass2: 3.2MHz
//Fstop2: 4MHz
//Apass: 1dB
//Astop1: 60dB
//Astop2: 60dB
//date:2022/04/05

//version: A3（Parallel)
//module:iir_a3
//************************************//
//`include "iir_a1.v"
module iir_a3(
    input clk,
    input rst_n,
    input signed [15:0] data_in_1,
    input signed [15:0] data_in_2,
    input signed [15:0] data_in_3,
    input data_in_en_1,
    input data_in_en_2,
    input data_in_en_3,
    output signed [31:0] data_out_1,
    output signed [31:0] data_out_2,
    output signed [31:0] data_out_3
);

iir_a1 iir_1(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in_1),
    .data_in_en(data_in_en_1),
    .data_out(data_out_1)
);

iir_a1 iir_2(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in_2),
    .data_in_en(data_in_en_2),
    .data_out(data_out_2)
);

iir_a1 iir_3(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in_3),
    .data_in_en(data_in_en_3),
    .data_out(data_out_3)
);

    
    
endmodule
