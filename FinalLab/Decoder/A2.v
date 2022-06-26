///VLSI final-project
///name: Optimized decoder


module decoder_A2 (
    input clk,
    input rst_n,
    input data_in,
    output data_out,
    output reg out_flag,     //输出有效信号out_flag，高电平为有效
    output reg in_flag       //输入控制信号，为高时允许比特串输入，为低时不允许
);
    reg div_reg[2:0];      //除法电路中移位寄存器
    wire div_feedback;      //除法电路中反馈信号线
    reg [2:0] clk_count;    //内置计数器    
    reg [6:0] r_x;           //接收码字并存储，以便纠正
    reg [3:0] tmp_out;      //暂存译码结果，用于串行输出
    reg [2:0] bit_count;    //余数不为0时，计s(x)右移的次数
    reg out_flag_sx;
    
    assign div_feedback = div_reg[2];
    assign data_out = tmp_out[3];

    //接收码字
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            r_x <= 7'b0000000;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} != 3'b000 && {div_reg[2],div_reg[1],div_reg[0]} != 3'b101) //a如果s(x)不是0也不是s6(x),此时需要保存r(x)，保证后面译码的正确性
            r_x <= r_x;
        else if(in_flag || clk_count == 0)
            r_x <= {r_x[5:0],data_in};
        else
            r_x <= r_x;      
    end

    //除法电路寄存器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            div_reg[0] <= 1'b0;
        else if(in_flag || clk_count ==0)        //有新数据输入
            begin       
                if(clk_count<=2 || (clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b000))    //如果s(x)=0，此时clk_count=7时可以继续读数进来;如果不是，则不能读数,保证a
                    div_reg[0] <= data_in;
                else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} != 3'b101)
                    div_reg[0] <= 0 ^ div_feedback;
                else
                    div_reg[0] <= data_in ^ div_feedback;
            end
        else                //对s(x)进行除法运算
            div_reg[0] <= 0 ^ div_feedback;
    end

    //除法电路寄存器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            div_reg[1] <= 1'b0;
        else if(clk_count<=2 || (clk_count == 7)&&{div_reg[2],div_reg[1],div_reg[0]} == 3'b000)
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

    //进行余数与s6(x)比对，进行纠错后进行输出
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            tmp_out <= 4'b0000;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b000 && in_flag)  //s(x)=0,直接输出
            tmp_out <= r_x[6:3];
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b101)   //if s(x)=s6(x),则可以输出
            tmp_out <= r_x[6:3]^(4'b1000>>bit_count);
        else if(clk_count ==7 && bit_count == 6)        //无法纠错的情况，直接输出信息位
            tmp_out <= r_x[6:3];
        else if((in_flag || clk_count == 0) && clk_count<=3)                //串行输出的操作
            tmp_out <= {tmp_out[2:0],tmp_out[3]};
        else
            tmp_out <= tmp_out;
    end

    //s(x)移动几次的计数器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            bit_count <= 3'b000;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b101) //s(x)=s6(x)，移位计数器需置零
            bit_count <= 3'b000;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b000) //s(x)=0,移位计数器也需要置零
            bit_count <= 3'b000;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} != 3'b101) //不是上述两种情况，需要记录移位情况
            bit_count <= bit_count+1;
        else 
            bit_count <= bit_count;
    end

    //内置计数器
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            clk_count <= 0;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b000 && in_flag)  //g(x)=0,clk_count置1
            clk_count <= 1;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b101 && !in_flag) //g(x)=g6(x),clk_count置0,重新开始接收比特串
            clk_count <= 0;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} != 3'b101)
            clk_count <= 7;
        else
            clk_count <= clk_count + 1;
    end

    //输出有效信号out_flag
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            out_flag <= 0;
        else if(clk_count==7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b000 && in_flag)
            out_flag <= 1;
        else if(clk_count==7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b101)
            out_flag <= 1;
        else if(out_flag_sx == 0&& clk_count==4)
            out_flag <= 0;
        else if(out_flag_sx == 1&& clk_count==3)
            out_flag <= 0;
        else
            out_flag <= out_flag;
    end

    //输入控制信号in_flag
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
            in_flag <= 1;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b000)
            in_flag <= 1;
        else if(clk_count == 7)
            in_flag <= 0;
        else if(clk_count == 0)
            in_flag <=1;
        else
            in_flag <= in_flag;
    end
    
    //是否纠错后进行输出
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            out_flag_sx <= 0;
        else if(clk_count == 7 && {div_reg[2],div_reg[1],div_reg[0]} == 3'b101)
            out_flag_sx <=1;
        else if(clk_count ==7)
            out_flag_sx <=0;
        else
            out_flag_sx <= out_flag_sx;
    end
endmodule