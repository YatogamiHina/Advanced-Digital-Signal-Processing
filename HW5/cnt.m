clc; clear all; close all;

N_list = [];
M_list = zeros(1,60);
for b = 1:60
    a = 10;
    M = 31;
    N = a^2 + b^2;
    M_list(b) = mod(N,M);
    if mod(N,M) == 1
        N_list = [N_list , b];
    end
end

        