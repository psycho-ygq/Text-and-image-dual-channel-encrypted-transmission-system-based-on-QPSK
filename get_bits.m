function [origin_bits,row,col] = get_bits(service)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   ���ݲ�ͬҵ�����Ͳ���01����
% service1 : ����ҵ��
% service2 : ͼ��ҵ��
% service3 : ����ҵ��

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
        imdata = imread('�϶����.jpg'); %��ȡͼƬ�ļ��е�����
        figure(9)
        imshow(imdata);
        title('����ǰԭʼͼƬ')
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
%         title('������ͼƬ')
    case 3
        a = '��Һã�����ITSPʵ���ҵ�һԱ��';
        disp('ԭʼ�ı���')
        disp(a);
        a1 = unicode2native(a);
        abin = de2bi(a1);
        
        row = size(abin,1);
        col = size(abin,2);
        origin_bits = double(abin(:).');
        
end
end

