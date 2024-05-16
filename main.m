%实现文本或者图片传输
clc
clear
close all

prompt='请选择需要使用的功能[1：传输英文文本  2：传输图像]:'
service=input(prompt);%选择功能
%% 传输文本功能
if service==1
clc
clear
fs = 100e+3;% 采样速率
sr = 5e3;% 码元速率
rate_data = [];
ii = 1;

%% 创建发送对象 ：
 txPluto = sdrtx('Pluto','RadioID','usb:0','CenterFrequency',800*1e6, ...
     'BasebandSampleRate',fs,'ChannelMapping',1,'Gain',0);

%% 创建接收对象 ：
rxPluto = sdrrx('Pluto','RadioID','usb:0','CenterFrequency',800e6, ...
    'BasebandSampleRate',fs,'ChannelMapping',1,'OutputDataType',...
    'double','Gain',20,'SamplesPerFrame',40e4);

%% 密码序列
Code = 'TEST CODE.';
bitCode = GenBitData(Code, 5);
lenCode = length(bitCode);

%% 产生信源
prompt='请输入传输一段英文：'
str_o=input(prompt,'s');
len_str = length(str_o);
bitData = GenBitData(str_o, 90);
nBytes1 = length(str_o)*90;
nCode = 8; %一个字节用8个bit编码

Sdata = [bitCode bitData];
nBytes = nBytes1 + length(Code)*5;
lenSdata = length(Sdata);

% 进行交织
bitData_scramble = matintrlv(Sdata, 10 * nCode, nBytes / 10);

% 映射为QPSK信号
symData = QPSKMap(bitData_scramble);

% 添加训练符号（相偏）
symData = [ones(1, 100), symData];

% 调制
modData = pskmod(symData, 4, pi/4);
len_modData = length(modData);

%% 同步头
onePreData = CreatZC(500);
preData = repmat(onePreData, 1, 2);
preLength = length(preData);

%% 发射滤波器
ipoint = fs/sr;
irfn = 8;
alfa = 0.5; % 由此可以得出带宽是10e3 * (1.5) = 15e3;
sendFilter = rcosdesign(alfa, irfn, ipoint, 'sqrt');
delay = irfn * ipoint / 2;

upData = upsample(modData, ipoint);   %插值
len_upData = length(upData);
toSend_0 = conv(upData, sendFilter,'same');

%% 接收设置
%接收滤波器
ipoint = 20;
irfn = 8;
alfa = 0.5; % 由此可以得出带宽是10e3 * (1.5) = 15e3;
recvFilter = rcosdesign(alfa, irfn, ipoint, 'sqrt');

freqComp = comm.CoarseFrequencyCompensator(...
    'Modulation','QPSK', ...
    'SampleRate',fs, ...
    'FrequencyResolution',1);
symbolSync = comm.SymbolSynchronizer('SamplesPerSymbol', ipoint);
fine = comm.CarrierSynchronizer( ...
    'SamplesPerSymbol',1,'Modulation','QPSK');

%% 最终发送数据
toSend=[preData toSend_0];
toSend=toSend.';

%% 发送接收
while(true)
    i = 0;
    while(i<5)
        i = i+1;
        txPluto(toSend);
    end
    
    [data_o,datavalid,overflow] = rxPluto();
    
    % 找同步头
    result_o = xcorr(data_o,onePreData);
    result = result_o(length(data_o):end);
    
    P1 = figure(1);
    plot(abs(result));
    title(' 同步头互相关')
    
    % 找同步头位置
    pos = find(abs(result) > 200);
    if isempty(pos)
        delete(P1);
        continue;
    end
    [pos_max_val,loc] = max(abs(result(pos(1):pos(1)+50)));
    pos1 = loc+pos(1)-1+500*2;  %截去同步头
    
    % 有用数据
    if length(data_o)<len_upData+pos1-1
        continue;
    end
    data = data_o(pos1:len_upData+pos1-1 );
    P2 = scatterplot(data);
    title('未频偏纠正');
    
    % 粗频偏纠正
    [rxData1, estFreqOffset] = freqComp(data);
    P3 = scatterplot(rxData1);
    title('粗频偏纠正');
    
    % 匹配滤波
    rxData2 = conv(rxData1, recvFilter, 'same');
    P4 = scatterplot(rxData2);
    title('匹配滤波');
    
    % 符号同步
    rxData3 = symbolSync(rxData2);
    if(length(rxData3) < len_modData)
    rxData3 = [rxData3, zeros(1, len_modData - length(rxData3))];
    else
        rxData3 = rxData3(1:len_modData);
    end
    
    P5 = scatterplot(rxData3);
    title('符号同步');
    
    % 相偏纠正
    rxData4 = fine(rxData3);
    P6 = scatterplot(rxData4);
    title('相偏纠正');

    % 相偏纠正
    pre100 = rxData4(1: 100);
    pre50 = pre100(51:end);
    pre50 = pre50.';
    a = repmat(-1+1j,1,50);
    anout = angle(pre50./a);
    anout = mean(anout);    %估计
    
    rxData5 = rxData4./exp(1j*anout);   % 纠正
    rxData5=rxData5(101:end);
    P7 = scatterplot(rxData5);
    title('相偏纠正2');
    
    % PSK解调
    demodData = pskdemod(rxData5, 4, pi/4);
    
    % 符号映射bit
    bitDemap = QPSKDeMap(demodData);

    % 解交织
    bitData_descramble = matdeintrlv(bitDemap, 10 * nCode, nBytes / 10);
    
    % 比较误码率
    [~, rate] = biterr(bitCode, bitData_descramble(1:1200));
    rate_data(ii) = rate;
    ii = ii + 1;
    
    % 是否进行第三次相偏纠正的标志
    flag = 0;
    if rate>=0.01 && rate<=0.9
        
        if rate>=0.5 && rate<=0.9
            flag = 1;
            rxerr=rxData5;
            rxData6 = rxerr./exp(1j*pi/2);   % 纠正
            P11 = scatterplot(rxData6);
            title('相偏纠正3');

            % PSK解调
            demodData = pskdemod(rxData6, 4, pi/4);

            % 符号映射bit
            bitDemap = QPSKDeMap(demodData);

            % 解交织
            bitData_descramble = matdeintrlv(bitDemap, 10 * nCode, nBytes / 10);

            % 比较误码率
            [~, rate] = biterr(bitCode, bitData_descramble(1:1200))
            if rate<=0.01
                flag = 2;
            end
        end
%         if flag ~= 0
%             delete(P11);
%         end
        if flag ~=2
            delete(P1);delete(P2);delete(P3);delete(P4);
            delete(P5);delete(P6);delete(P7);
            continue;
        end
    else
        if rate>0.9
           bitData_descramble = ~bitData_descramble;
           [~, rate] = biterr(bitCode, bitData_descramble(1:1200));
        end
    end
    
    disp(['误码率 ： ',num2str(rate)]);
    str = Bin2Ascii(bitData_descramble);
    disp(str(end-len_str+1:end));
    break;
end

%% 图片传输功能（加密）
elseif service==2
   
clc;close all;clear
while 1
    str=input('请输入用户密码：','s');
    if length(str)==9
        break
    else
        disp('请输入用户密码');
    end
end
% 设置参数
fs = 100e+3;%采样速率
sr = 5e+3;%码元速率
prompt='请输入图片地址：'
pic_name=input(prompt,'s');

image = imread(pic_name);
% image = image(:,:,1);
img_size = size(image);
img_len = Mul(img_size);
img_len_size = length(img_size);% 读取图片

figure(21);
imshow(image);
title('要发送的图片：');

% 加密
image_jiami=jiami(image,str);
image_u8 = uint8(image_jiami);
imshow(image_u8);


reshp_img = reshape(image_jiami,1,img_len);
bin_img = DecToBin(reshp_img);
bin_img_len = length(bin_img);% 将十进制图片RGB转化为二进制

% 信道编码
CCData=double(hamming_encode(bin_img,2)');
len_CCData=length(CCData);

% 处理图片
slice_len =len_CCData/4;       %每片的长度
slice_num = ceil(len_CCData/slice_len);
fx_bin_img = [CCData,zeros(1,slice_num*slice_len-len_CCData)];
len_fx_bin_img = length(fx_bin_img);
data = [];
for ii = 1:1:slice_num
    data(ii,:) = fx_bin_img((ii-1)*slice_len+1:ii*slice_len);
end

% 加密代码
Code = 'TEST CODE.';
bitCode = GenBitData(Code, 5);
lenCode = length(bitCode);

% 密码组合
pre_code = [];
for k = 1:1:slice_num
    pre_code = [pre_code;circshift(bitCode, 7*k)];
end
Source = [pre_code,data];
nBytes = slice_len/8 + length(Code)*5;
nCode = 8;

%% PLUTO发送对象
txPluto = sdrtx('Pluto','RadioID','usb:0','CenterFrequency',800e6, ...
    'BasebandSampleRate',fs,'ChannelMapping',1,'Gain',0);

%% PLUTO接收对象
rxPluto = sdrrx('Pluto','RadioID','usb:0','CenterFrequency',800e6, ...
    'BasebandSampleRate',fs,'ChannelMapping',1,'OutputDataType',...
    'double','Gain',20,'SamplesPerFrame',110e4);

%% 发射滤波器
ipoint = fs/sr;
irfn = 8;
alfa = 0.5; % 由此可以得出带宽是10e3 * (1.5) = 15e3;
sendFilter = rcosdesign(alfa, irfn, ipoint, 'sqrt');

%% 接收滤波器
recvFilter = sendFilter;

freqComp = comm.CoarseFrequencyCompensator(...
    'Modulation','QPSK', ...
    'SampleRate',fs, ...
    'FrequencyResolution',1);
symbolSync = comm.SymbolSynchronizer('SamplesPerSymbol', ipoint);
fine = comm.CarrierSynchronizer( ...
    'SamplesPerSymbol',1,'Modulation','QPSK');

%% 生成同步头
singlePreData = CreatZC(500);
preData = repmat(singlePreData, 1, 2);
preLength = length(preData);
rcv_data = [];

for k = 1:1:slice_num
    %% 交织
    bitData_scramble = matintrlv(Source(k,:), 10 * nCode, nBytes / 10);
    len_bitData_scramble= length(bitData_scramble);
    
    %% 调制
    % 映射为QPSK信号
    symData = QPSKMap(bitData_scramble);
    
    % 添加训练符号（纠正相偏）
    symData1 = [ones(1, 100), symData];
    
    % 调制
    modData = pskmod(symData1, 4, pi/4);
    len_modData = length(modData);
    P9=scatterplot(modData);
    title('已调信号星座图');
    
    %% 滤波
    upData = upsample(modData, ipoint);   %插值
    len_upData = length(upData);
    toSend1 = conv(upData, sendFilter,'same');
    
    %% 最终发送数据
    toSend2=[preData toSend1];
    toSend=toSend2.';
    P10=scatterplot(toSend);
    title('已调信号经发射滤波器后星座图');
    
    %% 发送接收
    state = false;
    count1=0;
    while(true)
        pause(0.1);
        i = 0;
        while(i<1)
            i = i+1;
%             tic;
            txPluto(toSend);
        end
        
        [data,datavalid,overflow] = rxPluto();
%         toc;
        % 计算互相关，找同步头
        result = xcorr(data,singlePreData);
        result = result(length(data):end);
        
        P1 = figure(20);
        plot(abs(result));
        title(' 同步头互相关')
        
        % 找同步头位置
        pos = find(abs(result) > 100);
        if isempty(pos)
            delete(P1);
            count1=count1+1;
            %             disp('没找到同步头')
            continue;
        end
        
        [pos_max,loc] = max(abs(result(pos(1):pos(1)+50)));
        pos1 = loc+pos(1)-1+500*2;  %截去同步头
        
        % 有用数据
        if length(data)<len_upData+pos1-1
            %             disp('有用数据不够')
            continue;
        end
        data = data(pos1:len_upData+pos1-1 );
        P2 = scatterplot(data);
        title('未进行频偏纠正');
        %         saveas(P2, '未进行频偏纠正.jpg')
        
        % 粗频偏纠正
        [rxData2, estFreqOffset] = freqComp(data);
        P3 = scatterplot(rxData2);
        title('粗频偏纠正');
        %         saveas(P3, '粗频偏纠正.jpg')
        
        % 接收滤波
        rxData1 = conv(rxData2, recvFilter, 'same');
        P4 = scatterplot(rxData2);
        title('接收滤波');
        %         saveas(P4, '接收滤波.jpg')
        
        rxData3 = symbolSync(rxData1);
        if(length(rxData3) < len_modData)
            %             continue;
            rxData3 = [rxData3; zeros( len_modData - length(rxData3)),1];
            
        else
            rxData3 = rxData3(1:len_modData);
        end
        
        P5 = scatterplot(rxData3);
        title('符号同步');
        %         saveas(P5, '符号同步.jpg')
        
        rxData4 = fine(rxData3);
        P6 = scatterplot(rxData4);
        title('相偏纠正');
        %         saveas(P6, '相偏纠正.jpg')
        
        % 相偏纠正
        pre100 = rxData4(1: 100);
        pre50 = pre100(51:end);
        pre50 = pre50.';
        a = repmat(-1+1j,1,50);
        anout = angle(pre50./a);
        if sum(abs(anout)>pi*0.75==1)~=0
            pre50=pre50.*1j;
        end
        anout = angle(pre50./a);
        anout = mean(anout);    %估计
        
        rxData4 = rxData4./exp(1j*anout);   % 纠正
        rxData4=rxData4(101:end);
        P7 =scatterplot(rxData4);
        title('相偏纠正2');
        %         saveas(P7, '相偏纠正2.jpg')
        
        % PSK解调
        demodData = pskdemod(rxData4, 4, pi/4);
        
        % 符号映射bit
        bitDemap = QPSKDeMap(demodData);
        
        % 解交织
        bitData_descramble = matdeintrlv(bitDemap, 10 * nCode, nBytes / 10);
        
        % 比较误码率
        [~, rate] = biterr(pre_code(k,:), bitData_descramble(1:1200));
%         disp(['信道误信率',num2str(rate)]);
        % 是否进行第三次相偏纠正的标志
        flag = 0;
        if rate>=0.01 && rate<=0.99
            if rate>=0.02 && rate<=0.99
                
%                 disp('第三次频偏纠正');
                flag = 1;
                % pi/2相偏纠正
                rxData6 = rxData4./exp(1j*pi/2);   % 纠正
                P11 = scatterplot(rxData6);
                title('相偏纠正3');
                
                % PSK解调
                demodData = pskdemod(rxData6, 4, pi/4);
                
                % 符号映射bit
                bitDemap = QPSKDeMap(demodData);
                
                % 解交织
                bitData_descramble = matdeintrlv(bitDemap, 10 * nCode, nBytes / 10);
                
                % 比较误码率
                [~, rate] = biterr(pre_code(k,:), bitData_descramble(1:1200));
                if rate<=0.001
                    flag = 2;
                else
                    delete(P11);
                    % 3pi/2相偏纠正
                    rxData6 = rxData4./exp(1j*3*pi/2);   % 纠正
                    P11 = scatterplot(rxData6);
                    title('相偏纠正3');
                    
                    % PSK解调
                    demodData = pskdemod(rxData6, 4, pi/4);
                    
                    % 符号映射bit
                    bitDemap = QPSKDeMap(demodData);
                    
                    % 解交织
                    bitData_descramble = matdeintrlv(bitDemap, 10 * nCode, nBytes / 10);
                    
                    % 比较误码率
                    [~, rate] = biterr(pre_code(k,:), bitData_descramble(1:1200));
%                     disp(['信道误信率',num2str(rate)]);
                    if rate<=0.02 %%%%%%
                        flag = 2;
                    end
                end
            end
            if flag ~= 0
                delete(P11);
            end
            if flag ~=2
                delete(P1);delete(P2);delete(P3);delete(P4);
                delete(P5);delete(P6);delete(P7);
                %                 disp('相偏纠正失败');
                continue;
            end
        else
            if rate>0.99
                bitData_descramble = ~bitData_descramble;
                [~, rate_pi] = biterr(Source(k,:), bitData_descramble);
            end
        end
        
        [~, rate_end] = biterr(Source(k,:), bitData_descramble);
         disp(['信道误信率 ： ',num2str(rate_end)]);
        rcv_data = [rcv_data,bitData_descramble(1201:end)];
        if k==1
            saveas(P1, '与同步头的互相关.jpg');
            saveas(P2, '未进行频偏纠正.jpg');
            saveas(P3, '粗频偏纠正.jpg');
            saveas(P4, '匹配滤波.jpg');
            saveas(P5, '符号同步.jpg');
            saveas(P6, '相偏纠正.jpg');
            saveas(P7, '相偏纠正2.jpg');
            %             saveas(P11, '相偏纠正3.jpg');
            saveas(P9, '已调信号星座图.jpg');
            saveas(P10, '已调信号经发射滤波器后星座图.jpg');
        end
        delete(P1);delete(P2);delete(P3);delete(P4);
        delete(P5);delete(P6);delete(P7);delete(P9);delete(P10);%delete(P11);
%         disp('done')
        break;
    end
end

bin_img_rcv = rcv_data(1:len_CCData);
% 解码
CC_DEData= double(hamming_decode(bin_img_rcv,2));

% 二进制转十进制
img_dec = BinToDec(CC_DEData);
% 恢复图像
rsp_img = reshape(img_dec,img_size(1),img_size(2),img_size(3));

rsp_img_u8 = uint8(rsp_img);
figure(22);
imshow(rsp_img_u8);
title('收到的未解密图片');
% 解密
while 1
    r1=input('请输入用户密码：','s');
    if length(r1)==9
        break
    else
        print('请输入用户密码：')
    end
end
rsp_img=jiemi1(rsp_img,r1);
% 总误码率
rsp_size = size(rsp_img);
rsp_img_len = Mul(rsp_size);

rate_all= sum(sum(sum(rsp_img-double(image)~=0)))./rsp_img_len;
disp('rate_all=');
disp(rate_all);
% 显示图片
rsp_img_u8 = uint8(rsp_img);
figure(23);
imshow(rsp_img_u8);
title('接收端收到的解密后图片');


end