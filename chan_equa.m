function [paldata_equa] = chan_equa(H_est,paldata_data,snr_est_dB)

if(nargin > 2)
    snr_est = 10^(snr_est_dB/10);
    paldata_equa = paldata_data .* conj(H_est)./(abs(H_est).^2 + 1/snr_est);
else
    paldata_equa = paldata_data./H_est;
end

end

