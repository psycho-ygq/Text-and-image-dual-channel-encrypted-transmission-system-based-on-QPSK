function [H_est] = chan_est(paldata_pilot,system,h)

if(nargin <= 2)
    zc_seq = system.ZC_seq;
    pilot_tx = repmat(zc_seq.',1,system.Pilot_ofdm);
    H_est_temp = paldata_pilot./pilot_tx;
    
    % ��ֵ�ڲ壬�����ڶ����ձȽ�С�����
    H_est = repmat(mean(H_est_temp,2),1,system.Data_ofdm);
    
else
    % �����ŵ�����
    H_est_temp = fft(h,system.FFTlen);
    H_est_temp = reshape(H_est_temp,system.FFTlen,1);
    H_est = repmat(H_est_temp,1,system.Data_ofdm);
end

