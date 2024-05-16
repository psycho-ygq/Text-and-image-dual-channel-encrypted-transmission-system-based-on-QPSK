function [preamble] = get_preamble
% 产生前导序列

STF = [0 0 1+1j 0 0 0 -1-1j 0 0 0 1+1j 0 0 0 -1-1j 0 0 0 -1-1j 0 0 0 1+1j 0 0 0 0 ...
     0 0 0 -1-1j 0 0 0 -1-1j 0 0 0 1+1j 0 0 0 1+1j 0 0 0 1+1j 0 0 0 1+1j 0 0].*sqrt(13/6);

LTF = [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 ...
    1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];

sub_carrier_index = [(2:27) (39:64)];
STF_Map = zeros(1,64);
STF_Map(sub_carrier_index) = [STF(end - 26 + 1 : end) STF(1:26)];
STF_time = ifft(STF_Map,64).*sqrt(64);
short_sequence = STF_time(1:16);

LTF_Map = zeros(1,64);
LTF_Map(sub_carrier_index) = [LTF(end - 26 + 1 : end) LTF(1:26)];
LTF_time = ifft(LTF_Map,64).*sqrt(64);
long_sequence = LTF_time;

preamble = [repmat(short_sequence,1,10) long_sequence(end - 32 + 1 : end) ...
    long_sequence long_sequence];


end

