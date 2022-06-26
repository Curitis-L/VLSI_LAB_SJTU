///VLSI final-project
///name:Decoder with no optimization


module decoder_A1 (
    input clk,
    input rst_n,
    input data_in,
    output data_out,
    output reg out_flag     //输出有效信号out_flag，高电平为有效
);
    reg div_reg[2:0];      //除法电路中移位寄存器
    wire div_feedback;      //除法电路中反馈信号线
    reg [2:0] clk_count;    //内置计数器    
    reg [6:0] r_x;           //接收码字并存储，以便纠正
    reg [3:0] tmp_out;      //暂存译码结果，用于串行输出

    parameter s0 = 7'b0000000;
    parameter s1 = 7'b0000001;
    parameter s2 = 7'b0000010;
    parameter s3 = 7'b0000100;
    parameter s4 = 7'b0001000;
    parameter s5 = 7'b0010000;
    parameter s6 = 7'b0100000;
    parameter s7 = 7'b1000000;

    assign div_feedback = div_reg[2];
    assign data_out = tmp_out[3];

    //接收码字
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_x <= 7'b0000000;
        else
            r_x <= {r_x[5:0],data_in};      
    end

    //除法电路寄存器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            div_reg[0] <= 1'b0;
        else if(clk_count<=2 || clk_count == 7)
            div_reg[0] <= data_in; 
        else
            div_reg[0] <= data_in ^ div_feedback;
    end

    //除法电路寄存器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            div_reg[1] <= 1'b0;
        else if(clk_count<=2 || clk_count == 7)
            div_reg[1] <= div_reg[0]; 
        else
            div_reg[1] <= div_reg[0] ^ div_feedback;
    end

    //除法电路寄存器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            div_reg[2] <= 1'b0;
        else 
            div_reg[2] <= div_reg[1]; 
    end

    //进行余数与校正子的比对，进行纠错后进行输出
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            tmp_out <= 4'b0000;
        else if(clk_count == 7)
        begin
            case({div_reg[2],div_reg[1],div_reg[0]})
                3'b001:begin
                    tmp_out <= r_x[6:3]^s1[6:3];
                end
                3'b010:begin
                    tmp_out <= r_x[6:3]^s2[6:3];
                end
                3'b100:begin
                    tmp_out <= r_x[6:3]^s3[6:3];
                end
                3'b011:begin
                    tmp_out <= r_x[6:3]^s4[6:3];
                end
                3'b110:begin
                    tmp_out <= r_x[6:3]^s5[6:3];
                end
                3'b111:begin
                    tmp_out <= r_x[6:3]^s6[6:3];
                end
                3'b101:begin
                    tmp_out <= r_x[6:3]^s7[6:3];
                end
                default:begin
                    tmp_out <= r_x[6:3]^s0[6:3];
                end
            endcase
        end
        else if(clk_count<=3)
            tmp_out <= {tmp_out[2:0],tmp_out[3]};
        else
            tmp_out <= tmp_out;
    end

    //内置计数器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            clk_count <= 0;
        else if(clk_count == 7)
            clk_count <= 1;
        else
            clk_count <= clk_count + 1;
    end

    //输出有效信号out_flag
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            out_flag <= 0;
        else if(clk_count==7)
            out_flag <= 1;
        else if(clk_count==4)
            out_flag <= 0;
        else
            out_flag <= out_flag;
    end

endmodule