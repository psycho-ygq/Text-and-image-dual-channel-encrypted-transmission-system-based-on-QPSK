function [bitData] = QPSKDeMap(symData)
% ֱ�Ӿ���10����ת2���ƾͿ�����
temp = de2bi(symData, 2);
temp = temp';
bitData = reshape(temp, 1, 2 * length(symData));
end