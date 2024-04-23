function FSM(k, H_range, H, interval, transition_band)
%% Initial Parameter
% If Input don't have transition band, default transition band = 0
msg = nargchk(4,5,nargin);
error(msg);
if nargin < 5
    transition_band = 0;
end

N = 2 * k + 1;
x = 0:interval:1;
point_num = 1/interval + 1;
sampling_interval = point_num/N;
Hd = zeros(1,point_num);
r = zeros(1,N);
Hd_list = zeros(1,N);
x_mid = H_range(2);

% cyclical 
for i = 1:point_num
    if x(i) < x_mid
        Hd(i) = H * x(i);
    else
        Hd(i) = H * (x(i)-1);
    end
end

%% Step 1: Set N points
Hd_list(1) = Hd(1);
if transition_band == 0
    for i = 1:N-1
        Hd_list(i+1) = Hd(round(i*sampling_interval));
    end
else
    for i = 1:N-1
        if i == k
            Hd_list(i+1) = transition_band(2)*Hd(round(i*sampling_interval));
        elseif i == k+1
            Hd_list(i+1) = transition_band(1)*Hd(round(i*sampling_interval));
        else
            Hd_list(i+1) = Hd(round(i*sampling_interval));
        end
    end
end

%% Step 2: Inverse Fourier Transform
r1 = ifft(Hd_list);

%% Step 3 & 4: Shift & Translation
r = [r1(round(N/2)+1:N) , r1(1:round(N/2))];

%% Step 5: Frequency Response
R = zeros(1,point_num);
for f = 1:point_num
    for n = 1:N
        R(f) = R(f) + r(n) * exp(-j*2*pi*x(f)*((n-1)-(N-1)/2));
    end
end

%% Figure 1
x1 = 0:N-1;
x2 = -(N-1)/2:(N-1)/2;
x3 = x1;

figure
subplot(3,1,1)
stem(x1,r1(x1+1))
xlim([-N-5 N+5])
title('r_1[n]')

subplot(3,1,2)
stem(x2,r(x2+(N-1)/2+1))
xlim([-N-5 N+5])
title('r[n]')

subplot(3,1,3)
stem(x3,r(x3+1))
xlim([-N-5 N+5])
title('h[n]')

%% Figure 2: Impulse Response
figure
plot(x-x_mid,real(Hd),'b',x-x_mid,real(R),'r')
title('Impulse Response')


%% Figure 3: The Imaginary Part of the Frequency Response
x_n = 1:N;
figure
plot(x,imag(Hd),'b',x,imag(R), 'r')
hold on;
plot((x_n-1)./N, imag(Hd_list(x_n)), 'go','MarkerSize', 10)
title('The Imaginary Part of the Frequency Response')
