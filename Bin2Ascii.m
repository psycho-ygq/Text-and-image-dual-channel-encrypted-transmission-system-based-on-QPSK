function  str = Bin2Ascii(bitData)
assert(size(bitData, 1) == 1); % ��֤��������
bitData = reshape(bitData, 8, length(bitData) / 8);
str = bi2de(bitData');
str = char(str)';
end