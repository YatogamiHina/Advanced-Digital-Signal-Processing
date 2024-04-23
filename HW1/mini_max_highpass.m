function [iteration, E_iteration, s, h] = mini_max_highpass(filter_length, sampling_frequency, pass_band_frequency, transition_band_frequency, weighting, delta, interval)
% Initial Parameter
max_ratio = 0.5;
point_num = max_ratio/interval+1;
k = (filter_length -1)/2; % N = 21, k = (N-1)/2 = 10
extreme_point_num = k + 2; % choose k + 2 = 12 extreme frequencies
Matrix = zeros(extreme_point_num , extreme_point_num);
Hd_Fn = zeros(extreme_point_num,1);
pass_band = pass_band_frequency / sampling_frequency; % pass band 0.225 < F < 0.5
transition_band = transition_band_frequency / sampling_frequency; % transition band 0.2 < F < 0.25
weighting_function = [weighting; transition_band]; % weighting function: W(F) = 0.8 for 0 < F < 0.2, W(F) = 1 for 0.25 < F < 0.5
Hd_F = zeros(1,point_num);
Hd_F(1,round(pass_band(1)*2*point_num) : end) = 1;
x = 0:interval:max_ratio;
iteration = 0;
E_iteration = zeros(1,100);
check = 0;
E1 = inf;

% Step 1: Choose extreme frequencies
m = k + 1; % R(F) have m = k+1 items (s[0] ~ s[k])
Fmax = 0.5;
F0 = 0;
epsilon = 0.001;
alpha = (Fmax - F0) / (extreme_point_num - 1);
extreme_point = zeros(1,extreme_point_num);
for i = 1:extreme_point_num
    extreme_point_value = Fmax - (extreme_point_num-i) * alpha; % 0 ≦ F ≦ 0.5, F0 ~ F11 (F0 ~ Fk+1)
    if extreme_point_value < transition_band(1) || extreme_point_value > transition_band(2) %% check if extreme point isn't into the transition band
        extreme_point(1,i) = extreme_point_value;
    else
        extreme_point(1,i) = transition_band(2) + epsilon;
    end
end

while(check ~= 1)
    iteration = iteration + 1; % iteration counting
    
    % Step 2: 
    % M = [cos(2π(j-1)F_(i-1)) 1/W(F_i-1)]
    e = zeros(extreme_point_num,1);
    for i = 1:extreme_point_num
        for j = 1:extreme_point_num
            if j == extreme_point_num
                if extreme_point(i) < transition_band(1)
                    e(j,1) = weighting(1);
                else
                    e(j,1) = weighting(2);
                end
                Matrix(i,j) = (-1)^(i-1) / e(j,1);
            else
                Matrix(i,j) = cos(2*pi*(j-1)*extreme_point(i));
            end
        end

        % Hd(Fn), n = 0, 1, ... , k+1
        if extreme_point(i) > transition_band(1)
            Hd_Fn(i,1) = 1;
        end
    end
    
    s = Matrix \ Hd_Fn; % (inverse Matrix) * Hd(Fn)

    % R(F) = sum(s[n]cos(2πnF)), n = 0, 1, ... , k+1
    R = zeros(1,m);
    R_F = zeros(1,point_num);
%     R_F_result = '';
    for i = 1:m
        R(1,i) = s(i);
        for j = 1:(point_num-1)
            R_F(1,j+1) = R_F(1,j+1) + R(1,i) * cos(2*pi * (i-1) * (j*interval));
        end
%         R_F_result = [R_F_result, num2str(R(1,i)), '×cos(2π', num2str((i-1)), 'F) + ' ];
    end
%     R_F_result= R_F_result(1:end-3);
%     fprintf(R_F_result)         % R(F) visualization
    

    % Step 3:
    %        ┌  1 , F > 0.25
    % W(F) = | 0.8, F < 0.2
    %        └  0 , 0.2 < F < 0.25
    W_F = zeros(1,point_num);
    for i = 1:point_num
        if (i*interval) < weighting_function(2,1)
            W_F(i) = weighting_function(1,1);
        elseif (i*interval) > weighting_function(2,2)
            W_F(i) = weighting_function(1,2);
        end
    end

    % err(F) = [R(F) - Hd(F)]W(F)
    err = (R_F - Hd_F) .* W_F;
    
    % Step 4: Find k+2 extremum (local maximal or minimal) points
    err_localmax = islocalmax(err);
    err_localmin = islocalmin(err);

    extreme_point = sort([find(err_localmax==1) / point_num * 0.5 , find(err_localmin==1) / point_num * 0.5, 0.5]);

    % Step 5: Minimize E0
    E0 = max(abs(err));

    if iteration == 1
        E = E1 - 0;
    else
        E = E1 - E0;
    end

    % Make sure Ei+1 < E
    if E < delta && E > 0
        check = 1;
    else
        check = 0;
    end

    E1 = E0; % Replace E0
    E_iteration(1,iteration) = E0;
    s = s(1:end-1,1)';
end
E_iteration = E_iteration(1,1:iteration);

% Step 6: Find impulse response h[n]
h_len = length(s) * 2 - 1;
h = zeros(1,h_len);
h_mid = round(h_len/2);

for i = 1:h_len
    if i == (h_len+1)/2
        h(i) = s(abs(h_mid - i)+1);
    else
        h(i) = s(abs(h_mid - i)+1) / 2;
    end
end

for i = 1:length(s)
    if i-1 == 10
        fprintf(['h[', num2str(i-1) , '] = ', num2str(h(i)), '\n']);
    else
        fprintf(['h[', num2str(i-1) , '] = h[', num2str(length(s)*2-1-i),'] = ', num2str(h(i)), '\n']);
    end
end

figure;
plot(x,Hd_F,'b')
hold on
plot(x,R_F,'r')
text(0.15,0.6,'H_d(F)','color','red','FontSize',14)
text(0.15,1,'R(F)','color','blue','FontSize',14)
hold off
title([num2str(iteration),'_t_h times R(F)'])

figure;
plot(x,err,'k',x(err_localmax),err(err_localmax),'r*',x(err_localmin),err(err_localmin),'r*')
hold on;
plot(x(end),err(end),'r*')
title([num2str(iteration),'_t_h times err(F)'])

x = 0:h_len-1;
figure;
stem(x,h(x+1));
title('Impluse Response')

fprintf('\nMax[|err(F)|] = [%s]\n\n', join(string(E_iteration), ','));
