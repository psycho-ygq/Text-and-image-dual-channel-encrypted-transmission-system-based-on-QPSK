function [rx_data_RemoveFreOffset,est_cfo] = fre_offset_correct(rx_data,Frame_len,fs,short_len,num_short)
%UNTITLED9 �˴���ʾ�йش˺�����ժҪ
%   Ƶƫ����

method = 1;
set_errorbegin = short_len + 1;%%%  ���õ���ʼ�㣬�����ʼ�㱣֤�Ӹõ����������ѵ������
window = short_len;
len = (num_short - 2)*window;

%%% 802.11a�еķ���
if(method == 1)
    rx_short_sequ = rx_data(1,set_errorbegin + 1: set_errorbegin + len);
    phase1 = sum(rx_short_sequ(1,1:end - window).*conj(rx_short_sequ(1,window + 1:end)));
    est_cfo = -angle(phase1)/(2*pi*window/fs);
    rx_data_RemoveFreOffset = rx_data(1:Frame_len + 100).*exp(-1i*2*pi*est_cfo.*(0:Frame_len + 100 - 1)./fs);%%%����tʱ��Բ��ϣ���������һ��������ƫ
else
    len = 112;
    rx_short_sequ = rx_data(1,set_errorbegin + 1: set_errorbegin + len);
    phase = zeros(1,len / window);
    for k = 1:len / window - 1
        phase(k) = angle(sum(rx_short_sequ((k - 1)*window + 1:k*window).*conj(rx_short_sequ(k*window + 1:(k + 1)*window))));
    end
    est_cfo = -mean(phase)/(2*pi*window/fs);
    rx_data_RemoveFreOffset = rx_data(1:Frame_len).*exp(-1i*2*pi*est_cfo.*(0:Frame_len-1)./fs);%%%����tʱ��Բ��ϣ���������һ��������ƫ
end


end

