clc; clear all; close all;

%%
% x = [1,2,3,4,5];
% y = [5,4,3,2,1];

x = input('Input the first real signal: ');
y = input('Input the second real signal: ');

[Fx, Fy] = fftreal(x,y);

fprintf("Fx[m] = [%s]\n", join(string(Fx), ', '))
fprintf("Fy[m] = [%s]\n", join(string(Fy), ', '))