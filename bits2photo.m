function [matrix] = bits2photo(bits,row,col)
%UNTITLED13 �˴���ʾ�йش˺�����ժҪ
% ��齫0 1bitsת��Ϊ�����ʾ

matrix_temp = reshape(bits,row,col);
index1 = matrix_temp == 0;
index2 = matrix_temp == 1;

matrix_temp(index1) = 0;
matrix_temp(index2) = 255;

matrix = zeros(row,col,3);
matrix(:,:,1) = matrix_temp;
matrix(:,:,2) = matrix_temp;
matrix(:,:,3) = matrix_temp;

end

