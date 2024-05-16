function kk=jiemi1(e,str)
e=double(e);
[a,b,c]=size(e);
e=floor(e);
for i=1:9
    data(i)=str2num(str(i));
end

data(1)=data(1)/10+0.01;
data(2)=data(2)/10+0.01;
data(3)=data(3)/10+0.01;



m3(1)=data(1);
m4(1)=data(2);
m5(1)=data(3);


data(4)=3.7+0.02*data(4);
data(5)=0.002*data(5);
data(6)=3.7+0.02*data(6);
data(7)=0.002*data(7);
data(8)=3.7+0.02*data(8);
data(9)=0.002*data(9);

u1=data(4)+data(5);
u2=data(6)+data(7);
u3=data(8)+data(9);

N=a*b*c;
for i=1:N-1
    m3(i+1)=u1*m3(i)*(1-m3(i));
end
m3=mode(255*m3,256);
m3=uint8(m3);

for i=1:N-1
    m4(i+1)=u2*m4(i)*(1-m4(i));
end
m4=mode(255*m4,256);
m4=uint8(m4);

for i=1:N-1
    m5(i+1)=u3*m5(i)*(1-m5(i));
end
m5=mode(255*m5,256);
m5=uint8(m5);

n=1;
m3=double(m3);
m4=double(m4);
m5=double(m5);

for i=1:a
    for j=1:b
        for k=1:c
            kk(i,j,k)=m3(n)+m4(n);
            kk(i,j,k)=bitxor(kk(i,j,k),m5(n));
            kk(i,j,k)=e(i,j,k)-kk(i,j,k);
            kk(i,j,k)=mod(kk(i,j,k),255);
            n=n+1;
        end
    end
end