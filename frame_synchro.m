function [rx_data,temp] = frame_synchro(rx_signal_fre_offset,N_short)
%UNTITLED8 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% ֡ͬ��
search_area = 120000;
xcorr_frame = zeros(1,search_area);
j = 1;
short_zc_seq = gen_zc_sequence(N_short);
while(j < search_area)
    xcorr_frame(j) = abs(sum(short_zc_seq.*conj(rx_signal_fre_offset(j:j + N_short - 1))));
    xcorr_frame(j) = xcorr_frame(j)/sum(abs(short_zc_seq).^2);
    j = j + 1;
end
Frame_sym = find(xcorr_frame > 0.5, 1);
if(~isempty(Frame_sym))  % ��⵽֡
    disp('�Ѳ���ͬ������!');
    figure(1)
    plot(abs(rx_signal_fre_offset));
    title('�����ź�');
    begin_frame = Frame_sym(1);
    disp(['֡�������㣺',num2str(begin_frame)]);
    figure (2)
    plot(xcorr_frame);
     title('�����ź����ͬ������');
    if(begin_frame > 50000 && begin_frame < 300000)
       temp = 1;
    else
       temp = 0;
    end
else
    temp = 0;
    begin_frame = 1;
end
rx_data = rx_signal_fre_offset(begin_frame:end); %%%% ȥ����������

end

