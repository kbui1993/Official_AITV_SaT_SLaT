%noise setting
noise_setting =1; %0 for salt-pepper noise, otherwise gaussian noise

%read image
house = imread('house.jpg');

house = rescale_color_image(double(house));
rng(1234);

if noise_setting == 0
    house_noise = impulsenoise(house, .1, noise_setting);
    lambda = 2; mu = 0.05;
else
    house_noise = imnoise(house, 'gaussian', 0, 0.025);
    lambda = 10; mu = 0.05;
end

%L1mL2 SLAT alpha = 0.8
L1mL2_0pt8_SLAT_result = L1mL2_SLaT(double(house_noise), lambda, mu, 0.8, 6);
L1mL2_0pt8_SLAT_psnr = psnr(L1mL2_0pt8_SLAT_result, house);

%L1mL2 SLAT alpha = 0.6
L1mL2_0pt6_SLAT_result = L1mL2_SLaT(double(house_noise), lambda, mu, 0.6, 6);
L1mL2_0pt6_SLAT_psnr = psnr(L1mL2_0pt6_SLAT_result, house);

%L1mL2 SLAT alpha = 0.4
L1mL2_0pt4_SLAT_result = L1mL2_SLaT(double(house_noise), lambda, mu, 0.4, 6);
L1mL2_0pt4_SLAT_psnr = psnr(L1mL2_0pt4_SLAT_result, house);

%L1mL2 SLAT alpha = 0.2
L1mL2_0pt2_SLAT_result = L1mL2_SLaT(double(house_noise), lambda, mu, 0.2, 6);
L1mL2_0pt2_SLAT_psnr = psnr(L1mL2_0pt2_SLAT_result, house);

%plot figure
figure;
subplot(2,4,1);
imagesc(house); axis off; axis square; 
title('Original');

subplot(2,4,2);
imagesc(house_noise); axis off; axis square; 
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
