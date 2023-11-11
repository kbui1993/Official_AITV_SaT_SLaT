%noise setting
noise_setting =0; %0 for salt-pepper noise, otherwise gaussian noise

%read image
man = imread('man.jpg');

man = rescale_color_image(double(man));
rng(1234);
if noise_setting == 0
    man_noise = impulsenoise(man, .1, noise_setting);
    lambda = 2; mu = 0.05;
else
    man_noise = imnoise(man, 'gaussian', 0, 0.025);
    lambda = 8; mu = 0.05;
end


%L1mL2 SLAT alpha = 0.8
L1mL2_0pt8_SLAT_result = L1mL2_SLaT(double(man_noise), lambda, mu, 0.8, 5);
L1mL2_0pt8_SLAT_psnr = psnr(L1mL2_0pt8_SLAT_result, man);

%L1mL2 SLAT alpha = 0.6
L1mL2_0pt6_SLAT_result = L1mL2_SLaT(double(man_noise), lambda, mu, 0.6, 5);
L1mL2_0pt6_SLAT_psnr = psnr(L1mL2_0pt6_SLAT_result, man);

%L1mL2 SLAT alpha = 0.4
L1mL2_0pt4_SLAT_result = L1mL2_SLaT(double(man_noise), lambda, mu, 0.4, 5);
L1mL2_0pt4_SLAT_psnr = psnr(L1mL2_0pt4_SLAT_result, man);

%L1mL2 SLAT alpha = 0.2
L1mL2_0pt2_SLAT_result = L1mL2_SLaT(double(man_noise), lambda, mu, 0.2, 5);
L1mL2_0pt2_SLAT_psnr = psnr(L1mL2_0pt2_SLAT_result, man);

%plot figure
figure;
subplot(2,4,1);
imagesc(man); axis off; axis square; 
title('Original');

subplot(2,4,2);
imagesc(man_noise); axis off; axis square; 
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
