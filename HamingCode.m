function h = HamingCode(a,k)
 %% 2^k>n+k
 
n=length(a(:));
z=1;
j=1;
h=zeros(1,n+k);
for i=1:n+k                 %将输入数组写入全零矩阵待用，且跳过验证
    if i==2^(z-1)
        z=z+1;
        continue
    else 
        h(i)=a(j);
        j=j+1;
    end
end
 
if k==4
    h(1)=rem(h(3)+h(5)+h(7)+h(9)+h(11),2);
    h(2)=rem(h(3)+h(6)+h(7)+h(10)+h(11),2);
    h(4)=rem(h(5)+h(6)+h(7),2);
    h(8)=rem(h(9)+h(10)+h(11),2);
    
    else if k==3
        h(1)=rem(h(3)+h(5)+h(7),2);
        h(2)=rem(h(3)+h(6)+h(7),2);
        h(4)=rem(h(5)+h(6)+h(7),2);
 
    else if k==2
        h(1)=rem(h(3),2);
        h(2)=rem(h(3),2);
        end
        end
end