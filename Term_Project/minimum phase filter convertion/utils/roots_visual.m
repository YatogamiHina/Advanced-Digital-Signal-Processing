function r_vis = roots_visual(polynomial_root, C)

r_vis = '';
if C == 1
    for i = 1:length(polynomial_root)
        r_vis = [r_vis, '[z-(', num2str(polynomial_root(i)), ')]'];
    end
else
    for i = 1:length(polynomial_root)
        r_vis = [r_vis, '[z-(', num2str(polynomial_root(i)), ')]'];
    end
    r_vis = ['(', num2str(C), ')',r_vis];
end
