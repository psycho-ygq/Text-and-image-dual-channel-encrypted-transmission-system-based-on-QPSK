function [fd] = fd_estimate(repeatdata,segment,bw)
%参数说明：
% repeatdata 是接收到的包括重复数据的部分
% segment 是重复的单元 这里实际上segment只提供了重复单元的长度
% bw 测试数据带宽，用于计算归一化频偏
% fd 估计出的频偏
% firefly 2019-2-20

len1=length(repeatdata);
len2=length(segment);
times=floor(len1/len2);

phase=zeros(1,times-3);%舍弃第一段和最后一段

for i=2:times-2
    s1=repeatdata((i-1)*len2+1:i*len2);
    s2=repeatdata(i*len2+1:(i+1)*len2);
    phase(i)=sum(angle(s2.*conj(s1)))/len2;
end
p_mean=mean(phase(2:end));
fd=p_mean*bw/(len2*2*pi);
end

















