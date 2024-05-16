function [data_encode ,add_segment ] = Turbo_code(data_origin)
% Turbo码由Berrou，Glavieux和Thitimajshima在1993年提出，是一种并行级联卷积码。Turbo码将分量码和随机交织器巧妙结合起来，采用并行级联的结构，实现了随机编码的思想，采用软输入软输出的迭代译码方法，达到了接近香农限的性能。
%   此处显示详细说明
g=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
CRC_bit = length(g) - 1;
[~,crc] = deconv([data_origin zeros(1,CRC_bit)],g);%%多项式相除
crc = mod(crc(end - CRC_bit + 1:end),2);
tx_bit_crc = [data_origin crc]; 

rv=0;
codelen = 4 * length(data_origin);
cbs = lteCodeBlockSegment(tx_bit_crc);
te = lteTurboEncode(cbs);
data_encode = double(lteRateMatchTurbo(te,codelen,rv).');
num_data = 0;
if(length(cbs) > 1)
    for i = 1:length(cbs)
        data_temp = double(cbs{1,i});
        index = length(find(data_temp < 0));
        num_data = num_data + index;
    end
    add_segment = num_data;
else
    add_segment = length(cbs{1,1}(:,1)) - length(tx_bit_crc);
end
end

