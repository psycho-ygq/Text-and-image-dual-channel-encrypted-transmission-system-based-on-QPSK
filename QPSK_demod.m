function [demod_qpsk] = QPSK_demod(data_mod)
%UNTITLED4 此处显示有关此函数的摘要
%   QPSK解调
data_mod = data_mod.*sqrt(2);
demod_qpsk = zeros(size(data_mod,1),size(data_mod,2)*2);
real_signal = real(data_mod) > 0;
imag_signal = imag(data_mod) > 0;

demod_qpsk(:,1:2:end) = real_signal;
demod_qpsk(:,2:2:end) = imag_signal;

end

