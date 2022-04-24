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
//module:iir_a3_top_module
//************************************//
//`include "iir_a3.v"
module iir_a3_top_module(
    input clk,
    input rst_n,
    input signed [47:0] data_in,
    input data_in_en,
    output signed [95:0] data_out
);
        iir_a3 t2(
        .clk(clk),
        .rst_n(rst_n),
        .data_in_1(data_in[47:32]),
        .data_in_2(data_in[31:16]),
        .data_in_3(data_in[15:0]),
        .data_in_en_1(data_in_en),
        .data_in_en_2(data_in_en),
        .data_in_en_3(data_in_en),
        .data_out_1(data_out[95:64]),
        .data_out_2(data_out[63:32]),
        .data_out_3(data_out[31:0])
    );   

endmodule
