clc; clear all; close all;

%% Walsh Transform
k = 4;
N = 2^k;

V = hadamard(N);
W = zeros(N,N);
for m = 1:N
    count = 0;
    for n = 1:N-1
        n1 = V(m,n);
        n2 = V(m,n+1);
        if n1 ~= n2
            count = count + 1;
        end
    end
    W(count+1,:) = V(m,:);
end  
%% CDMA modulation

data1 = [1 1 -1];
data2 = [-1 1 1];
data3 = [1 -1 1];

W1 = W(1,:);
W2 = W(6,:);
W3 = W(12,:);

m1 = [W1*data1(1) W1*data1(2) W1*data1(3)];
m2 = [W2*data2(1) W2*data2(2) W2*data2(3)];
m3 = [W3*data3(1) W3*data3(2) W3*data3(3)];
M = m1 + m2 + m3;
% 

fprintf("m1 = [%s]\n", join(string(m1), ', '))
fprintf("m2 = [%s]\n", join(string(m2), ', '))
fprintf("m3 = [%s]\n", join(string(m3), ', '))
fprintf("M = [%s]\n", join(string(M), ', '))

%% CDMA demodulation

M(8) = 0;
M(15) = 0;
fprintf("M_miss = [%s]\n", join(string(M), ', '))
r1 = sum(M(1,1:16).*W1)/16
r2 = sum(M(1,1:16).*W2)/16
r3 = sum(M(1,1:16).*W3)/16
