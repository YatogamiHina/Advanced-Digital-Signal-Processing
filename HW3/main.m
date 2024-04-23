clc; clear all; close all;

%% Load Image
A = double(imread("Lena.jpg"));

%% C420
B = C420(A);

%% Show Image
figure(1);
subplot(1,2,1)
imshow(uint8(A))
title('Original Image')
subplot(1,2,2)
imshow(uint8(B))
title('Reconstructed Image')