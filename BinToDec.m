function y1 = BinToDec(z)

%z = [1,1,1,0,1,0,0,0,0,0,0,0,0,1,1,0];

len_z  = length(z);

y1 = [];
for k = 1:8:len_z
    a = z(k:k+7);
    for kk = 1:1:8
        b(kk) = num2str(a(kk));
    end
    c = bin2dec(b);
    y1 = [y1,c];
end