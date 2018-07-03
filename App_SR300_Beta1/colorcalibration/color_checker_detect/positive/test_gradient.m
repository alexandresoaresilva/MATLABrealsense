clear
k = 10;
sigma1 =  0.2;
sigma2 = sigma1*k;
I = imread('dist_checker_rotated.png');

I = imresize(I,[480 640]);
gauss1 = imgaussfilt(I,sigma1);
gauss2 = imgaussfilt(I,sigma2);


dogImg = gauss1 - gauss2;
dogImg = dogImg*10;
%dogImg(dogImg>10) =  255;

I_gray_gauss = rgb2gray(dogImg);

[Gmag,Gdir] = imgradient(I_gray_gauss);
I_bw_gauss = imbinarize(dogImg);

imshow([I_gray_gauss, Gmag, Gdir])
title(['gray_gauss',...
    '            ----------------            ',...
    'Gmag',...
    '            ----------------            ',...
    'Gdir'])
figure
imshow(~I_bw_gauss)
title('gradient magnitude with binarized')