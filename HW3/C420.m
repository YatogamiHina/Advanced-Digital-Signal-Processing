function img_r = C420(img)

%% RGB Image to YCbCr Image
RGB2YCbCr_Matrix = [0.299 0.587 0.114;
                    -0.169 -0.331 0.500;
                    0.500 -0.419 -0.081];
[width , height , channel] = size(img);

img_YCbCr = zeros(width , height , channel);

for m = 1:width
    for n = 1:height
        img_vector = [img(m,n,1); img(m,n,2); img(m,n,3);];
        img_YCbCr(m,n,:) = RGB2YCbCr_Matrix * img_vector;
    end
end

%% Cb & Cr Compression
width_c = width/2;
height_c = height/2;

Y_c = img_YCbCr(:,:,1);
Cb_c = zeros(width_c,height_c);
Cr_c = zeros(width_c,height_c);

for m = 1:width_c
    for n = 1:height_c
        Cb_c(m,n) = img_YCbCr(m*2-1,n*2-1,2);
        Cr_c(m,n) = img_YCbCr(m*2-1,n*2-1,3);
    end
end

%% Cb & Cr Reconstruction
Y_r = Y_c;
Cb_r = zeros(width,height);
Cr_r = zeros(width,height);

for m = 1:2:width-1
    for n = 1:2:height-1
        if m ~= width-1 && n ~= height-1
            Cb_r(m,n) = Cb_c((m-1)/2+1,(n-1)/2+1);
            Cb_r(m+1,n) = 0.5 * (Cb_c((m-1)/2+1,(n-1)/2+1) + Cb_c((m-1)/2+2,(n-1)/2+1));
            Cb_r(m,n+1) = 0.5 * (Cb_c((m-1)/2+1,(n-1)/2+1) + Cb_c((m-1)/2+1,(n-1)/2+2));
            Cb_r(m+1,n+1) = 0.5 * (Cb_r(m+1,n) + Cb_r(m,n+1));

            Cr_r(m,n) = Cr_c((m-1)/2+1,(n-1)/2+1);
            Cr_r(m+1,n) = 0.5 * (Cr_c((m-1)/2+1,(n-1)/2+1) + Cr_c((m-1)/2+2,(n-1)/2+1));
            Cr_r(m,n+1) = 0.5 * (Cr_c((m-1)/2+1,(n-1)/2+1) + Cr_c((m-1)/2+1,(n-1)/2+2));
            Cr_r(m+1,n+1) = 0.5 * (Cr_r(m+1,n) + Cr_r(m,n+1));

        elseif m == width-1 && n ~= height-1
            Cb_r(m,n) = Cb_c((m-1)/2+1,(n-1)/2+1);
            Cb_r(m+1,n) = Cb_r(m,n);
            Cb_r(m,n+1) = 0.5 * (Cb_c((m-1)/2+1,(n-1)/2+1) + Cb_c((m-1)/2+1,(n-1)/2+2));
            Cb_r(m+1,n+1) = 0.5 * (Cb_r(m+1,n) + Cb_r(m,n+1));

            Cr_r(m,n) = Cr_c((m-1)/2+1,(n-1)/2+1);
            Cr_r(m+1,n) = Cr_r(m,n);
            Cr_r(m,n+1) = 0.5 * (Cr_c((m-1)/2+1,(n-1)/2+1) + Cr_c((m-1)/2+1,(n-1)/2+2));
            Cr_r(m+1,n+1) = 0.5 * (Cr_r(m+1,n) + Cr_r(m,n+1));

        elseif m ~= width-1 && n == height-1
            Cb_r(m,n) = Cb_c((m-1)/2+1,(n-1)/2+1);
            Cb_r(m+1,n) = 0.5 * (Cb_c((m-1)/2+1,(n-1)/2+1) + Cb_c((m-1)/2+2,(n-1)/2+1));
            Cb_r(m,n+1) = Cb_r(m,n);
            Cb_r(m+1,n+1) = 0.5 * (Cb_r(m+1,n) + Cb_r(m,n+1));

            Cr_r(m,n) = Cr_c((m-1)/2+1,(n-1)/2+1);
            Cr_r(m+1,n) = 0.5 * (Cr_c((m-1)/2+1,(n-1)/2+1) + Cr_c((m-1)/2+2,(n-1)/2+1));
            Cr_r(m,n+1) = Cr_r(m,n);
            Cr_r(m+1,n+1) = 0.5 * (Cr_r(m+1,n) + Cr_r(m,n+1));

        else
            Cb_r(m,n) = Cb_c((m-1)/2+1,(n-1)/2+1);
            Cb_r(m+1,n) = Cb_r(m,n);
            Cb_r(m,n+1) = Cb_r(m,n);
            Cb_r(m+1,n+1) = 0.5 * (Cb_r(m+1,n) + Cb_r(m,n+1));

            Cr_r(m,n) = Cr_c((m-1)/2+1,(n-1)/2+1);
            Cr_r(m+1,n) = Cr_r(m,n);
            Cr_r(m,n+1) = Cr_r(m,n);
            Cr_r(m+1,n+1) = 0.5 * (Cr_r(m+1,n) + Cr_r(m,n+1));

        end
    end
end

%% Image Reconstruction
img_YCbCr_r(:,:,1) = Y_r;
img_YCbCr_r(:,:,2) = Cb_r;
img_YCbCr_r(:,:,3) = Cr_r;

%% YCbCr Image to RGB Image
% inv_RGB2YCbCr_Matrix = inv(RGB2YCbCr_Matrix);
img_r = zeros(width,height,channel);

for m = 1:width
    for n = 1:height
        img_vector = [img_YCbCr_r(m,n,1); img_YCbCr_r(m,n,2); img_YCbCr_r(m,n,3);];
        img_r(m,n,:) = RGB2YCbCr_Matrix \ img_vector; % A\b = inv(A) * b
    end
end