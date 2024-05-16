function [rx_data,phase_ave] = phase_offset_correct(rx_data,rx_short_trainseq,rx_long_trainseq,short_len)
%UNTITLED 此处显示有关此函数的摘要
% 纠正相位偏移

% short_zc_seq = gen_zc_sequence(short_len);
% rx_short_zc = reshape(rx_short_trainseq,[],short_len);
% rx_short_zc = mean(rx_short_zc);
% phase = angle(short_zc_seq .* conj(rx_short_zc));
% phase = unwrap(phase);
% phase_ave = mean(phase);
% rx_data = rx_data.*exp(1j*phase_ave);


short_zc_seq = gen_zc_sequence(short_len);
short_zc = repmat(short_zc_seq,1,length(rx_short_trainseq)/short_len);
phase = angle(short_zc .* conj(rx_short_trainseq));
phase = unwrap(phase);
phase_ave = mean(phase);
rx_data = rx_data.*exp(1j*phase_ave);


% long_zc_seq = gen_zc_sequence(64);
% % rx_long_zc = (rx_long_trainseq(33:96) + rx_long_trainseq(97:160))./2;
% rx_long_zc = rx_long_trainseq(33:96);
% phase = angle(long_zc_seq .* conj(rx_long_zc));
% phase_ave = mean(phase);
% rx_data = rx_data.*exp(1j*phase_ave);

end

