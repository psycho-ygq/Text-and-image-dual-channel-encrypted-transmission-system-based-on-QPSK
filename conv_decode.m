function [seldata_decode] = conv_decode(seldata_code,code_rate,system)
if(nargin == 2)
    if(code_rate == 1)
        seldata_decode = seldata_code;
    elseif(code_rate == 1/2)
        t = poly2trellis(7,[171,133]);
        tblen = 30;
        [~,qcode] = quantiz(seldata_code,-15/16:1/16:15/16,0:1:31);
        seldata_decode = vitdec(qcode,t,tblen,'trunc','soft',5);
    end
else
    if(code_rate == 3/4)
        encode_bits = system.FFTlen * system.Data_ofdm * system.Mod_order * system.Code_rate * 2;
        punch_pattern = [1 1 1 0 0 1];
        punch_index = punch_pattern == 1;
        punch_len = length(find(punch_pattern == 1));
        remainder = rem(length(seldata_code),punch_len);
        seldata_temp = seldata_code(1:end - remainder);
        remaind_bits = seldata_code(end - remainder + 1 : end);
        
        paldata = reshape(seldata_temp, punch_len ,[]);
        paldata_temp = zeros(length(punch_pattern),size(paldata,2));
        paldata_temp(punch_index,:) = paldata;
        paldata_temp = paldata_temp(:).';
        
        remaind_bits_num = zeros(1,encode_bits - length(paldata_temp));
        index = punch_pattern(1:length(remaind_bits_num)) == 1;
        remaind_bits_num(index) = remaind_bits;
        
        seldata_code = [paldata_temp remaind_bits_num];
        
        t = poly2trellis(7,[171,133]);
        tblen = 30;
        [~,qcode] = quantiz(seldata_code,(-15/16 : 1/16 : 15/16),0:1:31);
        seldata_decode = vitdec(qcode,t,tblen,'trunc','soft',5);
    end
end

end

