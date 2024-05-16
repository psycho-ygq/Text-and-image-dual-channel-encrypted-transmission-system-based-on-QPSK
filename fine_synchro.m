function [rx_data,rx_short_trainseq,rx_long_trainseq] = fine_synchro(data,Frame_len,short_len,long_len,num_short)
%UNTITLED10 此处显示有关此函数的摘要
%   精同步

rx_zc_long = gen_zc_sequence(long_len);
est_begin = short_len*num_short - long_len / 2; %% 假设的一个起点
xcorr_len = long_len; %% 与接收数据相关的长度
if(est_begin < 0)
    est_begin = 120;
    xcorr_len = 80;
end
xcorr_fine_sym = zeros(1,xcorr_len);
for k = est_begin + 1:est_begin + xcorr_len
    xcorr_fine_sym(k - est_begin) = abs(sum(rx_zc_long.*conj(data(k:k + long_len - 1))));
end
figure (3)
plot(xcorr_fine_sym);
[~,fine_begin_frame] = max(xcorr_fine_sym);
rx_long_trainseq = data(est_begin + fine_begin_frame : est_begin + fine_begin_frame + 2 * long_len - 1);
rx_short_trainseq = data(est_begin + fine_begin_frame - short_len*(num_short - 1) :  est_begin + fine_begin_frame - 1);
data_len = Frame_len -  2 * long_len - short_len*num_short;
rx_data = data(est_begin + fine_begin_frame +  2 * long_len : est_begin + fine_begin_frame +  2 * long_len + data_len - 1);


end

