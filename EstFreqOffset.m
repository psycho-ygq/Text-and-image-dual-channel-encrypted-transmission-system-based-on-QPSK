function freqOffset = EstFreqOffset(input, ml, fs)
fftLength = 2^16;
if(length(input) > fftLength)
    offsetData = input(1:fftLength);
end
sigNoMod = offsetData.^ml;
freqHist = abs(fft(sigNoMod, fftLength));
[~, maxIndex] = max(freqHist);
offsetIndex = maxIndex - 1;
if (offsetIndex > fftLength/2)
    offsetIndex = offsetIndex - fftLength;
end
df = fs / fftLength;
freqOffset = offsetIndex * df / ml;
end