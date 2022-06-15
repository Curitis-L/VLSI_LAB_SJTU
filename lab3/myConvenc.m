
 function    coded_bits = myConvenc(info_bits)
    reg=zeros(1,7);
    out_1=zeros(1,4000);
    out_2=zeros(1,4000);
    g1=[1 0 1 1 0 1 1];       % Generation polynomial[133,171]
    g2=[1 1 1 1 0 0 1];
    for j=1:length(info_bits)
        for i=6:-1:1
            reg(i+1)=reg(i);
        end
        reg(1)=info_bits(j);
        out_1(j)=mod(sum(g1.*reg),2); 
        out_2(j)=mod(sum(g2.*reg),2);
        coded_bits(j*2-1:j*2)=[out_1(j) out_2(j)];
    end
 return  