function [demod_qpsk] = QPSK_demod_soft(data_mod)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   QPSK���
data_mod = data_mod.*sqrt(2);
demod_qpsk = zeros(size(data_mod,1),size(data_mod,2)*2);
real_signal = real(data_mod);
imag_signal = imag(data_mod);

demod_qpsk(:,1:2:end) = real_signal;
demod_qpsk(:,2:2:end) = imag_signal;

end