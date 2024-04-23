clc; clear all; close all;

%% Read Image
A = imread("Lena.jpg");
B = imread("Lena_darken.jpg");

%% Structural Similarity
c1 = 0.01;
c2 = 0.03;

Structural_Similarity = SSIM(A, B, c1, c2);

figure(1)
subplot(1,2,1)
imshow(A)
title('Lena');
subplot(1,2,2)
imshow(B)
title(['Darkening Lena SSIM = ', num2str(Structural_Similarity)]);

%%
clc;
N = 1100;
M = 2;
L = [1:N/2];
comp = N./L*3.*(M+L-1).*(log2(M+L-1)+1);
[cmin, L0] = min(comp);
L0
S = floor(N/3)