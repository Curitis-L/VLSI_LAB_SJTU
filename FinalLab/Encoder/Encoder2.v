/************************************************************
//VLSI_Final_LAB
//Function:(7,4) Cyclic code codec
//g(x)=1+x+x^3
//Version:1.0
//module:Encoder2
*************************************************************/

module Encoder2(
    input clk,
    input rst_n,
    input [3:0] data_in,
    output reg [6:0] data_out
);
    parameter base_0001 = 3'b101 ;
    parameter base_0010 = 3'b111 ;
    parameter base_0100 = 3'b011 ;
    parameter base_1000 = 3'b110 ;

    /*reg [2:0] mem_0;
    reg [2:0] mem_1;
    reg [2:0] mem_2;
    reg [2:0] mem_3;*/

    wire [2:0] mem_0;
    wire [2:0] mem_1;
    wire [2:0] mem_2;
    wire [2:0] mem_3;

    wire [2:0] tmp;
    //reg [2:0] data_in_reg;

    /*always @(posedge clk,negedge rst_n) begin
        if(~rst_n) 
            mem_3 <= 3'd0;
        else if(data_in[3])
            mem_3 <= base_1000;
        else mem_3 <= 3'd0;
    end   

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n) 
            mem_2 <= 3'd0;
        else if(data_in[2])
            mem_2 <= base_0100;
        else mem_2 <= 3'd0;
    end

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n) 
            mem_1 <= 3'd0;
        else if(data_in[1])
            mem_1 <= base_0010;
        else mem_1 <= 3'd0;
    end

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n) 
            mem_0 <= 3'd0;
        else if(data_in[0])
            mem_0 <= base_0001;
        else mem_0 <= 3'd0;
    end*/  

    assign mem_3 = (data_in[3]) ? base_1000 : 3'd0;
    assign mem_2 = (data_in[2]) ? base_0100 : 3'd0;
    assign mem_1 = (data_in[1]) ? base_0010 : 3'd0;
    assign mem_0 = (data_in[0]) ? base_0001 : 3'd0;

    /*always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            tmp <= 3'd0;
        else tmp <= mem_0 ^ mem_1 ^ mem_2 ^ mem_3;
    end*/

    assign tmp = mem_0 ^ mem_1 ^ mem_2 ^ mem_3;

    /*always @(posedge clk,negedge rst_n) begin
        if(~rst_n) 
            data_in_reg <= 3'd0;
        else data_in_reg <= data_in;
    end*/

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            data_out <= 7'd0;
        else
            data_out <= {tmp,data_in};
    end


endmodule
