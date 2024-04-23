clc; clear all; close all;

%% Add utils path
addpath(genpath('.\utils'));

%% Input

T = 2;

switch T
    case 1
        numerator = [1, -1-1.2i, -0.96-0.72i];   % H(z)的分子
        denominator = [1, -0.9]; % H(z)的分母
    case 2
        numerator = [1, 0.6; 1, -1.6-1.2i]; % H(z)的分子
        denominator = [1, -0.9]; % H(z)的分母
        numerator_temp = numerator(1,:);
        if length(numerator) > 1
            for n = 1:length(numerator(:,1))-1
                numerator_temp = conv(numerator_temp,numerator(n+1,:));
            end
            numerator = numerator_temp;
        end
        denominator_temp = denominator(1,:);
        if length(denominator(:,1)) > 1
            for n = 1:length(denominator)-1
                denominator_temp = conv(denominator_temp,denominator(n+1,:));
            end
            denominator = denominator_temp;
        end
end


%% H(z)可視化
numerator_visual = polynomial_visual(numerator); 
denominator_visual = polynomial_visual(denominator);
fprintf(['Original type: \nH(z) = (', numerator_visual, ') / (', denominator_visual, ')\n\n'])

%% H(z)因式分解可視化
numerator_root = roots(numerator);
denominator_root = roots(denominator);

C = 1;
numerator_root_vis = roots_visual(numerator_root, C);
denominator_root_vis = roots_visual(denominator_root, C);
fprintf(['factorization: \nH(z) = ', numerator_root_vis, ' / ', denominator_root_vis, '\n\n'])

%% 確認每一個pole和zeros都在單位圓上
check = 0;
for i = 1:length(numerator_root)
    if abs(numerator_root(i)) > 1
        check = check + 1;
        C1 = numerator_root(i);
        C = C * C1;
        numerator_root(i) = conj(1/C1);
    end
end

numerator_root_vis = roots_visual(numerator_root, C);
fprintf(['Move pole from outside to inside: \nH(z) = ', numerator_root_vis, ' / ', denominator_root_vis, '\n\n'])

%% 轉為z^-1形式

minimum_phase = phase_transform(numerator_root, denominator_root, C);

fprintf(['Minimum phase: \nH(z) = ', minimum_phase, '\n\n'])