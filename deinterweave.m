function  [seldata_deinter] = deinterweave(paldata_demod)

 seldata = paldata_demod(:).';
 data_num = length(seldata);
 row = floor(sqrt(data_num));
 while(rem(data_num,row) ~= 0)
     row = row + 1;
 end
 inter_depth = row;
 
paldata = reshape(seldata,[],inter_depth);
paldata = paldata.';
seldata_deinter = paldata(:).';
 
%  seldata = paldata_demod(:).';
%  data_num = length(seldata);
%  row = floor(sqrt(data_num));
%  while(rem(data_num/4,row) ~= 0 || rem(row,2)~=0)
%      row = row + 1;
%  end
%  inter_depth = row;
%  paldata_code = reshape(seldata,[],inter_depth);
%  paldata_code_temp = zeros(size(paldata_code));
%  paldata_code_temp(:,1:2:end) = paldata_code(:,1:2:end);
%  paldata_code_temp(1:2:end,2:2:end) = paldata_code(2:2:end,2:2:end);
%  paldata_code_temp(2:2:end,2:2:end) = paldata_code(1:2:end,2:2:end);
%  seldata_deinter = paldata_code_temp(:).';


end

