function [fd] = fd_estimate(repeatdata,segment,bw)
%����˵����
% repeatdata �ǽ��յ��İ����ظ����ݵĲ���
% segment ���ظ��ĵ�Ԫ ����ʵ����segmentֻ�ṩ���ظ���Ԫ�ĳ���
% bw �������ݴ������ڼ����һ��Ƶƫ
% fd ���Ƴ���Ƶƫ
% firefly 2019-2-20

len1=length(repeatdata);
len2=length(segment);
times=floor(len1/len2);

phase=zeros(1,times-3);%������һ�κ����һ��

for i=2:times-2
    s1=repeatdata((i-1)*len2+1:i*len2);
    s2=repeatdata(i*len2+1:(i+1)*len2);
    phase(i)=sum(angle(s2.*conj(s1)))/len2;
end
p_mean=mean(phase(2:end));
fd=p_mean*bw/(len2*2*pi);
end

















