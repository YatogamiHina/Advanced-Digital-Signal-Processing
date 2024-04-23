clc; clear all; close all;

%% Huffman
lambda = 0.97;
N = 40;
L = 50000;
entropy = 0;

for n = 0:40
    P = exp(-lambda) * lambda^n / factorial(n);
    entropy = entropy + P * log(1/P);
end

lower_limit_H = ceil(L*entropy/log(2));
upper_limit_H = floor(L*entropy/log(2)) + L;

%% Arithmetic
S0 = 0;
S = zeros(1,N);
P = zeros(1,N);
for i = 1:N
    P(i) = exp(-lambda) * lambda^i / factorial(i);
    S(i) = sum(P);
end

lower = S0;
upper = S(1);

for i = 2:N
    delta = upper - lower;
    lower = lower + S(i-1) * delta;
    upper = lower + S(i) * delta;
end

lower_limit_A = ceil(L*entropy/log(2));
upper_limit_A = floor(L*entropy/log(2)+log2(2)+1);