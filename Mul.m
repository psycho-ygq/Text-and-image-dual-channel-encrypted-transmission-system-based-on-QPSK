function y = Mul(z)

a = length(z);
b = 1;
for i = 1:1:a
    b = b*z(i);
end

y = b;
    