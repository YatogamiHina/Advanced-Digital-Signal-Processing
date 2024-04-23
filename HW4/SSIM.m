function Structural_Similarity = SSIM(A, B, c1, c2)
%% Check the image is only one channel
[height , width, channel1] = size(A);
[height , width, channel2] = size(B);

if channel1 == 3
    A = rgb2gray(A);
end
if channel2 == 3
    B = rgb2gray(B);
end

A = double(A);
B = double(B);

%% Calculate Means and Standard Deviation
means_A = sum(A , 'all') / height / width;
means_B = sum(B , 'all') / height / width;

std_A = std(A , 1 , 'all');
std_B = std(B , 1 , 'all');

covar = cov(A , B, 1);
covar = covar(2);

%% Structural Similarity
L = max(A , [] , 'all') - min(B , [] , 'all');

Structural_Similarity = (2*means_A * means_B + (c1*L)^2) * (2 * covar + (c2*L)^2) ...
                     / (means_A^2 + means_B^2 + (c1*L)^2) / (std_A^2 + std_B^2 + (c2*L)^2);