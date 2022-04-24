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
//module:iir_a1_testbench
//************************************//

`timescale  1ns/1ns
module a1_testbench( );
 
integer file_r,file_w;  
integer count;   
reg clk,rst,en;
reg signed[15:0] in;
wire signed[31:0] out;
 
always #10 clk <= ~clk;

initial  
begin
    en = 0;
    clk = 0; 
    in = 0;
    count = 0;
    rst = 1;
    file_r=$fopen("s_16.txt","r"); 
    file_w=$fopen("a1_out.txt","w");
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
        $fwrite(file_w,"%d\n",out);
    end
    else
    begin
         $fclose(file_w);
    end  
end

iir_a1 A1(
    .data_in(in),
    .data_out(out),
    .clk(clk),
    .rst_n(rst),
    .data_in_en(en)
);

endmodule
