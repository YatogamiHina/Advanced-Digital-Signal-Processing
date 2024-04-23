function poly_vis = polynomial_visual(polynomial)

poly_vis = '';

for i = 1:length(polynomial)
    k = length(polynomial) - i;
    pow_vis = power_visual(k);
    coef = num2str(polynomial(i));

    if length(find(coef == '-')) > 0 || length(find(coef == 'i')) > 0
        coef = ['(', coef, ')'];
    end

    if i == 1
        poly_vis = [coef, 'z', pow_vis];
    elseif k == 0
        if polynomial(i) == 0
            continue
        else
            poly_vis = [poly_vis , ' + ' , coef];
        end
    elseif polynomial(i) == 0
        continue
    else
        poly_vis = [poly_vis , ' + ' , coef, 'z', pow_vis];
    end
end