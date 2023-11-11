%noise setting
noise_setting =1; %0 for salt-pepper noise, otherwise gaussian noise

%read image
circle = imread('circle.jpg');

circle = rescale_color_image(double(circle));

rng(1234);
if noise_setting == 0
    circle_noise = impulsenoise(circle, .1, noise_setting);
    lambda = 10; mu = 1.0;
else
    circle_noise = imnoise(circle, 'gaussian', 0, 0.025);
    lambda = 22; mu = 0.1;
end

%L1mL2 SLAT alpha = 0.8
L1mL2_0pt8_SLAT_result = L1mL2_SLaT(double(circle_noise), lambda, mu, 0.8, 3);
L1mL2_0pt8_SLAT_psnr = psnr(L1mL2_0pt8_SLAT_result, circle);

%L1mL2 SLAT alpha = 0.6
L1mL2_0pt6_SLAT_result = L1mL2_SLaT(double(circle_noise), lambda, mu, 0.6, 3);
L1mL2_0pt6_SLAT_psnr = psnr(L1mL2_0pt6_SLAT_result, circle);

%L1mL2 SLAT alpha = 0.4
L1mL2_0pt4_SLAT_result = L1mL2_SLaT(double(circle_noise), lambda, mu, 0.4, 3);
L1mL2_0pt4_SLAT_psnr = psnr(L1mL2_0pt4_SLAT_result, circle);

%L1mL2 SLAT alpha = 0.2
L1mL2_0pt2_SLAT_result = L1mL2_SLaT(double(circle_noise), lambda, mu, 0.2, 3);
L1mL2_0pt2_SLAT_psnr = psnr(L1mL2_0pt2_SLAT_result, circle);

%plot figure
figure;
subplot(2,4,1);
imagesc(circle); axis off; axis square; 
title('Original');

subplot(2,4,2);
imagesc(circle_noise); axis off; axis square; 
title('Corrupted Image');

subplot(2,4,5);
imagesc(L1mL2_0pt2_SLAT_result); axis off; axis square; 
title(['\alpha =0.2', 'PSNR:' + string(L1mL2_0pt2_SLAT_psnr)])

subplot(2,4,6);
imagesc(L1mL2_0pt4_SLAT_result); axis off; axis square; 
title(['\alpha =0.4', 'PSNR:' + string(L1mL2_0pt4_SLAT_psnr)])

subplot(2,4,7);
imagesc(L1mL2_0pt6_SLAT_result); axis off; axis square; 
title(['\alpha =0.6', 'PSNR:' + string(L1mL2_0pt6_SLAT_psnr)])

subplot(2,4,8);
imagesc(L1mL2_0pt8_SLAT_result);axis off; axis square; 
title(['\alpha =0.8', 'PSNR:' + string(L1mL2_0pt8_SLAT_psnr)])
