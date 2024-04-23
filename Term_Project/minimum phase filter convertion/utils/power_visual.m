function pow_vis = power_visual(num)

digits = num2str(num);

result = repmat(' ', 1, length(digits));
for i = 1:length(digits)
    switch digits(i)
        case '1'
            result(i) = '¹';
        case '2'
            result(i) = '²';
        case '3'
            result(i) = '³';
        case '4'
            result(i) = '⁴';
        case '5'
            result(i) = '⁵';
        case '6'
            result(i) = '⁶';
        case '7'
            result(i) = '⁷';
        case '8'
            result(i) = '⁸';
        case '9'
            result(i) = '⁹';
        case '0'
            result(i) = '⁰';
        case '-'
            result(i) = '⁻';
    end
end

if num == 1 || num == 0
    result = '';
end
pow_vis = result;
% fprintf(['z', result, '\n'])

