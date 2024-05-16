function [seldata_code] = conv_code(seldata,code_rate)

if(code_rate == 1)
    seldata_code = seldata;
elseif(code_rate == 1/2)
    t = poly2trellis(7,[171,133]); %¾í»ıÂë±àÂë
    seldata_code = convenc(seldata,t);
elseif(code_rate == 3/4)
    t = poly2trellis(7,[171,133]);
    seldata_code_temp = convenc(seldata,t);
    punch_pattern = [1 1 1 0 0 1];
    punch_index = punch_pattern == 1;
    punch_size = length(punch_pattern);
    paldata_code = reshape(seldata_code_temp,punch_size,[]);
    seldata_code = paldata_code(punch_index,:);
end
    

end

