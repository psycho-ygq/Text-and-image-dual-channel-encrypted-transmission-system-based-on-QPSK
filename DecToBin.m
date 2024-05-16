function y = DecToBin(z)

len_z = length(z);
y = [];
for  k = 1:1:len_z
    a = dec2bin(z(k),8);
    for kk = 1:1:8
        b(kk) = str2double(a(kk));
    end
    y = [y,b];
end

    