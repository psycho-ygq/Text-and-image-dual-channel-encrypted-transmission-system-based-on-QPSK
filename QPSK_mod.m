function [output] = QPSK_mod(input)
%% QPSK µ÷ÖÆ
real = input(:,1:2:end);
imag = input(:,2:2:end);
output = (2.*real - 1) + (2.*imag - 1).*1i;
output = output./sqrt(2);
end

