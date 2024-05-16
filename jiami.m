function e=jiami(x,str)
%需要输入一个九位密码

%密码输入范例
% while 1
% r=input('请输入加密密钥key：','s');
% if length(r)==9
%     break
% else 
%     print('请输入九位密码')
% end
% end

for i=1:9
data(i)=str2num(str(i));
end

data(1)=data(1)/10+0.01;
data(2)=data(2)/10+0.01;
data(3)=data(3)/10+0.01;

data(4)=3.7+0.02*data(4);
data(5)=0.002*data(5);
data(6)=3.7+0.02*data(6);
data(7)=0.002*data(7);
data(8)=3.7+0.02*data(8);
data(9)=0.002*data(9);

m(1)=data(1);
m1(1)=data(2);
m2(1)=data(3);
[a,b,c]=size(x);
N=a*b*c;
u1=data(4)+data(5);
u2=data(6)+data(7);
u3=data(8)+data(9);

%u=4;
for i=1:N-1
    m(i+1)=u1*m(i)*(1-m(i));
end
m=mode(255*m,256);
m=uint8(m);


for i=1:N-1
    m1(i+1)=u2*m1(i)*(1-m1(i));
end
m1=mode(255*m1,256);
m1=uint8(m1);

for i=1:N-1
    m2(i+1)=u3*m2(i)*(1-m2(i));
end
m2=mode(255*m2,256);
m2=uint8(m2);
n=1;
x=double(x);
m=double(m);
m1=double(m1);
m2=double(m2);
for i=1:a
    for j=1:b
        for k=1:c
       e(i,j,k)=m(n)+m1(n);
       e(i,j,k)=bitxor(e(i,j,k),m2(n));
       e(i,j,k)=e(i,j,k)+x(i,j,k);
       e(i,j,k)=mod(e(i,j,k),255);
       n=n+1;
        end
    end
end
