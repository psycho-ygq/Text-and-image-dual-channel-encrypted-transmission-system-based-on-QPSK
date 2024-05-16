function [snr_est_dB] = snr_estimate(paldata_signal,system)
% snr estimate
if(nargin == 2) % 导频估计信噪比
    pilot = paldata_signal(:,system.Pilot_loc);
    % pilot = reshape(pilot,system.FFTlen / 4,[]);
    s_pow = mean(mean(abs(pilot).^2));
    noise = pilot(:,1:end - 1) - pilot(:,2:end);
    n_pow = mean(mean(abs(noise).^2)) / 2;
    snr_est = s_pow / n_pow;
    snr_est_dB = 10*log10(snr_est);
else
    paldata_signal = reshape(paldata_signal,[],9);
    s_pow = mean(mean(abs(paldata_signal).^2));
    noise = paldata_signal(:,1:end - 1) - paldata_signal(:,2:end);
    n_pow = mean(mean(abs(noise).^2)) / 2;
    snr_est = s_pow / n_pow;
    snr_est_dB = 10*log10(snr_est); 
    
end


end

