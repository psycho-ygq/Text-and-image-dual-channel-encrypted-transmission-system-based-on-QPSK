function [origin_bits,row,col] = get_bits(service)
%UNTITLED6 此处显示有关此函数的摘要
%   根据不同业务类型产生01比特
% service1 : 语音业务
% service2 : 图像业务
% service3 : 文字业务

switch(service)
    case 1    
        load('sound.mat','y');
        
        figure(1)
        sound(y,10000);
        plot(y);
        
        bits_num = 8;
        delta = 2^(bits_num - 1);
        y1 = round(y.*delta);
        
        y2 = fliplr(de2bi(abs(y1),bits_num - 1));
        bits = zeros(length(y),bits_num);
        bits(:,1) = y1 < 0;
        bits(:,2:end) = y2;
        row = size(bits,1);
        col = size(bits,2);
        origin_bits = bits(:).';
    case 2
        imdata = imread('嫦娥五号.jpg'); %读取图片文件中的数据
        figure(9)
        imshow(imdata);
        title('传输前原始图片')
        BinSer1 = double(imdata(:,:,1));
        index1 = BinSer1 > 128;
        index2 = BinSer1 < 128;
        BinSer2 = zeros(size(BinSer1));
        BinSer2(index1) = 1;
        BinSer2(index2) = 0;
        row = size(BinSer2,1);
        col = size(BinSer2,2);
        origin_bits = BinSer2(:).';
%         figure(2)
%         imshow(BinSer2);
%         title('传输后的图片')
    case 3
        a = '大家好，我是ITSP实验室的一员。';
        disp('原始文本：')
        disp(a);
        a1 = unicode2native(a);
        abin = de2bi(a1);
        
        row = size(abin,1);
        col = size(abin,2);
        origin_bits = double(abin(:).');
        
end
end

