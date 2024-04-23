clc; clear all; close all;

%%
signal = zeros(1,101);

for n = 1:length(signal)
    if n > 30 && n <= 70
        signal(1,n) = 1;
    end
end

output_signal = DHT(signal);

figure;
subplot(3,2,1)
plot(0:length(signal)-1, signal)
axis([0 length(signal)-1 -0.5 1.5])
title('Input')
subplot(3,2,2)
plot(0:length(output_signal)-1, output_signal)
axis([0 length(output_signal)-1 -2 2])
title('Difference')

%%
signal = signal + rand(1,length(signal)) - 0.5;

output_signal = DHT(signal);

subplot(3,2,3)
plot(0:length(signal)-1, signal)
axis([0 length(signal)-1 -0.5 1.5])
title('Input')
subplot(3,2,4)
plot(0:length(output_signal)-1, output_signal)
axis([0 length(output_signal)-1 -2 2])
title('Difference')

%%
signal = zeros(1,101);

for n = 1:length(signal)
    if n > 25 && n <= 35
        signal(1,n) = (n-25)/10;
    elseif n > 65 && n <= 75
        signal(1,n) = 1-(n-65)/10;
    elseif n > 35 && n <= 65
        signal(1,n) = 1;
    end
end

output_signal = DHT(signal);

subplot(3,2,5)
plot(0:length(signal)-1, signal)
axis([0 length(signal)-1 -0.5 1.5])
title('Input')
subplot(3,2,6)
plot(0:length(output_signal)-1, output_signal)
axis([0 length(output_signal)-1 -2 2])
title('Difference')