function [matrix] = bits2photo(bits,row,col)
%UNTITLED13 此处显示有关此函数的摘要
% 这块将0 1bits转化为矩阵表示

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

