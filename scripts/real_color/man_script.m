%read image
man = imread('man.jpg');

man = rescale_color_image(double(man));

man_noise = imnoise(man, 'gaussian', 0, 0.025);

man_noise = rescale_color_image(man_noise);

%L1mL2 SLAT alpha = 0.8
L1mL2_0pt8_SLAT_result = L1mL2_SLaT(double(man_noise), 3.5, 1.0, 0.8, 5);
L1mL2_0pt8_SLAT_psnr = psnr(L1mL2_0pt8_SLAT_result, man);

%L1mL2 SLAT alpha = 0.6
L1mL2_0pt6_SLAT_result = L1mL2_SLaT(double(man_noise), 3.5, 1.0, 0.6, 5);
L1mL2_0pt6_SLAT_psnr = psnr(L1mL2_0pt6_SLAT_result, man);

%L1mL2 SLAT alpha = 0.4
L1mL2_0pt4_SLAT_result = L1mL2_SLaT(double(man_noise), 3.5, 1.0, 0.4, 5);
L1mL2_0pt4_SLAT_psnr = psnr(L1mL2_0pt4_SLAT_result, man);

%L1mL2 SLAT alpha = 0.2
L1mL2_0pt2_SLAT_result = L1mL2_SLaT(double(man_noise), 3.5, 1.0, 0.2, 5);
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
