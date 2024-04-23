function minimum_phase = phase_transform(numerator_root, denominator_root, C)

R = length(numerator_root);
S = length(denominator_root);
z_pow = R - S;

numerator_vis = '';
denominator_vis = '';

pow_vis = power_visual(-1);

for i = 1:length(numerator_root)
    numerator_vis = [numerator_vis, '[1-(', num2str(numerator_root(i)), ')z', pow_vis, ']'];
end

for i = 1:length(denominator_root)
    denominator_vis = [denominator_vis, '[1-(', num2str(denominator_root(i)), ')z', pow_vis, ']'];
end

z_pow = power_visual(z_pow);
minimum_phase = ['(', num2str(C), ')z', z_pow, numerator_vis, ' / ', denominator_vis];

% if z_pow == 1
%     minimum_phase = ['(', num2str(C), ')z', numerator_vis, ' / ', denominator_vis];
% else
%     minimum_phase = ['(', num2str(C), ')z^', num2str(z_pow), numerator_vis, ' / ', denominator_vis];
% end
