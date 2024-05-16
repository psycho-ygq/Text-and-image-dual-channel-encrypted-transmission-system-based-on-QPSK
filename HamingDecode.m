function h = HamingDecode(a,k)
%a=[1,0,1,1,0,1,0,1,1,1,0];
n=length(a(:));     %求输入数组长度
h=zeros(1,n-k);     %解码和译码的n含义不同
check=zeros(1,k);   %四个组的验证数组
che=0;
if k==4
    if  a(1)~=rem(a(3)+a(5)+a(7)+a(9)+a(11),2);                 %四个组，如果有任意一个组验证不通过，则相应数组的变量变为1，标志位che变成1，方便后面修改
        check(1)=1
        che=1
        else if  a(2)~=rem(a(3)+a(6)+a(7)+a(10)+a(11),2);
                check(2)=1
                che=1;
        else if  a(4)~=rem(a(5)+a(6)+a(7),2);
                check(4)=1
                che=1;
        else if  a(8)~=rem(a(9)+a(10)+a(11),2);
                check(8)=1
                che=1;
            end
            end
            end
    end
j=1;
z=1;
    if che==1           %假如验证生效
        s= 2^(3*check(1))+2^(2*check(2))+2^(1*check(3))+2^(check(4)*0)
        a(s)=1-a(s)
    end
    
    for i=1:n           %跳过验证码，将数组写入输出数组
        if i==2^(z-1)
            z=z+1;
            continue
        else 
            h(j)=a(i);
            j=j+1;
        end
    end
end