function [data_decode] = Turbo_decode(data_encode,frame_len,add_segment)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
g=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
CRC_bit = length(g) - 1;
rv=0;

rrt = lteRateRecoverTurbo(data_encode,frame_len,rv);
td = lteTurboDecode(rrt);
rx_desegment = lteCodeBlockDesegment(td).';

rx_desegment = rx_desegment(add_segment + 1:end);
[~,crc] = deconv(rx_desegment,g);%%多项式相除
crc = sum(mod(crc(end - CRC_bit + 1:end),2));
data_decode = double(rx_desegment(1:end - CRC_bit));

end

