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

//version: A3(Basic)
//module:iir_a3_testbench
//************************************//

`timescale  1ns/1ns
module a3_testbench( );
 
integer file_r,file_w1,file_w2,file_w3;  
integer count;   
reg clk,rst,en;
reg signed[47:0] in;
wire signed[95:0] out;
 
always #10 clk <= ~clk;

initial  
begin
    en = 0;
    clk = 0; 
    in = 0;
    count = 0;
    rst = 1;
    file_r=$fopen("s_16.txt","r"); 
    file_w1=$fopen("a3_out_1.txt","w1");
    file_w2=$fopen("a3_out_2.txt","w2");
    file_w3=$fopen("a3_out_3.txt","w3");
    #1 rst = 0;
    #1 rst = 1;
    #4 en = 1;
end 
 
always@(posedge clk)
begin
    if(count < 100000)
    begin
        $fscanf(file_r,"%d" ,in);
        $display(in);
    end
    else
    begin
         $fclose(file_r);
    end  
end

always@(posedge clk)
begin
    if(count < 100000)
    begin
        count <= count + 1; 
    end
    else
    begin
        count <= count;
    end  
end

always@(posedge clk)
begin
    if(count < 100000)
    begin
        $fwrite(file_w1,"%d\n",out[95:64]);
    end
    else
    begin
         $fclose(file_w1);
    end  
end

always@(posedge clk)
begin
    if(count < 100000)
    begin
        $fwrite(file_w2,"%d\n",out[63:32]);
    end
    else
    begin
         $fclose(file_w2);
    end  
end

always@(posedge clk)
begin
    if(count < 100000)
    begin
        $fwrite(file_w3,"%d\n",out[31:0]);
    end
    else
    begin
         $fclose(file_w3);
    end  
end


iir_a3_top_module a3(
    .clk(clk),
    .rst_n(rst),
    .data_in(in),
    .data_out(out),
    .data_in_en(en)
);

endmodule