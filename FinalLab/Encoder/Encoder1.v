module Encoder1 (
    input clk,
    input rst_n,
    input data_in,
    //input data_in_en,
    output reg data_out
);
    reg data_delay;
    wire feedback;
    reg data_reg [2:0];
    reg [2:0] cnt;
    parameter max = 3'd6;
    parameter T = 3'd3;
    reg flag;
    
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            data_delay <= 1'd0;
        else data_delay <= data_in;
    end
     //count
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            cnt <= 3'd0;
        else if(cnt < max)
            cnt <= cnt + 1;
        else cnt <= 3'd0;
    end
    
    //flag
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            flag <= 1'd0;
        else if(cnt <= T)
            flag <= 1'd1;
        else if(cnt < max)
            flag <= 1'd0;
        else flag <= flag;
    end

    //Codec
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            data_reg[0] <= 1'b0;
        else data_reg[0] <= feedback;
    end

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            data_reg[1] <= 1'b0;
        else data_reg[1] <= data_reg[0] ^ feedback;
    end

    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            data_reg[2] <= 1'b0;
        else data_reg[2] <= data_reg[1];
    end

    //feedback
    assign feedback = (flag&&rst_n) ? data_reg[2] ^ data_delay : 1'd0;

    /*
    always @(*) begin
        if(~rst_n)
            feedback = 1'd0;
        else if(flag)
            feedback = data_reg[2] ^ data_in;
        else feedback = 1'd0;
    end
    */

    //data_out
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)
            data_out <= 1'd0;
        else if(flag)
            data_out <= data_delay;
        else data_out <= data_reg[2] ^ data_delay;
    end

endmodule
