function y = Gen_bit_Duan(z)
%z = [400,300,3];
len_num = 8;

len_z = length(z);

y = [];

for k = 1:1:len_z
    a = dec2bin(z(k),len_num);
    for kk = 1:1:len_num
        b(kk) = str2double(a(kk));
    end
    y = [y,b];
end
