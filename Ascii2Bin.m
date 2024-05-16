function bitData = Ascii2Bin(str)
    assert(size(str, 1) == 1); % 保证是行向量
    temp = abs(str);
    tempData = de2bi(temp, 8);
    row = size(tempData, 1);
    bitData = reshape(tempData', 1, row * 8);
end