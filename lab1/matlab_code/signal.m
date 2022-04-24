% Generating signals 
Fs = 1e7; % Fs=10MHz 
f1 = 1e6; % f1=1MHz 
f2 = 2*1e6; % f2=2MHz
f3 = 4*1e6; % f3=4MHz
t = 0 : 1/Fs : 10000/Fs; 
s1 = cos((2 * pi * f1) .* t); % Generating cosine signal with f1=1MHz 
s2 = cos((2 * pi * f2) .* t); % Generating cosine signal with f2=2MHz 
s3 = cos((2 * pi * f3) .* t); % Generating cosine signal with f3=4MHz 
s = (s1 + s2 + s3) ./ 3; % add them


figure(1); % plot
subplot(2,1,1); stem(s(1:100)); grid; % plot original 
title('Original signal in time-domain'); 
xlabel('k');
ylabel('s(k)'); 
% FFT on signal s
len = 4096; % FFT length
f = Fs .* (0 : len/2 - 1) ./ len; 
y = fft(s, len); % do len-points FFT transform on the signal s
subplot(2,1,2);
plot(f, abs(y(1:len/2))); grid; % plot original signal s on the frequency domain
title('Original signal spectrum in frequency domain') 
xlabel('f (Hz)');
ylabel('S(f)'); 

%将产生的信号s进行移位操作并输出到.txt文件中方便Modelsim仿真
s_2 = ceil(s *(2^8));
s_3 = ceil(s *(2^14));
fid = fopen('s.txt','wt');      %s.txt需要输出的数据
fprintf(fid,'%g\n',s_2);     
fclose(fid);

%tmp_data为modelsim仿真输出的数据(为.txt文件)，需要右移操作还原信号大小
tmp_data = (textread("a2_out.txt"))/(2^28);
y_bp=fft(tmp_data, len); % do len-points FFT transform on the signal s_bp

figure(2); 
subplot(2,1,1);
s2 = s2 ./ 3;
plot(t(1:1000), s2(1:1000), 'blue', t(1:1000), tmp_data(1:1000), 'red'); grid; xlim([0.000001 0.000002])
legend('Original 1500Hz signal','Filtered 1500Hz signal'); 
title('Comparison of signal before and after filtering'); 
xlabel('t (s)');ylabel('s(t)'); 
subplot(2,1,2);
plot(f, abs(y_bp(1:len/2)));grid; 
title('Filtered signal spectrum in frequency domain'); 
xlabel('f (Hz)');ylabel('S(f)');
