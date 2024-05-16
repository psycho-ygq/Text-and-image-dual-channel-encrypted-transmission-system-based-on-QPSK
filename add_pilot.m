function  [paldata_add_pilot] = add_pilot(paldata_mod,system)
% Ìí¼Óµ¼Æµ

% pilot is generated from zc sequence 
zc_seq = system.ZC_seq;
pilot = repmat(zc_seq.',1,system.Pilot_ofdm);
%
data_loc = system.Data_loc;
pilot_loc = system.Pilot_loc;
paldata_add_pilot = zeros(system.FFTlen,system.Sym_ofdm);
paldata_add_pilot(:,data_loc) = paldata_mod;
paldata_add_pilot(:,pilot_loc) = pilot;

end

