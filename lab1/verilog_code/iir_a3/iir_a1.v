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

//version: A1(Basic)
//module:iir_a1
//************************************//

module iir_a1(
    input clk,
    input rst_n,
    input signed [15:0] data_in,
    input data_in_en,
    output signed [31:0] data_out
);
    //16阶
    parameter N = 5'd16;
    
    //量化后的系数,左移了14位
    //输入数据也左移了14位
    wire signed [15:0] Qa [N:1];
    wire signed [15:0] Qb [N:0];
    
    //mid，用于存储中间的寄存器的值
    reg signed [31:0] w_reg [N:1];
    

    //a，用于存储与Qa相乘后的数据
    wire signed [47:0] w_mid [N:0];
    wire signed [31:0] w_n [N:0];

    //b，用于存储与Qb相乘后的数据
    wire signed [47:0] w_mid_b [N:0];
    wire signed [31:0] w_n_b [N:0];

    //量化后的系数Qa 
    assign Qa[1] = 18009;
    assign Qa[2] = -42498;
    assign Qa[3] = 38204;
    assign Qa[4] = -62125;
    assign Qa[5] = -62125;
    assign Qa[6] = -54472;
    assign Qa[7] = 33535;
    assign Qa[8] = -31993;
    assign Qa[9] = 15886;
    assign Qa[10] = -12279;
    assign Qa[11] = 4716;
    assign Qa[12] = -3021;
    assign Qa[13] = 812;
    assign Qa[14] = -424;
    assign Qa[15] = 61;
    assign Qa[16] = -26;

    //量化后的系数Qb   
    assign Qb[0] = 23;
    assign Qb[1] = 0;
    assign Qb[2] = -179;
    assign Qb[3] = 0;
    assign Qb[4] = 628;
    assign Qb[5] = 0;
    assign Qb[6] = -1255;
    assign Qb[7] = 0;
    assign Qb[8] = 1570;
    assign Qb[9] = 0;
    assign Qb[10] = -1255;
    assign Qb[11] = 0;
    assign Qb[12] = 628;
    assign Qb[13] = 0;
    assign Qb[14] = -179;
    assign Qb[15] = 0;
    assign Qb[16] = 23;


    //w_reg[n]移位:15拍
    genvar i;
    generate
        for(i=1;i<N;i=i+1)begin:t1
            always @(posedge clk,negedge rst_n) 
            begin
                if(!rst_n)
                    w_reg[i+1] <= 16'd0;
                else if(data_in_en==1'b1)
                    w_reg[i+1] <= w_reg [i];
                else w_reg[i+1] <= w_reg[i+1];
            end
        end
    endgenerate

    //w_reg[1]，对第一个中间位置的寄存器特殊处理
    always @(posedge clk,negedge rst_n) begin
                if(!rst_n)
                    w_reg[1] <= 16'd0;
                else if(data_in_en==1'b1)
                    w_reg[1] <= w_n[0];
                else w_reg[1] <= w_reg[1];
    end

    //乘系数Qa后的中间节点
    genvar j;
    generate
        for(j=1;j<=N;j=j+1)begin:t2
            assign w_mid[j] = (Qa[j]*w_reg[j])>>>14;
            assign w_n[j] = (w_mid[j][47]==1'b0) ? {1'b0,w_mid[j][30:0]} : {1'b1,w_mid[j][30:0]};
        end
    endgenerate

    //计算w_n[0]的值，w_n[0]的值为中间结果，后续周期中会通过寄存器逐级传递给w_reg
    assign w_n[0] = data_in + w_n[1] + w_n[2] + w_n[3] + w_n[4] + w_n[5] + w_n[6] + w_n[7] + w_n[8] + w_n[9] + w_n[10] + w_n[11] + w_n[12] + w_n[13] + w_n[14] + w_n[15] + w_n[16];

    //乘系数Qb后的中间节点
    genvar k;
    generate
        for(k=2;k<=N;k=k+2)begin:t3
            assign w_mid_b[k] = (Qb[k]*w_reg[k])>>>14;
            assign w_n_b[k] = (w_mid_b[k][47]==1'b0) ? {1'b0,w_mid_b[k][30:0]} : {1'b1,w_mid_b[k][30:0]};
        end
    endgenerate

    //计算w_n_b[0],特殊处理
    assign w_mid_b[0] = (Qb[0]*w_n[0])>>>14;
    assign w_n_b[0] = (w_mid_b[0][47]==1'b0) ? {1'b0,w_mid_b[0][30:0]} : {1'b1,w_mid_b[0][30:0]};
//
    //计算data_out的值
    assign data_out = w_n_b[0] +  w_n_b[2] +  w_n_b[4]  + w_n_b[6]  + w_n_b[8] +  w_n_b[10] +  w_n_b[12] +  w_n_b[14] +  w_n_b[16];   
    
endmodule
