function [data_encode ,add_segment ] = Turbo_code(data_origin)
% Turbo����Berrou��Glavieux��Thitimajshima��1993���������һ�ֲ��м�������롣Turbo�뽫������������֯�����������������ò��м����Ľṹ��ʵ������������˼�룬����������������ĵ������뷽�����ﵽ�˽ӽ���ũ�޵����ܡ�
%   �˴���ʾ��ϸ˵��
g=[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
CRC_bit = length(g) - 1;
[~,crc] = deconv([data_origin zeros(1,CRC_bit)],g);%%����ʽ���
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

