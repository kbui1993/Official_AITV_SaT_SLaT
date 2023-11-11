%noise setting
noise_setting =1; %0 for salt-pepper noise, otherwise gaussian noise

%read image
building = imread('building.jpg');

building = rescale_color_image(double(building));

rng(1234);
if noise_setting == 0
    building_noise = impulsenoise(building, .1, noise_setting);
    lambda = 2; mu = 0.05;
else
    building_noise = imnoise(building, 'gaussian', 0, 0.025);
    lambda = 10; mu = 0.1;
end

building_noise = rescale_color_image(building_noise);

%L1mL2 SLAT alpha = 0.8
L1mL2_0pt8_SLAT_result = L1mL2_SLaT(double(building_noise), lambda, mu, 0.8, 8);
L1mL2_0pt8_SLAT_psnr = psnr(L1mL2_0pt8_SLAT_result, building);

%L1mL2 SLAT alpha = 0.6
L1mL2_0pt6_SLAT_result = L1mL2_SLaT(double(building_noise), lambda, mu, 0.6, 8);
L1mL2_0pt6_SLAT_psnr = psnr(L1mL2_0pt6_SLAT_result, building);

%L1mL2 SLAT alpha = 0.4
L1mL2_0pt4_SLAT_result = L1mL2_SLaT(double(building_noise), lambda, mu, 0.4, 8);
L1mL2_0pt4_SLAT_psnr = psnr(L1mL2_0pt4_SLAT_result, building);

%L1mL2 SLAT alpha = 0.2
L1mL2_0pt2_SLAT_result = L1mL2_SLaT(double(building_noise), lambda, mu, 0.2, 8);
L1mL2_0pt2_SLAT_psnr = psnr(L1mL2_0pt2_SLAT_result, building);

%plot figure
figure;
subplot(2,4,1);
imagesc(building); axis off; axis square; 
title('Original');

subplot(2,4,2);
imagesc(building_noise); axis off; axis square; 
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
