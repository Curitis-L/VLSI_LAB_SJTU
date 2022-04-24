%将系数a,b都扩大2^14，再取整，方便进行仿真
result_den = (-ceil(Den*(2^14)));
result_num = ceil(Num*(2^14));

fid = fopen('a.txt','wt');      %输出量化后的系数到文件a.txt中
fprintf(fid,'%g\n',result_den);     
fclose(fid);

fid_1 = fopen('b.txt','wt');      %输出量化后的系数到文件b.txt中
fprintf(fid_1,'%g\n',result_num);     
fclose(fid_1);
