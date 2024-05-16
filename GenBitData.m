function bitData = GenBitData(str, repeat)
one = Ascii2Bin(str);
bitData = repmat(one, 1, repeat);
end