function  [seldata_inter] = interweave(seldata_code)
 % 块交织
 data_num = length(seldata_code);
 row = floor(sqrt(data_num));
 while(rem(data_num,row) ~= 0)
     row = row + 1;
 end
 inter_depth = row;
 
 paldata_code = reshape(seldata_code,inter_depth,[]);
 paldata_code = paldata_code.';
 seldata_inter = paldata_code(:).';
 
 % 两次交织
 
%  data_num = length(seldata_code);
%  row = floor(sqrt(data_num));
%  while(rem(data_num/4,row) ~= 0 || rem(row,2)~=0)
%      row = row + 1;
%  end
%  inter_depth = row;
%  paldata_code = reshape(seldata_code,inter_depth,[]);
%  paldata_code = paldata_code.';
%  paldata_code_temp = zeros(size(paldata_code));
%  paldata_code_temp(:,1:2:end) = paldata_code(:,1:2:end);
%  paldata_code_temp(1:2:end,2:2:end) = paldata_code(2:2:end,2:2:end);
%  paldata_code_temp(2:2:end,2:2:end) = paldata_code(1:2:end,2:2:end);
%  seldata_inter = paldata_code_temp(:).';

end

